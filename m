Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1GHFFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:05:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab1GHFE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:00 2011
Message-Id: <20110708001700.735088948@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>
Subject: [082/107] KEYS: Fix error handling in construct_key_and_link()
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

commit b1d7dd80aadb9042e83f9778b484a2f92e0b04d4 upstream.

Fix error handling in construct_key_and_link().

If construct_alloc_key() returns an error, it shouldn't pass out through
the normal path as the key_serial() called by the kleave() statement
will oops when it gets an error code in the pointer:

  BUG: unable to handle kernel paging request at ffffffffffffff84
  IP: [<ffffffff8120b401>] request_key_and_link+0x4d7/0x52f
  ..
  Call Trace:
   [<ffffffff8120b52c>] request_key+0x41/0x75
   [<ffffffffa00ed6e8>] cifs_get_spnego_key+0x206/0x226 [cifs]
   [<ffffffffa00eb0c9>] CIFS_SessSetup+0x511/0x1234 [cifs]
   [<ffffffffa00d9799>] cifs_setup_session+0x90/0x1ae [cifs]
   [<ffffffffa00d9c02>] cifs_get_smb_ses+0x34b/0x40f [cifs]
   [<ffffffffa00d9e05>] cifs_mount+0x13f/0x504 [cifs]
   [<ffffffffa00caabb>] cifs_do_mount+0xc4/0x672 [cifs]
   [<ffffffff8113ae8c>] mount_fs+0x69/0x155
   [<ffffffff8114ff0e>] vfs_kern_mount+0x63/0xa0
   [<ffffffff81150be2>] do_kern_mount+0x4d/0xdf
   [<ffffffff81152278>] do_mount+0x63c/0x69f
   [<ffffffff8115255c>] sys_mount+0x88/0xc2
   [<ffffffff814fbdc2>] system_call_fastpath+0x16/0x1b

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/keys/request_key.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -470,7 +470,7 @@ static struct key *construct_key_and_lin
 	} else if (ret == -EINPROGRESS) {
 		ret = 0;
 	} else {
-		key = ERR_PTR(ret);
+		goto couldnt_alloc_key;
 	}
 
 	key_put(dest_keyring);
@@ -480,6 +480,7 @@ static struct key *construct_key_and_lin
 construction_failed:
 	key_negate_and_link(key, key_negative_timeout, NULL, NULL);
 	key_put(key);
+couldnt_alloc_key:
 	key_put(dest_keyring);
 	kleave(" = %d", ret);
 	return ERR_PTR(ret);


