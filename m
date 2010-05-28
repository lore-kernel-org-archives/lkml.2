Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab0E1Ap1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:45:27 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:49656 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab0E1Ap0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:45:26 -0400
MIME-Version: 1.0
In-Reply-To: <20100528005045.6ea5feba@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org>
	<20100527181433.GG3543@srcf.ucam.org>
	<20100527200313.5c532f2f@lxorguk.ukuu.org.uk>
	<201005280110.17075.rjw@sisk.pl>
	<20100528005045.6ea5feba@lxorguk.ukuu.org.uk>
Date: Thu, 27 May 2010 17:45:25 -0700
Message-ID: <AANLkTimqvMuMpB5E3tj58OtlRc-7mVaec-9EHAegywg7@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 4:50 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> That's correct, but to me the Arve's goal is simply to maximize battery life
>> and he found experimentally that the longest battery life is achieved if
>> system suspend is used whenever the system doesn't need to be active (from its
>> user's perspective).  This actually is different from "when the system is
>> idle", because the system isn't idle, for example, when updatedb is running.
>> However, from the user's perspective the updatedb process doesn't really need
>> to run at this particular time, it can very well do it's job in parallel with
>> the user typing or reading news.  So, the system may very well be suspended
>> when updatedb is running.
>
> This is where the original questions around QoS came in
>
>> Since I think we've now rejected the feature, do we have a clear picture about
>> what the Android people should do _instead_ and yet keep the battery life they
>> want?  Because I don't think telling "let them do what they want, who cares"
>> is right.
>
> Today "idle" means "no task running"
>
> If you are prepared to rephrase that as "no task that matters is running"
> what would need to answer ?
>
> - How do we define who matters: QoS ?
>

This is a much harder question to answer that what we need to use
opportunistic suspend. The question we ask is more like this: "Is all
important work complete?". In the simplest case these can be the same,
but on Android they are not. Some wakeup events require work to be
performed in many processes. A thread that needs to respond to a
wakeup event may currently be busy doing unimportant work. This could
possibly be solved by saying all important work must be above priority
N, but you would need full priority inheritance support and we are not
there today.

> - Can you describe "idle" in terms of QoS without then breaking the
>  reliable wakeup for an event (and do you need to ?)
>
>        Could this for example look like
>
>        Set QoS of 'user apps' to QS_NONE
>        Button pushed
>        Button driver sets QoS of app it wakes to QS_ABOVESUSPEND
>

What happens if the user presses the button right before you set QoS
of 'user apps' to  QS_NONE?
To me it looks like this solution would result in this sequence which
may ignore the button press:
        Button pushed
        Button driver sets QoS of app it wakes to QS_ABOVESUSPEND
        Set QoS of 'user apps' to QS_NONE


>        That would I think solve the reliable wakeup case although
>        drivers raising a QoS parameter is a bit unusual in the kernel.
>        That would at least however be specific to a few Android drivers
>        and maybe a tiny amount of shared driver stuff so probably not
>        unacceptable. (wake_up_pri(&queue, priority); isn't going to
>        kill anyone is it - especially if it usually ignores the
>        priority argument)

Why is "wake_up_pri(&queue, priority)" more acceptable than "suspend_block(..."?

>
>        I am curious Thomas how that would tie in with PI in the RT
>        world, it's effectively inheriting priority from the users finger.
>
> - Would a model where the UI side behaviour looked like
>
>        Timeout
>        Screen Off
>        Set QoS of 'user apps' to QS_NONE
>
>        Event
>        [Some chain of activity]
>        Screen On
>        Set QoS of 'user apps' to QS_ABOVESUSPEND
>
>  do the job combined with the ability to see who is stopping us dropping
>  to suspend so user space can take action. This could be a data table
>  from the Android cpu manager provided to Android specific policy in
>  whoever owns the display.
>
>
> If so how do we fix the UI policy code doing
>
>        Screen Off
>                                        Button Press
>                                        task to QS_ABOVESUSPEND
>        task to QS_NONE
>
> without touching the app userspace code
>
>
> Perhaps
>

What happens if the button press happend before this line:
>        count2 = tasks to QS_NONE | QS_NOTCHANGED
>        Screen off
>                                        Button Press
>                                        task to QS_ABOVESUSPEND
>        count = tasks that are QS_NOTCHANGED to QS_NONE
>
>        if (count != count2) {
>                Stuff happened ... rethink
>        }
>
> That is still a bit weird and wonderful but all the logic is in the right
> places. The special magic remains in the Android policy code and in the
> kernel specifics for Android.
>
> Thoughts ?

I don't think it works. Also, it does not seem much less invasive than
suspend blockers.

-- 
Arve Hjønnevåg
