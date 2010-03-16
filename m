Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab0CPQCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:02:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:34912 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838Ab0CPQCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:02:05 -0400
Message-ID: <4B9FABB7.6030906@kernel.org>
Date: Wed, 17 Mar 2010 01:03:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org, oleg@redhat.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#4
References: <4B9AC657.1090607@kernel.org> <4B99CB0F.1090505@kernel.org> <1267187000-18791-1-git-send-email-tj@kernel.org> <29029.1268232771@redhat.com> <3491.1268393035@redhat.com> <11791.1268750298@redhat.com>
In-Reply-To: <11791.1268750298@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 16:00:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/16/2010 11:38 PM, David Howells wrote:
>> Well, you can RR queue them but in general I don't think things like
>> that would be much of a problem for IO bounded works.
> 
> "RR queue"?  Do you mean realtime?

I meant round-robin as the last resort but if fscache really needs
such workaround, cmwq is probably a bad fit for it.

>> If it becomes bad, scheduler will end up moving the source around
> 
> "The source"?  Do you mean the process that's loading the deferred
> work items onto the workqueue?  Why should it get moved?  Isn't it
> pinned to a CPU?

Whatever the source may be.  If a cpu gets loaded heavily from fscache
workload, things which aren't pinned to the cpu will be distributed to
other cpus.  But again, I have difficult time imagining cpu loading
being an actual issue for fscache even in pathological cases.  It's
almost strictly IO bound and CPU intensive stuff sitting in the IO
path already have or should grow mechanisms to schedule those properly
anyway.

>> and for most common cases, those group queued works are gonna hit similar
>> code paths over and over again during their short CPU burn durations so it's
>> likely to be more efficient.
> 
> True.
>
>> Are you seeing maleffects of cpu affine work scheduling during
>> fscache load tests?
> 
> Hard to say.  Hear are some benchmarks:

Yay, some numbers. :-) I reorganized them for easier comparison.

(*) cold/cold-ish server, cold cache:

	SLOW-WORK			CMWQ
real    2m0.974s			1m5.154s
user    0m0.492s			0m0.628s
sys     0m15.593s			0m14.397s

(*) hot server, cold cache:

	SLOW-WORK			CMWQ
real    1m31.230s	1m13.408s	1m1.240s	1m4.012s
user    0m0.612s	0m0.652s	0m0.732s	0m0.576s
sys     0m17.845s	0m15.641s	0m13.053s	0m14.133s

(*) hot server, warm cache:

	SLOW-WORK			CMWQ
real    3m22.108s	3m52.557s	3m10.949s	4m9.805s
user    0m0.636s	0m0.588s	0m0.636s	0m0.648s
sys     0m13.317s	0m16.101s	0m14.065s	0m13.505s

(*) hot server, hot cache:

	SLOW-WORK			CMWQ
real    1m54.331s	2m2.745s	1m22.511s	2m57.075s
user    0m0.596s	0m0.608s	0m0.612s	0m0.604s
sys     0m11.457s	0m12.625s	0m11.629s	0m12.509s

(*) hot server, no cache:

	SLOW-WORK			CMWQ
real    1m1.508s	0m54.973s	
user    0m0.568s	0m0.712s
sys     0m15.457s	0m13.969s

> Note that it took me several goes to get a second result for this
> case: it kept failing in a way that suggested that the
> non-reentrancy stuff you put in there failed somehow, but it's
> difficult to say for sure.

Sure, there could be a bug in the non-reentrance implementation but
I'm leaning more towards a bug in work flushing before freeing thing
which also seems to show up in the debugfs path.  I'll try to
reproduce the problem here and debug it.

That said, the numbers look generally favorable to CMWQ although the
sample size is too small to draw conclusions.  I'll try to get things
fixed up so that testing can be smoother.

Thanks a lot for testing.

-- 
tejun
