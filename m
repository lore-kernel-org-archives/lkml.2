Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab0DCGog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 02:44:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:20507 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab0DCGoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 02:44:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,356,1267430400"; 
   d="scan'208";a="609965177"
Subject: Re: [PATCH 1/4] [tip:x86/mm] Correcting improper large page
 preservation
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
In-Reply-To: <v2o817ecb6f1003311859nb14bab83y80f743a0accc5028@mail.gmail.com>
References: <v2o817ecb6f1003311859nb14bab83y80f743a0accc5028@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 02 Apr 2010 23:43:20 -0700
Message-Id: <1270277000.2686.20.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 18:59 -0700, Siarhei Liakh wrote:
> +	/*
> +	 * .data and .bss should always be writable.
> +	 */
> +	if ((within(pfn, __pa((unsigned long)_sdata) >> PAGE_SHIFT,
> +		   __pa((unsigned long)_edata) >> PAGE_SHIFT)) ||
> +	    (within(pfn, __pa((unsigned long)__bss_start) >> PAGE_SHIFT,
> +		   __pa((unsigned long)__bss_stop) >> PAGE_SHIFT))) {
> +		pgprot_val(required) |= _PAGE_RW;
> +	}

I have reviewed this patch and the only comment I have is:

On 64bit kernels, kernel text/data mapping and kernel identity mappings
are different virtual addresses mapping to same pfn ranges. For the
data/bss pages, does it help (in identifying certain data corruptions
more easily) in making the kernel identity mapping to be set to
read-only and enforce the need of RW only for the kernel data mappings.

Or is there some obscure code that uses something like
__va(__pa(data_symbol)) and writes to it?

If not, we can remove the __pa() constructs above and use the addr for
comparisons.

Otherwise this patch looks good to me.

Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>

