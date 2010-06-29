Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0F2Sh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:37:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:34205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab0F2Sh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:37:57 -0400
Message-ID: <4C2A3CD0.70706@kernel.org>
Date: Tue, 29 Jun 2010 20:34:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, oleg@redhat.com,
       axboe@kernel.dk, dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de,
       florian@mickler.org, andi@firstfloor.org, mst@redhat.com,
       randy.dunlap@oracle.com, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 34/35] async: use workqueue for worker pool
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <4C2A2688.1020206@kernel.org> <4C2A3652.7030806@linux.intel.com> <4C2A385B.3010909@kernel.org> <4C2A39D4.8040505@linux.intel.com>
In-Reply-To: <4C2A39D4.8040505@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 18:35:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/29/2010 08:22 PM, Arjan van de Ven wrote:
> I'm not trying to suggest "unbound".  I'm trying to suggest "don't
> start bounding until you hit # threads >= # cpus you have some
> clever tricks to deal with bounding things; but lets make sure that
> the simple case of having less work to run in parallel than the
> number of cpus gets dealt with simple and unbound.

Well, the thing is, for most cases, binding to cpus is simply better.
That's the reason why our default workqueue was per-cpu to begin with.
There just are a lot more opportunities for optimization for both
memory access and synchronization overheads.

> You also consolidate the thread pools so that you have one global
> pool, so unlike the current situation where you get O(Nr pools * Nr
> cpus), you only get O(Nr cpus) number of threads... that's not too
> burdensome imo.  If you want to go below that then I think you're
> going too far in reducing the number of threads in your
> pool. Really.

I lost you in the above paragraph, but I think it would be better to
keep kthread pools separate.  It behaves much better regarding memory
access locality (work issuer and worker are on the same cpu and stack
and other memory used by worker are likely to be already hot).  Also,
we don't do it yet, but when creating kthreads we can allocate the
stack considering NUMA too.

> so... back to my question; will those two tasks run in parallel or
> sequential ?

If they are scheduled on the same cpu, they won't.  If that's
something actually necessary, let's implement it.  I have no problem
with that.  cmwq already can serve as simple execution context
provider without concurrency control and pumping contexts to async
isn't hard at all.  I just wanna know whether it's something which is
actually useful.  So, where would that be useful?

Thanks.

-- 
tejun
