Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0DVHhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:37:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46964 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab0DVHg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:36:56 -0400
Date: Thu, 22 Apr 2010 16:36:33 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, security@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1][BUG][IMPORTANT] KEYRINGS: find_keyring_by_name() can
 gain the freed keyring
Message-Id: <20100422163633.de233f25.toshi.okajima@jp.fujitsu.com>
Organization: Fujitsu co.,ltd.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

With linux-2.6.34-rc5, find_keyring_by_name() can gain the keyring which has
been already freed. And then, its space (which is gained by 
find_keyring_by_name()) is broken by accessing the freed keyring as the 
available keyring:

1) If the space of the freed keyring is reallocated for other purpose 
 (ie. filp SLUB), the data of the filp object may be destroyed by the user of 
 the freed keyring.
(SLUB configuration can share the freed space with other same-size slabs.)

2) If the slab space of the freed keyring is released into the system,
 the system panic may happen because accessing the space of the freed keyring 
 causes the page-fault.
 
Example: (we can easily confirm this problem if CONFIG_SLUB is "y".)
[1] with CONFIG_SLUB_DEBUG_ON
 While we are executing my reproducer (which is attached),
we can notice that the user of the freed keyring breaks its space:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# ./reproducer &
...
# dmesg 
...
=============================================================================
BUG key_jar: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xffff880197a7e200-0xffff880197a7e200. First byte 0x6a instead of 0x6b
INFO: Allocated in key_alloc+0x10b/0x35f age=25 cpu=1 pid=5086
INFO: Freed in key_cleanup+0xd0/0xd5 age=12 cpu=1 pid=10
INFO: Slab 0xffffea000592cb90 objects=16 used=2 fp=0xffff880197a7e200 flags=0x200000000000c3
INFO: Object 0xffff880197a7e200 @offset=512 fp=0xffff880197a7e300

Bytes b4 0xffff880197a7e1f0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff880197a7e200:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b jkkkkkkkkkkkkkkk
  Object 0xffff880197a7e210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff880197a7e220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff880197a7e230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff880197a7e240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff880197a7e250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff880197a7e260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff880197a7e270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff880197a7e280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff880197a7e290:  6b 6b 6b 6b 6b 6b 6b a5                         kkkkkkk�        
 Redzone 0xffff880197a7e298:  bb bb bb bb bb bb bb bb                         ��������        
 Padding 0xffff880197a7e2d8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff880197a7e2e8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff880197a7e2f8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 5090, comm: su Not tainted 2.6.34-rc5-nofixed #1
Call Trace:
 [<ffffffff810e3e9c>] ? check_bytes_and_report+0xb5/0xe6
 [<ffffffff81152994>] ? key_alloc+0x10b/0x35f
 [<ffffffff810e3f8f>] ? check_object+0xc2/0x1a4
 [<ffffffff810e5c09>] ? __slab_alloc+0x2ff/0x3a6
 [<ffffffff81152994>] ? key_alloc+0x10b/0x35f
 [<ffffffff81152780>] ? key_user_lookup+0x78/0x181
 [<ffffffff81152994>] ? key_alloc+0x10b/0x35f
 [<ffffffff810e658a>] ? kmem_cache_alloc+0x75/0xe9
 [<ffffffff81152994>] ? key_alloc+0x10b/0x35f
 [<ffffffff8115360a>] ? keyring_alloc+0x29/0x61
 [<ffffffff81155897>] ? install_user_keyrings+0x99/0x168
 [<ffffffff81155ae6>] ? lookup_user_key+0x180/0x30a
 [<ffffffff81153eaf>] ? keyctl_get_keyring_ID+0x15/0x38
 [<ffffffff81008a02>] ? system_call_fastpath+0x16/0x1b
FIX key_jar: Restoring 0xffff880197a7e200-0xffff880197a7e200=0x6b

FIX key_jar: Marking all objects used
=============================================================================
BUG key_jar: Poison overwritten
-----------------------------------------------------------------------------
...
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

[2] without CONFIG_SLUB_DEBUG_ON
 While we are executing my reproducer (which is attached),
we may find such the back-trace at the system panic:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# ls -l /sys/kernel/slab
total 0
drwxr-xr-x 2 root root 0 Apr 21 00:45 :at-0000016
...
lrwxrwxrwx 1 root root 0 Apr 21 00:45 cred_jar -> :t-0000192
...
lrwxrwxrwx 1 root root 0 Apr 21 00:45 filp -> :t-0000192
...
lrwxrwxrwx 1 root root 0 Apr 21 00:45 key_jar -> :t-0000192
...
lrwxrwxrwx 1 root root 0 Apr 21 00:45 kmalloc-192 -> :t-0000192
...

# ./reproducer.sh
(PANIC)
<1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
<1>IP: [<ffffffff810e61a3>] kmem_cache_alloc+0x5b/0xe9
<4>PGD 6b2b4067 PUD 6a80d067 PMD 0 
<0>Oops: 0000 [#1] SMP 
<0>last sysfs file: /sys/kernel/kexec_crash_loaded
<4>CPU 1 
<4>Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc autofs4 ipv6 ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mul
tipath uinput shpchp i2c_i801 ppdev parport_pc e752x_edac edac_core i2c_core tg3 iTCO_wdt iTCO_vendor_support parport pcspkr ext3 
jbd mbcache ata_generic pata_acpi megaraid_mbox megaraid_mm ata_piix floppy dm_mod [last unloaded: scsi_wait_scan]
<4>Pid: 31245, comm: su Not tainted 2.6.34-rc5-nofixed-nodebug #2 D2089/PRIMERGY
<4>RIP: 0010:[<ffffffff810e61a3>]  [<ffffffff810e61a3>] kmem_cache_alloc+0x5b/0xe9
<4>RSP: 0018:ffff88006af3bd98  EFLAGS: 00010002
<4>RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff88007d19900b
<4>RDX: 0000000100000000 RSI: 00000000000080d0 RDI: ffffffff81828430
<4>RBP: ffffffff81828430 R08: ffff88000a293750 R09: 0000000000000000
<4>R10: 0000000000000001 R11: 0000000000100000 R12: 00000000000080d0
<4>R13: 00000000000080d0 R14: 0000000000000296 R15: ffffffff810f20ce
<4>FS:  00007f97116bc700(0000) GS:ffff88000a280000(0000) knlGS:0000000000000000
<4>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>CR2: 0000000000000001 CR3: 000000006a91c000 CR4: 00000000000006e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process su (pid: 31245, threadinfo ffff88006af3a000, task ffff8800374414c0)
<0>Stack:
<4> 0000000512e0958e 0000000000008000 ffff880037f8d180 0000000000000001
<4><0> 0000000000000000 0000000000008001 ffff88007d199000 ffffffff810f20ce
<4><0> 0000000000008000 ffff88006af3be48 0000000000000024 ffffffff810face3
<0>Call Trace:
<4> [<ffffffff810f20ce>] ? get_empty_filp+0x70/0x12f
<4> [<ffffffff810face3>] ? do_filp_open+0x145/0x590
<4> [<ffffffff810ce208>] ? tlb_finish_mmu+0x2a/0x33
<4> [<ffffffff810ce43c>] ? unmap_region+0xd3/0xe2
<4> [<ffffffff810e4393>] ? virt_to_head_page+0x9/0x2d
<4> [<ffffffff81103916>] ? alloc_fd+0x69/0x10e
<4> [<ffffffff810ef4ed>] ? do_sys_open+0x56/0xfc
<4> [<ffffffff81008a02>] ? system_call_fastpath+0x16/0x1b
<0>Code: 0f 1f 44 00 00 49 89 c6 fa 66 0f 1f 44 00 00 65 4c 8b 04 25 60 e8 00 00 48 8b 45 00 49 01 c0 49 8b 18 48 85 db 74 0d 48 63 45 18 <48> 8b 04 03 49 89 00 eb 14 4c 89 f9 83 ca ff 44 89 e6 48 89 ef 
<1>RIP  [<ffffffff810e61a3>] kmem_cache_alloc+0x5b/0xe9
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

[reproducer.sh]
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#!/bin/sh

LOOP=100000
USER=dummy_user
# add
/bin/su -c "exit;" $USER || { /usr/sbin/adduser -m $USER; add=1; }

for ((i=0; i<LOOP; i++))
do
        /bin/su -c "echo '$i' > /dev/null" $USER
done

# del
(( add == 1 )) && /usr/sbin/userdel -r $USER
exit
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

I created the patch which fixes this problem.
(I attach it into the following mail. And I couldn't see the "Poison" lines 
of dmesg with the fixed kernel while I was executing my reproducer. So, this 
problem seems to be fixed by this patch.)
This problem is serious because it may trigger the user data destructions.
Please confirm and fix this problem.

Best Regards,
Toshiyuki Okajima
