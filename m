Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2LQNPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:15:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2LQNPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:15:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/2] KEYS: Use keyring_alloc() to create module signing
 keyring
To: torvalds@linux-foundation.com
From: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, jmorris@namei.org,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Dec 2012 13:15:31 +0000
Message-ID: <20121217131531.2974.66791.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121217131523.2974.74337.stgit@warthog.procyon.org.uk>
References: <20121217131523.2974.74337.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use keyring_alloc() to create special keyrings now that it has a permissions
parameter rather than using key_alloc() + key_instantiate_and_link().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
---

 kernel/modsign_pubkey.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
index 767e559..524a56f 100644
--- a/kernel/modsign_pubkey.c
+++ b/kernel/modsign_pubkey.c
@@ -40,18 +40,15 @@ static __init int module_verify_init(void)
 {
 	pr_notice("Initialise module verification\n");
 
-	modsign_keyring = key_alloc(&key_type_keyring, ".module_sign",
-				    KUIDT_INIT(0), KGIDT_INIT(0),
-				    current_cred(),
-				    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
-				    KEY_USR_VIEW | KEY_USR_READ,
-				    KEY_ALLOC_NOT_IN_QUOTA);
+	modsign_keyring = keyring_alloc(".module_sign",
+					KUIDT_INIT(0), KGIDT_INIT(0),
+					current_cred(),
+					((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+					 KEY_USR_VIEW | KEY_USR_READ),
+					KEY_ALLOC_NOT_IN_QUOTA, NULL);
 	if (IS_ERR(modsign_keyring))
 		panic("Can't allocate module signing keyring\n");
 
-	if (key_instantiate_and_link(modsign_keyring, NULL, 0, NULL, NULL) < 0)
-		panic("Can't instantiate module signing keyring\n");
-
 	return 0;
 }
 

