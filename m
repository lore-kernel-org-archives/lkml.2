Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab1CBV3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:29:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193Ab1CBV3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:29:02 -0500
Date: Wed, 2 Mar 2011 16:28:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>, lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Andrea Righi <arighi@develer.com>, Greg Thelen <gthelen@google.com>
Subject: Re: RFC: default group_isolation to 1, remove option
Message-ID: <20110302212845.GC2547@redhat.com>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
 <20110301142002.GB25699@redhat.com>
 <AANLkTimEcrZPv8L_Sn3UtkCQ3yUUJFORtHVEvFapcJG-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimEcrZPv8L_Sn3UtkCQ3yUUJFORtHVEvFapcJG-@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 10:44:52AM -0800, Justin TerAvest wrote:
> On Tue, Mar 1, 2011 at 6:20 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, Feb 28, 2011 at 04:19:43PM -0800, Justin TerAvest wrote:
> >> Hi Vivek,
> >>
> >> I'd like to propose removing the group_isolation setting and changing
> >> the default to 1. Do we know if anyone is using group_isolation=0 to get
> >> easy group separation between sequential readers and random readers?
> >
> > CCing Corrado.
> >
> > I like the idea of setting group_isolation = 1 to default. So far I have
> > not found anybody trying to use group_isolation=0 and every time I had
> > to say can you try setting group_isolation to 1 if you are not seeing
> > service differentiation.
> >
> > I think I would not mind removing it completely altogether also. This will
> > also remove some code from CFQ. The reason we introduced group_isolation
> > because by default we idle on sync-noidle tree and on fast devices idling on
> > every syn-noidle tree can be very harmful for throughput, especially on faster
> > storage like storage arrays.
> >
> > One of the soutions for that problem can be that run with slice idle
> > enabled on SATA disks and run with slice_idle=0 and possibly group_idle=0
> > also on faster storage. Setting idling to 0 will increase throughput but
> > at the same time reduce the isolation significantly. But I guess this
> > is the performance vs isolation trade off.
> 
> I agree. Thanks! I'll send a patch shortly, CCing everyone here and we
> can have any further discussion there.
> 
> >
> >>
> >> Allowing group_isolation complicates implementing per-cgroup request
> >> descriptor pools when a queue is moved to the root group. Specifically,
> >> if we have pools per-cgroup, we would be forced to use request
> >> descriptors from the pool for the "original" cgroup, while the requests
> >> are actually being serviced by the root cgroup.
> >
> > I think creating per group request pool will complicate the implementation
> > further. (we have done that once in the past). Jens once mentioned that
> > he liked number of requests per iocontext limit better than overall queue
> > limit. So if we implement per iocontext limit, it will get rid of need
> > of doing anything extra for group infrastructure.
> 
> I will go read the discussion history for this, but I am concerned that doing
> page tracking to look up the iocontext will be more complicated than
> tracking dirtied pages per-cgroup. I would hope there is a big advantage
> to per icontext limits.

Advantage of iocontext limit I think is that we don't have to implement
per group request descriptor pools or limits.

Secondly, it also allows some isolation between two processes/iocontexts
with-in the group.

So we could think of a page taking a reference on iocontext but the
real issue would be how to store the pointer of that iocontext in
page_cgroup. We are already hard pressed for space and cssid consumes
less bits.

So may be keeping it per group might turn out to be simpler.

Also once we were talking (I think at LSF last year) about associating an
inode to a cgroup. So a bio can point to page and page can point to its inode
and we get the pointer to the cgroup. This approach should not require tracking
information in page and at coarse level it should work (as long as
applications are working on separate inodes).

I think another advantage of this scheme is that request queue can
export per cgroup congestion mechanism. So if a flusher thread picks
an inode for writting back the pages, it can retrieve the cgroup from
inode and enquire block layer if associated cgroup on the device is
congested and if it is, flusher thread can move on to next inode.

In fact if we are just worried about isolating READS from WRITES, then
we can skip implementing per group congestion idea. Even if flusher
thread gets blocked because of request descriptors, it does not impact
reads. I think at last summit people did not like the idea of congestion
per group per bdi.

One could do similar things with getting page->cgroup pointer also but
then flusher threads will also have to go throgh all the pages of
inode before it can decide whether to dispatch some IO or not and that
might slow down the writeback.

So if we are ready to sacrifice some granularity of async writeback
control and do it per inode basis instead of per page basis, it might
simplify the implementation and reduce performance overhead.

CCing Greg and Andrea. They might have thoughts on this.

Thanks
Vivek
