Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1LVENU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 23:13:20 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46734 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098Ab1LVENR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 23:13:17 -0500
MIME-Version: 1.0
In-Reply-To: <20111222034717.GB14174@suse.de>
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com> <20111222005114.GA22541@suse.de>
 <4EF288B4.1070601@am.sony.com> <20111222014718.GA13085@suse.de>
 <4EF29217.7040408@am.sony.com> <20111222034717.GB14174@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 22 Dec 2011 05:12:55 +0100
Message-ID: <CAPXgP10ikqHFn41wc1HPsKHyaC7fe1WGC2eHqs-hdRaZ7XCTLw@mail.gmail.com>
Subject: Re: RFC: android logger feedback request
To: Greg KH <gregkh@suse.de>
Cc: Tim Bird <tim.bird@am.sony.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 04:47, Greg KH <gregkh@suse.de> wrote:
> On Wed, Dec 21, 2011 at 06:12:39PM -0800, Tim Bird wrote:
>> > Again, please see what we are already doing in the kernel and userspace,
>> > I think a lot of the above is already implemented.
>>
>> I don't know what systemd has got going on in user-space.  I'm looking
>> at a very recent kernel, and I see no support for multiple log channels,
>> or an optimized open/write path.
>
> How is the existing syslog read path not "optimized"?  What kind of
> speed and numbers are we talking about here?
>
> Oh, and you do know about the userspace printk tty driver, right?  What
> about using that combined with the existing syslog system call?
>
> systemd doesn't use it, but I know of a few embedded systems that are
> already using it today, and I think it might solve the android issues
> already.

We would like to have for the general Linux use case is a kmsg, that
supports structured data, but looks the same as it looks today to
current and legacy tools.

We would like to have every printk that does not start with a
KERN_CONT to create a record in the kmsg buffer. This record would
carry directly a timestamp, the log facility and the log level and a
reference to the usual human readable string.

The current kmsg prefixing of the timestamp would be a runtime switch,
and just added when the records are traversed, instead of the current
buffer printing.

In addition to this common data, every record can carry a
'dictionary', which basically looks like a process environment, means
KEY=value pairs. The additional data can carry all the stuff that is
needed for structured logging and provides the base for machine
readable log information.

We don't want to separate multiple stores to avoid ordering problems
when the messages need to be merged from the multiple streams on the
receiver side.

I think this is theoretically all possible with the current kmsg,
without breaking anything. The current interfaces would iterate over
the record list and print out the human readable parts and skip the
metadata, instead of just copying a linear byte stream. To tools, it
could look the same as it is currently. It's just that the ring buffer
is not a byte- but a record-buffer.

Advanced tools could get a new interface or switch the old interface
to pipe out the structured data too.

In the systemd journal, we have an ASCII-like stream format that
carries out structured data and is binary data capable.

If we want to think about any next generation logging, I'm convinced,
we need to support records, structured data and binary data; anything
else is unlikely worth to change the current stuff.

Kay
