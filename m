Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0D0Rkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:40:47 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:7081 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0D0Rkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:40:46 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzz6ff19hz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1JQFJ-02-0OW-02
X-M-MSG: 
Date: Tue, 27 Apr 2010 19:40:26 +0200
From: Robert Richter <robert.richter@amd.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
CC: schwidefsky@de.ibm.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] updates for oprofile
Message-ID: <20100427174026.GR6450@erda.amd.com>
References: <20100427152544.GA9063@pcarmody-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100427152544.GA9063@pcarmody-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Apr 2010 17:40:26.0587 (UTC) FILETIME=[B8BFB2B0:01CAE630]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing oprofile-list)

On 27.04.10 18:25:44, Phil Carmody wrote:
> Ingo, et al., 
> 
> Regarding today's pulled request, containing:
> 
> commit bc078e4eab65f11bbaeed380593ab8151b30d703
> Author: Martin Schwidefsky <schwidef...@de.ibm.com>
> Date:   Tue Mar 2 16:01:10 2010 +0100
> 
>     oprofile: convert oprofile from timer_hook to hrtimer
>     
> 
> Information is a touch scant, as I'm doing the investigation as I
> write, but I believe that that patch can cause ooops regressions
> via a null-pointer dereference in oprofile_add_sample().
> 
> That function declares:
> """
> /**
>  * Add a sample. This may be called from any context.
>  */
> void oprofile_add_sample(struct pt_regs * const regs, unsigned long event);
> """
> 
> And begins:
> """
> void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
> {
>         int is_kernel = !user_mode(regs);
> """
> 
> Where on at least two major architectures (Arm, x86), user_mode()
> unconditionally dereferences its parameter.
> 
> Now oprofile_add_sample() is called from this context:
> """
> static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
> {
>          oprofile_add_sample(get_irq_regs(), 0);
> """
> 
> And get_irq_regs() is NULL when not in an IRQ context.

Perf is simply dropping the sample in such cases, see:

 kernel/perf_event.c:perf_swevent_hrtimer()

So at quick fix would be to check for a null pointer also. But,
according to this:

 http://www.mail-archive.com/linux-omap@vger.kernel.org/msg14074.html

samples will be incorrect then since only interrupt context is
profiled. It seems there is no solution available right now.

-Robert

> 
> Bang.
> 
> An example of this kind of thing kicking in has already been encountered 
> last year:
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg14069.html
> (That thread got a little side-tracked onto OMAP specifics, but the 
> original report is topical.)
> 
> Now would be a very good time for the "many eyes" principle to kick in.
> 
> I'm now looking into workarounds, but nothing that I'd necessarily
> want to submit as a real fix.
> 
> Phil
> cc:'d replies appreciated
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

