Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0DVHiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:38:21 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60409 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0DVHiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:38:19 -0400
Date: Thu, 22 Apr 2010 16:37:55 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, security@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1][BUG][IMPORTANT] KEYRINGS: find_keyring_by_name() can
 gain the freed keyring
Message-Id: <20100422163755.355794e3.toshi.okajima@jp.fujitsu.com>
Organization: Fujitsu co.,ltd.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

With linux-2.6.34-rc5, find_keyring_by_name() can gain the keyring which has
been already freed. And then, its space (which is gained by 
find_keyring_by_name()) is broken by accessing the freed keyring as the 
available keyring.
This problem is serious because it may trigger the user data destructions.

[Figure Description](Example)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
|(cleaner)				(user)
| free_user(user)			sys_keyctl()
|  |                                     |
|  key_put(user->session_keyring)        keyctl_get_keyring_ID()
|  ||	//=> keyring->usage = 0           |
|  |schedule_work(&key_cleanup_task)      lookup_user_key()
|  ||                                      |
|  kmem_cache_free(,user)                  |
|  .                                       |[KEY_SPEC_USER_KEYRING]
|  .                                       install_user_keyrings()
|  .                                       ||
| key_cleanup() [<= worker_thread()]       ||
|  |                                       ||
|  [spin_lock(&key_serial_lock)]           |[mutex_lock(&key_user_keyr..mutex)]
|  |                                       ||
|  rb_ease(&key->serial_node,)             ||
|  |                                       ||
|  [spin_unlock(&key_serial_lock)]         |find_keyring_by_name()
|  |                                       |||
|  keyring_destroy(keyring)                ||[read_lock(&keyring_name_lock)]
|  ||                                      |||
|  |[write_lock(&keyring_name_lock)]       ||*** GET freeing keyring ***
|  |.                                      ||[read_unlock(&keyring_name_lock)]
|  ||                                      |||
|  |list_del()                             |||
|  ||                                      |||
|  |[write_unlock(&keyring_name_lock)]     |||
|  |                                       |||
|  kmem_cache_free(,keyring)               |||
|                                          ||atomic_inc(&keyring->usage) 
|                                          || ***DESTROYED***
|                                          |[mutex_unlock(&key_user_k..mutex)]
v                                          |
TIME                                       ** INVALID keyring is returned **
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

If CONFIG_SLUB_DEBUG_ON is configured, we may see the following message in
dmesg:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
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
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Otherwise, such a system panic may happen:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
<1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
<1>IP: [<ffffffff810e61a3>] kmem_cache_alloc+0x5b/0xe9
<4>PGD 6b2b4067 PUD 6a80d067 PMD 0 
<0>Oops: 0000 [#1] SMP 
<0>last sysfs file: /sys/kernel/kexec_crash_loaded
<4>CPU 1 
...
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

This root cause is not to confirm the keyring is valid.
So, adding its validate confirmation with spin_lock(&key_serial_lock) 
can fix this problem.
[Figure Description]
Case 1)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
|(cleaner)				(user)
| free_user(user)			sys_keyctl()
|  |                                     |
|  key_put(user->session_keyring)        keyctl_get_keyring_ID()
|  ||	//=> keyring->usage = 0           |
|  |schedule_work(&key_cleanup_task)      lookup_user_key()
|  ||                                      |
|  kmem_cache_free(,user)                  |
|  .                                       |[KEY_SPEC_USER_KEYRING]
|  .                                       install_user_keyrings()
|  .                                       ||
| key_cleanup() [<= worker_thread()]       ||
|  |                                       ||
|  [spin_lock(&key_serial_lock)]           |[mutex_lock(&key_user_keyr..mutex)]
|  |                                       ||
|  rb_ease(&key->serial_node,)             ||
|  |                                       ||
|  [spin_unlock(&key_serial_lock)]         |find_keyring_by_name()
|  |                                       |||
|  keyring_destroy(keyring)                ||[read_lock(&keyring_name_lock)]
|  ||                                      |||
|  ||                                      ||[spin_lock(&key_serial_lock)]
|  ||                                      |||
|  ||                                      ||*** THIS keyring is freeing ***
|  |[write_lock(&keyring_name_lock)]       |||  So, returns with -ENOKEY
|  |.                                      ||[spin_unlock(&key_serial_lock)]
|  |.                                      |||
|  |.                                      ||[read_unlock(&keyring_name_lock)]
|  ||                                      ||
|  |list_del()                             |[mutex_unlock(&key_user_k..mutex)]
|  ||                                      | 
|  |[write_unlock(&keyring_name_lock)]     ** Keyring is not found. **  
|  |                                         
|  kmem_cache_free(,keyring)                 
v                                             
TIME
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Case 2)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
|(cleaner)				(user)
| free_user(user)			sys_keyctl()
|  |                                     |
|  key_put(user->session_keyring)        keyctl_get_keyring_ID()
|  ||	//=> keyring->usage = 0           |
|  |schedule_work(&key_cleanup_task)      lookup_user_key()
|  ||                                      |[KEY_SPEC_USER_KEYRING]
|  kmem_cache_free(,user)                  install_user_keyrings() 
|  .                                       ||
|  .                                       |[mutex_lock(&key_user_keyr..mutex)] 
|  .                                       ||
| key_cleanup() [<= worker_thread()]       |find_keyring_by_name() 
|  |                                       |||
|  |                                       ||[read_lock(&keyring_name_lock)]
|  |                                       |||
|  |                                       ||[spin_lock(&key_serial_lock)]
|  [spin_lock(&key_serial_lock)]           |||
|  .                                       ||*** GET this keyring ***
|  .                                       |||
|  .                                       ||atomic_inc(&keyring->usage)
|  .                                       |||
|  .                                       ||[spin_unlock(&keyring_name_lock)]
|  |                                       |||
|  *** NOT erase because usage>0 ***       ||[read_unlock(&keyring_name_lock)]
|  |                                       ||
|  [spin_unlock(&key_serial_lock)]         |[mutex_unlock(&key_user_k..mutex)]
v                                          |  
TIME                                       ** VALID keyring is returned **
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 security/keys/key.c     |    1 +
 security/keys/keyring.c |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/security/keys/key.c b/security/keys/key.c
index e50d264..3728bc9 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -559,6 +559,7 @@ static void key_cleanup(struct work_struct *work)
 	/* we found a dead key - once we've removed it from the tree, we can
 	 * drop the lock */
 	rb_erase(&key->serial_node, &key_serial_tree);
+	RB_CLEAR_NODE(&key->serial_node); //this can enable RB_EMPTY_NODE()
 	spin_unlock(&key_serial_lock);
 
 	key_check(key);
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index e814d21..72e2b74 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -555,13 +555,23 @@ struct key *find_keyring_by_name(const char *name, bool skip_perm_check)
 					   KEY_SEARCH) < 0)
 				continue;
 
-			/* we've got a match */
+			/* we've got a match but must confirm this keyring
+			* hasn't been yet removed from rb-tree */
+			spin_lock(&key_serial_lock);
+			if (RB_EMPTY_NODE(&keyring->serial_node)) {
+				/* this keyring is now freeing */
+				spin_unlock(&key_serial_lock);
+				goto not_found;
+			}
+			/* we let key_cleanup() not release this keyring */
 			atomic_inc(&keyring->usage);
+			spin_unlock(&key_serial_lock);
 			read_unlock(&keyring_name_lock);
 			goto error;
 		}
 	}
 
+not_found:
 	read_unlock(&keyring_name_lock);
 	keyring = ERR_PTR(-ENOKEY);
 
-- 
1.5.5.6
