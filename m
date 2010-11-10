Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0KJAuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:50:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab0KJAuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:50:20 -0500
MIME-Version: 1.0
In-Reply-To: <201011100039.17689.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1011041045350.2522-100000@netrider.rowland.org> <201011100039.17689.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Nov 2010 16:49:49 -0800
Message-ID: <AANLkTik3ufjfFRKk6Yu39h-E314+ds0iAy1dfFoZSeVN@mail.gmail.com>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 3:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> So, what about the patch below?

I think it looks saner, but I also think that it would be saner yet to
have a separate list entirely, and *not* do this crazy "move things
back and forth between 'dpm_list'" thing.

So I would seriously suggest that the design should aim for each
suspend event to move things between two lists, and as devices go
through the suspend phases, they'd move to/from lists that also
indicate which suspend level they are at.

So why not introduce a new list called "dpm_list_suspended", and in
"dpm_suspend_noirq()" you move devices one at a time from the
"dpm_list" to the "dmp_list_suspended".

And then in "dpm_resume_noirq()" you move them back.

Wouldn't that be nice?

(Optimally, you'd have separate lists for "active", "suspended", and
"irq-suspended")

But regardless, your patch does seem to at least match what we
currently do in the regular suspend/resume code (ie the
non-irq's-disabled case). So I don't mind it. I just think that it
would be cleaner to not take things off one list only to put them back
on the same list again.

In particular, _if_ device add events can happen concurrently with
this, I don't understand how that would maintain the depth-first order
of the list. In contrast, if you do it with separate lists, then you
know that if a device is on the "suspended" list, then it by
definition has to be "after" all devices that are on the non-suspended
list, since you cannot have a non-suspended device that depends on a
suspended one.

So having separate lists with state should also be very sensible from
a device topology standpoint - while doing that "list_splice()" back
on the same list is _not_ at all obviously correct from a topological
standpoint (I'm not sure I'm explaining this well).

                 Linus
