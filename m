Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab0KLUEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:04:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166Ab0KLUD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:03:59 -0500
Date: Fri, 12 Nov 2010 15:03:51 -0500
From: David Teigland <teigland@redhat.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: dlm: Use cmwq for send and receive workqueues
Message-ID: <20101112200351.GE11037@redhat.com>
References: <1289563949.2419.13.camel@dolmen>
 <20101112161220.GA11037@redhat.com>
 <1289578835.2419.20.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289578835.2419.20.camel@dolmen>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 04:20:35PM +0000, Steven Whitehouse wrote:
> Hi,
> 
> On Fri, 2010-11-12 at 11:12 -0500, David Teigland wrote:
> > On Fri, Nov 12, 2010 at 12:12:29PM +0000, Steven Whitehouse wrote:
> > > 
> > > So far as I can tell, there is no reason to use a single-threaded
> > > send workqueue for dlm, since it may need to send to several sockets
> > > concurrently. Both workqueues are set to WQ_MEM_RECLAIM to avoid
> > > any possible deadlocks, WQ_HIGHPRI since locking traffic is highly
> > > latency sensitive (and to avoid a priority inversion wrt GFS2's
> > > glock_workqueue) and WQ_FREEZABLE just in case someone needs to do
> > > that (even though with current cluster infrastructure, it doesn't
> > > make sense as the node will most likely land up ejected from the
> > > cluster) in the future.
> > 
> > Thanks, I'll want to do some testing with this, but my test machines do
> > not seem to create more than one dlm_recv workqueue thread (prior to this
> > patch).  Have you tested in any cases where many threads end up being
> > created?  I've noticed while debugging some many-cpu machines a huge
> > number of dlm_recv threads, which is just excessive.  Does this patch
> > address that?
> > 
> > 
> Yes, one of the features of the cmwq is that you land up with only as
> many threads as required. When threads block, new ones are created to
> avoid stalling the workqueue. Workqueues marked with WQ_MEM_RECLAIM
> create a single rescuer thread, otherwise the threads are shared with
> all other users of cmwq,

Thanks, pushed to
git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git#next

