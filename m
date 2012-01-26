Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2AZWgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:36:31 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57189 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2AZWga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:36:30 -0500
Message-ID: <4F21D57F.7090103@lwfinger.net>
Date: Thu, 26 Jan 2012 16:36:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>
Subject: Kernel BUG due to kernel page fault
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to convert the rtlwifi family of drivers to use asynchronous 
firmware loading. With recent changes in udev, many problems are being reported. 
See Bug 42632] at b.k.o.

Most of the code is now working, but I still have one problem. When the firmware 
is available, everything is fine. I delay the starting of the driver and the MAC 
layer until the firmware is available. The problem occurs when I start the 
driver with the firmware file not available. Under those conditions, when I 
unload the driver, I get the following BUG output:

BUG: unable to handle kernel paging request at ffffffffa0056641
IP: [<ffffffff811e3ecb>] strnlen+0xb/0x30
PGD 1607067 PUD 160b063 PMD b2aed067 PTE 0
Oops: 0000 [#1] SMP
CPU 1
Modules linked in: fuse autofs4 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device 
edd nfs nfsd lockd auth_rpcgss nfs_acl sunrpc exportfs ipv6 vboxpci(O) 
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) cpufreq_conservative cpufreq_userspace 
cpufreq_powersave powernow_k8 mperf ext3 jbd ide_cd_mod cdrom 
snd_hda_codec_conexant ide_pci_generic snd_hda_intel snd_hda_codec snd_pcm 
k8temp amd74xx sg snd_timer ide_core joydev button hwmon i2c_nforce2 serio_raw 
ac battery forcedeth snd i2c_core video soundcore snd_page_alloc ext4 mbcache 
jbd2 crc16 sd_mod ohci_hcd ahci libahci libata ehci_hcd scsi_mod usbcore 
usb_common fan processor thermal [last unloaded: rfkill]

Pid: 3605, comm: irqbalance Tainted: G           O 3.3.0-rc1-wl+ #175 
Hewlett-Packard HP Pavilion dv2700 Notebook PC/30D6
RIP: 0010:[<ffffffff811e3ecb>]  [<ffffffff811e3ecb>] strnlen+0xb/0x30
RSP: 0018:ffff8800b3179c98  EFLAGS: 00010086
RAX: 0000000000000000 RBX: ffff880084cdd28f RCX: 0000000000000000
RDX: ffffffffa0056641 RSI: ffffffffffffffff RDI: ffffffffa0056641
RBP: ffff8800b3179c98 R08: 000000000000ffff R09: 000000000000ffff
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa0056641
R13: ffff880084cde000 R14: 0000000000000000 R15: 000000000000ffff
FS:  00007fa070fdd720(0000) GS:ffff8800bbd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa0056641 CR3: 00000000b2bba000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process irqbalance (pid: 3605, threadinfo ffff8800b3178000, task ffff8800b5875880)
Stack:
  ffff8800b3179cd8 ffffffff811e58ae ffff8800b3179cf8 ffff880084cdd28f
  ffffffff8151f664 ffff8800b3179d70 ffffffff8151f664 ffff880084cde000
  ffff8800b3179d58 ffffffff811e6889 000000000000ffff 0000000000000002
Call Trace:
  [<ffffffff811e58ae>] string.isra.4+0x3e/0xd0
  [<ffffffff811e6889>] vsnprintf+0x219/0x600
  [<ffffffff81153093>] seq_printf+0x53/0x80
  [<ffffffff811e21db>] ? radix_tree_lookup+0xb/0x10
  [<ffffffff810ba5ab>] show_interrupts+0x24b/0x300
  [<ffffffff81153474>] seq_read+0x2b4/0x3f0
  [<ffffffff811531c0>] ? seq_lseek+0x100/0x100
  [<ffffffff8118b651>] proc_reg_read+0x81/0xc0
  [<ffffffff8112f967>] vfs_read+0xa7/0x160
  [<ffffffff8112fa65>] sys_read+0x45/0x90
  [<ffffffff813a33a2>] system_call_fastpath+0x16/0x1b
Code: 31 c0 80 3f 00 55 48 89 e5 74 11 48 89 f8 66 90 48 83 c0 01 80 38 00 75 f7 
48 29 f8 5d c3 66 90 55 31 c0 48 85 f6 48 89 e5 74 23 <80> 3f 00 74 1e 48 89 f8 
eb 0c 0f 1f 00 48 83 ee 01 80 38 00 74
RIP  [<ffffffff811e3ecb>] strnlen+0xb/0x30
RSP <ffff8800b3179c98>
CR2: ffffffffa0056641
---[ end trace ad5f2d26ea4a9371 ]---

Nothing that I have tried has made any difference. Does this kind of fault 
suggest a fix? I found nothing useful with Google.

Thanks,

Larry
