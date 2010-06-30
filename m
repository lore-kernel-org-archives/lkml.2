Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0F3JjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:39:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab0F3JjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:39:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Reinstate lost passing of process keyring ID in
	call_sbin_request_key()
To: linux-security-module@vger.kernel.org
Cc: keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Wed, 30 Jun 2010 10:39:11 +0100
Message-ID: <20100630093911.28103.73746.stgit@warthog.procyon.org.uk>
In-Reply-To: <1277861297-13824-1-git-send-email-justinmattock@gmail.com>
References: <1277861297-13824-1-git-send-email-justinmattock@gmail.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin P. Mattock <justinmattock@gmail.com>

In commit bb952bb98a7e479262c7eb25d5592545a3af147d there was the accidental
deletion of a statement from call_sbin_request_key() to render the process
keyring ID to a text string so that it can be passed to /sbin/request-key.

With gcc 4.6.0 this causes the following warning:

  CC      security/keys/request_key.o
security/keys/request_key.c: In function 'call_sbin_request_key':
security/keys/request_key.c:102:15: warning: variable 'prkey' set but not used

This patch reinstates that statement.

Without this statement, /sbin/request-key will get some random rubbish from the
stack as that parameter.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/request_key.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index f5ec9ac..0d26f68 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -144,6 +144,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 	prkey = 0;
 	if (cred->tgcred->process_keyring)
 		prkey = cred->tgcred->process_keyring->serial;
+	sprintf(keyring_str[1], "%d", prkey);
 
 	rcu_read_lock();
 	session = rcu_dereference(cred->tgcred->session_keyring);

