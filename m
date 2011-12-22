Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1LVDob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:44:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49743 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1LVDo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:44:29 -0500
MIME-Version: 1.0
In-Reply-To: <4EF29217.7040408@am.sony.com>
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com> <20111222005114.GA22541@suse.de>
 <4EF288B4.1070601@am.sony.com> <20111222014718.GA13085@suse.de> <4EF29217.7040408@am.sony.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 22 Dec 2011 04:44:08 +0100
Message-ID: <CAPXgP13eh9ibYBq4vFo21TrQiu5gvaZtOX4J3AscPHZix6BVSg@mail.gmail.com>
Subject: Re: RFC: android logger feedback request
To: Tim Bird <tim.bird@am.sony.com>
Cc: Greg KH <gregkh@suse.de>, linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 03:12, Tim Bird <tim.bird@am.sony.com> wrote:
> On 12/21/2011 05:47 PM, Greg KH wrote:

>> Again, please see what we are already doing in the kernel and userspace,
>> I think a lot of the above is already implemented.
>
> I don't know what systemd has got going on in user-space.  I'm looking
> at a very recent kernel, and I see no support for multiple log channels,
> or an optimized open/write path.

> How does current systemd prevent user-space messages from crowding
> out kernel messages?  (or vice-versa).

It intentionally doesn't. Splitting messages in separate stores is not
what we want in the general use case.

Syslog has the 'facility' for that, and it works just good enough. We
think that filtering in the receiver is more flexible and useful, than
to have multiple stores of pretty much the same type.

If you have multiple stores, you always have to fight the ordering
problem, and that really creates problems sometimes.

We are very convinced, that there should be a single entry only for
logging, and not multiple, and the filtering should happen on the
receiver side.

> Since you've been doing
> a lot of work on logging, do you have any existing metrics for logging
> overhead via the kernel log buffer?

Which overhead? I don't really think that is too interesting. Writing
to a device node or socket and copy it to the kernel's ring buffer,
not sure if it has an interesting potential of being optimized, if you
don't use fancy consoles and such.

We have no numbers, but until I see numbers of a real world problem, I
would expect there is no actual problem.

>> Which brings me back to my original question, what does this code do,
>> that is not already present in the kernel, and why is a totally new
>> interface being proposed for it?
>
> At the least, it supports multiple log channels.  Quite frankly my mind
> has been blown a bit by the suggestion to overload the kernel log buffer
> with user-space messages.  I would never have gone that route. But I'll have
> to find out more about this systemd thing to answer your question.

It's just fine. And honestly, for early boot and debugging
interleaving is exactly what you want, because userspace is triggering
the actions in the kernel, and you want to see that in the same
channel.

Also you can use netconsole and all the weird stuff people support for
the kernel and get the messages from early boot userspace including
intramfs there.

> Secondly, this is not a particularly new or radical interface. It is new
> to legacy Linux, but it's been in the Android Linux kernel for some years
> now, and it has worked well.

Sure, it's understandable, it sounds like something that made sense
when it was invented, and which probably still make a lot of sense for
Android today. But I don't think it should be discussed as a general
purpose Linux use case, or something that replaces kmsg. It does not
look like too interesting for general needs today outside of Android.

We probably just want the simple stuff we have today, or something
that really solves the structured logging problem in a proper way.
Something slightly better, with almost the same model and limitations,
than what we have already, is probably not that important enough to
make changes.

Thanks,
Kay
