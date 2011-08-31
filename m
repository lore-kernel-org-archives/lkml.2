Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1HaX7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 19:59:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58485 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1HaX7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 19:59:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=PCWTfdqGPRIWX0XcOEjLE/2wjSM9iUfaU7zRC/AxW9iMXqkkZOjRAobhoH9rVb76+
	qz/Fl2LHBcdFiCZA6TgFA==
MIME-Version: 1.0
In-Reply-To: <1314834486.5738.572.camel@simey>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
	<CAAK6Zt0Sh1GdEOb-tNf2FGXJs=e1Jbcqew13R_GdTqrv6vW97w@mail.gmail.com>
	<x49k49uk2ox.fsf@segfault.boston.devel.redhat.com>
	<4E5D5817.6040704@kernel.dk>
	<CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>
	<4E5D64E8.7000102@kernel.dk>
	<20110830154157.d802d097.akpm@linux-foundation.org>
	<CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>
	<20110830155438.bc31ab99.akpm@linux-foundation.org>
	<1314770655.5738.512.camel@simey>
	<CAAK6Zt1wHdm6tRW10zGS1eNQtE+29bv-8RxT99ZOMDNeRc0X_g@mail.gmail.com>
	<1314834486.5738.572.camel@simey>
Date: Wed, 31 Aug 2011 16:59:26 -0700
Message-ID: <CAAK6Zt0C_cuTP3U2AdRVdhAQqA04O8y1TqaikA+egJV1jYbgYg@mail.gmail.com>
Subject: Re: Approaches to making io_submit not block
From: Daniel Ehrenberg <dehrenberg@google.com>
To: guy keren <choo@actcom.co.il>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 4:48 PM, guy keren <choo@actcom.co.il> wrote:
> On Wed, 2011-08-31 at 16:16 -0700, Daniel Ehrenberg wrote:
>> On Tue, Aug 30, 2011 at 11:04 PM, guy keren <choo@actcom.co.il> wrote:
>> > On Tue, 2011-08-30 at 15:54 -0700, Andrew Morton wrote:
>> >> On Tue, 30 Aug 2011 15:45:35 -0700
>> >> Daniel Ehrenberg <dehrenberg@google.com> wrote:
>> >>
>> >> > >> Not quite sure, and after working on them and fixing thing up, I don't
>> >> > >> even think they are that complex or intrusive (which I think otherwise
>> >> > >> would've been the main objection). Andrew may know/remember.
>> >> > >
>> >> > > Boy, that was a long time ago. __I was always unhappy with the patches
>> >> > > because of the amount of additional code/complexity they added.
>> >> > >
>> >> > > Then the great syslets/threadlets design session happened and it was
>> >> > > expected that such a facility would make special async handling for AIO
>> >> > > unnecessary. __Then syslets/threadlets didn't happen.
>> >> >
>> >> > Do you think we could accomplish the goals with less additional
>> >> > code/complexity? It looks like the latest version of the patch set
>> >> > wasn't so invasive.
>> >> >
>> >> > If syslets/threadlets aren't happening, should these patches be
>> >> > reconsidered for inclusion in the kernel?
>> >>
>> >> I haven't seen any demand at all for the feature in many years.  That
>> >> doesn't mean that there _isn't_ any demand - perhaps everyone got
>> >> exhausted.
>> >
>> > you should consider the emerging enterprise-grade SSD devices - which
>> > can serve several tens of thousands of I/O requests per device actually
>> > controller). These devices could be better utilized by better
>> > interfaces. further more, in our company we had to resort to using
>> > windows for IOPS benchmarking (using iometer) against storage systems
>> > using these (and similar) devices, because it manages to generate higher
>> > IOPS then linux can (i don't remember the exact numbers, but we are
>> > talking about an order of several hundred thousands IOPS).
>> >
>> > It could be that we are currently an esoteric use-case - but the
>> > high-end performance market seems to be stepping in that direction.
>>
>> I'm interested in SSD performance too. Could you tell me more about
>> your use case? Were you using a file system or a raw block device? The
>> patches we're discussing don't have any effect on a raw block device.
>
> well, the use case i've discussed specifically was with raw devices -
> not file systems.
>
> for file systems info - i'll have to consult the people that were
> running benchmarks at our work place.
>
>> Do you have any particular ideas about a new interface? What does
>> Windows provide that Linux lacks that's relevant here?
>
> i don't know what exactly it provides that linux does not - basically,it
> provides a similar asynchronous I/O API (using a mechanism they call
> "completion ports") - it just seems that they have a faster
> implementation (we compare execution on the same box, with 8GBps
> fiber-channel connections, and when we are comparing IOPS - not
> bandwidth nor latency. the storage device is the product that we
> manufacture - which is based on DRAM for storage).
>
> i can't tell you what's the specific part that causes the performance
> differences - the AIO implementation, the multi-path driver or something
> else.
>
> internally inside the box, we had problems when attempting to recover
> after a disconnection - back when we used iscsi as our internal
> transport. we stopped using it - so this is not relevant for us - but
> the phenomena we saw was that at certain times, when we had many (a few
> tens) of AIO operations to perform at once - it could take several
> seconds just to send them all (i'm not talking about completion). this
> was when we used the POSIX API on top of linux's AIO implementation
> (i.e. using librtkaio - not using the user-space implementation of
> glibc).

I'm just as interested in improving the performance of the raw block
device as I am of the file system. Any more details you could give me
about this would be great. You're saying io_submit on a raw block
device blocked for tens of seconds? Did your POSIX AIO implementation
make sure not to overrun the queue length established in io_setup?
Could you provide the test code you used? Do you have function-level
CPU profiles available?
>
>> >
>> >> If there is demand then that should be described and circulated, see
>> >> how much interest there is in resurrecting the effort.
>> >>
>> >> And, of course, the patches should be dragged out and looked at - it's
>> >> been a number of years now.
>> >>
>> >> Also, glibc has userspace for POSIX AIO.  A successful kernel-based
>> >> implementation would result in glibc migrating away from its current
>> >> implementation.  So we should work with the glibc developers on ensuring
>> >> that the migration can happen.
>> >
>> > glibc's userspace implementation doesn't scale to fast devices. It could
>> > make sense when working with slower disk devices - not when you're
>> > working with solid-state storage devices.
>> >
>> > --guy
>> >
>> >
>>
>> Dan
>
> --guy
>
>
