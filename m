Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab2BCAgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:36:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44999 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2BCAgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:36:52 -0500
Date: Fri, 3 Feb 2012 00:36:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
Message-ID: <20120203003633.GD14129@n2100.arm.linux.org.uk>
References: <1328210686-15909-1-git-send-email-sboyd@codeaurora.org> <20120202204411.GB14129@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1202021632400.2759@xanadu.home> <4F2B1E11.1040000@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2B1E11.1040000@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 03:36:49PM -0800, Stephen Boyd wrote:
> On 02/02/12 13:38, Nicolas Pitre wrote:
> > On Thu, 2 Feb 2012, Russell King - ARM Linux wrote
> >> On Thu, Feb 02, 2012 at 11:24:46AM -0800, Stephen Boyd wrote:
> >>> Should we move get_thread_info into assembler.h? It seems odd
> >>> to include entry-header.S but I saw that vfp was doing the same.
> >> Probably yes, and probably also have preempt_disable and preempt_enable
> >> assembler macros.  That's going to get rather icky if we have to
> >> explicitly call the scheduler though (to solve (1)).
> > What about a pair of helpers written in C instead?
> >
> > v7_flush_dcache_all() could be renamed, and a wrapper function called 
> > v7_flush_dcache_all() would call the preemption disable helper, call the 
> > former v7_flush_dcache_all code, then call the preemption enable helper.
> >
> > Then __v7_setup() could still call the core cache flush code without 
> > issues.
> 
> I tried to put the preemption disable/enable right around the place
> where it was needed. With this approach we would disable preemption
> during the entire cache flush. I'm not sure if we want to make this
> function worse for performance, do we? It certainly sounds easier than
> writing all the preempt macros in assembly though.

Err, why do you think it's a big task?

preempt disable is a case of incrementing the thread preempt count, while
preempt enable is a case of decrementing it, testing for zero, if zero,
then checking whether TIF_NEED_RESCHED is set and calling a function.

If that's too much, then the simple method in assembly to quickly disable
preemption over a very few set of instructions is using mrs/msr and cpsid i.
That'll be far cheaper than fiddling about with preempt counters or
messing about with veneers in C code.
