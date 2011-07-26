Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1GZJah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:30:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38805 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1GZJab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:30:31 -0400
Date: Tue, 26 Jul 2011 11:30:29 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt3
Message-ID: <20110726093029.GR16561@pengutronix.de>
References: <alpine.LFD.2.02.1107241223560.2702@ionos>
 <4E2E306A.6040007@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E2E306A.6040007@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 08:11:38PM -0700, Frank Rowand wrote:
> On 07/24/11 03:33, Thomas Gleixner wrote:
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.0-rt3 release.
> 
> ARM panda board boots for PREEMPT_NONE.
> 
> New compile warning for ARM pandaboard, PREEMPT_NONE:
> 
> kernel/softirq.c: In function 'softirq_check_pending_idle':
> kernel/softirq.c:119: warning: format '%02lx' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
This happens on x86, too.

The obvious fix is:

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 99620ec..af749f6 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -77,7 +77,7 @@ char *softirq_to_name[NR_SOFTIRQS] = {
 void softirq_check_pending_idle(void)
 {
 	static int rate_limit;
-	u32 warnpending = 0, pending = local_softirq_pending();
+	unsigned warnpending = 0, pending = local_softirq_pending();
 
 	if (rate_limit >= 10)
 		return;
@@ -101,7 +101,7 @@ void softirq_check_pending_idle(void)
 	}
 
 	if (warnpending) {
-		printk(KERN_ERR "NOHZ: local_softirq_pending %02lx\n",
+		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
 		       pending);
 		rate_limit++;
 	}
@@ -115,7 +115,7 @@ void softirq_check_pending_idle(void)
 	static int rate_limit;
 
 	if (rate_limit < 10) {
-		printk(KERN_ERR "NOHZ: local_softirq_pending %02lx\n",
+		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
 		       local_softirq_pending());
 		rate_limit++;
 	}

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
