Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0LWCnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 21:43:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0LWCm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 21:42:59 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=Zf2-li83EnIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=cIs6I4qDPgwQT4n7TxkA:9 a=utSY0b3mPEPAp6o-YhbHN9HOMXoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Oops in trace_hardirqs_on (powerpc)
From: Steven Rostedt <rostedt@goodmis.org>
To: =?ISO-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20101219132705.GE6615@alea.gnuu.de>
References: <20100806233157.GA7117@alea.gnuu.de>
	 <1285184671.26872.127.camel@gandalf.stny.rr.com>
	 <20100927125037.GA4497@alea.gnuu.de> <1285639094.2989.1.camel@frodo>
	 <20101219132705.GE6615@alea.gnuu.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 22 Dec 2010 21:42:56 -0500
Message-ID: <1293072176.22802.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 14:27 +0100, Jörg Sommer wrote:
> Hi Steven,
> 

> Did you've fixed this problem? The bug report is still marked as open.
> https://bugzilla.kernel.org/show_bug.cgi?id=16573
> 

I just posted a patch to that BZ. I have it here below too. Could you
see if it fixes you problem. I only fixed the one place that you
reported, it may need more fixes (and in that case a macro to do the
work).

I hit the same bug on my ppc64 box, and have a fix for that, that I'll
post to LKML tomorrow.

-- Steve

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index ed4aeb9..915cc03 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -879,7 +879,18 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_47x)
 	 */
 	andi.	r10,r9,MSR_EE
 	beq	1f
+	/*
+	 * Since the ftrace irqsoff latency trace checks CALLER_ADDR1,
+	 * which is the stack frame here, we need to force a stack frame
+	 * in case we came from user space.
+	 */
+	stwu	r1,-32(r1)
+	mflr	r0
+	stw	r0,4(r1)
+	stwu	r1,-32(r1)
 	bl	trace_hardirqs_on
+	lwz	r1,0(r1)
+	lwz	r1,0(r1)
 	lwz	r9,_MSR(r1)
 1:
 #endif /* CONFIG_TRACE_IRQFLAGS */


