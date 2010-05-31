Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0EaXDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:03:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52780 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab0EaXD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kvTsUNZ986CoMmKRhq6xkLO4YxZujOWLxQmDtfvWHcsubJqKEOT/ayOANAq24R+WWL
         tfbiOHJBKqJfwJVPquhQCV0WE1bYKVd1OTufFkJwSTgZ6Zw9pOSIg7QuWhfmsU7TTXYA
         9AKUgGCNn+2vkzK4j98TxkI6y+yLJgqG/KRBo=
Date: Mon, 31 May 2010 16:03:44 -0700
From: mark gross <640e9920@gmail.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: markgross@thegnar.org, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mark.gross@intel.com
Subject: Re: [RFC] lp_events: an lternitive to suspend blocker user mode
 and kernel API
Message-ID: <20100531230343.GE31155@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100530200409.GA21632@gvim.org>
 <AANLkTilPCxcVhcxEyLSixAoOs-ujXzzkSq8cAOE-5Nsz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilPCxcVhcxEyLSixAoOs-ujXzzkSq8cAOE-5Nsz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 02:55:16AM -0700, Arve Hjønnevåg wrote:
> On Sun, May 30, 2010 at 1:04 PM, mark gross <640e9920@gmail.com> wrote:
> > Low Power Events is a possible alternative to suspend blocker / wake
> > lock API used by Android.
> >
> > It provides comparable power state notification and kernel mode critical
> > section definition.  It differs from suspend blocker in that:
> > 1) it is a platform and device independent implementation.  Device
> > specific code is register as lp_ops, similar to pm_ops.  Drivers use
> > the platform independent functions.
> >
> How is this more platform independent than suspend blockers?

You don't have to do "suspend to ram" for the low power mode and one
could could entertain something different form S2R.
 
> > 2) it forces a user mode transition coming out of a LP state.
> > Notification of wake up sources go to the user mode process managing the
> > lp states.  Notification of blocked LP state entry is through an
> > error return, and notification of un-blocking is through a file node as
> > well.
> >
> If you want a user mode transition for every resume, you can easily
> get this with the opportunistic suspend patchset by sending an input
> event (or other a custom event with that blocks suspend) from a
> driver's resume hook.

the input event thing looks like a way to go.
 
> > I think the change need to the Google Android user mode power handling
> > code can be limited to changes to _only_
> > "hardware/libhardware_legacy/power/power.c"
> >
> > This code is still just a prototype of the platform independent code,
> > and I'm implementing it on Eclair for the Intel Moorestown platform this
> > weekend.  I'll have patches to eclair and updated kernel patches that
> > enable this sometime Monday, after I bring it up on my target device.
> > Hopefully by the end of next week I think I'll have it working well with
> > Android.
> >
> > At this time the following patch is only known to compile.  I send it to
> > help with the discussion.
> >
> > FWTW I do work on Android at Intel and I think I can make this work.
> > (well, today I do.)
> >
> > --mgross
> >
> > Draft kernel patch :
> >
> ...
> > +
> > +/dev/lpe_wake_event:
> > +reads from this returns a list of wake events that happened between entry
> > +into the LP state and the return from the read of the low_power_enter device
> > +node.  User mode is expected to do something with these events before
> > +re-trying to enter low power mode.
> > +
> 
> I don't think this will work very well. Multiple input events can be
> pending at the same time. If you register a single wake-event for an
> input device, you don't know if all the events have been read when you
> try to clear this wake-event.
>
whats important, to me at least, is that uppon wakeup some entity in
user mode makes a choice on when to re-enter suspend.  

--mgross
 
