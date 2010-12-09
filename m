Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0LINhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:37:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56652 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0LINhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:37:12 -0500
Date: Thu, 9 Dec 2010 14:37:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
Message-ID: <20101209133709.GA3133@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Nick Piggin <npiggin@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arch@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20101209070938.GA3949@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101209070938.GA3949@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 06:09:38PM +1100, Nick Piggin wrote:
> I was actually discussing this with Linus a while back, and finally
> got around to testing it out now that I have a modern CPU to measure
> it on! CCing linux-arch because it would be interesting to know
> whether your tuned functions do better than gcc or not (I would
> suspect not).
> 
> BTW. patch and numbers are on top of my scaling series, just for
> an idea of what it does, I just want to generate some interesting
> discussion.
> 
> If people are interested in running benchmarks, I'll be pushing out
> a new update soon, after some more testing and debugging here.
> 
> The standard memcmp function on a Westmere system shows up hot in
> profiles in the `git diff` workload (both parallel and single threaded),
> and it is likely due to the costs associated with trapping into
> microcode, and little opportunity to improve memory access (dentry
> name is not likely to take up more than a cacheline).
> 
> So replace it with an open-coded byte comparison. This increases code
> size by 24 bytes in the critical __d_lookup_rcu function, but the
> speedup is huge, averaging 10 runs of each:
> 
> git diff st   user   sys   elapsed  CPU
> before        1.15   2.57  3.82      97.1
> after         1.14   2.35  3.61      96.8
> 
> git diff mt   user   sys   elapsed  CPU
> before        1.27   3.85  1.46     349
> after         1.26   3.54  1.43     333
> 
> Elapsed time for single threaded git diff at 95.0% confidence:
>         -0.21  +/- 0.01
>         -5.45% +/- 0.24%

Nice.

[..]

> +static inline int dentry_memcmp(const unsigned char *cs,
> +				const unsigned char *ct, size_t count)
> +{
> +	while (count) {
> +		int ret = (*cs != *ct);
> +		if (ret)
> +			return ret;
> +		cs++;
> +		ct++;
> +		count--;
> +	}
> +	return 0;
> +}

we have a memcmp() in lib/string.c. Maybe reuse it from there?

-- 
Regards/Gruss,
Boris.
