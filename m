Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1FUNdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:33:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560Ab1FUNdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:33:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Fix error handling in construct_key_and_link()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Date: Tue, 21 Jun 2011 14:32:05 +0100
Message-ID: <20110621133205.32304.82464.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix error handling in construct_key_and_link().  If construct_alloc_key()
returns an error, it shouldn't pass out through the normal path as the
key_serial() called by the kleave() statement will oops when it gets an error
code in the pointer:

BUG: unable to handle kernel paging request at ffffffffffffff84
IP: [<ffffffff8120b401>] request_key_and_link+0x4d7/0x52f
PGD 1a05067 PUD 1a06067 PMD 0
Oops: 0000 [#1] SMP
CPU 0
Modules linked in: cifs nls_utf8 fscache sunrpc ipx p8022 psnap llc p8023 rose ax25 joydev i2c_piix4 i2c_core virtio_balloon virtio_net virtio_blk [last unloaded: cifs]

Pid: 6888, comm: mount.cifs Not tainted 3.0-0.rc3.git5.1.fc16.x86_64 #1 Bochs Bochs
RIP: 0010:[<ffffffff8120b401>]  [<ffffffff8120b401>] request_key_and_link+0x4d7/0x52f
RSP: 0018:ffff8800314fd9d8  EFLAGS: 00010282
RAX: ffffffffffffff00 RBX: ffffffffffffff80 RCX: 000000000000000a
RDX: 0000000000000000 RSI: ffffffff81a59c90 RDI: ffff88003b2aa180
RBP: ffff8800314fda78 R08: 0000000000000002 R09: 0000000000000000
R10: 0000ffff00066c0a R11: 0000000000000001 R12: ffffffffa01017a0
R13: ffff88003b2aa180 R14: ffff880032525600 R15: ffffffff81a5a518
FS:  00007f8353a09740(0000) GS:ffff88003fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffffffff84 CR3: 000000003b821000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount.cifs (pid: 6888, threadinfo ffff8800314fc000, task ffff88003aa9c7a0)
Stack:
 0000000000000000 0000000000000000 0000000000000000 ffffffff8125be28
 ffffffffa00ff5a7 0000000000000000 0000000000000000 ffffffff81a5a500
 ffffffffa00ff5dd ffff8800326f7d68 ffffff8000000000 0000000000000000
Call Trace:
 [<ffffffff8125be28>] ? vsnprintf+0x3c5/0x401
 [<ffffffff8120b52c>] request_key+0x41/0x75
 [<ffffffffa00ed6e8>] cifs_get_spnego_key+0x206/0x226 [cifs]
 [<ffffffffa00eb0c9>] CIFS_SessSetup+0x511/0x1234 [cifs]
 [<ffffffff81085bea>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa00d9799>] cifs_setup_session+0x90/0x1ae [cifs]
 [<ffffffffa00d9c02>] cifs_get_smb_ses+0x34b/0x40f [cifs]
 [<ffffffffa00d9e05>] cifs_mount+0x13f/0x504 [cifs]
 [<ffffffff81261e71>] ? __raw_spin_lock_init+0x31/0x52
 [<ffffffffa00caabb>] cifs_do_mount+0xc4/0x672 [cifs]
 [<ffffffff810f08ea>] ? __free_pages+0x26/0x2f
 [<ffffffff810f093a>] ? free_pages+0x47/0x4c
 [<ffffffff81212829>] ? selinux_sb_copy_data+0x192/0x1ab
 [<ffffffff8113ae8c>] mount_fs+0x69/0x155
 [<ffffffff81104750>] ? __alloc_percpu+0x10/0x12
 [<ffffffff8114ff0e>] vfs_kern_mount+0x63/0xa0
 [<ffffffff81150be2>] do_kern_mount+0x4d/0xdf
 [<ffffffff81152278>] do_mount+0x63c/0x69f
 [<ffffffff8115255c>] sys_mount+0x88/0xc2
 [<ffffffff814fbdc2>] system_call_fastpath+0x16/0x1b

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
---

 security/keys/request_key.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 8e319a4..8246532 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -469,7 +469,7 @@ static struct key *construct_key_and_link(struct key_type *type,
 	} else if (ret == -EINPROGRESS) {
 		ret = 0;
 	} else {
-		key = ERR_PTR(ret);
+		goto couldnt_alloc_key;
 	}
 
 	key_put(dest_keyring);
@@ -479,6 +479,7 @@ static struct key *construct_key_and_link(struct key_type *type,
 construction_failed:
 	key_negate_and_link(key, key_negative_timeout, NULL, NULL);
 	key_put(key);
+couldnt_alloc_key:
 	key_put(dest_keyring);
 	kleave(" = %d", ret);
 	return ERR_PTR(ret);

