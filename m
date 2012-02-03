Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2BCBQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:16:28 -0500
Received: from relais.videotron.ca ([24.201.245.36]:15315 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531Ab2BCBQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:16:25 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 02 Feb 2012 20:16:24 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
In-reply-to: <20120203003633.GD14129@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.02.1202022010020.2759@xanadu.home>
References: <1328210686-15909-1-git-send-email-sboyd@codeaurora.org>
 <20120202204411.GB14129@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1202021632400.2759@xanadu.home>
 <4F2B1E11.1040000@codeaurora.org>
 <20120203003633.GD14129@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Feb 2012, Russell King - ARM Linux wrote:

> On Thu, Feb 02, 2012 at 03:36:49PM -0800, Stephen Boyd wrote:
> > On 02/02/12 13:38, Nicolas Pitre wrote:
> > > What about a pair of helpers written in C instead?
> > >
> > > v7_flush_dcache_all() could be renamed, and a wrapper function called 
> > > v7_flush_dcache_all() would call the preemption disable helper, call the 
> > > former v7_flush_dcache_all code, then call the preemption enable helper.
> > >
> > > Then __v7_setup() could still call the core cache flush code without 
> > > issues.
> > 
> > I tried to put the preemption disable/enable right around the place
> > where it was needed. With this approach we would disable preemption
> > during the entire cache flush. I'm not sure if we want to make this
> > function worse for performance, do we? It certainly sounds easier than
> > writing all the preempt macros in assembly though.
> 
> Err, why do you think it's a big task?
> 
> preempt disable is a case of incrementing the thread preempt count, while
> preempt enable is a case of decrementing it, testing for zero, if zero,
> then checking whether TIF_NEED_RESCHED is set and calling a function.

Oh certainly.  And we already do just that in a few places already.  I 
re-read your previous email to realize that I initially misread your 
remark about the ickness of explicitly calling the scheduler.

> If that's too much, then the simple method in assembly to quickly disable
> preemption over a very few set of instructions is using mrs/msr and cpsid i.
> That'll be far cheaper than fiddling about with preempt counters or
> messing about with veneers in C code.

Indeed.  And I think that would be plenty sufficient here as the 
protected region is really short.  I don't think that warrants any 
macros.


Nicolas
