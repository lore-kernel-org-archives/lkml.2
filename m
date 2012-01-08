Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab2AHKTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 05:19:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45942 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2AHKTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 05:19:20 -0500
Message-ID: <1326017954.2442.35.camel@twins>
Subject: Re: A regression in recent 3.2 kernel: bdi_dirty_limit() divide
 error
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <wfg@linux.intel.com>
Cc: =?UTF-8?Q?=D0=98=D0=BB=D1=8C=D1=8F_?=
	 =?UTF-8?Q?=D0=A2=D1=83=D0=BC=D0=B0=D0=B9=D0=BA=D0=B8=D0=BD?= 
	<librarian_rus@yahoo.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Date: Sun, 08 Jan 2012 11:19:14 +0100
In-Reply-To: <20120108023305.GA5074@localhost>
References: <1325884395.57034.YahooMailClassic@web161605.mail.bf1.yahoo.com>
	 <20120107145645.GA4997@localhost> <1325954125.2442.27.camel@twins>
	 <20120108023305.GA5074@localhost>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-08 at 10:33 +0800, Wu Fengguang wrote:
> On Sat, Jan 07, 2012 at 05:35:25PM +0100, Peter Zijlstra wrote:
> > On Sat, 2012-01-07 at 22:56 +0800, Wu Fengguang wrote:
> > > Subject: 
> > > Date: Sat Jan 07 22:50:45 CST 2012
> > > 
> > > The uninitilized shift may lead to denominator=0 in
> > > prop_fraction_percpu() and divide error in bdi_dirty_limit().
> > 
> > I'm not seeing how, only proc_change_shift() can change ->index, and it
> > does that after it writes ->pg[index]->shift.
> 
> Then I lose the clue why bdi_dirty_limit() will divide error at all.

You and me both, the weird thing is, this code hasn't been changes like
forever and I can't recall any such weirdness. 

In fact, prop_fraction_percpu() sets the denominator to period_2 +
(global_count & counter_mask). 

The only way to make that 0 is to overflow the unsigned long.. did the
crash happen on 32bit -- I never saw the initial report?

But even then, we limit PROP_MAX_SHIFT to 3*BITS_PER_LONG/4, I don't
think that could ever overflow.

> prop_change_shift() does
> 
>         change ->pg[index]->shift
>         smp_wmb()
>         change ->index
> 
> Will the read side prop_fraction_percpu() need some read memory barrier?

It actually has one, see prop_get_global()...
