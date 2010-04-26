Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0DZPou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 11:44:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0DZPot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 11:44:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: The request_key() syscall should link an existing key
	to the dest keyring
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Apr 2010 16:44:41 +0100
Message-ID: <20100426154441.26028.52967.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The request_key() system call and request_key_and_link() should make a link
from an existing key to the destination keyring (if supplied), not just from a
new key to the destination keyring.

This can be tested by:

	ring=`keyctl newring fred @s`
	keyctl request2 user debug:a a
	keyctl request user debug:a $ring
	keyctl list $ring

If it says:

	keyring is empty

then it didn't work.  If it shows something like:

	1 key in keyring:
	1070462727: --alswrv     0     0 user: debug:a

then it did.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/request_key.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index ea97c31..d737cea 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -339,8 +339,10 @@ static int construct_alloc_key(struct key_type *type,
 
 key_already_present:
 	mutex_unlock(&key_construction_mutex);
-	if (dest_keyring)
+	if (dest_keyring) {
+		__key_link(dest_keyring, key_ref_to_ptr(key_ref));
 		up_write(&dest_keyring->sem);
+	}
 	mutex_unlock(&user->cons_lock);
 	key_put(key);
 	*_key = key = key_ref_to_ptr(key_ref);
@@ -431,6 +433,11 @@ struct key *request_key_and_link(struct key_type *type,
 
 	if (!IS_ERR(key_ref)) {
 		key = key_ref_to_ptr(key_ref);
+		if (dest_keyring) {
+			construct_get_dest_keyring(&dest_keyring);
+			key_link(dest_keyring, key);
+			key_put(dest_keyring);
+		}
 	} else if (PTR_ERR(key_ref) != -EAGAIN) {
 		key = ERR_CAST(key_ref);
 	} else  {

