Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0KDVKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 17:10:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0KDVKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 17:10:48 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: CFQ and dm-crypt
References: <4CC439ED.8090400@dcs.fmph.uniba.sk>
	<x49y69b6qg6.fsf@segfault.boston.devel.redhat.com>
	<4CD185C2.8000006@dcs.fmph.uniba.sk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 04 Nov 2010 17:07:02 -0400
In-Reply-To: <4CD185C2.8000006@dcs.fmph.uniba.sk> (Richard Kralovic's message
	of "Wed, 03 Nov 2010 16:54:42 +0100")
Message-ID: <x49tyjwajd5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk> writes:

> On 11/03/10 04:23, Jeff Moyer wrote:
>>> > CFQ io scheduler relies on using task_struct current to determine which
>>> > process makes the io request. On the other hand, some dm modules (such
>>> > as dm-crypt) use separate threads for doing io. As CFQ sees only these
>>> > threads, it provides a very poor performance in such a case.
>>> >
>>> > IMHO the correct solution for this would be to store, for every io
>>> > request, the process that initiated it (and preserve this information
>>> > while the request is processed by device mapper). Would that be feasible?
>> Sure.  Try the attached patch (still an rfc) and let us know how it
>> goes.  In my environment, it speed up multiple concurrent buffered
>> readers.  I wasn't able to do a full analysis via blktrace as 2.6.37-rc1
>> seems to have broken blktrace support on my system.
>
> Thanks for the patch. Unfortunately, I got a kernel panic quite soon
> after booting the patched kernel. I was not able to reproduce the
> panic in a virtual machine, so I had to manually note the backtrace,
> thus I apologize that it's incomplete:
>
> Fatal exception in interupt.
> ...
> do_invalid_op
> cic_free_func 0x9d/0xb0
> bio_endio 0x42/0x70
> task_rq_lock
> try_to_wake_up
> invalid_op
> cic_free_func
> cfq_free_io_context
> put_io_context
> cfq_put_request
> ...

Hmm, clearly a reference counting issue.  I can't reproduce it, but I'll
keep staring and trying.

> When I combined the patch with my previous hack on dm-crypt, it worked
> fine; so the problem apparently goes away if cfq sees the corret io
> context.

OK, good to know, thanks for the info.

> Moreover, I noticed in the sources that cfq still uses current task on
> many places. For example, the CPU scheduler settings are inherited if
> there is no io priority set. Hence I was wondering if it does not make
> more sense to store whole task_struct of the initiating process in
> bio, instead of just io_context?

It's actually not that many.  elv_may_queue should also get passed the
io_context (and I've since fixed that in my local version).  The cgroup
code may actually require the task;  I'm waiting to hear back from Vivek
to see if there's a way to get from io_context to cgroup.  As for the io
priority, it may be that we can set that in the io_context as well.  I'm
not completely sure I agree with linking a task struct into a bio.  It
may make the exit path a bit tricky.  I'll think more about it if it
comes to that.

Thanks for the testing and the thoughtful comments.  I'll let you know
when I have another patch for testing (though I'm at the Linux Plumbers
Conference, so I'm not sure how much time I'll have to dedicate to the
task this week).

Cheers,
Jeff
