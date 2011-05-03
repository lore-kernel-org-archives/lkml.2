Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1ECHBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 03:01:37 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:22999 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1ECHBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 03:01:35 -0400
Message-ID: <4DBFA78F.9060001@snapgear.com>
Date: Tue, 3 May 2011 16:58:23 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <akpm@linux-foundation.org>, <arnd@arndb.de>,
        Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH v3 1/7] m68knommu: fix build error due to the lack of
 find_next_bit_le()
References: <1303910411-15793-1-git-send-email-akinobu.mita@gmail.com> <1303910411-15793-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1303910411-15793-2-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

On 27/04/11 23:20, Akinobu Mita wrote:
> m68knommu can't build ext4, udf, and ocfs2 due to the lack of
> find_next_bit_le().
>
> This implements find_next_bit_le() on m68knommu by duplicating the
> generic find_next_bit_le() in lib/find_next_bit.c.

Wouldn't the m68k specific implementation of this in
arch/m68k/include/asm/bitops_mm.h be better?

(bitops_*.h is still on my list of files to clean up and
merge for m68k mmu and non-mmu)

Regards
Greg



> Signed-off-by: Akinobu Mita<akinobu.mita@gmail.com>
> Cc: Greg Ungerer<gerg@uclinux.org>
> ---
>
> This patch should go into 2.6.39
>
>   arch/m68k/include/asm/bitops_no.h |   44 +++++++++++++++++++++++++++++++++++++
>   1 files changed, 44 insertions(+), 0 deletions(-)
>
> diff --git a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
> index 7d3779f..97d1d0c 100644
> --- a/arch/m68k/include/asm/bitops_no.h
> +++ b/arch/m68k/include/asm/bitops_no.h
> @@ -336,6 +336,50 @@ found_middle:
>   	return result + ffz(__swab32(tmp));
>   }
>
> +static inline unsigned long find_next_bit_le(const void *addr, unsigned
> +		long size, unsigned long offset)
> +{
> +	const unsigned long *p = addr;
> +	unsigned long result = offset&  ~(BITS_PER_LONG - 1);
> +	unsigned long tmp;
> +
> +	if (offset>= size)
> +		return size;
> +	p += offset / BITS_PER_LONG;
> +	size -= result;
> +	offset&= (BITS_PER_LONG - 1UL);
> +	if (offset) {
> +		tmp = __swab32(*(p++));
> +		tmp&= (~0UL<<  offset);
> +		if (size<  BITS_PER_LONG)
> +			goto found_first;
> +		if (tmp)
> +			goto found_middle;
> +		size -= BITS_PER_LONG;
> +		result += BITS_PER_LONG;
> +	}
> +
> +	while (size&  ~(BITS_PER_LONG - 1)) {
> +		tmp = *(p++);
> +		if (tmp)
> +			goto found_middle_swap;
> +		result += BITS_PER_LONG;
> +		size -= BITS_PER_LONG;
> +	}
> +	if (!size)
> +		return result;
> +	tmp = __swab32(*p);
> +found_first:
> +	tmp&= (~0UL>>  (BITS_PER_LONG - size));
> +	if (tmp == 0UL)		/* Are any bits set? */
> +		return result + size; /* Nope. */
> +found_middle:
> +	return result + __ffs(tmp);
> +
> +found_middle_swap:
> +	return result + __ffs(__swab32(tmp));
> +}
> +
>   #endif /* __KERNEL__ */
>
>   #include<asm-generic/bitops/fls.h>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
