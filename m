Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1FOPe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:34:56 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35855 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab1FOPez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:34:55 -0400
Date: Wed, 15 Jun 2011 17:34:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Dietsche <greg@farmergreg.com>
Cc: linux-kernel@vger.kernel.org, cocci@diku.dk, Gilles.Muller@lip6.fr
Subject: Re: [Cocci] Re: [PATCH v2] coccinelle: if (ret) return ret; return
 ret; semantic patch
In-Reply-To: <4DF8D0B4.7020505@gregd.org>
Message-ID: <Pine.LNX.4.64.1106151734220.10106@ask.diku.dk>
References: <Pine.LNX.4.64.1106060656050.7113@ask.diku.dk>
 <1307989386-17666-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk> <4DF67933.9080707@cuw.edu>
 <Pine.LNX.4.64.1106140746590.14970@ask.diku.dk> <4DF7D197.5070205@cuw.edu>
 <4DF807B4.8010807@gregd.org> <Pine.LNX.4.64.1106150751390.27735@ask.diku.dk>
 <4DF8D0B4.7020505@gregd.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Greg Dietsche wrote:

> On 06/15/2011 12:58 AM, Julia Lawall wrote:
> > On Tue, 14 Jun 2011, Greg Dietsche wrote:
> >
> > >
> > >
> > > On 06/14/2011 04:24 PM, Greg Dietsche wrote:
> > > > On 06/14/2011 12:50 AM, Julia Lawall wrote:
> > > > > On Mon, 13 Jun 2011, Greg Dietsche wrote:
> > > > > > just curious... i see you usually just write "return ret;" here when
> > > > > > posting.
> > > > > > I've assumed that's because it will 1) work and 2) is close enough.
> > > > > >
> > > > > > You'll notice I've been doing:
> > > > > > -return ret;
> > > > > > +return ret;
> > > > > > because it seems to help coccinelle realize that it can get rid of
> > > > > > extra line
> > > > > > feeds - does this make sense - or should i just be doing a "return
> > > > > > ret"?
> > > > > I wondered why you were doing that :)
> > > > >
> > > > > Is the problem that the removed if is being replaced by a blank line?
> > > > > If
> > > > > so, that is not intentional. I will look into it. If it doesn't happen
> > > > > always, an example where it does happen could be helpful.
> > > > >
> > > >
> > > > Some times it gets it right, so it's not always wrong. For example:
> > > >
> > > > diff -u -p a/arch/m68k/math-emu/fp_log.c b/arch/m68k/math-emu/fp_log.c
> > > > --- a/arch/m68k/math-emu/fp_log.c 2011-06-13 14:06:37.943954469 -0500
> > > > +++ b/arch/m68k/math-emu/fp_log.c 2011-06-14 16:07:22.394954040 -0500
> >>> @@ -105,9 +105,6 @@ fp_fetoxm1(struct fp_ext *dest, struct f
> > > >
> > > > fp_monadic_check(dest, src);
> > > >
> > > > - if (IS_ZERO(dest))
> > > > - return dest;
> > > > -
> > > > return dest;
> >>> }
> > > >
> > > >
> > > >
> > > > Here's an example where it got it "wrong" - notice how the blank line is
> > > > missing the - :
> > > >
> > > > diff -u -p a/arch/frv/mm/pgalloc.c b/arch/frv/mm/pgalloc.c
> > > > --- a/arch/frv/mm/pgalloc.c 2011-06-13 14:06:37.855954391 -0500
> > > > +++ b/arch/frv/mm/pgalloc.c 2011-06-14 16:07:16.714954008 -0500
> >>> @@ -136,8 +136,6 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
> > > > pgd_t *pgd;
> > > >
> > > > pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
> > > > - if (!pgd)
> > > > - return pgd;
> > > >
> > > > return pgd;
> >>> }
> >
> > OK, but it is going to be hard for Coccinelle to know that, although the
> > programmer previously thought that return should be separated from the
> > rest of the function by a blank line, that is now no longer the case.
> > Perhaps it is due to the fact that there is now only one other line in the
> > body of the function, but it seems like an opinion as to how to draw the
> > line.
> >
> 
> OK - I can see how that would be hard for Coccinelle to guess what we really
> want in this case.
> 
> > So your - return ret; + return ret; is probably the appropriate solution.
> > You want to get rid of the whole pattern if (...) return ret; return ret;
> > and replace it with just return ret;, which will then be inserted at the
> > point of the beginning of the match to the pattern.
> 
> ok
> 
> > It would be nicer to put the - return ret; + return ret; inside the last
> > line of the ( | ).  Then only those return ret's are rewritten rather than
> > every return ret in the program.  It should improver performance and
> 
> except that 4 of the 5 ORs are cases where we want to do the -return ret; +
> return ret; So I suppose for performance, I should actually add the +/- to
> each of the 4 cases that we want cocci to generate a patch for?

Yes.  Or you could at least see if it helps.

julia
