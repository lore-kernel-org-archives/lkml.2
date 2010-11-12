Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0KLKsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:48:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35281 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab0KLKsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:48:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
 <22542.1289507293@localhost> <20101111205123.GC10585@shisha.kicks-ass.net> <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 12 Nov 2010 11:47:57 +0100
Message-ID: <AANLkTi=ozec3+z4FBn3dX7H3JfSvHanS1DLdQf02fzaa@mail.gmail.com>
Subject: Re: [PATCHv6 0/7] system time changes notification
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Shishkin <virtuoso@slind.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 22:16, Thomas Gleixner <tglx@linutronix.de> wrote:
> B1;2401;0cOn Thu, 11 Nov 2010, Alexander Shishkin wrote:
>
>> On Thu, Nov 11, 2010 at 03:28:13PM -0500, Valdis.Kletnieks@vt.edu wrote:
>> > On Thu, 11 Nov 2010 21:29:55 +0200, Alexander Shishkin said:
>> >
>> > > Consider we want stuff like "wakeup every day at 3pm", the next wakeup
>> > > might be earlier than the timer we calculated last time, on system
>> > > time changes. We need to re-calculate it. This is necessary for all
>> > > repeating events.
>> > >
>> > > Say we want to wakeup at 3pm, now it's 4pm, so we schedule it in 23
>> > > hours. Now the system time changes to 2pm, and we would expect to
>> > > wakeup in one hour, but we take 25.
>> >
>> > Sorry, I tuned in late here...
>> >
>> > So the plan is that if you're not using this new interface, it will go off at
>> > the same absolute offset (23 hours after timer was set), but if you're using
>> > this interface, your timer event gets interrupted, you get woken up (say)
>> > 15 hours into your 23, and it's your job to decide if you need to set a
>> > new timer for the remaining 6, 7, 8 hours or some other number?
>>
>> Yes. This interface doesn't deal with timers, it only provides notifications.
>
> The notification itself is pointless unless your application is
> dealing with timers which need to be adjusted the one way or the
> other.
>
> That said, I'm still not convinced that this usecase justifies a new
> systemcall.
>
> 1) We can make timers wake up when a clock change happens

That would be fine too. We just need to wake up somehow and then can
find out ourselves what has happened underneath us.

> 2) Can't we use existing notification stuff like uevents or such ?

Uevents are heavy and very expensive to handle in userspace. Udev
wakes up all of these and runs stuff. They can only be used for device
discovery or some low-frequency state change notification, nothing
else. If there is the slightest chance that they might happen at a
very high frequency, they might bring an entire box down. It's really
not what they are made for.

Can't we just let poll() on timerfd return POLLPRI|POLLERR if the time
shifted to something that needs re-calculation in the requesting
process?

Kay
