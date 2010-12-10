Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0LJCiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 21:38:08 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:54207 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab0LJCiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 21:38:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMMeAU15LdBk/2dsb2JhbACjfnnADIVKBA
Date: Fri, 10 Dec 2010 13:38:00 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Borislav Petkov <bp@alien8.de>, Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
Message-ID: <20101210023800.GD3331@amd>
References: <20101209070938.GA3949@amd>
 <20101209133709.GA3133@a1.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209133709.GA3133@a1.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 02:37:09PM +0100, Borislav Petkov wrote:
> On Thu, Dec 09, 2010 at 06:09:38PM +1100, Nick Piggin wrote:
> > +static inline int dentry_memcmp(const unsigned char *cs,
> > +				const unsigned char *ct, size_t count)
> > +{
> > +	while (count) {
> > +		int ret = (*cs != *ct);
> > +		if (ret)
> > +			return ret;
> > +		cs++;
> > +		ct++;
> > +		count--;
> > +	}
> > +	return 0;
> > +}
> 
> we have a memcmp() in lib/string.c. Maybe reuse it from there?

Well I think I prefer it to be inline so it doesn't clobber registers,
and also so that it isn't required to carry an integer value to return
(only boolean) if that might help.

I might also change it a bit and take advantage of the fact we won't
have a zero sized count -- this could move the loop branch to after the
values are loaded, and would mean that the load will get underway
even if the branch is mispredicted...

