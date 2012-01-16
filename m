Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab2APP0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:26:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab2APP0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:26:16 -0500
Date: Mon, 16 Jan 2012 10:26:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-ID: <20120116152605.GA9129@redhat.com>
References: <20111222154138.d6c583e3.akpm@linux-foundation.org>
 <20111223012112.GB12738@redhat.com>
 <20111222173820.3461be5d.akpm@linux-foundation.org>
 <20111223025411.GD12738@redhat.com>
 <20111222191144.78aec23a.akpm@linux-foundation.org>
 <20111223145856.GB16818@redhat.com>
 <20111227132501.ad7f895f.akpm@linux-foundation.org>
 <20111227220753.GH17712@google.com>
 <20111227142156.7943446e.akpm@linux-foundation.org>
 <20111227223012.GJ17712@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111227223012.GJ17712@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 02:30:12PM -0800, Tejun Heo wrote:
> Hello, Andrew.
> 
> On Tue, Dec 27, 2011 at 02:21:56PM -0800, Andrew Morton wrote:
> > <autorepeat>For those users who don't want the stats, stats shouldn't
> > consume any resources at all.
> 
> Hmmm.... For common use cases - a few cgroups doing IOs to most likely
> single physical device and maybe a couple virtual ones, I don't think
> this would show up anywhere both in terms of memory and process
> overhead.  While avoding it would be nice, I don't think that should
> be the focus of optimization or design decisions.
> 
> > And I bet that the majority of the minority who want stats simply want
> > to know "how much IO is this cgroup doing", and don't need per-cgroup,
> > per-device accounting.
> > 
> > And it could be that the minority of the minority who want per-device,
> > per-cgroup stats only want those for a minority of the time.
> > 
> > IOW, what happens if we give 'em atomic_add() and be done with it?
> 
> I really don't know.  That surely is an enticing idea tho.  Jens,
> Vivek, can you guys chime in?  Is gutting out (or drastically
> simplifying) cgroup-dev stats an option?  Are there users who are
> actually interested in this stuff?

Ok, I am back after a break of 3 weeks. So time to restart the discussion.

So we seem to be talking of two things.

- Use atomic_add() for stats.
- Do not keep stats per cgroup/per device instead just keep gloabl per
  cgroup stat.

For the first point, is atomic operation really that cheap then taking
spin lock. The whole point of introducing per cpu data structure was
to make fast path lockless. My understanding is that atomic operation
on IO submission path is expensive so to me it really does not solve
the overhead problem?

Initially google folks (Divyesh Shah) introduced additional files to
display additional stats which per per cgroup per device. I am assuming
they are making use of it. To me knowing how IO is distributed to
different devies from a cgroup is a good thing to know.

Keeping the stats per device also helps that aggregation of stats happens
from process context and we reduce the contention on stat update from
various devices. So to me it is good thing to keep stats per device and
then display these as user find them useful (Either per cgroup or per
cgroup per device).

So to me none of the above options are really solving the issue of
reducing the cost/overhead of atomic operation in IO submission path.
Please correct me if missed something here.

Thanks
Vivek
