Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1AYRc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:32:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47631 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1AYRc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:32:57 -0500
Message-ID: <4D3F0896.4050006@zytor.com>
Date: Tue, 25 Jan 2011 09:29:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next 2/2][RFC] x86: Saveoops: Reserve low memory and
 register code
References: <20110125134748.GA10051@laptop> <20110125135326.GC10051@laptop>
In-Reply-To: <20110125135326.GC10051@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 05:53 AM, Ahmed S. Darwish wrote:
> +
> +/*
> + * Extended BIOS services write to disk in units of 512-byte sectors.
> + * Thus, always align the ring buffer size on a 512-byte boundary.
> + */

Units of sectors, not always 512 bytes.  This needs to be done
correctly, or you will destroy real data.

> +/*
> + * Page tables to identity map the first 2 Mbytes.
> + */
> +static __aligned(PAGE_SIZE) pud_t ident_level3[PTRS_PER_PUD];
> +static __aligned(PAGE_SIZE) pmd_t ident_level2[PTRS_PER_PMD];
> +
> +/*
> + * The lmode->rmode switching code needs to run from an identity page
> + * since it disables paging.
> + */
> +static void build_identity_mappings(void)
> +{
> +	pgd_t *pgde;
> +	pud_t *pude;
> +	pmd_t *pmde;
> +
> +	pmde = ident_level2;
> +	set_pmd(pmde, __pmd(0 + __PAGE_KERNEL_IDENT_LARGE_EXEC));
> +
> +	pude = ident_level3;
> +	set_pud(pude, __pud(__pa(ident_level2) + _KERNPG_TABLE));
> +
> +	pgde = init_level4_pgt;
> +	set_pgd(pgde, __pgd(__pa(ident_level3) + _KERNPG_TABLE));
> +
> +	__flush_tlb_all();
> +}

We now have a permanent identity map so there is no point in building a
new one.

However, I'm quite nervous about this -- this patch has *plenty* of real
possibility of wrecking data.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

