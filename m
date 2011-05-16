Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1EPJHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:07:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:39434 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab1EPJHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:07:53 -0400
Date: Mon, 16 May 2011 11:07:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Hoffmann <email@christianhoffmann.info>
cc: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
In-Reply-To: <4DD0335A.6050400@christianhoffmann.info>
Message-ID: <alpine.LFD.2.02.1105161105170.3078@ionos>
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm>
 <4DC100D0.1030302@christianhoffmann.info> <alpine.LFD.2.02.1105041015220.3005@ionos> <4DC1832E.5030806@christianhoffmann.info> <alpine.LFD.2.02.1105041931510.3005@ionos> <4DC1AB9B.8080501@christianhoffmann.info> <alpine.LFD.2.02.1105042154410.3005@ionos>
 <4DC2DE2C.40108@christianhoffmann.info> <alpine.LFD.2.02.1105091020450.2895@ionos> <4DD0335A.6050400@christianhoffmann.info>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 May 2011, Christian Hoffmann wrote:
> new trace:
> http://dl.dropbox.com/u/21820416/traceing2.log.bz2
> 
> Sorry for delay.

Nothing to be sorry about. Thanks for providing the information. If I
decoded the problem correctly then this just unearthed a real long
standing bug. Does the patch below solve the problem ?

Thanks,

	tglx

--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -522,10 +522,11 @@ static void tick_broadcast_init_next_eve
  */
 void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
+	int cpu = smp_processor_id();
+
 	/* Set it up only once ! */
 	if (bc->event_handler != tick_handle_oneshot_broadcast) {
 		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
-		int cpu = smp_processor_id();
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
@@ -551,6 +552,15 @@ void tick_broadcast_setup_oneshot(struct
 			tick_broadcast_set_event(tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
+	} else {
+		/*
+		 * The first cpu which switches to oneshot mode sets
+		 * the bit for all other cpus which are in the general
+		 * (periodic) broadcast mask. So the bit is set and
+		 * would prevent the first broadcast enter after this
+		 * to program the bc device.
+		 */
+		tick_broadcast_clear_oneshot(cpu);
 	}
 }
 
