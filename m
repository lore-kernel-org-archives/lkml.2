Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab2KICVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:21:08 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59862 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab2KICVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:21:04 -0500
Message-ID: <509C688B.5010502@gmail.com>
Date: Fri, 09 Nov 2012 10:20:59 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: steffen.klassert@secunet.com, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v3 3/9] net: xfrm: use __this_cpu_read per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>


Signed-off-by: Shan Wei <davidshan@tencent.com>
---
v3 fix compile warning:
net/xfrm/xfrm_ipcomp.c: In function 'ipcomp_alloc_tfms':
net/xfrm/xfrm_ipcomp.c:285: warning: assignment from incompatible pointer type

---
 net/xfrm/xfrm_ipcomp.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index e5246fb..898c899 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -276,18 +276,15 @@ static struct crypto_comp * __percpu *ipcomp_alloc_tfms(const char *alg_name)
 	struct crypto_comp * __percpu *tfms;
 	int cpu;
 
-	/* This can be any valid CPU ID so we don't need locking. */
-	cpu = raw_smp_processor_id();
 
 	list_for_each_entry(pos, &ipcomp_tfms_list, list) {
 		struct crypto_comp *tfm;
 
-		tfms = pos->tfms;
-		tfm = *per_cpu_ptr(tfms, cpu);
+		tfm = (struct crypto_comp *) __this_cpu_read(pos->tfms);
 
 		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
-			return tfms;
+			return pos->tfms;
 		}
 	}
 
-- 
1.7.1
