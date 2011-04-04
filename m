Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1DDOPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 10:15:23 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59771 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318Ab1DDOPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:15:22 -0400
Date: Mon, 4 Apr 2011 15:15:18 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [PATCH] avr32: Don't acquire siglock when reading sighand
 action
Message-ID: <20110404151518.58005fa8@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110402163722.GA2973@redhat.com>
References: <1301511856-9370-1-git-send-email-matt@console-pimps.org>
	<20110402163722.GA2973@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Apr 2011 18:37:22 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 03/30, Matt Fleming wrote:
> >
> > From: Matt Fleming <matt.fleming@linux.intel.com>
> >
> > There's no need to acquire the siglock when simply reading the
> > action handler. We would need to lock it if we were modifying the
> > handler or we were protecting it from modification across function
> > calls, but if we're just reading it, there's no need to lock it
> 
> Agreed, ->siglock buys nothing.
> 
> But,
> 
> > --- a/arch/avr32/kernel/traps.c
> > +++ b/arch/avr32/kernel/traps.c
> > @@ -106,9 +106,7 @@ void _exception(long signr, struct pt_regs
> > *regs, int code, if (is_global_init(current)) {
> 
> is_global_init() is not right in theory, /sbin/init can be
> multithreaded. And, this doesn't cover the sub-namespace inits... I'd
> suggest to check SIGNAL_UNKILLABLE, but looking closer I think you
> can simply remove this code.
> 
> The comment says:
> 
> 	/*
> 	 * Init gets no signals that it doesn't have a handler for.
> 	 * That's all very well, but if it has caused a synchronous
> 	 * exception and we ignore the resulting signal, it will just
> 	 * generate the same exception over and over again and we get
> 	 * nowhere.  Better to kill it and let the kernel panic.
> 	 */
> 
> This is correct, but please look at force_sig_info(), it already does
> what you need:
> 
> 	* We don't want to have recursive SIGSEGV's etc, for example,
> 	* that is why we also clear SIGNAL_UNKILLABLE.

Aha! Yeah, you're totally correct - good spot. Interestingly, after a
bit of git archaeology it seems that this code was copied from powerpc,

commit 623b0355d5b1f9c6d05005b649a2f3a7b9fd7816
Author: Haavard Skinnemoen <hskinnemoen@atmel.com>
Date:   Tue Mar 13 17:59:11 2007 +0100

    [AVR32] Clean up exception handling code
    
      * Use generic BUG() handling
      * Remove some useless debug statements
      * Use a common function _exception() to send signals or oops when
        an exception can't be handled. This makes sure init doesn't
        enter an infinite exception loop as well. Borrowed from powerpc.
      * Add some basic exception tracing support to the page fault code.
      * Rework dump_stack(), show_regs() and friends and move everything
        into process.c
      * Print information about configuration options and chip type when
        oopsing
    
    Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>


... and Ben H deleted the copy in arch/powerpc in Nov 2009, 

commit a0592d42fe3e12966db02f5c41f1edae2e59c490
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Tue Nov 10 15:13:15 2009 +0000

    powerpc: kill the obsolete code under is_global_init()
    
    The code under "if (is_global_init())" is bogus, and is_global_init()
    itself is not right in mt case.
    
    Contrary to what the comment says, nowadays force_sig_info() does kill
    init even if the handler is SIG_DFL. Note that force_sig_info() clears
    SIGNAL_UNKILLABLE exactly for this case.
    
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>


I'll send a new patch that deletes this code for avr32.

-- 
Matt Fleming, Intel Open Source Technology Center
