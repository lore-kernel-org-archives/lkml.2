Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab1G0RRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:17:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53851 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184Ab1G0RRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:17:02 -0400
Message-ID: <4E3047D4.2000608@zytor.com>
Date: Wed, 27 Jul 2011 10:16:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
References: <1311340547-7861-1-git-send-email-bp@amd64.org> <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com> <20110724172222.GB12621@aftab> <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com> <20110727171015.GD19477@aftab>
In-Reply-To: <20110727171015.GD19477@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 10:10 AM, Borislav Petkov wrote:
> 
> How about something like the following instead - it should take care
> of all your bitmask generating needs. There are also a couple of
> GENMASK/BITMASK identical definitions around the tree which can be
> unified while I'm at it too.
> 
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index a3ef66a..b1970e3 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -6,6 +6,19 @@
>  #define BIT(nr)                        (1UL << (nr))
>  #define BIT_MASK(nr)           (1UL << ((nr) % BITS_PER_LONG))
>  #define BIT_WORD(nr)           ((nr) / BITS_PER_LONG)
> +
> +/*
> + * Create a contiguous bitmask starting at bit position @lo and ending at
> + * position @hi. For example
> + *
> + * GENMASK_ULL(21, 39) gives us the 64bit vector 0x000000ffffe00000.
> + */
> +#define _GENMASK_T(cast, type, lo, hi) \
> +       (((cast)(1##type << ((hi) - (lo) + 1)) - 1) << (lo))
> +#define GENMASK(lo, hi)                _GENMASK_T(unsigned, U, lo, hi)
> +#define GENMASK_UL(lo, hi)     _GENMASK_T(unsigned long, UL, lo, hi)
> +#define GENMASK_ULL(lo, hi)    _GENMASK_T(unsigned long long, ULL, lo, hi)
> +

These really need to be usable from assembly language, too (in which
case you of course need to not have the cast and suffix), so it probably
should be defined in <linux/const.h> with the other constant macros.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

