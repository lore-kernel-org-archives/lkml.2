Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1FNFuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:50:07 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45917 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab1FNFuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:50:05 -0400
Date: Tue, 14 Jun 2011 07:50:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Cc: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] coccinelle: if (ret) return ret; return ret; semantic
 patch
In-Reply-To: <4DF67933.9080707@cuw.edu>
Message-ID: <Pine.LNX.4.64.1106140746590.14970@ask.diku.dk>
References: <Pine.LNX.4.64.1106060656050.7113@ask.diku.dk>
 <1307989386-17666-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk> <4DF67933.9080707@cuw.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011, Greg Dietsche wrote:

> On 06/13/2011 01:38 PM, Julia Lawall wrote:
> > How about:
> >
> > @@
> > identifier f;
> > expression ret;
> > identifier x;
> > @@
> >
> > (
> > - if (likely(x)) return ret;
> > |
> > - if (\(IS_ERR\|IS_ZERO\|is_ordinal_table\)(x)) return ret;
> > |
> >    if (<+...f(...)...+>) return ret;
> > |
> > - if (...) return ret;
> > )
> > return ret;
> >
> >    
> just curious... i see you usually just write "return ret;" here when posting.
> I've assumed that's because it will 1) work and 2) is close enough.
> 
> You'll notice I've been doing:
> -return ret;
> +return ret;
> because it seems to help coccinelle realize that it can get rid of extra line
> feeds - does this make sense - or should i just be doing a "return ret"?

I wondered why you were doing that :)

Is the problem that the removed if is being replaced by a blank line?  If 
so, that is not intentional.  I will look into it.  If it doesn't happen 
always, an example where it does happen could be helpful.

The disadvantage of removing something and then adding it back is that 
then Coccinelle takes over the pretty printing of that thing.  Since ret 
is usually a variable, it doesn't matter, and since Coccinelle tries to 
follow Linux spacing conventions it might not matter either.  But eg 
f(a,b,c,d) would become f(a, b, c, d).

julia

> > I have put the likely case separate from the other function calls to
> > benefit from the isomorphism.  I have restricted the argument to these
> > functions to be an identifier so that it won't have any side effects.  It
> > doesn't have to be the same as ret though.  The third line keeps all other
> > ifs that contain function calls.  The fourth line gets rid of everything
> > else.
> >
> > You could see if this finds all of the cases of your proposed rule and if
> > it at least doesn't find anything else that you don't want it to find.
> >
> >    
> I'll try it out this afternoon/evening hopefully.
> > julia
> >
> >    
> 
> There are two other issues with the patch that I've noticed. I'll be teaching
> myself more on coccinelle to figure these out. Unless someone else wants to
> jump in :) So far I've read or skimmed a number of paper's that have been
> written on Coccinelle... I find it all very interesting :)
> 
> 1) sometimes you see this type of code - which i've chosen to ignore for now:
> if ((ret=XXXXX) < 0)
>     return ret;
> return ret;
> 
> which could just be simplified to:
> return XXXXX;
> 
> for an example see the function load_firmware in
> sound/pci/echoaudio/echoaudio_dsp.c
> 
> 2) after the semantic patch has removed an "if (...)return ret;" Quite often,
> but not always, we end up with this:
> ret=...;
> return ret;
> 
> which of course could just become
> return ...;
> 
> 
> So as you can see the problems are quite similar, but a little different.
> 
> Greg
> 
> 
> 
