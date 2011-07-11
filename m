Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab1GKQzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:55:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab1GKQzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:55:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=n5LK/YFzyKLEAgVa1AVthnfYrTYuP6Hxv7aZBz3FkcQGMy+YtnpRvnQFSTLc784tI
	+6pdQxaj2Xc+WGRi0hphQ==
MIME-Version: 1.0
In-Reply-To: <CANGUGtCJpq32AYr5=3LGcxfCqAG5CbDVW6fxS824GdCi53Pr3g@mail.gmail.com>
References: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
 <1309994990-4729-4-git-send-email-sergiu@chromium.org> <20110707130130.8dd02f01.akpm@linux-foundation.org>
 <CAGDaqBQMp0xyBF7Z=P5qBqNcceG3JfWNEUX=T=yMZH74UP5kxA@mail.gmail.com>
 <20110707155426.fd95445f.akpm@linux-foundation.org> <CAGDaqBT13wsz3AWbLy7_STT2_EY1O6w3h_bc2bFYhrLMQobefw@mail.gmail.com>
 <20110707162727.f361f053.akpm@linux-foundation.org> <20110707233335.GA15120@kroah.com>
 <CANGUGtCJpq32AYr5=3LGcxfCqAG5CbDVW6fxS824GdCi53Pr3g@mail.gmail.com>
From: Sergiu Iordache <sergiu@chromium.org>
Date: Mon, 11 Jul 2011 09:54:42 -0700
X-Google-Sender-Auth: YBuK4mmWG10RJqZu1UwFCl4qwIc
Message-ID: <CAGDaqBRcuF8nSd6ehGpbj4_uPuCC16ZPED8tvMXVkjprSaQB5Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] char drivers: ramoops debugfs entry
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 11:43 PM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> 2011/7/8 Greg KH <greg@kroah.com>:
>> On Thu, Jul 07, 2011 at 04:27:27PM -0700, Andrew Morton wrote:
>>> On Thu, 7 Jul 2011 16:16:43 -0700
>>> Sergiu Iordache <sergiu@google.com> wrote:
>>>
>>> > Ramoops currently dumps the log of a panic/oops in a memory area which
>>> > is known not to be overwritten on restart (for example 1MB starting at
>>> > 15MB). The way it works is by dividing the memory area in records of a
>>> > set size (fixed at 4K before my patches, configurable after) and by
>>> > dumping a record there for each oops/panic. The problem is that right
>>> > now you have to access that memory area through other means, such as
>>> > /dev/mem, which is not always possible.
>>> >
>>> > What my patch did was to add a debugfs entry which returns a valid
>>> > record each time (a single dump done by ramoops). The first call
>>> > returns the first dump. The first call after the last valid dump
>>> > returns an empty buffer. .
>>>
>>> Please fully describe this "record" in the v2 patch changelog.  We'll
>>> want to review it for endianness, 32/64-bit compat issues,
>>> maintainability, extensibility, etc.
>>>
>>> > After it has returned nothing, the next
>>> > calls return records from the start again.
>>>
>>> That sounds a bit weird.  One would expect it to keep returning zero,
>>> requiring userspace to lseek or close/open.
>>>
>>> > The validity of a dump is
>>> > checked by looking after the header. Any comments on this approach are
>>> > welcome.
>>> >
>>> > Changing the entry from debugfs to sysfs wouldn't be a problem. If
>>> > sysfs is a valid solution I'll come with a patch that updates the
>>> > documentation as well along with the sysfs entry.
>>>
>>> sysfs sounds OK to me.  Then again, sysfs is supposed to be
>>> one-value-per-file, so using it would be naughty.
>>>
>>> I dunno, I'd be inclined to abuse the sysfs rule and hope that nobody
>>> notices rather than create a fake char device.  But there's certainly
>>> plenty of precedent for the fake char driver.
>>
>> No, please don't abuse sysfs that way.
>>
>> Use debugfs or a char device node.
>>
>> thanks,
>>
>> greg k-h
>>
>
> I agree with Greg. I asked to not break the existent way to read data
> via /dev/mem because for me it's the right way to do this thing.
> However to do an easy *debug* a debugfs entry can be useful. IMHO, a
> "production" script/application that use debugfs instead of /dev/mem
> in this case is simply broken because the debugfs can't be like a
> system call or other kernel interaction mechanism. Debugfs should be
> used only for debug.
>
> Marco

Any consensus/decision on how to go on with this patch idea?

The options that I see right now are:
- keep access through /dev/mem only (but access to /dev/mem is
sometimes restricted);
- keep the debugfs entry as well(as in the patch);
- remove the debugfs entry and add a char driver to access the memory
using read and seek operations.

+ the rejected(?) options from before

Sergiu
