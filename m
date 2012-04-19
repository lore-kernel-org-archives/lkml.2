Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2DSLCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:02:48 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51489 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab2DSLCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:02:45 -0400
Date: Thu, 19 Apr 2012 13:02:29 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Frank Arnold <frank.arnold@amd.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] cpu: remove some dead code in store_cache_disable()
Message-ID: <20120419110229.GB30447@aftab>
References: <20120419070053.GB16645@elgon.mountain>
 <4F8FCA3A.5060504@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8FCA3A.5060504@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 01:48:02PM +0530, Srivatsa S. Bhat wrote:
> On 04/19/2012 12:30 PM, Dan Carpenter wrote:
> 
> > amd_set_l3_disable_slot() never returns -EEXIST, it only returns -EINVAL
> > or zero.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> > index 73d08ed..7b4e294 100644
> > --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> > +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> > @@ -466,12 +466,9 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
> >  		return -EINVAL;
> > 
> >  	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
> > -	if (err) {
> > -		if (err == -EEXIST)
> > -			printk(KERN_WARNING "L3 disable slot %d in use!\n",
> > -					    slot);
> > +	if (err)
> >  		return err;
> > -	}
> > +
> >  	return count;
> >  }
> > 
> 
> 
> Looking at the comments around the code and the print statement your patch
> is trying to remove, I wonder if it would be more appropriate to return
> -EEXIST in amd_set_l3_disable_slot(), like this:
> 
> ---
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] cpu: Fix error return code in amd_set_l3_disable_slot()
> 
> If the L3 disable slot is already in use, return -EEXIST instead of -EINVAL.
> The caller, store_cache_disable(), checks this return value to print an
> appropriate warning.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index 73d08ed..0b49e29 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -433,7 +433,7 @@ int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
>  	/*  check if @slot is already used or the index is already disabled */
>  	ret = amd_get_l3_disable_slot(nb, slot);
>  	if (ret >= 0)
> -		return -EINVAL;
> +		return -EEXIST;
>  
>  	if (index > nb->l3_cache.indices)
>  		return -EINVAL;

Well, let's see, there's 8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0 which
was intending at looking at -EEXIST when it gets returned but forgot to
return it at the end. Crap. Somebody should b*tchslap its author... oh,
that's me.

Good catch guys, thanks. I'll take a bit enhanced version of Srivatsa's
patch because it goes in the way of what was originally intended. The
enhanced version returns -EEXIST for the other slot too when we're
disabling the same index, see below:

--
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 19 Apr 2012 12:35:08 +0200
Subject: [PATCH] x86, intel_cacheinfo: Fix error return code in amd_set_l3_disable_slot()

If the L3 disable slot is already in use, return -EEXIST instead of
-EINVAL. The caller, store_cache_disable(), checks this return value to
print an appropriate warning.

Also, we want to signal with -EEXIST that the current index we're
disabling has actually been already disabled on the node:

$ echo 12 > /sys/devices/system/cpu/cpu3/cache/index3/cache_disable_0
$ echo 12 > /sys/devices/system/cpu/cpu3/cache/index3/cache_disable_0
-bash: echo: write error: File exists
$ echo 12 > /sys/devices/system/cpu/cpu3/cache/index3/cache_disable_1
-bash: echo: write error: File exists
$ echo 12 > /sys/devices/system/cpu/cpu5/cache/index3/cache_disable_1
-bash: echo: write error: File exists

The old code would say

-bash: echo: write error: Invalid argument

for disable slot 1 when playing the example above with no output in
dmesg, which is clearly misleading.

Cc: <stable@vger.kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120419070053.GB16645@elgon.mountain
[Boris: add testing for the other index too]
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 73d08ed98a64..b8f3653dddbc 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -433,14 +433,14 @@ int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
 	/*  check if @slot is already used or the index is already disabled */
 	ret = amd_get_l3_disable_slot(nb, slot);
 	if (ret >= 0)
-		return -EINVAL;
+		return -EEXIST;
 
 	if (index > nb->l3_cache.indices)
 		return -EINVAL;
 
 	/* check whether the other slot has disabled the same index already */
 	if (index == amd_get_l3_disable_slot(nb, !slot))
-		return -EINVAL;
+		return -EEXIST;
 
 	amd_l3_disable_index(nb, cpu, slot, index);
 
@@ -468,8 +468,8 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
 	if (err) {
 		if (err == -EEXIST)
-			printk(KERN_WARNING "L3 disable slot %d in use!\n",
-					    slot);
+			pr_warning("L3 slot %d in use/index already disabled!\n",
+				   slot);
 		return err;
 	}
 	return count;
-- 
1.7.9.3.362.g71319


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
