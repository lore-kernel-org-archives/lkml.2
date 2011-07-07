Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1GGXRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 19:17:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59944 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1GGXRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 19:17:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ik2p3P1QZh1JvL/cBKyddJGWYft7j3XoyUCPXAKAAK+4hUV9dhMyzijD7jmJ6tLlE
	9WqnY1HndmlkzVEzBKY1Q==
MIME-Version: 1.0
In-Reply-To: <20110707155426.fd95445f.akpm@linux-foundation.org>
References: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
 <1309994990-4729-4-git-send-email-sergiu@chromium.org> <20110707130130.8dd02f01.akpm@linux-foundation.org>
 <CAGDaqBQMp0xyBF7Z=P5qBqNcceG3JfWNEUX=T=yMZH74UP5kxA@mail.gmail.com> <20110707155426.fd95445f.akpm@linux-foundation.org>
From: Sergiu Iordache <sergiu@google.com>
Date: Thu, 7 Jul 2011 16:16:43 -0700
Message-ID: <CAGDaqBT13wsz3AWbLy7_STT2_EY1O6w3h_bc2bFYhrLMQobefw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] char drivers: ramoops debugfs entry
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
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

On Thu, Jul 7, 2011 at 3:54 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 7 Jul 2011 15:34:26 -0700
> Sergiu Iordache <sergiu@chromium.org> wrote:
>
>> On Thu, Jul 7, 2011 at 1:01 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Wed, __6 Jul 2011 16:29:50 -0700
>> > Sergiu Iordache <sergiu@chromium.org> wrote:
>> >
>> >> While ramoops writes to ram, accessing the dump requires using /dev/mem
>> >> and knowing the memory location (or a similar solution). This patch
>> >> provides a debugfs interface through which the respective memory
>> >> area can be easily accessed.
>> >>
>> >> The entry added is /sys/kernel/debug/ramoops/next
>> >>
>> >> The entry returns a dump of size record_size each time, skipping invalid
>> >> dumps. When it reaches the end of the memory area reserved for dumps it
>> >> returns an empty record and resets the current record count.
>> >
>> > The patch increases the size of ramoops.o text&data from 1725 bytes to
>> > 2282 even when CONFIG_DEBUG_FS=n. __That's quite a lot of bloat!
>> >
>> > Furthermore, I think debugfs is the wrong place to put this. __debugfs
>> > is, umm, for debugging. __It's a place in which to put transitory junk
>> > which may or may not be there and where interfaces may change without
>> > notice and whose presence userspace should not assume. __But in this
>> > patch you're proposing a permanent and formal new interface into the
>> > ramoops driver. __It should go into a permanent well-known place where
>> > it will be maintained with the formality and care of all the other
>> > parts of the kernel API.
>> How about not using the debugfs entry and adding a char driver? There
>> are 2 possibilities here as well: using read operations to return the
>> data like the current patch does or using ioctl to return the data(and
>> maybe return other info as well such as the records size and the
>> memory size). Any suggestions regarding a valid approach?
>
> Well.  I haven't seen a description of what the interfaces *does* (and
> I'm too obstinate to work that out from the patch) so it's hard to
> advise.
>
> ioctls are unpopular.
>
> A char driver always seems weird and fake to me - there's no underlying
> device.  /dev/zero considered harmful!
>
> Perhaps switch it to sysfs?
I tried to explain it in the patch message, sorry if I was not clear enough.

Ramoops currently dumps the log of a panic/oops in a memory area which
is known not to be overwritten on restart (for example 1MB starting at
15MB). The way it works is by dividing the memory area in records of a
set size (fixed at 4K before my patches, configurable after) and by
dumping a record there for each oops/panic. The problem is that right
now you have to access that memory area through other means, such as
/dev/mem, which is not always possible.

What my patch did was to add a debugfs entry which returns a valid
record each time (a single dump done by ramoops). The first call
returns the first dump. The first call after the last valid dump
returns an empty buffer. . After it has returned nothing, the next
calls return records from the start again. The validity of a dump is
checked by looking after the header. Any comments on this approach are
welcome.

Changing the entry from debugfs to sysfs wouldn't be a problem. If
sysfs is a valid solution I'll come with a patch that updates the
documentation as well along with the sysfs entry.

Sergiu
