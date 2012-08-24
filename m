Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2HXIHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 04:07:13 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:53566 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2HXIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 04:06:59 -0400
Date: Fri, 24 Aug 2012 10:07:00 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com
Subject: Re: [RFC patch 7/7] thp, s390: architecture backend for thp on
 System z
Message-ID: <20120824080700.GC3533@osiris.de.ibm.com>
References: <20120823171733.595087166@de.ibm.com>
 <20120823171855.006932817@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823171855.006932817@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12082408-6892-0000-0000-000002CCFECA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 07:17:40PM +0200, Gerald Schaefer wrote:
> +#define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
> +static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
> +					    unsigned long address,
> +					    pmd_t *pmdp)
> +{
> +	int rc = 0;
> +	int counter = PTRS_PER_PTE;
> +	unsigned long pmd_addr = pmd_val(*pmdp) & HPAGE_MASK;
> +
> +	asm volatile(
> +		"0:	rrbe	0,%2\n"
> +		"	la	%2,0(%3,%2)\n"
> +		"	brc	12,1f\n"
> +		"	lhi	%0,1\n"
> +		"1:	brct	%1,0b\n"
> +		: "+d" (rc), "+d" (counter), "+a" (pmd_addr)
> +		: "a" (4096UL): "cc" );
> +	return rc;
> +}

Just a small side note: given that rrbe is very expensive you probably
should extend this function so it makes use of the rrbm instruction
if available.

