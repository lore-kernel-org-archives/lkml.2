Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab1BRVRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:17:23 -0500
Received: from www.tglx.de ([62.245.132.106]:56757 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1BRVRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:17:21 -0500
Date: Fri, 18 Feb 2011 22:16:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Rodolfo Giometti <giometti@linux.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] pps: Make pps_gen_parport depend on BROKEN
Message-ID: <alpine.LFD.2.00.1102182214190.2701@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver causes hard lockups, when the active clock soure is
jiffies. The reason is that it loops with interrupts disabled waiting
for a timestamp to be reached by polling getnstimeofday(). Though with
a jiffies clocksource, when that code runs on the same CPU which is
responsible for updating jiffies, then we loop in circles for ever
simply because the timer interrupt cannot update jiffies. So both UP
and SMP can be affected.

There is no easy fix for that problem so make it depend on BROKEN for
now.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <giometti@linux.it>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 drivers/pps/generators/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pps/generators/Kconfig
===================================================================
--- linux-2.6.orig/drivers/pps/generators/Kconfig
+++ linux-2.6/drivers/pps/generators/Kconfig
@@ -6,7 +6,7 @@ comment "PPS generators support"
 
 config PPS_GENERATOR_PARPORT
 	tristate "Parallel port PPS signal generator"
-	depends on PARPORT
+	depends on PARPORT && BROKEN
 	help
 	  If you say yes here you get support for a PPS signal generator which
 	  utilizes STROBE pin of a parallel port to send PPS signals. It uses
