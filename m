Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0FGIjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 04:39:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59958 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab0FGIjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 04:39:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm for reading & writing a hibernation image.
Date: Mon, 7 Jun 2010 10:40:13 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com> <201006061606.02403.rjw@sisk.pl> <4C0C8250.1020509@crca.org.au>
In-Reply-To: <4C0C8250.1020509@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006071040.13530.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 June 2010, Nigel Cunningham wrote:
> Hi.
> 
> On 07/06/10 00:06, Rafael J. Wysocki wrote:
> > On Sunday 06 June 2010, Nigel Cunningham wrote:
> >> On 06/06/10 09:20, Rafael J. Wysocki wrote:
> >>> On Sunday 06 June 2010, Nigel Cunningham wrote:
> > ...
> >>> I'm not talking about dropping the page cache, but about keeping it in place
> >>> and saving as a part of the image - later.  The part I think is too complicated
> >>> is the re-using of that memory for creating the "atomic" image.  That in my
> >>> opinion really goes too far and causes things to be excessively fragile -
> >>> without a really good reason (it is like "we do that because we can" IMO).
> >>
> >> First, it's not fragile.
> >
> > Well, I obviously don't agree and I'm not convinced by the arguments below.
> 
> Okay. I'm going to assume you're not being unreasonable and ask: "What 
> do you find unconvincing in the arguments below? That is, what can I do 
> to help build a better case for you?"

First, the freezer really doesn't guarantee that the things will work the way
you like it, for the simple reason that not all processes are frozen.  The
second paragraph below is simply wrong (it's not been _proven_, at least
not with respect to the case when we save 80% of RAM I'm talking about
and I don't believe the user will see a difference between systems where
80% and 90% or more RAM is saved) and the third paragraph is just
hand waving.

> >> All it depends on is the freezer being
> >> effective, just as the other parts of hibernation depend on the freezer
> >> being effective. Checksumming has been used to confirm that the contents
> >> of memory haven't changed prior to this page fault idea. I can think of
> >> examples where pages have been found to have changed, but they're few
> >> and far between, and easily addressed by resaving the affected pages in
> >> the atomic copy.
> >>
> >> Second, it's not done without reason or simply because we can. It's done
> >> because it's been proven to make it more likely for us to be able to
> >> hibernate successfully in the first place AND gives us a more responsive
> >> system post-resume.
> >>
> >> We haven't mentioned the first part so far, so let me go into more
> >> detail there. The problem with not doing things the TuxOnIce way is that
> >> you when you have more than (say) 80% of memory in use, you MUST free
> >> memory. Depending upon your workload, that simply might not be possible.
> >> In other cases, the only way to free memory might be to swap it out, but
> >> you're then reducing the amount of storage available for the image,
> >> which means you have to free more memory again, which means... For
> >> maximum reliability, you need an algorithm wherein you can save the
> >> contents of memory as they are at the start of the cycle.
> >>
> > ...
> >>>> I do agree that doing a single atomic copy and saving the result makes
> >>>> for a simpler algorithm, but I've always been of the opinion that we're
> >>>> writing code to satisfy real work needs and desires, not our own desires
> >>>> for simpler or easier to understand algorithms. Doing the bare minimum
> >>>> isn't an option for me.
> >>>
> >>> I'm not talking about that!
> >>>
> >>> In short, if your observation that the page cache doesn't really change during
> >>> hibernation is correct, then it should be possible to avoid making an atomic
> >>> copy of it and to save it directly from its original locations.  I think that
> >>> would allow us to save about 80% of memory in the majority of cases without
> >>> the entire complexity that makes things extremely fragile and depends haevily
> >>> on the current (undocumented) behavior of our mm subsystem that _happens_
> >>> to be favourable to TuxOnIce.  HTH
> >>
> >> I'm not sure what this current undocumented behaviour is.
> >
> > Easy.  The behavior that allows you to use memory used for the page cache
> > hibernation without the risk of it being overwritten in the process.  This is
> > not documented anywhere and I don't think it'll ever be.
> >
> >> All I'm relying on is the freezer working and the mm subsystem not deciding to
> >> free process pages or LRU for no good reason.
> >
> > It's more than just freeing them.  In fact you need a guarantee that their
> > contents won't be modified over the entire hibernation in a way that you don't
> > control.  There's no such guarantee at the moment I know of, so you have to
> > assume that that won't happen, which is _exactly_ relying on undocumented
> > behavior that's not guaranteed to change in future.
> 
> I think it's rather unfair to talk about undocumented and unguaranteed 
> behaviour when you know I'm relying on the freezer, which is documented 
> and guaranteed to work.

The freezer _doesn't_ give you the guarantee you need.  It only guarantees
user space to be frozen, which is _not_ _enough_.

> I'm willing to modify things so we use this page-fault idea to make the 
> guarantee even more certain - would that satisfy you?

I said what I didn't like: Re-using of the page cache memory for another
purpose behind the back of the mm subsystem in the _hope_ it won't break.
This is simply wrong IMO.

> >> Remember that kswapd is also frozen.
> >
> > But some day it may turn out that it would be better not to freeze it for some
> > reason.  If we go the TuxOnIce route, that won't ever be possible I think.
> 
> It may also turn out some day that it's better not to freeze any 
> processes at all.

Well, I think we'll always need to freeze user space, more or less, but kernel
threads not necessarily.

> But seriously, what could possibly lead us to that decision? The only 
> reason we'd want to not freeze kswapd would be if we wanted it to be 
> able to free memory while we're hibernating.

And why would that be unreasonable?

> What demand would there be for such memory apart from our own routines
> for writing the image? What impetus would it have to do any freeing? After
> the atomic copy, any other work is pointless - it's going to be thrown away
> when we power off.

It may be useful for image saving or a progress meter or whatever is going on
while the image is being saved.

Rafael
