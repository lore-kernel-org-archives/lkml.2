Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1BXCBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 21:01:50 -0500
Received: from smtp-out.google.com ([74.125.121.67]:61985 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1BXCBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 21:01:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=X9ljXCMR4jp/m00/+k5i8TFwJqLhG5IZCMpazDm0Ztx25EGtoXYNa33nP/6zLnNz8m
         PAsyk91Qg3j5tv79o4XQ==
MIME-Version: 1.0
In-Reply-To: <20110224094039.89c07bea.kamezawa.hiroyu@jp.fujitsu.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
 <20110222193403.GG28269@redhat.com> <20110222224141.GA23723@linux.develer.com>
 <20110223000358.GM28269@redhat.com> <20110223083206.GA2174@linux.develer.com>
 <20110223152354.GA2526@redhat.com> <20110223231410.GB1744@linux.develer.com>
 <20110224001033.GF2526@redhat.com> <20110224094039.89c07bea.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 23 Feb 2011 18:01:22 -0800
Message-ID: <AANLkTimka0euS_+Rp0Vrj4RrUx9CW_JJygNxYFdGsw2J@mail.gmail.com>
Subject: Re: [PATCH 0/5] blk-throttle: writeback and swap IO control
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        Hirokazu Takahashi <taka@valinux.co.jp>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 4:40 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 23 Feb 2011 19:10:33 -0500
> Vivek Goyal <vgoyal@redhat.com> wrote:
>
>> On Thu, Feb 24, 2011 at 12:14:11AM +0100, Andrea Righi wrote:
>> > On Wed, Feb 23, 2011 at 10:23:54AM -0500, Vivek Goyal wrote:
>> > > > > Agreed. Granularity of per inode level might be accetable in many
>> > > > > cases. Again, I am worried faster group getting stuck behind slower
>> > > > > group.
>> > > > >
>> > > > > I am wondering if we are trying to solve the problem of ASYNC write throttling
>> > > > > at wrong layer. Should ASYNC IO be throttled before we allow task to write to
>> > > > > page cache. The way we throttle the process based on dirty ratio, can we
>> > > > > just check for throttle limits also there or something like that.(I think
>> > > > > that's what you had done in your initial throttling controller implementation?)
>> > > >
>> > > > Right. This is exactly the same approach I've used in my old throttling
>> > > > controller: throttle sync READs and WRITEs at the block layer and async
>> > > > WRITEs when the task is dirtying memory pages.
>> > > >
>> > > > This is probably the simplest way to resolve the problem of faster group
>> > > > getting blocked by slower group, but the controller will be a little bit
>> > > > more leaky, because the writeback IO will be never throttled and we'll
>> > > > see some limited IO spikes during the writeback.
>> > >
>> > > Yes writeback will not be throttled. Not sure how big a problem that is.
>> > >
>> > > - We have controlled the input rate. So that should help a bit.
>> > > - May be one can put some high limit on root cgroup to in blkio throttle
>> > >   controller to limit overall WRITE rate of the system.
>> > > - For SATA disks, try to use CFQ which can try to minimize the impact of
>> > >   WRITE.
>> > >
>> > > It will atleast provide consistent bandwindth experience to application.
>> >
>> > Right.
>> >
>> > >
>> > > >However, this is always
>> > > > a better solution IMHO respect to the current implementation that is
>> > > > affected by that kind of priority inversion problem.
>> > > >
>> > > > I can try to add this logic to the current blk-throttle controller if
>> > > > you think it is worth to test it.
>> > >
>> > > At this point of time I have few concerns with this approach.
>> > >
>> > > - Configuration issues. Asking user to plan for SYNC ans ASYNC IO
>> > >   separately is inconvenient. One has to know the nature of workload.
>> > >
>> > > - Most likely we will come up with global limits (atleast to begin with),
>> > >   and not per device limit. That can lead to contention on one single
>> > >   lock and scalability issues on big systems.
>> > >
>> > > Having said that, this approach should reduce the kernel complexity a lot.
>> > > So if we can do some intelligent locking to limit the overhead then it
>> > > will boil down to reduced complexity in kernel vs ease of use to user. I
>> > > guess at this point of time I am inclined towards keeping it simple in
>> > > kernel.
>> > >
>> >
>> > BTW, with this approach probably we can even get rid of the page
>> > tracking stuff for now.
>>
>> Agreed.
>>
>> > If we don't consider the swap IO, any other IO
>> > operation from our point of view will happen directly from process
>> > context (writes in memory + sync reads from the block device).
>>
>> Why do we need to account for swap IO? Application never asked for swap
>> IO. It is kernel's decision to move soem pages to swap to free up some
>> memory. What's the point in charging those pages to application group
>> and throttle accordingly?
>>
>
> I think swap I/O should be controlled by memcg's dirty_ratio.
> But, IIRC, NEC guy had a requirement for this...
>
> I think some enterprise cusotmer may want to throttle the whole speed of
> swapout I/O (not swapin)...so, they may be glad if they can limit throttle
> the I/O against a disk partition or all I/O tagged as 'swapio' rather than
> some cgroup name.
>
> But I'm afraid slow swapout may consume much dirty_ratio and make things
> worse ;)
>
>
>
>> >
>> > However, I'm sure we'll need the page tracking also for the blkio
>> > controller soon or later. This is an important information and also the
>> > proportional bandwidth controller can take advantage of it.
>>
>> Yes page tracking will be needed for CFQ proportional bandwidth ASYNC
>> write support. But until and unless we implement memory cgroup dirty
>> ratio and figure a way out to make writeback logic cgroup aware, till
>> then I think page tracking stuff is not really useful.
>>
>
> I think Greg Thelen is now preparing patches for dirty_ratio.
>
> Thanks,
> -Kame
>
>

Correct.  I am working on the memcg dirty_ratio patches with latest
mmotm memcg.  I am running some test cases which should be complete
tomorrow.  Once testing is complete, I will sent  the patches for
review.
