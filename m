Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965288Ab2JCRuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:50:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33720 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267Ab2JCRug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:50:36 -0400
Date: Wed, 3 Oct 2012 10:50:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
cc: herbert@gondor.hengli.com.au, pjones@redhat.com, jwboyer@redhat.com,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
Subject: [patch] MODSIGN: Fix build error with strict typechecking
In-Reply-To: <16088.1348736905@warthog.procyon.org.uk>
Message-ID: <alpine.DEB.2.00.1210031045060.29765@chino.kir.corp.google.com>
References: <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"MODSIGN: Provide module signing public keys to the kernel" causes a build 
error when CONFIG_UIDGID_STRICT_TYPE_CHECKS is enabled:

kernel/modsign_pubkey.c: In function 'module_verify_init':
kernel/modsign_pubkey.c:47: error: incompatible type for argument 3 of 'key_alloc'
include/linux/key.h:195: note: expected 'kuid_t' but argument is of type 'int'
kernel/modsign_pubkey.c:47: error: incompatible type for argument 4 of 'key_alloc'
include/linux/key.h:195: note: expected 'kgid_t' but argument is of type 'int'

Cast the parameters accordingly.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/modsign_pubkey.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
--- a/kernel/modsign_pubkey.c
+++ b/kernel/modsign_pubkey.c
@@ -41,7 +41,8 @@ static __init int module_verify_init(void)
 	pr_notice("Initialise module verification\n");
 
 	modsign_keyring = key_alloc(&key_type_keyring, ".module_sign",
-				    0, 0, current_cred(),
+				    KUIDT_INIT(0), KGIDT_INIT(0),
+				    current_cred(),
 				    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
 				    KEY_USR_VIEW | KEY_USR_READ,
 				    KEY_ALLOC_NOT_IN_QUOTA);
