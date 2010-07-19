Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966716Ab0GSUbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:31:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966644Ab0GSUbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:31:13 -0400
Date: Mon, 19 Jul 2010 16:31:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, axboe@kernel.dk,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
Message-ID: <20100719203109.GE32503@redhat.com>
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
 <x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
 <x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
 <AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
 <x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
 <20100713195650.GA21044@redhat.com>
 <x49aapvp1k0.fsf@segfault.boston.devel.redhat.com>
 <20100713204236.GB21044@redhat.com>
 <x4939vfv4i0.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x4939vfv4i0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 12:08:23PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Tue, Jul 13, 2010 at 04:30:23PM -0400, Jeff Moyer wrote:
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > I don't mind looking at traces. Do let me know where can I access those.
> 
> Forwarded privately.
> 
> >> Now, to answer your question, the jbd2 thread runs and issues a barrier,
> >> which causes a forced dispatch of requests.  After that a new queue is
> >> selected, and since the fs_mark thread is blocked on the journal commit,
> >> it's always the fio process that gets to run.
> >
> > Ok, that explains it.  So somehow after the barrier, fio always wins
> > as issues next read request before the fs_mark is able to issue the
> > next set of writes.
> >
> >> 
> >> This, of course, raises the question of why the blk_yield patches didn't
> >> run into the same problem.  Looking back at some saved traces, I don't
> >> see WBS (write barrier sync) requests, so I wonder if barriers weren't
> >> supported by my last storage system.
> >
> > I think that blk_yield patches will also run into the same issue if
> > barriers are enabled.
> 
> Agreed.
> 
> Here are the results again with barriers disabled for Corrado's patch:
> 
> fs_mark: 348.2 files/sec
> fio: 53324.6 KB/s
> 
> Remember that deadline was seeing 450 files/sec and 78 MB/s.  So, in
> this case, the buffered reader appears to be starved.  Looking into this
> further, I found that the journal thread is running with I/O priority 0,
> while the fio and fs_mark processes are running at the default (4).
> Because the jbd thread has a higher I/O priority, its requests are
> always closer to the front of the sort list, and thus the sync-noidle
> workload is chosen more often than the sync workload.  This essentially
> results in an elevated I/O priority for the fs_mark process as well.
> While troubling, that problem is not directly related to the problem
> we're looking at.
> 
> So, I'm still in favor of Corrado's approach.  Are there any remaining
> dissenting opinions on this?

Nope. I am fine with moving all WRITE_SYNC with RQ_NOIDLE to sync-noidle
tree and also marking jbd writes as WRITE_SYNC. By bringing dependent
threads on single service tree, we don't have to worry about slice
yielding.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
