Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab0LXAhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 19:37:02 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab0LXAhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 19:37:00 -0500
Date: Thu, 23 Dec 2010 16:35:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCHv7 16/16] pps: add parallel port PPS signal generator
Message-Id: <20101223163549.86a73ae8.akpm@linux-foundation.org>
In-Reply-To: <bbca0f7138c0814482a1d907833b7de1b7e70f25.1292844387.git.lasaine@lvk.cs.msu.su>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<cover.1292844387.git.lasaine@lvk.cs.msu.su>
	<bbca0f7138c0814482a1d907833b7de1b7e70f25.1292844387.git.lasaine@lvk.cs.msu.su>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 14:54:56 +0300
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> +	expire_time = ktime_to_timespec(timer->_expires);

It's bad to play around with internal fields, especially when an
accessor API was provided to access those fields.

And lo, hrtimers got changed in linux-next:

drivers/pps/generators/pps_gen_parport.c: In function 'hrtimer_event':
drivers/pps/generators/pps_gen_parport.c:92: error: 'struct hrtimer' has no member named '_expires'

The documentation in hrtimer.h is of course complete crap and
Documentation/timers/hrtimers.txt appears to be bitrot, but with a little
sleuthing and guesswork, it seems that what you want here is



--- a/drivers/pps/generators/pps_gen_parport.c~pps-add-parallel-port-pps-signal-generator-fix
+++ a/drivers/pps/generators/pps_gen_parport.c
@@ -82,7 +82,7 @@ static enum hrtimer_restart hrtimer_even
 
 	/* first of all we get the time stamp... */
 	getnstimeofday(&ts1);
-	expire_time = ktime_to_timespec(timer->_expires);
+	expire_time = ktime_to_timespec(hrtimer_get_softexpires(timer));
 	dev = container_of(timer, struct pps_generator_pp, timer);
 	lim = NSEC_PER_SEC - send_delay - dev->port_write_time;
 
_

