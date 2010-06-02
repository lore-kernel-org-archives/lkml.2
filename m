Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab0FBE0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 00:26:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51416 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab0FBE0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 00:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA1BBBBC9359F04AA639128AC0D5D1E9692AAF4C@orsmsx502.amr.corp.intel.com>
References: <20100530200409.GA21632@gvim.org>
	<20100531095753.4c174f2d@notabene.brown>
	<20100531221035.GB31155@gvim.org>
	<201006010045.21382.rjw@sisk.pl>
	<20100601050914.GG31155@gvim.org>
	<AANLkTik4ixmtv5Ki7jds5gEspJAxBRAcJCR1Jv-V6ajR@mail.gmail.com>
	<20100601140120.GB1281@gvim.org>
	<AANLkTimNlEqGhLplj8RjYLNHf3DpI13pDf70eAvRxfI_@mail.gmail.com>
	<CA1BBBBC9359F04AA639128AC0D5D1E9692AAF4C@orsmsx502.amr.corp.intel.com>
Date: Tue, 1 Jun 2010 21:26:38 -0700
Message-ID: <AANLkTinUuCqkHilD1jvb6n9YnUg7-eW6MNwWK1SP8NtD@mail.gmail.com>
Subject: Re: [linux-pm] [RFC] lp_events: an lternitive to suspend blocker user 
	mode and kernel API
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Gross, Mark" <mark.gross@intel.com>
Cc: "markgross@thegnar.org" <markgross@thegnar.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Neil Brown <neilb@suse.de>,
       Brian Swetland <swetland@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Arve@smtp1.linux-foundation.org" <Arve@smtp1.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 8:24 PM, Gross, Mark <mark.gross@intel.com> wrote:
>
>
>>-----Original Message-----
>>From: Arve Hjønnevåg [mailto:arve@android.com]
>>Sent: Tuesday, June 01, 2010 8:10 PM
>>To: markgross@thegnar.org
>>Cc: Rafael J. Wysocki; Gross, Mark; Neil Brown; Brian Swetland; linux-
>>kernel@vger.kernel.org; Arve@smtp1.linux-foundation.org; Thomas Gleixner;
>>linux-pm@lists.linux-foundation.org; Alan Cox
>>Subject: Re: [linux-pm] [RFC] lp_events: an lternitive to suspend blocker
>>user mode and kernel API
>>
>>2010/6/1 mark gross <640e9920@gmail.com>:
>>> On Mon, May 31, 2010 at 10:24:30PM -0700, Arve Hjønnevåg wrote:
>>>> On Mon, May 31, 2010 at 10:09 PM, mark gross <640e9920@gmail.com> wrote:
>>>> > On Tue, Jun 01, 2010 at 12:45:21AM +0200, Rafael J. Wysocki wrote:
>>>> >> On Tuesday 01 June 2010, mark gross wrote:
>>>> >> > On Mon, May 31, 2010 at 09:57:53AM +1000, Neil Brown wrote:
>>>> >> ...
> [mtg: ] snipping outlook bollixed formatting of history.
>
>>approach?
>>>> >>
>>>> > I just saw Alan Stern's proposal, and have gotten some input form some
>>>> > others.  I can't say my patch represents a better Idea than what Alan
>>>> > proposed.  However; what Alan (and Thomas) are talking about is
>>>> > effectively the same as the kenrel mode wakelock/suspend blocker thing,
>>>> > and although it reuses existing infrastructure, it doesn't solve the
>>>> > problem of needing overlapping blocking sections of code from ISR to
>>>> > user mode.
>>>> >
>>>>
>>>> I don't think your solution solves this either.
>>>
>>> Why?  my proposal effectively removes the overlapping kernel blocking
>>> sections uppon wake up by forcing the user mode to ack the wake event
>>> and re-issue the suspend request explicitly.  That pretty much solves
>>> that problem.
>>>
>>
>>How to you ack the wakeup event in a safe way. Another wakeup event
>>can come in after you decided to ack the last event. Also when the
> [mtg: ] um, by blocking?  Ok, I see your point here.  I need more care here.
>
> How real is this race? At some point you turn off interrupts before programming the wake up sources anyway, and between turning off interrupts and the programming of the wake up events on the way into the platform suspend you have the same race.

This depends on the hardware but if you can enable the wakeup event
before you turn the interrupt off you don't have a race (msm works
this way). On other hardware the interrupt controller is the wakeup
source so by masking the interrupt during suspend instead or turning
it off altogether you also don't have a race.

>
>>user-space power manager reads that there was a wakeup event, how does
>>it know if the real event has been delivered to user-space, and if the
>>user-space code that consumed this event has had a chance to block
>>suspend?
> [mtg: ] I suppose the same way the uevent.c wake_lock handling does.  (that code grabs a 5 second timeout wake lock on key events, not pretty either...)  I think the idea of getting the wake events passing through the input layer could help with this.

The 5 second timeout on keyevents are there to avoid blocking suspend
forever if someone opens an input device and don't read from it. The
suspend blocker patchset uses an ioctl to enable the suspend blocker
so it does not have this timeout. Either way, the 5 second timeout is
not how the system normally goes back to sleep after a key event. I do
think timeouts are useful so a driver can keep the system awake for a
while after passing an event to a subsystem that has not been modified
to block suspend (tty, network etc) but I don't think we should force
subsystems that can easily use overlapping constraints (like input
events) to keep the system awake for longer than needed.

>
> --mgross
>
>>
>>> We can talk about whether or not it can be used effectively with Android
>>> user mode PM or not, which I still think it can, but I need to try the
>>> mods to power.c.
>>>
>>
>>
>>--
>>Arve Hjønnevåg
>



-- 
Arve Hjønnevåg
