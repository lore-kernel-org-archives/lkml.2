Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936342Ab0GSQIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 12:08:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936315Ab0GSQIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 12:08:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, axboe@kernel.dk,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
	<x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
	<AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
	<x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
	<20100713195650.GA21044@redhat.com>
	<x49aapvp1k0.fsf@segfault.boston.devel.redhat.com>
	<20100713204236.GB21044@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 19 Jul 2010 12:08:23 -0400
In-Reply-To: <20100713204236.GB21044@redhat.com> (Vivek Goyal's message of
	"Tue, 13 Jul 2010 16:42:36 -0400")
Message-ID: <x4939vfv4i0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Jul 13, 2010 at 04:30:23PM -0400, Jeff Moyer wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:

> I don't mind looking at traces. Do let me know where can I access those.

Forwarded privately.

>> Now, to answer your question, the jbd2 thread runs and issues a barrier,
>> which causes a forced dispatch of requests.  After that a new queue is
>> selected, and since the fs_mark thread is blocked on the journal commit,
>> it's always the fio process that gets to run.
>
> Ok, that explains it.  So somehow after the barrier, fio always wins
> as issues next read request before the fs_mark is able to issue the
> next set of writes.
>
>> 
>> This, of course, raises the question of why the blk_yield patches didn't
>> run into the same problem.  Looking back at some saved traces, I don't
>> see WBS (write barrier sync) requests, so I wonder if barriers weren't
>> supported by my last storage system.
>
> I think that blk_yield patches will also run into the same issue if
> barriers are enabled.

Agreed.

Here are the results again with barriers disabled for Corrado's patch:

fs_mark: 348.2 files/sec
fio: 53324.6 KB/s

Remember that deadline was seeing 450 files/sec and 78 MB/s.  So, in
this case, the buffered reader appears to be starved.  Looking into this
further, I found that the journal thread is running with I/O priority 0,
while the fio and fs_mark processes are running at the default (4).
Because the jbd thread has a higher I/O priority, its requests are
always closer to the front of the sort list, and thus the sync-noidle
workload is chosen more often than the sync workload.  This essentially
results in an elevated I/O priority for the fs_mark process as well.
While troubling, that problem is not directly related to the problem
we're looking at.

So, I'm still in favor of Corrado's approach.  Are there any remaining
dissenting opinions on this?

Cheers,
Jeff
