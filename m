Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614Ab0FKVgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:36:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44254 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab0FKVgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:36:05 -0400
Date: Fri, 11 Jun 2010 14:36:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sequence lock in Linux
Message-ID: <20100611213602.GI2394@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100611194016.GA5213@Krystal>
 <AANLkTil84IIgzlPcycNWJFRpZIGRqTFL6FGffzqOaSEx@mail.gmail.com>
 <20100611203607.GH2394@linux.vnet.ibm.com>
 <4C12A539.1000709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C12A539.1000709@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 02:06:01PM -0700, H. Peter Anvin wrote:
> On 06/11/2010 01:36 PM, Paul E. McKenney wrote:
> > 
> > The reason that the C standard permits this is to allow for things like
> > 8-bit CPUs, which are simply unable to load or store 32-bit quantities
> > except by doing it chunkwise.  But I don't expect the Linux kernel to
> > boot on these, and certainly not on any of the ones that I have used!
> > 
> > I most definitely remember seeing a gcc guarantee that loads and stores
> > would be done in one instruction whenever the hardware supported this,
> > but I am not finding it today.  :-(
> 
> What gcc does not -- and should not -- guarantee is that accessing a
> non-volatile member is done exactly once.  As Mathieu pointed out, it
> can choose to drop it due to register pressure and load it again.
> 
> What is possibly a much bigger risk -- since this is an inline -- is
> that the value is cached from a previous piece of code, *or* that since
> the structure is const(!) that the second read in the repeat loop is
> elided.  Presumably current versions of gcc don't do that across a
> memory clobber, but that doesn't seem entirely out of the question.

Memory barriers in the sequence-lock code prevent this, assuming, as
you point out, that memory clobber works (but if it doesn't, it should
be fixed):

o	write_seqlock() and write_tryseqlock() each have an smp_wmb()
	following the increment.  Ditto for write_seqcount_begin().

o	write_sequnlock() has an smp_wmb() preceding the increment,
	and ditto for write_seqcount_end().  There are thus two smp_wmb()
	calls between the increments in the usual code sequence:

		write_seqlock(&l);
		do_something();
		write_sequnlock();

o	read_seqbegin() has an smp_rmb() following its read from
	->sequence.  Ditto for read_seqcount_begin().

o	read_seqretry() has an smp_rmb() preceding its read from
	->sequence, and ditto for read_seqcount_retry().  There are thus
	two smp_wmb() calls between the reads in the usual code sequence:

		do {
			s = read_seqbegin(&l);
			read_something();
		} while read_seqretry(&l, s);

So sequence locks should be pretty safe, at least as far as this
vulnerability is concerned. ;-)

							Thanx, Paul
