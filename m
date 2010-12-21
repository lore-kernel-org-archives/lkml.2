Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab0LUT1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 14:27:48 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:57542 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab0LUT1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:27:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Wnyv8Q7sVwockU6lvBo6l791xNHnB5nTRGy0WLDou4W6Hu7+Qx65z67AZIBDuGDPn8
         6eWFiJ9srezIT/KAlzlz199DOMpm+h43vSig99cznquy7qeIhxmozALeQngBXPyQlgwi
         zt0VXfGHNte7JjPvBpf36Cb99iPzkEMVRmT/c=
Date: Tue, 21 Dec 2010 20:27:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 09/15] rcu: Make rcu_enter,exit_nohz() callable
 from irq
Message-ID: <20101221192739.GR1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-10-git-send-email-fweisbec@gmail.com>
 <20101221192635.GO2143@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221192635.GO2143@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 11:26:35AM -0800, Paul E. McKenney wrote:
> On Mon, Dec 20, 2010 at 04:24:16PM +0100, Frederic Weisbecker wrote:
> > In order to be able to enter/exit into rcu extended quiescent
> > state from interrupt, we need to make rcu_enter_nohz() and
> > rcu_exit_nohz() callable from interrupts.
> > 
> > So, this proposes a new implementation of the rcu nohz fast path
> > related helpers, where rcu_enter_nohz() or rcu_exit_nohz() can
> > be called between rcu_enter_irq() and rcu_exit_irq() while keeping
> > the existing semantics.
> > 
> > We maintain three per cpu fields:
> > 
> > - nohz indicates we entered into extended quiescent state mode,
> > we may or not be in an interrupt even if that state is set though.
> > 
> > - irq_nest indicates we are in an irq. This number is incremented on
> > irq entry and decreased on irq exit. This includes NMIs
> > 
> > - qs_seq is increased everytime we see a true extended quiescent
> > state:
> > 	* When we call rcu_enter_nohz() and we are not in an irq.
> > 	* When we exit the outer most nesting irq and we are in
> > 	  nohz mode (rcu_enter_nohz() was called without a pairing
> > 	  rcu_exit_nohz() yet).
> > 
> > >From that three-part we can deduce the extended grace periods like
> > we did before on top of snapshots and comparisons.
> > 
> > If nohz == 1 and irq_nest == 0, we are in a quiescent state. qs_seq
> > is used to keep track of elapsed extended quiescent states, useful
> > to compare snapshots of rcu nohz state.
> > 
> > This is experimental and does not take care of barriers yet.
> 
> Indeed!!!
> 
> I will likely be reworking the dyntick interface soon anyway, so will
> try to make sure that your requirements are met.

Great, thanks!
