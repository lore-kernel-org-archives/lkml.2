Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0LVQZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:25:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab0LVQZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:25:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Don't call up_write() if __key_link_begin() returns an
 error
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 22 Dec 2010 16:24:13 +0000
Message-ID: <20101222162412.11779.50496.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In construct_alloc_key(), up_write() is called in the error path if
__key_link_begin() fails, but this is incorrect as __key_link_begin() only
returns with the nominated keyring locked if it returns successfully.

Without this patch, you might see the following in dmesg:

	=====================================
	[ BUG: bad unlock balance detected! ]
	-------------------------------------
	mount.cifs/5769 is trying to release lock (&key->sem) at:
	[<ffffffff81201159>] request_key_and_link+0x263/0x3fc
	but there are no more locks to release!

	other info that might help us debug this:
	3 locks held by mount.cifs/5769:
	 #0:  (&type->s_umount_key#41/1){+.+.+.}, at: [<ffffffff81131321>] sget+0x278/0x3e7
	 #1:  (&ret_buf->session_mutex){+.+.+.}, at: [<ffffffffa0258e59>] cifs_get_smb_ses+0x35a/0x443 [cifs]
	 #2:  (root_key_user.cons_lock){+.+.+.}, at: [<ffffffff81201000>] request_key_and_link+0x10a/0x3fc

	stack backtrace:
	Pid: 5769, comm: mount.cifs Not tainted 2.6.37-rc6+ #1
	Call Trace:
	 [<ffffffff81201159>] ? request_key_and_link+0x263/0x3fc
	 [<ffffffff81081601>] print_unlock_inbalance_bug+0xca/0xd5
	 [<ffffffff81083248>] lock_release_non_nested+0xc1/0x263
	 [<ffffffff81201159>] ? request_key_and_link+0x263/0x3fc
	 [<ffffffff81201159>] ? request_key_and_link+0x263/0x3fc
	 [<ffffffff81083567>] lock_release+0x17d/0x1a4
	 [<ffffffff81073f45>] up_write+0x23/0x3b
	 [<ffffffff81201159>] request_key_and_link+0x263/0x3fc
	 [<ffffffffa026fe9e>] ? cifs_get_spnego_key+0x61/0x21f [cifs]
	 [<ffffffff812013c5>] request_key+0x41/0x74
	 [<ffffffffa027003d>] cifs_get_spnego_key+0x200/0x21f [cifs]
	 [<ffffffffa026e296>] CIFS_SessSetup+0x55d/0x1273 [cifs]
	 [<ffffffffa02589e1>] cifs_setup_session+0x90/0x1ae [cifs]
	 [<ffffffffa0258e7e>] cifs_get_smb_ses+0x37f/0x443 [cifs]
	 [<ffffffffa025a9e3>] cifs_mount+0x1aa1/0x23f3 [cifs]
	 [<ffffffff8111fd94>] ? alloc_debug_processing+0xdb/0x120
	 [<ffffffffa027002c>] ? cifs_get_spnego_key+0x1ef/0x21f [cifs]
	 [<ffffffffa024cc71>] cifs_do_mount+0x165/0x2b3 [cifs]
	 [<ffffffff81130e72>] vfs_kern_mount+0xaf/0x1dc
	 [<ffffffff81131007>] do_kern_mount+0x4d/0xef
	 [<ffffffff811483b9>] do_mount+0x6f4/0x733
	 [<ffffffff8114861f>] sys_mount+0x88/0xc2
	 [<ffffffff8100ac42>] system_call_fastpath+0x16/0x1b

Reported-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-and-Tested-by: Jeff Layton <jlayton@redhat.com>
---

 security/keys/request_key.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 0088dd8..0ea52d2 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -403,7 +403,6 @@ link_check_failed:
 	return ret;
 
 link_prealloc_failed:
-	up_write(&dest_keyring->sem);
 	mutex_unlock(&user->cons_lock);
 	kleave(" = %d [prelink]", ret);
 	return ret;

