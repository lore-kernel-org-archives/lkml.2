Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0HSL5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:57:48 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:2402 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000Ab0HSL5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:57:44 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7JBvdNZ013730
Subject: Re: [RFC][PATCH] introduce ptr_diff()
From: Bernd Petrovitsch <bernd@sysprog.at>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 13:57:38 +0200
Message-ID: <1282219058.10440.26.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Don, 2010-08-19 at 20:37 +0900, Namhyung Kim wrote:
> When I compiled allyesconfig'ed kernel with C=1, I got 1519 lines of
> following message:
> 
>  include/linux/mm.h:599:16: warning: potentially expensive pointer subtraction
> 
> which is around 10% of total warnings. this was caused by page_to_pfn() macro
> so I think it's worth to remove it by calculating pointer subtraction
> manually.
> 
> ptr_diff() does subtraction of two pointers as if they were integer values
> and divides it by the size of their base type. Currently it does not deal
> with a difference alignment requirement than the size of base type, it
> would be a trivial job.
> 
> Impact: remove a _lot_ of sparse warnings
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
> 
> I have no idea where the right place is.
> Please kindly point me to the place if here is not the one.
> And any comments are greatly welcomed also.
> 
> Thanks.
> 
>  include/asm-generic/memory_model.h |   23 +++++++++++++++++++----
>  1 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
> index fb2d63f..ffec625 100644
> --- a/include/asm-generic/memory_model.h
> +++ b/include/asm-generic/memory_model.h
> @@ -22,13 +22,28 @@
>  
>  #endif /* CONFIG_DISCONTIGMEM */
>  
> +#include <linux/log2.h>
> +
> +#define ptr_diff(p1, p2)					\
> +({	long __diff;						\
> +	unsigned long  __addr1 = (unsigned long) (p1);		\
> +	unsigned long  __addr2 = (unsigned long) (p2);		\
> +	unsigned __size = sizeof(typeof(*p1));			\
The typeof() is actually redundant here.
> +								\
> +	if (is_power_of_2(__size))				\
> +		__diff = (__addr1 - __addr2) >> ilog2(__size);	\
> +	else							\
> +		__diff = (__addr1 - __addr2) / __size;		\
> +	__diff;							\
> +})
> +

IMHO this kills gcc's type compatibility checks on p1 and p2 (even if
they are suboptimal).
There is the "__same_type" macro in compiler.h for this or the "else"
branch uses plain C
	__diff = p1 - p2;
to keep them (which probably also keeps sparse's warnings).

Actually one would assume that gcc internally just does the above as the
size of the type is statically known (and sparse could be improved to
not warn where sizeof(*p1) is a power of 2).

	Bernd
-- 
mobile: +43 664 4416156              http://www.sysprog.at/
    Linux Software Development, Consulting and Services

