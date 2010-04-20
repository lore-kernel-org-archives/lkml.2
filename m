Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0DTVl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:41:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab0DTVlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:41:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Fix double free in prepare_usermodehelper_creds() error
	handling
To: linux-security-module@vger.kernel.org
Cc: dhowells@redhat.com, mathieu.desnoyers@efficios.com,
       linux-kernel@vger.kernel.org
Date: Tue, 20 Apr 2010 22:41:18 +0100
Message-ID: <20100420214117.10400.82534.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 570b8fb505896e007fd3bb07573ba6640e51851d:

	Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
	Date:   Tue Mar 30 00:04:00 2010 +0100
	Subject: CRED: Fix memory leak in error handling

attempts to fix a memory leak in the error handling by making the offending
return statement into a jump down to the bottom of the function where a
kfree(tgcred) is inserted.

This is, however, incorrect, as it does a kfree() after doing put_cred() if
security_prepare_creds() fails.  That will result in a double free if 'error'
is jumped to as put_cred() will also attempt to free the new tgcred record by
virtue of it being pointed to by the new cred record.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/cred.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index e1dbe9e..ce1a52b 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -398,6 +398,8 @@ struct cred *prepare_usermodehelper_creds(void)
 
 error:
 	put_cred(new);
+	return NULL;
+
 free_tgcred:
 #ifdef CONFIG_KEYS
 	kfree(tgcred);

