Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0KJDWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 22:22:43 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38554 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751379Ab0KJDWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 22:22:42 -0500
Date: Tue, 9 Nov 2010 22:22:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
In-Reply-To: <AANLkTik3ufjfFRKk6Yu39h-E314+ds0iAy1dfFoZSeVN@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1011092144340.14099-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Linus Torvalds wrote:

> On Tue, Nov 9, 2010 at 3:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > So, what about the patch below?

The "transition_started" thing is a little odd.  I get the feeling that
it shouldn't be set back to false during dpm_resume_noirq() at all.  
Maybe I'm not quite thinking straight just now...

> I think it looks saner, but I also think that it would be saner yet to
> have a separate list entirely, and *not* do this crazy "move things
> back and forth between 'dpm_list'" thing.
> 
> So I would seriously suggest that the design should aim for each
> suspend event to move things between two lists, and as devices go
> through the suspend phases, they'd move to/from lists that also
> indicate which suspend level they are at.
> 
> So why not introduce a new list called "dpm_list_suspended", and in
> "dpm_suspend_noirq()" you move devices one at a time from the
> "dpm_list" to the "dmp_list_suspended".
> 
> And then in "dpm_resume_noirq()" you move them back.
> 
> Wouldn't that be nice?
> 
> (Optimally, you'd have separate lists for "active", "suspended", and
> "irq-suspended")
> 
> But regardless, your patch does seem to at least match what we
> currently do in the regular suspend/resume code (ie the
> non-irq's-disabled case). So I don't mind it. I just think that it
> would be cleaner to not take things off one list only to put them back
> on the same list again.
> 
> In particular, _if_ device add events can happen concurrently with
> this,

They can.  We explicitly allow new devices to be registered during the 
final "complete" phase, and we grudgingly allow it even during the 
"resume" phase, if the parent has already been resumed.

The "prepare" traversal is ordered in the forward direction so that if
a child is registered beneath a device during that device's ->prepare
callback, it will end up in the right place (i.e., after the parent in
the list).  The "complete" traversal should work out the same way, only
in reverse.  Which means we should _start_ with everything on the other
list, and move each device onto the dpm_list just _before_ invoking its
->complete callback.

The way the code is now, it looks like a child registered during the
parent's callback will end up in the wrong place.

>  I don't understand how that would maintain the depth-first order
> of the list. In contrast, if you do it with separate lists, then you
> know that if a device is on the "suspended" list, then it by
> definition has to be "after" all devices that are on the non-suspended
> list, since you cannot have a non-suspended device that depends on a
> suspended one.

The situation isn't quite as bad as it seems, if you assume that a 
child will never be registered at a time when its parent is still 
suspended.  Right now we warn if such a thing happens but we don't 
prevent it.

> So having separate lists with state should also be very sensible from
> a device topology standpoint - while doing that "list_splice()" back
> on the same list is _not_ at all obviously correct from a topological
> standpoint (I'm not sure I'm explaining this well).

I don't see anything wrong with changing over to multiple list heads.  
It might even allow us to remove the dev->power.status field.

Alan Stern

