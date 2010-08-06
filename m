Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0HFPJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:09:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab0HFPJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:09:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: request_key() should return -ENOKEY if the constructed
	key is negative
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 06 Aug 2010 16:08:27 +0100
Message-ID: <20100806150827.8027.8956.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_key() should return -ENOKEY if the key it constructs has been
negatively instantiated.

Without this, request_key() can return an unusable key to its caller, and if
the caller then does key_validate() that won't catch the problem.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/request_key.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 0d26f68..0088dd8 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -537,6 +537,8 @@ int wait_for_key_construction(struct key *key, bool intr)
 			  intr ? TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
 	if (ret < 0)
 		return ret;
+	if (test_bit(KEY_FLAG_NEGATIVE, &key->flags))
+		return -ENOKEY;
 	return key_validate(key);
 }
 EXPORT_SYMBOL(wait_for_key_construction);

