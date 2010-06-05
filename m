Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab0FEXTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:19:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55616 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab0FEXTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:19:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm for reading & writing a hibernation image.
Date: Sun, 6 Jun 2010 01:20:45 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com> <201006052121.45816.rjw@sisk.pl> <4C0AD5BF.3030204@crca.org.au>
In-Reply-To: <4C0AD5BF.3030204@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006060120.45682.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 June 2010, Nigel Cunningham wrote:
> Hi.
> 
> On 06/06/10 05:21, Rafael J. Wysocki wrote:
> > On Saturday 05 June 2010, Maxim Levitsky wrote:
> >> On Sat, 2010-06-05 at 20:45 +0200, Rafael J. Wysocki wrote:
> >>> On Saturday 05 June 2010, Nigel Cunningham wrote:
> >>>> Hi again.
> >>>>
> >>>> As I think about this more, I reckon we could run into problems at
> >>>> resume time with reloading the image. Even if some bits aren't modified
> >>>> as we're writing the image, they still might need to be atomically
> >>>> restored. If we make the atomic restore part too small, we might not be
> >>>> able to do that.
> >>>>
> >>>> So perhaps the best thing would be to stick with the way TuxOnIce splits
> >>>> the image at the moment (page cache / process pages vs 'rest'), but
> >>>> using this faulting mechanism to ensure we do get all the pages that are
> >>>> changed while writing the first part of the image.
> >>>
> >>> I still don't quite understand why you insist on saving the page cache data
> >>> upfront and re-using the memory occupied by them for another purpose.  If you
> >>> dropped that requirement, I'd really have much less of a problem with the
> >>> TuxOnIce's approach.
> >> Because its the biggest advantage?
> >
> > It isn't in fact.
> 
> Because saving a complete image of memory gives you a much more 
> responsive system, post-resume - especially if (as is likely) you're 
> going to keep doing the same work post-resume that you were doing 
> pre-hibernate.

We've given that argument for (at least) 100 times already and I still claim
that the user won't see a difference between putting 80% and 95% of RAM
contents into the image (you don't save 100%, at least not every time).

> Saving a complete image means it's for all intents and 
> purposes just as if you'd never done the hibernation. Dropping page 
> cache, on the other hand, slows things down post-resume because it has 
> to be repopulated - and the repopulation takes longer than reading the 
> pages as part of the image because they're not compressed and there's 
> extra work required to get the pages back in.

I'm not talking about dropping the page cache, but about keeping it in place
and saving as a part of the image - later.  The part I think is too complicated
is the re-using of that memory for creating the "atomic" image.  That in my
opinion really goes too far and causes things to be excessively fragile -
without a really good reason (it is like "we do that because we can" IMO).

> >> Really saving whole memory makes huge difference.
> >
> > You don't have to save the _whole_ memory to get the same speed (you don't
> > do that anyway, but the amount of data you don't put into the image with
> > TuxOnIce is smaller).  Something like 80% would be just sufficient IMO and
> > then (a) the level of complications involved would drop significantly and (2)
> > you'd be able to use the image-reading code already in the kernel without
> > any modifications.  It really looks like a win-win to me, doesn't it?
> 
> It is certainly true that you'll notice the effect less if you save 80% 
> of memory instead of 40%, but how much you'll be affected is also 
> heavily influenced by your amount of memory and how you're using it. If 
> you're swapping heavily or don't have much memory (embedded), freeing 
> memory might not be an option.

I don't think you have any practical example of anything like this, do you?

> At the end of the day, I would argue that the user knows best, and this 
> should be a tuneable. This is, in fact the way TuxOnIce has done it for 
> years: the user can use a single sysfs entry to set a (soft) image size 
> limit in MB (values 1 and up), tell TuxOnIce to only free memory if 
> needed (0), abort if freeing memory is necessary (-1) or drop caches (-2).
>
> I do agree that doing a single atomic copy and saving the result makes 
> for a simpler algorithm, but I've always been of the opinion that we're 
> writing code to satisfy real work needs and desires, not our own desires 
> for simpler or easier to understand algorithms. Doing the bare minimum 
> isn't an option for me.

I'm not talking about that!

In short, if your observation that the page cache doesn't really change during
hibernation is correct, then it should be possible to avoid making an atomic
copy of it and to save it directly from its original locations.  I think that
would allow us to save about 80% of memory in the majority of cases without
the entire complexity that makes things extremely fragile and depends haevily
on the current (undocumented) behavior of our mm subsystem that _happens_
to be favourable to TuxOnIce.  HTH

Rafael
