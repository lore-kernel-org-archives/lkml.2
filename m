Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab2EVXFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:05:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114Ab2EVXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:05:26 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/23] MODSIGN: Panic the kernel if FIPS is enabled upon
 module signing failure
To: rusty@rustcorp.com.au, kyle@mcmartin.ca
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, David Howells <dhowells@redhat.com>
Date: Wed, 23 May 2012 00:05:18 +0100
Message-ID: <20120522230518.24007.93525.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If module signing fails when the kernel is running with FIPS enabled then the
kernel should panic lest the crypto layer be compromised.  Possibly a panic
shouldn't happen on cases like ENOMEM.

Reported-by: Stephan Mueller <stephan.mueller@atsec.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/module-verify.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/kernel/module-verify.c b/kernel/module-verify.c
index f989fee..9baecc6 100644
--- a/kernel/module-verify.c
+++ b/kernel/module-verify.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/modsign.h>
 #include <linux/moduleparam.h>
+#include <linux/fips.h>
 #include <keys/crypto-type.h>
 #include "module-verify.h"
 
@@ -109,6 +110,10 @@ int module_verify(const void *data, size_t size, bool *_gpgsig_ok)
 
 	pr_devel("module_verify_signature() = %d\n", ret);
 
+        if (ret < 0 && fips_enabled)
+                panic("Module verification failed with error %d in FIPS mode\n",
+                      ret);
+
 	switch (ret) {
 	case 0:			/* Good signature */
 		*_gpgsig_ok = true;

