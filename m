Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0EaJzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:55:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46711 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab0EaJzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:55:17 -0400
MIME-Version: 1.0
In-Reply-To: <20100530200409.GA21632@gvim.org>
References: <20100530200409.GA21632@gvim.org>
Date: Mon, 31 May 2010 02:55:16 -0700
Message-ID: <AANLkTilPCxcVhcxEyLSixAoOs-ujXzzkSq8cAOE-5Nsz@mail.gmail.com>
Subject: Re: [RFC] lp_events: an lternitive to suspend blocker user mode and 
	kernel API
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: markgross@thegnar.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mark.gross@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 1:04 PM, mark gross <640e9920@gmail.com> wrote:
> Low Power Events is a possible alternative to suspend blocker / wake
> lock API used by Android.
>
> It provides comparable power state notification and kernel mode critical
> section definition.  It differs from suspend blocker in that:
> 1) it is a platform and device independent implementation.  Device
> specific code is register as lp_ops, similar to pm_ops.  Drivers use
> the platform independent functions.
>
How is this more platform independent than suspend blockers?

> 2) it forces a user mode transition coming out of a LP state.
> Notification of wake up sources go to the user mode process managing the
> lp states.  Notification of blocked LP state entry is through an
> error return, and notification of un-blocking is through a file node as
> well.
>
If you want a user mode transition for every resume, you can easily
get this with the opportunistic suspend patchset by sending an input
event (or other a custom event with that blocks suspend) from a
driver's resume hook.

> I think the change need to the Google Android user mode power handling
> code can be limited to changes to _only_
> "hardware/libhardware_legacy/power/power.c"
>
> This code is still just a prototype of the platform independent code,
> and I'm implementing it on Eclair for the Intel Moorestown platform this
> weekend.  I'll have patches to eclair and updated kernel patches that
> enable this sometime Monday, after I bring it up on my target device.
> Hopefully by the end of next week I think I'll have it working well with
> Android.
>
> At this time the following patch is only known to compile.  I send it to
> help with the discussion.
>
> FWTW I do work on Android at Intel and I think I can make this work.
> (well, today I do.)
>
> --mgross
>
> Draft kernel patch :
>
...
> +
> +/dev/lpe_wake_event:
> +reads from this returns a list of wake events that happened between entry
> +into the LP state and the return from the read of the low_power_enter device
> +node.  User mode is expected to do something with these events before
> +re-trying to enter low power mode.
> +

I don't think this will work very well. Multiple input events can be
pending at the same time. If you register a single wake-event for an
input device, you don't know if all the events have been read when you
try to clear this wake-event.


-- 
Arve Hjønnevåg
