Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab0LOQwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:52:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:41088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0LOQwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:52:54 -0500
Message-ID: <4D08F21B.3000706@kernel.org>
Date: Wed, 15 Dec 2010 17:51:39 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 4/4] Lockless (and preemptless) fastpaths
 for slub
References: <20101214174847.887713690@linux.com> <20101214174901.827380447@linux.com>
In-Reply-To: <20101214174901.827380447@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 16:51:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 06:48 PM, Christoph Lameter wrote:
> Use the this_cpu_cmpxchg_double functionality to implement a lockless
> allocation algorithm on arches that support fast this_cpu_ops.
> 
> Each of the per cpu pointers is paired with a transaction id that ensures
> that updates of the per cpu information can only occur in sequence on
> a certain cpu.
> 
> A transaction id is a "long" integer that is comprised of an event number
> and the cpu number. The event number is incremented for every change to the
> per cpu state. This means that the cmpxchg instruction can verify for an
> update that nothing interfered and that we are updating the percpu structure
> for the processor where we picked up the information and that we are also
> currently on that processor when we update the information.
> 
> This results in a significant decrease of the overhead in the fastpaths. It
> also makes it easy to adopt the fast path for realtime kernels since this
> is lockless and does not require the use of the current per cpu area
> over the critical section. It is only important that the per cpu area is
> current at the beginning of the critical section and at the end.
> 
> So there is no need even to disable preemption.
> 
> Test results show that the fastpath cycle count is reduced by up to ~ 40%
> (alloc/free test goes from ~140 cycles down to ~80). The slowpath for kfree
> adds a few cycles.
> 
> Sadly this does nothing for the slowpath which is where the main issues with
> performance in slub are but the best case performance rises significantly.
> (For that see the more complex slub patches that require cmpxchg_double)

The first two look good to me but I frankly don't have much idea about
the latter two.  Pekka, can you please ack those?  Alternatively, you
can later pull the percpu tree in and apply the allocator bits in your
tree, which I actually prefer.

Thanks.

-- 
tejun
