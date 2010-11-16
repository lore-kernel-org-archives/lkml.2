Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab0KPSwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:52:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33581 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab0KPSwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:52:11 -0500
MIME-Version: 1.0
In-Reply-To: <20101116171447.29336514@lxorguk.ukuu.org.uk>
References: <1289922400.1253.3.camel@yio.site> <20101116155717.6671e484@lxorguk.ukuu.org.uk>
 <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com> <20101116171447.29336514@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 16 Nov 2010 19:51:55 +0100
Message-ID: <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 18:14, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > NAK this, its a nonsense interface
>> >
>> > Seriously what use is an interface that tells you "what the console might
>> > have been", this is why we have a proper event tracking interface instead.
>>
>> You mean the VT_WAITEVENT? Sleeping ioctls() can't be used. The time
>> between the check for the current, and you go to sleep in the ioctl()
>> for teh next is a window which isn't covered with such interface.
>
> The only thing you need to add is VT_GETACTIVE, which is fine providing
> you know how to use it, but in both cases it is basically useless because
> by the time you've asked the question the answer is undefined. You can
> only use an interface of this type if you lock against VT changes, which
> is how the X interface works if you look at it.
>
> So what are you going to do with the return value from an interface which
> provide "what was the console, perhaps, at some point you asked but could
> even have been deleted, assigned to a different user, hot unplugged or
> moved to another framebuffer device by the time I answer"
>
> What is it for ???

It's for tracking changes. Every async event interface might carry
values which are not true anytime after the event. But, unlike with
the ioctl(), that does not matter for us, because changes are always
signaled with poll() and there is no window between a check and the
next wait-for-the-next-event which can't be covered.

Sleeping ioctl()s like VT_EVENT can't be used to track the current VT
because they might go to sleep() even when stuff has changed since the
last check. We actually need to revert its use from ConsoleKit because
it can't be fixed properly, and actually causes problems for people.

It does not matter if things change at high frequency underneath us,
we always will apply the final result just fine, when stuff stops
changing. It's actually a nice feature and no a problem at all, that
we only see the most recent state.

Sure, with the ioctl() we've seen many not interesting changes, but we
often miss the single one that is important -- the last last one. The
thing is that we don't need to sleep here and miss changes.

It's a straight-forward and simple text interface that does all we
need to track console and vt changes.

Kay
