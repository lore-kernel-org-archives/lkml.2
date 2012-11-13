Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2KMMgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 07:36:14 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58380 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2KMMgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 07:36:12 -0500
Message-ID: <50A23EB0.1060808@gmail.com>
Date: Tue, 13 Nov 2012 20:36:00 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Steffen Klassert <steffen.klassert@secunet.com>
CC: Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/9] net: xfrm: use __this_cpu_read per-cpu helper
References: <50A1A7C9.3060703@gmail.com> <20121113072101.GG22290@secunet.com> <50A213DF.1040103@gmail.com> <20121113104839.GJ22290@secunet.com>
In-Reply-To: <20121113104839.GJ22290@secunet.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steffen Klassert said, at 2012/11/13 18:48:
> 
> Ok, so please add a commit message to describe your changes.
> 
> Thanks.
> 

[PATCH v5] net: xfrm: use __this_cpu_read per-cpu helper

this_cpu_ptr/this_cpu_read is faster than per_cpu_ptr(p, smp_processor_id()) 
and can reduce  memory accesses.
The latter helper needs to find the offset for current cpu,
and needs more assembler instructions which objdump shows in following. 

this_cpu_ptr relocates and address. this_cpu_read() relocates the address
and performs the fetch. this_cpu_read() saves you more instructions
since it can do the relocation and the fetch in one instruction.

per_cpu_ptr(p, smp_processor_id())：
  1e:   65 8b 04 25 00 00 00 00         mov    %gs:0x0,%eax
  26:   48 98                           cltq
  28:   31 f6                           xor    %esi,%esi
  2a:   48 c7 c7 00 00 00 00            mov    $0x0,%rdi
  31:   48 8b 04 c5 00 00 00 00         mov    0x0(,%rax,8),%rax
  39:   c7 44 10 04 14 00 00 00         movl   $0x14,0x4(%rax,%rdx,1)

this_cpu_ptr(p)
  1e:   65 48 03 14 25 00 00 00 00      add    %gs:0x0,%rdx
  27:   31 f6                           xor    %esi,%esi
  29:   c7 42 04 14 00 00 00            movl   $0x14,0x4(%rdx)
  30:   48 c7 c7 00 00 00 00            mov    $0x0,%rdi

Signed-off-by: Shan Wei <davidshan@tencent.com>
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


