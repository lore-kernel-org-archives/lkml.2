Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2DERKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 13:10:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab2DERKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:10:50 -0400
Date: Thu, 5 Apr 2012 13:09:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, sjayaraman@suse.com,
        andrea@betterlinux.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        ctalbott@google.com, rni@google.com, lsf@lists.linux-foundation.org
Subject: Re: [RFC] writeback and cgroup
Message-ID: <20120405170956.GE23999@redhat.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404175124.GA8931@localhost>
 <20120404193355.GD29686@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404201816.GL12676@redhat.com>
 <20120405163113.GD12854@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120405163113.GD12854@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 09:31:13AM -0700, Tejun Heo wrote:
> Hey, Vivek.
> 
> On Wed, Apr 04, 2012 at 04:18:16PM -0400, Vivek Goyal wrote:
> > Hey how about reconsidering my other proposal for which I had posted
> > the patches. And that is keep throttling still at device level. Reads
> > and direct IO get throttled asynchronously but buffered writes get
> > throttled synchronously.
> > 
> > Advantages of this scheme.
> > 
> > - There are no separate knobs.
> > 
> > - All the IO (read, direct IO and buffered write) is controlled using
> >   same set of knobs and goes in queue of same cgroup.
> > 
> > - Writeback logic has no knowledge of throttling. It just invokes a 
> >   hook into throttling logic of device queue.
> > 
> > I guess this is a hybrid of active writeback throttling and back pressure
> > mechanism.
> > 
> > But it still does not solve the NFS issue as well as for direct IO,
> > filesystems still can get serialized, so metadata issue still needs to 
> > be resolved. So one can argue that why not go for full "back pressure"
> > method, despite it being more complex.
> > 
> > Here is the link, just to refresh the memory. Something to keep in mind
> > while assessing alternatives.
> > 
> > https://lkml.org/lkml/2011/6/28/243
> 
> Hmmm... so, this only works for blk-throttle and not with the weight.
> How do you manage interaction between buffered writes and direct
> writes for the same cgroup?
> 

Yes, it is only for blk-throttle. We just account for buffered write
in balance_dirty_pages() instead of when they are actually submitted to
device by flusher thread.

IIRC, I just had two queues. In one queue I had bios and in another queue
I had  tasks with information how much memory they are dirtying. So I 
did round robin in terms of dispatch between two queues depending on
throttling rate. I will allow dispatch bio from direct IO queue, then 
look at the other queue and see how much IO other task wanted to do and
when sufficient time had passed based on throttling rate, I will remove
that task from my wait queue and wake it up. 

That way it becomes equivalent to that two IO paths (direct IO + buffered
write),  doing IO to single pipe which has throttling limit. Both the
IOs are sujected to same common limit (and no split). Just that we round
robin between two types of IO and try to divide available bandwidth
equally (This ofcourse could be made tunable).

Thanks
Vivek
