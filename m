Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206Ab0HEXvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:51:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37822 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758633Ab0HEXvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:51:03 -0400
MIME-Version: 1.0
In-Reply-To: <1281047390.3405.22.camel@localhost.localdomain>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org> 
	<1280937526.28884.21.camel@work-vm> <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com> 
	<1281042665.3405.15.camel@localhost.localdomain> <AANLkTi=Gxk7FwmyCqNwXQEg7OsvDh4p2Mg3Fhiy1g5pv@mail.gmail.com> 
	<1281047390.3405.22.camel@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 6 Aug 2010 01:50:48 +0200
Message-ID: <AANLkTimNEbVacF6EzFAjdyvY6G8xa0nXCi0Do_i=FSaY@mail.gmail.com>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
To: john stultz <johnstul@us.ibm.com>
Cc: Alexander Shishkin <virtuoso@slind.org>, gregkh@suse.de,
        lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 00:29, john stultz <johnstul@us.ibm.com> wrote:
> On Fri, 2010-08-06 at 00:17 +0200, Kay Sievers wrote:
>> On Thu, Aug 5, 2010 at 23:11, john stultz <johnstul@us.ibm.com> wrote:
>> > On Thu, 2010-08-05 at 15:33 +0300, Alexander Shishkin wrote:
>> >> On 4 August 2010 18:58, john stultz <johnstul@us.ibm.com> wrote:
>> >> > Is there a actual use case that you need this for?  I don't really have
>> >> > an issue with the code I just really want to make sure the feature would
>> >> > be useful enough to justify the API and code maintenance going forward.
>>
>> Basically everything that schedules an action based on an absolute
>> time specification, like at 3pm today, and not in 3 hours from now,
>> needs to track such system time changes. Otherwise it has to do
>> nonsense like cron does, to wake up every minute to check the current
>> time.
>
> time_create(CLOCK_REALTIME,...) creates absolute (not relative) timers
> that should be adjusted when the clock is changed. Is that not the case?

That works, yes. The created timer is still is a fixed value, and it
gets automatically adjusted when the system time changes.

This is the example Lennart and I thought about when we considered
adding cron-like stuff to systemd's timer configs, but didn't want to
do silly things like scheduled checks for the actual time, so we
delayed this feature until such a notification becomes available.

Consider we want stuff like "wakeup every day at 3pm", the next wakeup
might be earlier than the timer we calculated last time, on system
time changes. We need to re-calculate it. This is necessary for all
repeating events.

Say we want to wakeup at 3pm, now it's 4pm, so we schedule it in 23
hours. Now the system time changes to 2pm, and we would expect to
wakeup in one hour, but we take 25.

Kay
