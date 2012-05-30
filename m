Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2E3C1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 22:27:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:64744 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab2E3C1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 22:27:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158487638"
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Tilo =?utf-8?Q?M=C3=BCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler implementation
References: <20120527145112.GF17705@kronos.redsun>
Date: Tue, 29 May 2012 19:27:43 -0700
In-Reply-To: <20120527145112.GF17705@kronos.redsun> (Johannes Goetzfried's
	message of "Sun, 27 May 2012 16:51:12 +0200")
Message-ID: <m2396il7xc.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Goetzfried
<Johannes.Goetzfried@informatik.stud.uni-erlangen.de> writes:
> +
> +static int __init serpent_init(void)
> +{
> +	u64 xcr0;
> +
> +	if (!cpu_has_avx || !cpu_has_osxsave) {
> +		printk(KERN_INFO "AVX instructions are not detected.\n");
> +		return -ENODEV;
> +	}
> +
> +	xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
> +	if ((xcr0 & (XSTATE_SSE | XSTATE_YMM)) != (XSTATE_SSE | XSTATE_YMM)) {
> +		printk(KERN_INFO "AVX detected but unusable.\n");
> +		return -ENODEV;
> +	}
> +
> +	return crypto_register_algs(serpent_algs, ARRAY_SIZE(serpent_algs));
> +}
> +
> +static void __exit serpent_exit(void)
> +{
> +	crypto_unregister_algs(serpent_algs, ARRAY_SIZE(serpent_algs));
> +}
> +
> +module_init(serpent_init);
> +module_exit(serpent_exit);
> +
> +MODULE_DESCRIPTION("Serpent Cipher Algorithm, AVX optimized");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("serpent");

The driver needs CPUID annotations now (since 3.3), so that it can be 
autoloaded.  Something like:

#include <asm/cpu_device_id.h>


static const struct x86_cpu_id avx_cpu_id[] = {
        X86_FEATURE_MATCH(X86_FEATURE_AVX),
        {}
};
MODULE_DEVICE_TABLE(x86cpu, avx_cpu_id);


Replace the manual check in init with

            if (!x86_match_cpu(avx_cpu_id))
                return -ENODEV;

Also drivers should never print anything when they cannot find hardware.
Remove that printk.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
