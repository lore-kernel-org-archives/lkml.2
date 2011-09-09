Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866Ab1IINsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:48:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58971 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933756Ab1IINs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:48:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110909180028.d1aba6c0.yoshikawa.takuya@oss.ntt.co.jp>
References: <20110908181353.8b3eb66d.yoshikawa.takuya@oss.ntt.co.jp>
	<20110908134945.GA7024@redhat.com>
	<20110909180028.d1aba6c0.yoshikawa.takuya@oss.ntt.co.jp>
Date: Fri, 9 Sep 2011 14:48:28 +0100
Message-ID: <CAJSP0QXpnJYsgtVH-wore0csxkDb5NSmUEYyFVeqNO_BZ8tpSg@mail.gmail.com>
Subject: Re: [Qemu-devel] CFQ I/O starvation problem triggered by RHEL6.0 KVM guests
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
        takuya.yoshikawa@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 10:00 AM, Takuya Yoshikawa
<yoshikawa.takuya@oss.ntt.co.jp> wrote:
> Vivek Goyal <vgoyal@redhat.com> wrote:
>
>> So you are using both RHEL 6.0 in both host and guest kernel? Can you
>> reproduce the same issue with upstream kernels? How easily/frequently
>> you can reproduce this with RHEL6.0 host.
>
> Guests were CentOS6.0.
>
> I have only RHEL6.0 and RHEL6.1 test results now.
> I want to try similar tests with upstream kernels if I can get some time.
>
> With RHEL6.0 kernel, I heard that this issue was reproduced every time, 100%.
>
>> > On the host, we were running 3 linux guests to see if I/O from these guests
>> > would be handled fairly by host; each guest did dd write with oflag=direct.
>> >
>> > Guest virtual disk:
>> >   We used a host local disk which had 3 partitions, and each guest was
>> >   allocated one of these as dd write target.
>> >
>> > So our test was for checking if cfq could keep fairness for the 3 guests
>> > who shared the same disk.
>> >
>> > The result (strage starvation):
>> >   Sometimes, one guest dominated cfq for more than 10sec and requests from
>> >   other guests were not handled at all during that time.
>> >
>> > Below is the blktrace log which shows that a request to (8,27) in cfq2068S (*1)
>> > is not handled at all during cfq2095S and cfq2067S which hold requests to
>> > (8,26) are being handled alternately.
>> >
>> > *1) WS 104920578 + 64
>> >
>> > Question:
>> >   I guess that cfq_close_cooperator() was being called in an unusual manner.
>> >   If so, do you think that cfq is responsible for keeping fairness for this
>> >   kind of unusual write requests?
>>
>> - If two guests are doing IO to separate partitions, they should really
>>   not be very close (until and unless partitions are really small).
>
> Sorry for my lack of explanation.
>
> The IO was issued from QEMU and the cooperative threads were both for the same
> guest. In other words, QEMU was using two threads for one IO stream from the guest.
>
> As my blktrace log snippet showed, cfq2095S and cfq2067S treated one sequential
> IO; cfq2095S did 64KB, then cfq2067S did next 64KB, and so on.
>
>  These should be from the same guest because the target partition was same,
>  which was allocated to that guest.
>
> During the 10sec, this repetition continued without allowing others to interrupt.
>
> I know it is unnatural but sometimes QEMU uses two aio threads for issuing one
> IO stream.
>
>>
>> - Even if there are close cooperators, these queues are merged and they
>>   are treated as single queue from slice point of view. So cooperating
>>   queues should be merged and get a single slice instead of starving
>>   other queues in the system.
>
> I understand that close cooperators' queues should be merged, but in our test
> case, when the 64KB request was issued from one aio thread, the other thread's
> queue was empty; because these queues are for the same stream, next request
> could not come until current request got finished.
>
>  But this is complicated because it depends on the qemu block layer aio.
>
> I am not sure if cfq would try to merge the queues in such cases.

Looking at posix-aio-compat.c, QEMU's threadpool for asynchronous I/O,
this seems like a fairly generic issue.  Other applications may suffer
from this same I/O scheduler behavior.  It would be nice to create a
test case program which doesn't use QEMU at all.

QEMU has a queue of requests that need to be processed.  There is a
pool of threads that sleep until requests become available with
pthread_cond_timedwait(3).  When a request is added to the queue,
pthread_cond_signal(3) is called in order to wake one sleeping thread.

This bouncing pattern between two threads that you describe is
probably a result of pthread_cond_timedwait(3) waking up each thread
in alternating fashion.  So we get this pattern:

A  B  <-- threads
1     <-- I/O requests
   2
3
   4
5
   6
...

Stefan
