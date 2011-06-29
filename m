Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1F2Bxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 21:53:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab1F2Bxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 21:53:50 -0400
Date: Tue, 28 Jun 2011 21:53:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, andrea@betterlinux.com
Subject: Re: [PATCH 0/8][V2] blk-throttle: Throttle buffered WRITEs in
 balance_dirty_pages()
Message-ID: <20110629015336.GA19082@redhat.com>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
 <20110629004219.GP32466@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629004219.GP32466@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:42:19AM +1000, Dave Chinner wrote:
> On Tue, Jun 28, 2011 at 11:35:01AM -0400, Vivek Goyal wrote:
> > Hi,
> > 
> > This is V2 of the patches. First version is posted here.
> > 
> > https://lkml.org/lkml/2011/6/3/375
> > 
> > There are no changes from first version except that I have rebased it to
> > for-3.1/core branch of Jens's block tree.
> > 
> > I have been trying to find ways to solve two problems with block IO controller
> > cgroups.
> > 
> > - Current throttling logic in IO controller does not throttle buffered WRITES.
> >   Well it does throttle all the WRITEs at device and by that time buffered
> >   WRITE have lost the submitter's context and most of the IO comes in flusher
> >   thread's context at device. Hence currently buffered write throttling is
> >   not supported.
> 
> This problem is being solved in a different manner - by making the
> bdi-flusher writeback cgroup aware.

That's good. I am looking forward for that work and that should things
better for blkio cgroups in general.

> 
> That is, writeback will be done in the context of the cgroup that
> dirtied the inode in the first place. Hence writeback will be done
> in the context that the existing block throttle can understand
> without modification.
> 
> And with cgroup-aware throttling in balance-dirty-pages (also part of
> the same piece of work), we get the throttling based
> on dirty memory usage of the cgroup and the rate at which the
> bdi-flusher for the cgroup can clean pages. This is directly related
> to the block throttle configuration of the specific cgroup....
> 
> There are already prototpyes for this infrastructure been written,
> and we are currently waiting on the IO-less dirty throttling to be
> merged before moving forward with it.
> 
> There is still one part missing, though - a necessary precursor to
> this is that we need a bdi flush context per cgroup so we don't get
> flushing of one cgroup blocking the flushing of another on the same
> bdi. The easiest way to do this is to convert the bdi-flusher
> threads to use workqueues. We can then easily extend the flush
> context to be per-cgroup without an explosion of threads and the
> management problems that would introduce.....

Agreed.

[..]
> > - Throttle WRITEs while they are entering the cache and not after that.
> >   Something like balance_dirty_pages(). Direct IO is still throttled
> >   at device level. That way, we can avoid these journalling related
> >   serialization issues w.r.t trottling.
> > 
> >   But the big issue with this approach is that we control the IO rate
> >   entering into the cache and not IO rate at the device. That way it
> >   can happen that flusher later submits lots of WRITEs to device and
> >   we will see a periodic IO spike on end node.
> > 
> >   So this mechanism helps a bit but is not the complete solution. It
> >   can primarily help those folks which have the system resources and
> >   plenty of IO bandwidth available but they don't want to give it to
> >   customer because it is not a premium customer etc.
> 
> As I said earlier - the cgroup aware bdi-flushing infrastructure
> solves this problem directly inside balance_dirty_pages. i.e.  The
> bdi flusher variant integrates much more cleanly with the way the MM
> and writeback subsystems work and also work even when block layer
> throttling is not being used at all.
> 
> If we weren't doing cgroup-aware bdi writeback and IO-less
> throttling, then this block throttle method would probably be a good
> idea. However, I think we have a more integrated solution already
> designed and slowly being implemented....
> 
> > Option 1 seem to be really hard to fix. Filesystems have not been written
> > keeping cgroups in mind. So I am really skeptical that I can convince file
> > system designers to make fundamental changes in filesystems and journalling
> > code to make them cgroup aware.
> 
> Again, you're assuming that cgroup-awareness is the solution to the
> filesystem problem and that filesystems will require fundamental
> changes. Some may, but different filesystems will require different
> types of changes to work in this environment.
> 

So for the case of ext3/ext4, atleast journaling design seems to be
fundamental problem. (my example of fsync in slow cgroup serializing
everything behind it) and per bdi per cgroup flusher changes are not going
to address it.

So how would we go about handling this.

- We will change journaling design to fix it.
- It is not a problem and I should simply ask people to use throttling
  with ext3/ext4. 
- It is a problem but hard to solve problem, so we should ask user
  to just live with it.
 
> FYI, filesystem development cycles are slow and engineers are
> conservative because of the absolute requirement for data integrity.
> Hence we tend to focus development on problems that users are
> reporting (i.e. known pain points) or functionality they have
> requested.
> 
> In this case, block throttling works OK on most filesystems out of
> the box, but it has some known problems. If there are people out
> there hitting these known problems then they'll report them, we'll
> hear about them and they'll eventually get fixed.
> 
> However, if no-one is reporting problems related to block throttling
> then it either works well enough for the existing user base or
> nobody is using the functionality. Either way we don't need to spend
> time on optimising the filesystem for such functionality.
> 
> So while you may be skeptical about whether filesystems will be
> changed, it really comes down to behaviour in real-world
> deployments. If what we already have is good enough, then we don't
> need to spend resources on fixing problems no-one is seeing...

Ok. I was kind of being proactive and wanted to bring this issue forward
now before I really ask my customers to deploy throttling and then two
months down the line they come back either with long delays in dependent
operations or with the problems of file system scalability.

But looks like you prefer to hear from other users before this thing
can be considered a problem.

Thanks
Vivek
