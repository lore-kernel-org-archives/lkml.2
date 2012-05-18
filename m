Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2ERPWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:22:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2ERPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:22:36 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=jKu8JnxlA44A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=r-5qGNJFG_0aW0o-5EEA:9 a=MQh5_zL2VGivxk0_CiUA:7 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337354554.7562.1.camel@gandalf.stny.rr.com>
Subject: Re: [WARNING] at kernel/irq/manage.c:421 __enable_irq
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>
Date: Fri, 18 May 2012 11:22:34 -0400
In-Reply-To: <alpine.LFD.2.02.1205162354310.3231@ionos>
References: <1337131823.6724.11.camel@gandalf.stny.rr.com>
	  <alpine.LFD.2.02.1205161001500.3231@ionos>
	 <1337169432.6724.30.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1205162354310.3231@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 00:35 +0200, Thomas Gleixner wrote:
> On Wed, 16 May 2012, Steven Rostedt wrote:
> > On Wed, 2012-05-16 at 13:27 +0200, Thomas Gleixner wrote:
> > > I have an idea how to fix that proper. Will send out patches later.
> > 
> > I'll test them, but it's a bit of a pain, as it would require me
> > shutting down evolution, xchat, firefox, chrome and all my emacs
> > windows :-)  This is why I don't reboot this box often.
> 
> Ok. Here you go. Compile tested only.

I booted it and I didn't see the warning. The system seems to be stable.
I'll keep it up and running over the weekend before I boot back into the
stable kernel. And then I'll give it a Tested-by tag.

-- Steve

> 
> --------------->
> Subject: ide: Request irq before calling irq_probe_port
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 16 May 2012 15:53:41 +0200
> 
> Steven reported that the warning in __enable_irq(), which yells about
> an unbalanced enable_irq() call, is triggered in context of
> ide_probe_port().
> 
> What happens is:
> 
> CPU0               CPU1
> disable_irq(X);
> ide_do_probe();    request_irq(X, ....);
> enable_irq(X)
> 
> request_irq() which happens on a non used interrupt undoes nested
> disables and enables the interrupt immediately. So the magic probe
> code in ide_probe_port() will trigger the unbalanced warning when
> enabling the irq at the end of the probe routine. A similar problem
> exists when a concurrent device init uses the irq auto probe
> functions.
> 
> The only solution for this is to request the interrupt _BEFORE_
> calling the probe code. That prevents a parallel request_irq for the
> same irq line to unconditionally undo the disabled state.
> 
> The code contains a few magics which are - as far as I understand the
> current code - simply leftovers of the historic ide implementation.
> 
> The following comment is completely bogus:
>  /*
>   * Use cached IRQ number. It might be (and is...) changed by probe
>   * code above
>   */
> 
> hwif->irq is set up _BEFORE_ the probe code is called. There is no
> function which modifies it in the context of the probe code.
> 
> Sigh, why can't people just clean up the mess when they change the
> code flow?
> 
> Also the check for hwif->irq != 0 there in the probe code is backwards
> as well. Why should we do probing first and then discard the hw
> interface because the function which installs the irq handler disables
> the interface when hwif->irq == 0 ???
> 
> There is nothing wrong with installing the interrupt handler before
> calling the probe code. All it takes is a check in the interrupt
> handler, so it can nicely coexist with another shared interrupt
> handler on the same irq line. 
> 
> Famous last words: This shouldn't break anything as the code needs to
> deal with shared interrupts anyway.
> 
> While at it remove the host.irq_handler member as it is unused and
> just adds extra confusion. TBH, I can't be bothered to split that into
> a separate patch. I wasted enough time already staring into that
> trainwreck.
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Link: http://lkml.kernel.org/r/1337131823.6724.11.camel@gandalf.stny.rr.com


