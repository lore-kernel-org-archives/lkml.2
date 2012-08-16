Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab2HPBii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:38:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab2HPBid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:38:33 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/25] MODSIGN: Panic the kernel if FIPS is enabled upon
 module signing failure
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 02:38:24 +0100
Message-ID: <20120816013824.872.75588.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
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
 1 file changed, 5 insertions(+)


diff --git a/kernel/module-verify.c b/kernel/module-verify.c
index 6684e24..070d730 100644
--- a/kernel/module-verify.c
+++ b/kernel/module-verify.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/modsign.h>
 #include <linux/moduleparam.h>
+#include <linux/fips.h>
 #include <keys/crypto-type.h>
 #include "module-verify.h"
 
@@ -97,6 +98,10 @@ int module_verify(const void *data, size_t size, bool *_gpgsig_ok)
 
 	pr_devel("module_verify_signature() = %d\n", ret);
 
+        if (ret < 0 && fips_enabled)
+                panic("Module verification failed with error %d in FIPS mode\n",
+                      ret);
+
 	switch (ret) {
 	case 0:			/* Good signature */
 		*_gpgsig_ok = true;

