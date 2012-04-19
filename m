Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2DSIb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:31:27 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33789 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2DSIbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:31:23 -0400
Message-ID: <4F8FCA3A.5060504@linux.vnet.ibm.com>
Date: Thu, 19 Apr 2012 13:48:02 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Frank Arnold <frank.arnold@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] cpu: remove some dead code in store_cache_disable()
References: <20120419070053.GB16645@elgon.mountain>
In-Reply-To: <20120419070053.GB16645@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041908-8878-0000-0000-0000021619A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 12:30 PM, Dan Carpenter wrote:

> amd_set_l3_disable_slot() never returns -EEXIST, it only returns -EINVAL
> or zero.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index 73d08ed..7b4e294 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -466,12 +466,9 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
>  		return -EINVAL;
> 
>  	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
> -	if (err) {
> -		if (err == -EEXIST)
> -			printk(KERN_WARNING "L3 disable slot %d in use!\n",
> -					    slot);
> +	if (err)
>  		return err;
> -	}
> +
>  	return count;
>  }
> 


Looking at the comments around the code and the print statement your patch
is trying to remove, I wonder if it would be more appropriate to return
-EEXIST in amd_set_l3_disable_slot(), like this:

---
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] cpu: Fix error return code in amd_set_l3_disable_slot()

If the L3 disable slot is already in use, return -EEXIST instead of -EINVAL.
The caller, store_cache_disable(), checks this return value to print an
appropriate warning.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 73d08ed..0b49e29 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -433,7 +433,7 @@ int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
 	/*  check if @slot is already used or the index is already disabled */
 	ret = amd_get_l3_disable_slot(nb, slot);
 	if (ret >= 0)
-		return -EINVAL;
+		return -EEXIST;
 
 	if (index > nb->l3_cache.indices)
 		return -EINVAL;


Regards,
Srivatsa S. Bhat

