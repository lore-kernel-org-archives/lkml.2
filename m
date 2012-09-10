Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2IJUuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:50:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44159 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2IJUuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120910195931.GD20721@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com>
 <20120910090521.GB18544@redhat.com> <CAGTjWtBa5jW6+y1k6zZmD9TUNHBgv8WRbO_iy7huY_dJSumStw@mail.gmail.com>
 <20120910195931.GD20721@redhat.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 10 Sep 2012 16:49:40 -0400
Message-ID: <CAGTjWtCiqjkR_Ze=0-ebO08+eziz6c8TXLb+O1iiArRQeSE6zw@mail.gmail.com>
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Frank Swiderski <fes@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 3:59 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Mon, Sep 10, 2012 at 01:37:06PM -0400, Mike Waychison wrote:
>> On Mon, Sep 10, 2012 at 5:05 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> > On Tue, Jun 26, 2012 at 01:32:58PM -0700, Frank Swiderski wrote:
>> >> This implementation of a virtio balloon driver uses the page cache to
>> >> "store" pages that have been released to the host.  The communication
>> >> (outside of target counts) is one way--the guest notifies the host when
>> >> it adds a page to the page cache, allowing the host to madvise(2) with
>> >> MADV_DONTNEED.  Reclaim in the guest is therefore automatic and implicit
>> >> (via the regular page reclaim).  This means that inflating the balloon
>> >> is similar to the existing balloon mechanism, but the deflate is
>> >> different--it re-uses existing Linux kernel functionality to
>> >> automatically reclaim.
>> >>
>> >> Signed-off-by: Frank Swiderski <fes@google.com>
>>
>> Hi Michael,
>>
>> I'm very sorry that Frank and I have been silent on these threads.
>> I've been out of the office and Frank has been been swamped :)
>>
>> I'll take a stab at answering some of your questions below, and
>> hopefully we can end up on the same page.
>>
>> > I've been trying to understand this, and I have
>> > a question: what exactly is the benefit
>> > of this new device?r balloon is told upper limit on target size by host and pulls
>>
>> The key difference between this device/driver and the pre-existing
>> virtio_balloon device/driver is in how the memory pressure loop is
>> controlled.
>>
>> With the pre-existing balloon device/driver, the control loop for how
>> much memory a given VM is allowed to use is controlled completely by
>> the host.  This is probably fine if the goal is to pack as much work
>> on a given host as possible, but it says nothing about the expected
>> performance that any given VM is expecting to have.  Specifically, it
>> allows the host to set a target goal for the size of a VM, and the
>> driver in the guest does whatever is needed to get to that goal.  This
>> is great for systems where one wants to "grow or shrink" a VM from the
>> outside.
>>
>>
>> This behaviour however doesn't match what applications actually expectr balloon is told upper limit on target size by host and pulls
>> from a memory control loop however.  In a native setup, an application
>> can usually expect to allocate memory from the kernel on an as-needed
>> basis, and can in turn return memory back to the system (using a heap
>> implementation that actually releases memory that is).  The dynamic
>> size of an application is completely controlled by the application,
>> and there is very little that cluster management software can do to
>> ensure that the application fits some prescribed size.
>>
>> We recognized this in the development of our cluster management
>> software long ago, so our systems are designed for managing tasks that
>> have a dynamic memory footprint.  Overcommit is possible (as most
>> applications do not use the full reservation of memory they asked for
>> originally), letting us do things like schedule lower priority/lower
>> service-classification work using resources that are otherwise
>> available in stand-by for high-priority/low-latency workloads.
>
> OK I am not sure I got this right so pls tell me if this summary is
> correct (note: this does not talk about what guest does with memory,
> ust what it is that device does):
>
> - existing balloon is told lower limit on target size by host and pulls in at least
>   target size. Guest can inflate > target size if it likes
>   and then it is OK to deflate back to target size but not less.

Is this true?   I take it nothing is keeping the existing balloon
driver from going over the target, but the same can be said about
either balloon implementation.

> - your balloon is told upper limit on target size by host and pulls at most
>   target size. Guest can deflate down to 0 at any point.
>
> If so I think both approaches make sense and in fact they
> can be useful at the same time for the same guest.
> In that case, I see two ways how this can be done:
>
> 1. two devices: existing ballon + cache balloon the
> 2. add "upper limit" to existing ballon
>
> A single device looks a bit more natural in that we don't
> really care in which balloon a page is as long as we
> are between lower and upper limit. Right?

I agree that this may be better done using a single device if possible.

> From implementation POV we could have it use
> pagecache for pages above lower limit but that
> is a separate question about driver design,
> I would like to make sure I understand the highr balloon is told upper limit on tr balloon is told upper limit on target size by host and pullsarget size by host and pulls
> level design first.

I agree that this is an implementation detail that is separate from
discussions of high and low limits.  That said, there are several
advantages to pushing these pages to the page cache (memory defrag
still works for one).

>> > Note that users could not care less about how a driver
>> > is implemented internally.
>> >
>> > Is there some workload where you see VM working better with
>> > this than regular balloon? Any numbers?
>>
>> This device is less about performance as it is about getting the
>> memory size of a job (or in this case, a job in a VM) to grow and
>> shrink as the application workload sees fit, much like how processes
>> today can grow and shrink without external direction.
>
> Still, e.g. swap in host achieves more or less the same functionality.

Swap comes at the extremely prejudiced cost of latency.  Swap is very
very rarely used in our production environment for this reason.

> I am guessing balloon can work better by getting more cooperation
> from guest but aren't there any tests showing this is true in practice?

There aren't any meaningful test-specific numbers that I can readily
share unfortunately :(  If you have suggestions for specific things we
should try, that may be useful.

The way this change is validated on our end is to ensure that VM
processes on the host "shrink" to a reasonable working set in size
that is near-linear with the expected working set size for the
embedded tasks as if they were running native on the host.  Making
this happen with the current balloon just isn't possible as there
isn't enough visibility on the host as to how much pressure there is
in the guest.

>
>
>> >
>> > Also, can't we just replace existing balloon implementation
>> > with this one?
>>
>> Perhaps, but as described above, both devices have very different
>> characteristics.
>>
>> > Why it is so important to deflate silently?
>>
>> It may not be so important to deflate silently.  I'm not sure why it
>> is important that we deflate "loudly" though either :)  Doing so seems
>> like unnecessary guest/host communication IMO, especially if the guest
>> is expecting to be able to grow to totalram (and the host isn't able
>> to nack any pages reclaimed anyway...).
>
> First, we could add nack easily enough :)

:) Sure.  Not sure how the driver is going to expect to handle that though ! :D

> Second, access gets an exit anyway. If you tell
> host first you can maybe batch these and actually speed things up.
> It remains to be measured but historically we told host
> so the onus of proof would be on whoever wants to remove this.

I'll concede that there isn't a very compelling argument as to why the
balloon should deflate silently.  You are right that it may be better
to deflate in batches (amortizing exit costs). That said, it isn't
totally obvious that queue'ing pfns to the virtio queue is the right
thing to do algorithmically either.  Currently, the file balloon
driver can reclaim memory inline with memory reclaim (via the
->writepage callback). Doing otherwise may cause the LRU shrinking to
queue large numbers of pages to the virtio queue, without any
immediate progress made with regards to actually freeing memory.  I'm
worried that such an enqueue scheme will cause large bursts of pages
to be deflated unnecessarily when we go into reclaim.

On the plus side, having an exit taken here on each page turns out to
be relatively cheap, as the vmexit from the page fault should be
faster to process as it is fully handled within the host kernel.

Perhaps some combination of both methods is required? I'm not sure :\

>
> Third, see discussion on ML - we came up with
> the idea of locking/unlocking balloon memory
> which is useful for an assigned device.
> Requires telling host first.

I just skimmed the other thread (sorry, I'm very much backlogged on
email).  By "locking", does this mean pinning the pages so that they
are not changed?

I'll admit that I'm not familiar with the details for device
assignment.  If a page for a given bus address isn't present in the
IOMMU, does this not result in a serviceable fault?

>
> Also knowing how much memory there is in a balloon
> would be useful for admin.

This is just another counter and should already be exposed.

>
> There could be other uses.
>
>> > I guess filesystem does not currently get a callback
>> > before page is reclaimed but this isan implementation detail -
>> > maybe this can be fixed?
>>
>> I do not follow this question.
>
> Assume we want to tell host before use.
> Can you implement this on top of your patch?

Potentially, yes.  Both drivers are bare-bones at the moment IIRC and
don't support sending multiple outstanding commands to the host, but
this could be conceivably fixed (although one would have to work out
what happens when virtio_add_buf() returns -ENOBUFS).

>
>> >
>> > Also can you pls answer Avi's question?
>> > How is overcommit managed?
>>
>> Overcommit in our deployments is managed using memory cgroups on the
>> host.  This allows us to have very directed policies as to how
>> competing VMs on a host may overcommit.
>
> So you push VM out to swap if it's over allowed memory?

As mentioned above, we don't use swap. If the task is of a lower
service band, it may end up blocking a lot more waiting for host
memory to become available, or may even be killed by the system and
restarted elsewhere.  Tasks that are of the higher service bands will
cause other tasks of lower service band to give up the ram (by will or
by force).

> Existing balloon does this better as it is cooperative,
> it seems.
