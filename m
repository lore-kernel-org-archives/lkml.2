Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab0I0WBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:01:17 -0400
Received: from relay3.sgi.com ([192.48.152.1]:44264 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752289Ab0I0WBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:01:15 -0400
Date: Mon, 27 Sep 2010 15:01:13 -0700
From: Arthur Kepner <akepner@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC/PATCHv2] x86/irq: round-robin distribution of irqs to
	cpus w/in node
Message-ID: <20100927220113.GD30050@sgi.com>
References: <20100927203448.GC30050@sgi.com> <alpine.LFD.2.00.1009272236430.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009272236430.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:46:02PM +0200, Thomas Gleixner wrote:
> ...
> Sigh. Why is this a x86 specific problem ?
>

It's obviously not. But we're particularly seeing it on x86 
systems, so an x86-specific fix would address our problem.
 
> If we setup an irq on a node then we should set the affinity to the
> target node in general. 

OK.

> .... The round robin inside the node is really not
> a problem unless you hit:
> 
>    nr_irqs_per_node * nr_cpus_per_node > max_vectors_per_cpu
> 

No, I don't think that's true. 

The problem we're seeing is that one driver asks for a large 
number of interrupts (on no CPU in particular). And because of the 
way that the vectors are initially assigned to CPUs (in 
__assign_irq_vector()), a particular CPU can have all its vectors 
consumed. 

Now, a second driver comes along, and requests an interrupt on 
a specific CPU, N. But CPU N is out of interrupts, so that driver 
fails.

This all happens before a user-space irq balancer is available.

-- 
Arthur
