Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0DFLir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 07:38:47 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:58949 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0DFLik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 07:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x8To7XhPfrBCA7Lt0/IEOqJRotBuupFPWXCHHbefGFvJxre8Ep4QKrg19Kmr3rlnW5
         Qx8s+fCG/chiF2jJ+Gi8OVuqMBRXYvRsXsYA4Iu1vm5Aqp/fICTCH/qdgdTmNkte1NpO
         FnWNUEP8udUAYdpQDQmgKlxPuCXftk5B5vSbw=
Date: Tue, 6 Apr 2010 13:38:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
	events on sparc 64
Message-ID: <20100406113830.GF5147@nowhere>
References: <20100405065701.GC5127@nowhere> <20100405.122233.188421941.davem@davemloft.net> <20100405194055.GA5265@nowhere> <20100406.025049.267615796.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406.025049.267615796.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 02:50:49AM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 5 Apr 2010 21:40:58 +0200
> 
> > It happens without CONFIG_FUNCTION_TRACER as well (but it happens
> > when the function tracer runs). And I hadn't your
> > perf_arch_save_caller_regs() when I triggered this.
> 
> I figured out the problem, it's NMIs.  As soon as I disable all of the
> NMI watchdog code, the problem goes away.
> 
> This is because some parts of the NMI interrupt handling path are not
> marked with "notrace" and the various tracer code paths use
> local_irq_disable() (either directly or indirectly) which doesn't work
> with sparc64's NMI scheme.  These essentially turn NMIs back on in the
> NMI handler before the NMI condition has been cleared, and thus we can
> re-enter with another NMI interrupt.
> 
> We went through this for perf events, and we just made sure that
> local_irq_{enable,disable}() never occurs in any of the code paths in
> perf events that can be reached via the NMI interrupt handler.  (the
> only one we had was sched_clock() and that was easily fixed)



That reminds me we have a new pair of local_irq_disable/enable
in perf_event_task_output(), which path can be taken by hardware
pmu events.

See this patch:

8bb39f9aa068262732fe44b965d7a6eb5a5a7d67
perf: Fix 'perf sched record' deadlock

