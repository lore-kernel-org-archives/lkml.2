Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1AUAq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:46:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59991 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab1AUAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:46:26 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=Zf2-li83EnIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=DnL8GuZpbblXTxYtpzMA:9 a=DRps-_N0Q0auJ_6kXe0GIyFRdesA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Oops in trace_hardirqs_on (powerpc)
From: Steven Rostedt <rostedt@goodmis.org>
To: =?ISO-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <1293072176.22802.6.camel@gandalf.stny.rr.com>
References: <20100806233157.GA7117@alea.gnuu.de>
	 <1285184671.26872.127.camel@gandalf.stny.rr.com>
	 <20100927125037.GA4497@alea.gnuu.de> <1285639094.2989.1.camel@frodo>
	 <20101219132705.GE6615@alea.gnuu.de>
	 <1293072176.22802.6.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 20 Jan 2011 19:46:23 -0500
Message-ID: <1295570783.12215.3239.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 21:42 -0500, Steven Rostedt wrote:
> On Sun, 2010-12-19 at 14:27 +0100, Jörg Sommer wrote:
> > Hi Steven,
> > 
> 
> > Did you've fixed this problem? The bug report is still marked as open.
> > https://bugzilla.kernel.org/show_bug.cgi?id=16573
> > 
> 
> I just posted a patch to that BZ. I have it here below too. Could you
> see if it fixes you problem. I only fixed the one place that you
> reported, it may need more fixes (and in that case a macro to do the
> work).
> 
> I hit the same bug on my ppc64 box, and have a fix for that, that I'll
> post to LKML tomorrow.


Here's my official:

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> -- Steve
> 
> diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
> index ed4aeb9..915cc03 100644
> --- a/arch/powerpc/kernel/entry_32.S
> +++ b/arch/powerpc/kernel/entry_32.S
> @@ -879,7 +879,18 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_47x)
>  	 */
>  	andi.	r10,r9,MSR_EE
>  	beq	1f
> +	/*
> +	 * Since the ftrace irqsoff latency trace checks CALLER_ADDR1,
> +	 * which is the stack frame here, we need to force a stack frame
> +	 * in case we came from user space.
> +	 */
> +	stwu	r1,-32(r1)
> +	mflr	r0
> +	stw	r0,4(r1)
> +	stwu	r1,-32(r1)
>  	bl	trace_hardirqs_on
> +	lwz	r1,0(r1)
> +	lwz	r1,0(r1)
>  	lwz	r9,_MSR(r1)
>  1:
>  #endif /* CONFIG_TRACE_IRQFLAGS */
> 


