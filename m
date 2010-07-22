Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab0GVRdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:33:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab0GVRdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:33:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/6] KEYS: Authorise keyctl_set_timeout() on a key if we have
	its authorisation key
To: smfrench@gmail.com, jlayton@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 22 Jul 2010 18:32:51 +0100
Message-ID: <20100722173251.1512.29858.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Authorise a process to perform keyctl_set_timeout() on an uninstantiated key if
that process has the authorisation key for it.

This allows the instantiator to set the timeout on a key it is instantiating -
provided it does it before instantiating the key.

For instance, the test upcall script provided with the keyutils package could
be modified to set the expiry to an hour hence before instantiating the key:

	[/usr/share/keyutils/request-key-debug.sh]
	 if [ "$3" != "neg" ]
	 then
	+    keyctl timeout $1 3600
	     keyctl instantiate $1 "Debug $3" $4 || exit 1
	 else

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/keyctl.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 6261745..639226a 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1091,7 +1091,7 @@ error:
 long keyctl_set_timeout(key_serial_t id, unsigned timeout)
 {
 	struct timespec now;
-	struct key *key;
+	struct key *key, *instkey;
 	key_ref_t key_ref;
 	time_t expiry;
 	long ret;
@@ -1099,10 +1099,25 @@ long keyctl_set_timeout(key_serial_t id, unsigned timeout)
 	key_ref = lookup_user_key(id, KEY_LOOKUP_CREATE | KEY_LOOKUP_PARTIAL,
 				  KEY_SETATTR);
 	if (IS_ERR(key_ref)) {
+		/* setting the timeout on a key under construction is permitted
+		 * if we have the authorisation token handy */
+		if (PTR_ERR(key_ref) == -EACCES) {
+			instkey = key_get_instantiation_authkey(id);
+			if (!IS_ERR(instkey)) {
+				key_put(instkey);
+				key_ref = lookup_user_key(id,
+							  KEY_LOOKUP_PARTIAL,
+							  0);
+				if (!IS_ERR(key_ref))
+					goto okay;
+			}
+		}
+
 		ret = PTR_ERR(key_ref);
 		goto error;
 	}
 
+okay:
 	key = key_ref_to_ptr(key_ref);
 
 	/* make the changes with the locks held to prevent races */

