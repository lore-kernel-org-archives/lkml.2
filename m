Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab1BWD3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:29:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46171 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1BWD3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:29:04 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=njT7K2uRR_sA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=uAY28HCUNGyHl04cuSYA:9 a=NAJTCJscNSjTvNiikosA:7 a=jITsyONc86Bc_yMI1OU_1pmEJEsA:4 a=PUjeQqilurYA:10 a=5N5v8Mvg8T1RXmSF:21 a=7AfBVGTqTW_lFLhJ:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC tip/core/rcu 06/11] smp: Document transitivity for
 memory barriers.
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
In-Reply-To: <1298425183-21265-6-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-6-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Feb 2011 22:29:02 -0500
Message-ID: <1298431742.7666.77.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 17:39 -0800, Paul E. McKenney wrote:
> Transitivity is guaranteed only for full memory barriers (smp_mb()).
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  Documentation/memory-barriers.txt |   58 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 58 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 631ad2f..f0d3a80 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -21,6 +21,7 @@ Contents:
>       - SMP barrier pairing.
>       - Examples of memory barrier sequences.
>       - Read memory barriers vs load speculation.
> +     - Transitivity
>  
>   (*) Explicit kernel barriers.
>  
> @@ -959,6 +960,63 @@ the speculation will be cancelled and the value reloaded:
>  	retrieved                               :       :       +-------+
>  
> 
> +TRANSITIVITY
> +------------
> +
> +Transitivity is a deeply intuitive notion about ordering that is not
> +always provided by real computer systems.  The following example
> +demonstrates transitivity (also called "cumulativity"):
> +
> +	CPU 1			CPU 2			CPU 3
> +	=======================	=======================	=======================
> +		{ X = 0, Y = 0 }
> +	STORE X=1		LOAD X			STORE Y=1
> +				<general barrier>	<general barrier>
> +				LOAD Y			LOAD X
> +
> +Suppose that CPU 2's load from X returns 1 and its load from Y returns 0.
> +This indicates that CPU 2's load from X in some sense follows CPU 1's
> +store to X and that CPU 2's load from Y in some sense preceded CPU 3's
> +store to Y.  The question is then "Can CPU 3's load from X return 0?"
> +
> +Because CPU 2's load from X in some sense came after CPU 1's store, it
> +is natural to expect that CPU 3's load from X must therefore return 1.
> +This expectation is an example of transitivity: if a load executing on
> +CPU A follows a load from the same variable executing on CPU B, then
> +CPU A's load must either return the same value that CPU B's load did,
> +or must return some later value.
> +
> +In the Linux kernel, use of general memory barriers guarantees
> +transitivity.  Therefore, in the above example, if CPU 2's load from X
> +returns 1 and its load from Y returns 0, then CPU 3's load from X must
> +also return 1.
> +
> +However, transitivity is -not- guaranteed for read or write barriers.
> +For example, suppose that CPU 2's general barrier in the above example
> +is changed to a read barrier as shown below:
> +
> +	CPU 1			CPU 2			CPU 3
> +	=======================	=======================	=======================
> +		{ X = 0, Y = 0 }
> +	STORE X=1		LOAD X			STORE Y=1
> +				<read barrier>		<general barrier>
> +				LOAD Y			LOAD X
> +
> +This substitution destroys transitivity: in this example, it is perfectly
> +legal for CPU 2's load from X to return 1, its load from Y to return 0,
> +and CPU 3's load from X to return 0.
> +
> +The key point is that although CPU 2's read barrier orders its pair
> +of loads, it does not guarantee to order CPU 1's store.  Therefore, if
> +this example runs on a system where CPUs 1 and 2 share a store buffer
> +or a level of cache, CPU 2 might have early access to CPU 1's writes.
> +General barriers are therefore required to ensure that all CPUs agree
> +on the combined order of CPU 1's and CPU 2's accesses.

Sounds like someone had a fun time debugging their code.

> +
> +To reiterate, if your code requires transitivity, use general barriers
> +throughout.

I expect that your code is the only code in the kernel that actually
requires transitivity ;-)

-- Steve

> +
> +
>  ========================
>  EXPLICIT KERNEL BARRIERS
>  ========================


