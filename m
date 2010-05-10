Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab0EJW7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:59:01 -0400
Received: from kroah.org ([198.145.64.141]:51641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462Ab0EJW5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:38 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:35 2010
Message-Id: <20100510223535.869870792@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Subject: [16/98] keys: the request_key() syscall should link an existing key to the dest keyring
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

commit 03449cd9eaa4fa3a7faa4a59474bafe2e90bd143 upstream.

The request_key() system call and request_key_and_link() should make a
link from an existing key to the destination keyring (if supplied), not
just from a new key to the destination keyring.

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

request_key() system call is meant to recursively search all your keyrings for
the key you desire, and, optionally, if it doesn't exist, call out to userspace
to create one for you.

If request_key() finds or creates a key, it should, optionally, create a link
to that key from the destination keyring specified.

Therefore, if, after a successful call to request_key() with a desination
keyring specified, you see the destination keyring empty, the code didn't work
correctly.

If you see the found key in the keyring, then it did - which is what the patch
is required for.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/keys/request_key.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -336,8 +336,10 @@ static int construct_alloc_key(struct ke
 
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
@@ -428,6 +430,11 @@ struct key *request_key_and_link(struct
 
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


