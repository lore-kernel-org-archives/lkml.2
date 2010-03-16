Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937894Ab0CPOkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:40:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935577Ab0CPOkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:40:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B9AC657.1090607@kernel.org>
References: <4B9AC657.1090607@kernel.org> <4B99CB0F.1090505@kernel.org> <1267187000-18791-1-git-send-email-tj@kernel.org> <29029.1268232771@redhat.com> <3491.1268393035@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#4
Date: Tue, 16 Mar 2010 14:38:18 +0000
Message-ID: <11791.1268750298@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> Well, you can RR queue them but in general I don't think things like
> that would be much of a problem for IO bounded works.

"RR queue"?  Do you mean realtime?

> If it becomes bad, scheduler will end up moving the source around

"The source"?  Do you mean the process that's loading the deferred work items
onto the workqueue?  Why should it get moved?  Isn't it pinned to a CPU?

> and for most common cases, those group queued works are gonna hit similar
> code paths over and over again during their short CPU burn durations so it's
> likely to be more efficient.

True.

> Are you seeing maleffects of cpu affine work scheduling during fscache load
> tests?

Hard to say.  Hear are some benchmarks:

 (*) SLOW-WORK, cold server, cold cache:

	real    2m0.974s
	user    0m0.492s
	sys     0m15.593s

 (*) SLOW-WORK, hot server, cold cache:

	real    1m31.230s	1m13.408s
	user    0m0.612s	0m0.652s
	sys     0m17.845s	0m15.641s

 (*) SLOW-WORK, hot server, warm cache:

	real    3m22.108s	3m52.557s
	user    0m0.636s	0m0.588s
	sys     0m13.317s	0m16.101s

 (*) SLOW-WORK, hot server, hot cache:

	real    1m54.331s	2m2.745s
	user    0m0.596s	0m0.608s
	sys     0m11.457s	0m12.625s

 (*) SLOW-WORK, hot server, no cache:

	real    1m1.508s	0m54.973s
	user    0m0.568s	0m0.712s
	sys     0m15.457s	0m13.969s

 (*) CMWQ, cold-ish server, cold cache:

	real    1m5.154s
	user    0m0.628s
	sys     0m14.397s

 (*) CMWQ, hot server, cold cache:

	real    1m1.240s	1m4.012s
	user    0m0.732s	0m0.576s
	sys     0m13.053s	0m14.133s

 (*) CMWQ, hot server, warm cache:

	real    3m10.949s	4m9.805s
	user    0m0.636s	0m0.648s
	sys     0m14.065s	0m13.505s

 (*) CMWQ, hot server, hot cache:

	real    1m22.511s	2m57.075s
	user    0m0.612s	0m0.604s
	sys     0m11.629s	0m12.509s

     Note that it took me several goes to get a second result for this case:
     it kept failing in a way that suggested that the non-reentrancy stuff you
     put in there failed somehow, but it's difficult to say for sure.

David
