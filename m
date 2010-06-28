Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab0F1NFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:05:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab0F1NFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:05:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Use the variable 'key' in keyctl_describe_key()
To: linux-security-module@vger.kernel.org
Cc: keyrings@linux-nfs.org, dhowells@redhat.com, justinmattock@gmail.com,
       linux-kernel@vger.kernel.org
Date: Mon, 28 Jun 2010 14:05:04 +0100
Message-ID: <20100628130504.9134.11866.stgit@warthog.procyon.org.uk>
In-Reply-To: <1277621246-10960-2-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-2-git-send-email-justinmattock@gmail.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keyctl_describe_key() turns the key reference it gets into a usable key pointer
and assigns that to a variable called 'key', which it then ignores in favour of
recomputing the key pointer each time it needs it.  Make it use the precomputed
pointer instead.

Without this patch, gcc 4.6 reports that the variable key is set but not used:

	building with gcc 4.6 I'm getting a warning message:
	 CC      security/keys/keyctl.o
	security/keys/keyctl.c: In function 'keyctl_describe_key':
	security/keys/keyctl.c:472:14: warning: variable 'key' set but not used

Reported-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/keyctl.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 639226a..b2b0998 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -505,13 +505,11 @@ okay:
 
 	ret = snprintf(tmpbuf, PAGE_SIZE - 1,
 		       "%s;%d;%d;%08x;%s",
-		       key_ref_to_ptr(key_ref)->type->name,
-		       key_ref_to_ptr(key_ref)->uid,
-		       key_ref_to_ptr(key_ref)->gid,
-		       key_ref_to_ptr(key_ref)->perm,
-		       key_ref_to_ptr(key_ref)->description ?
-		       key_ref_to_ptr(key_ref)->description : ""
-		       );
+		       key->type->name,
+		       key->uid,
+		       key->gid,
+		       key->perm,
+		       key->description ?: "");
 
 	/* include a NUL char at the end of the data */
 	if (ret > PAGE_SIZE - 1)

