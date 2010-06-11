Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab0FKUHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:07:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46705 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab0FKUHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:07:03 -0400
Date: Fri, 11 Jun 2010 13:07:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sequence lock in Linux
Message-ID: <20100611200700.GG2394@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100611194016.GA5213@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611194016.GA5213@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 03:40:16PM -0400, Mathieu Desnoyers wrote:
> Hi Paul,
> 
> (CCing lkml)
> 
> Is it just me, or the following code:
> 
> static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
> {
>         unsigned ret;
> 
> repeat:
>         ret = sl->sequence;
>         smp_rmb();
>         if (unlikely(ret & 1)) {
>                 cpu_relax();
>                 goto repeat;
>         }
> 
>         return ret;
> }
> 
> could use a ACCESS_ONCE() around the sl->sequence read ? I'm concerned about the
> compiler generating code that reads the sequence number chunkwise.
> 
> The same apply to all other reads of the sequence number in seqlock.h (including
> the retry code).
> 
> Thoughts ?

Doesn't gcc guarantee that accesses to aligned basic types that fit into
a machine word are loaded and stored in one shot?  Now, gcc might choose
to load twice (or to merge loads) due to things like register pressure,
but given that ->sequence is an int, gcc should not be accessing it
(say) bytewise on any platform supporting 32-bit accesses.

Or am I suffering from wishful thinking here?

							Thanx, Paul
