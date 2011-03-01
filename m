Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab1CAIly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:41:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:36856 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696Ab1CAIlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:41:53 -0500
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Security] [PATCH] fix mmap random address range on x86
Date: Tue, 1 Mar 2011 09:41:50 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37-20-default; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, security@kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1298034957-17128-1-git-send-email-ludwig.nussel@suse.de> <20110228151825.26458ec9.akpm@linux-foundation.org>
In-Reply-To: <20110228151825.26458ec9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103010941.50421.ludwig.nussel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 18 Feb 2011 14:15:57 +0100
> Ludwig Nussel <ludwig.nussel@suse.de> wrote:
> 
> > On x86 casting the unsigned int result of get_random_int() to long
> > may result in a negative value. On x86 the range of mmap_rnd()
> > therefore was -255 to 255. The 32bit mode on x86_64 used 0 to 255 as
> > intended.
> > 
> > The bug was introduced by commit 675a081 in January 2008.
> > 
> > Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
> > ---
> >  arch/x86/mm/mmap.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> > index 1dab519..f927429 100644
> > --- a/arch/x86/mm/mmap.c
> > +++ b/arch/x86/mm/mmap.c
> > @@ -87,9 +87,9 @@ static unsigned long mmap_rnd(void)
> >  	*/
> >  	if (current->flags & PF_RANDOMIZE) {
> >  		if (mmap_is_ia32())
> > -			rnd = (long)get_random_int() % (1<<8);
> > +			rnd = get_random_int() % (1<<8);
> >  		else
> > -			rnd = (long)(get_random_int() % (1<<28));
> > +			rnd = get_random_int() % (1<<28);
> >  	}
> >  	return rnd << PAGE_SHIFT;
> >  }
> 
> The changelog didn't describe the user-visible consequences of this
> bug, so readers must try to work this out for themselves.  That's not a
> very desirable or efficient thing, so please do prepare more complete
> changelogs.

The consequence of the bug is that (pie)programs and libraries are
mapped to 511 possible addresses on i586. The intention of the code
is to use only 256 addresses though ("8 bits of randomness"). That's
also what the code did on x86_64.

> afacit the effects are very small: the mmap base may fall slightly
> below MIN_GAP, but that won't really affect anything?

Apparently it has no bad effect otherwise the bug would have been
discovered earlier I guess. So given that the bigger address range
worked unintentionally I wonder whether it would make sense to
increase the range explicitly.

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
