Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2KMBwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:52:22 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36812 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2KMBwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:52:18 -0500
Message-ID: <50A1A7C9.3060703@gmail.com>
Date: Tue, 13 Nov 2012 09:52:09 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: steffen.klassert@secunet.com, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v4 3/9] net: xfrm: use __this_cpu_read per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>


Signed-off-by: Shan Wei <davidshan@tencent.com>
---
v4:
  derefrence pointer before reading to avoid compile warning.
---
 net/xfrm/xfrm_ipcomp.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index e5246fb..2906d52 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -276,18 +276,16 @@ static struct crypto_comp * __percpu *ipcomp_alloc_tfms(const char *alg_name)
 	struct crypto_comp * __percpu *tfms;
 	int cpu;
 
-	/* This can be any valid CPU ID so we don't need locking. */
-	cpu = raw_smp_processor_id();
 
 	list_for_each_entry(pos, &ipcomp_tfms_list, list) {
 		struct crypto_comp *tfm;
 
-		tfms = pos->tfms;
-		tfm = *per_cpu_ptr(tfms, cpu);
+		/* This can be any valid CPU ID so we don't need locking. */
+		tfm = __this_cpu_read(*pos->tfms);
 
 		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
-			return tfms;
+			return pos->tfms;
 		}
 	}
 
-- 
1.7.1


