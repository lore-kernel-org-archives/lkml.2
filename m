Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab1EYPdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:33:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52517 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029Ab1EYPdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:33:35 -0400
Date: Wed, 25 May 2011 08:33:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110525153327.GA2341@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
 <20110523153848.GC2310@linux.vnet.ibm.com>
 <1306318636.9059.33.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306318636.9059.33.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 12:17:16PM +0200, Paul Bolle wrote:
> > Polling is fine.  Please see attached for a script to poll at 15-second
> > intervals.  Please also feel free to adjust, just tell me what you
> > adjusted.
> 
> 0) I have not yet tried this script, but I did have a look at it (to see
> what's needed to run it).
> 
> 1) All debugfs files it polls come from kernel/rcutree_trace.c. That
> file is written as a module (and will only be built if
> CONFIG_TREE_RCU_TRACE isn't "n"). But in init/Kconfig, the
> TREE_RCU_TRACE config entry is set to "def_bool".
> 
> 2) So shouldn't either the config entry be set to "tristate" or the
> module support removed from kernel/rcutree_trace.c?

No.

Just set CONFIG_RCU_TRACE=y and you will have RCU tracing.  Here is why:

CONFIG_TREE_RCU_TRACE is defined as follows:

	config TREE_RCU_TRACE
		def_bool RCU_TRACE && ( TREE_RCU || TREE_PREEMPT_RCU )
		select DEBUG_FS
		help
		  This option provides tracing for the TREE_RCU and
		  TREE_PREEMPT_RCU implementations, permitting Makefile to
		  trivially select kernel/rcutree_trace.c.

In other words, CONFIG_TREE_RCU_TRACE will be set to "y" if CONFIG_RCU_TRACE=y
and if either CONFIG_TREE_RCU=y or CONFIG_TREE_PREEMPT_RCU=y.  If you
are running CONFIG_SMP=y, then we are guaranteed that either
CONFIG_TREE_RCU=y or CONFIG_TREE_PREEMPT_RCU=y, which leaves
CONFIG_RCU_TRACE.

CONFIG_RCU_TRACE is defined as follows:

	config RCU_TRACE
		bool "Enable tracing for RCU"
		help
		  This option provides tracing in RCU which presents stats
		  in debugfs for debugging RCU implementation.

		  Say Y here if you want to enable RCU tracing
		  Say N if you are unsure.

So you can set CONFIG_RCU_TRACE, and if you are running CONFIG_SMP=y,
you will have RCU tracing in your kernel.

							Thanx, Paul
