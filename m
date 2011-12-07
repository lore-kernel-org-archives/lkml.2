Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab1LGS7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:59:54 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:48196 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195Ab1LGS7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:59:51 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: "David S . Miller" <davem@davemloft.net>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 1/3] crypto: Add per-cpu transform alloc() and free()
Date: Wed,  7 Dec 2011 12:59:08 -0600
Message-Id: <1323284350-13784-2-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323284350-13784-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1323284350-13784-1-git-send-email-sjenning@linux.vnet.ibm.com>
x-cbid: 11120718-1780-0000-0000-0000017A9487
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000238; HX=3.00000179; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00094108; UDB=6.00024740; UTC=2011-12-07
 18:59:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add two functions for allocating a freeing
dynamically allocated per-cpu transform structures.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 crypto/api.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..f95b3f9 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -602,5 +602,67 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_alg);
 
+/*
+ * Per-cpu crypto helpers
+ *
+ * crypto_alloc_percpu_tfms() and crypto_free_percpu_tfms() are used for
+ * allocating tfms on a per-cpu basis. The set of cpus the tfms are
+ * allocated/freed on is determined by the cpumask (see linux/cpumask.h).
+ * If the cpu_possible_mask is used, then the user has a tfm for every cpu
+ * that could ever possibly enabled. However, if the user calls with cpumask
+ * cpu_online_mask or cpu_present_mask with HOTPLUG enabled, the user
+ * must register a cpu notifier to allocate/free the tfm for dynamically
+ * added/removed cpus.
+*/
+void crypto_free_percpu_tfms(struct crypto_tfm * __percpu *tfms,
+				const struct cpumask *cpumask)
+{
+	int cpu;
+	struct crypto_tfm *tfm;
+
+	if (!tfms)
+		return;
+
+	for_each_cpu(cpu, cpumask) {
+		tfm = *per_cpu_ptr(tfms, cpu);
+		if (!tfm)
+			continue;
+		crypto_free_tfm(tfm);
+		*per_cpu_ptr(tfms, cpu) = NULL;
+	}
+
+	free_percpu(tfms);
+}
+EXPORT_SYMBOL_GPL(crypto_free_percpu_tfms);
+
+struct crypto_tfm * __percpu *crypto_alloc_percpu_tfms(const char *alg_name,
+			u32 type, u32 mask, const struct cpumask *cpumask)
+{
+	int cpu, err;
+	struct crypto_tfm * __percpu *tfms, *tfm;
+
+	tfms = alloc_percpu(struct crypto_tfm *);
+	if (!tfms) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	for_each_cpu(cpu, cpumask) {
+		tfm = crypto_alloc_base(alg_name, type, mask);
+		if (IS_ERR(tfm)) {
+			err = PTR_ERR(tfm);
+			goto error;
+		}
+		*per_cpu_ptr(tfms, cpu) = tfm;
+	}
+	return tfms;
+
+error:
+	if (tfms)
+		crypto_free_percpu_tfms(tfms, cpumask);
+	return (struct crypto_tfm * __percpu *)(ERR_PTR(err));
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_percpu_tfms);
+
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4

