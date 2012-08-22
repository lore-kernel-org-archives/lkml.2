Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab2HVDYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 23:24:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:24442 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab2HVDYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 23:24:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,806,1336374000"; 
   d="scan'208";a="189629555"
Message-ID: <503450C1.8070600@intel.com>
Date: Wed, 22 Aug 2012 11:23:45 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: apparent regressions from TLB range flushing page set
References: <503261F00200007800096710@nat28.tlf.novell.com>
In-Reply-To: <503261F00200007800096710@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 10:12 PM, Jan Beulich wrote:

> Alex,
> 
> without even having run that code yet, I think I see two bugs here,
> both of which I'm pretty sure I pointed out at least once during the
> review cycle:


I was thought you have 'Agreed' for xen part code. :)

> 
> For one, while TLB_FLUSH_ALL gets passed as 'end' argument to
> flush_tlb_others(), the Xen code was made to check its 'start'
> parameter.


Do you mean need the following change? --untested.

>From the logical of flush_tlb_others, the old code should cause unflushed TLB issue
(when end == -1, xen just executed INVLPG_MULTI, not whole TLB_FLUSH_MULTI). but we
 didn't find this problem in xen test. So, guess the xen code has other bug cover this. 

=========
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b65a761..5141d80 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1283,7 +1283,7 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
        cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
 
        args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
-       if (start != TLB_FLUSH_ALL && (end - start) <= PAGE_SIZE) {
+       if (end != TLB_FLUSH_ALL && (end - start) <= PAGE_SIZE) {
                args->op.cmd = MMUEXT_INVLPG_MULTI;
                args->op.arg1.linear_addr = start;
        }

