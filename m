Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab1EJIzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:55:18 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:59430 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab1EJIzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:55:15 -0400
Date: Tue, 10 May 2011 10:55:10 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Nicolas Kaiser <nikai@nikai.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] s390: oprofile: fix error checks in
 oprofile_hwsampler_init()
Message-ID: <20110510105510.455bbf5d@mschwide>
In-Reply-To: <20110503085540.GX31407@erda.amd.com>
References: <20110502154805.71664123@absol.kitzblitz>
	<20110503085540.GX31407@erda.amd.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011 10:55:40 +0200
Robert Richter <robert.richter@amd.com> wrote:

> On 02.05.11 09:48:05, Nicolas Kaiser wrote:
> > Checking 'oprofile_min_interval < 0' and
> > 'oprofile_max_interval < 0' doesn't work because
> > 'oprofile_min_interval' and 'oprofile_max_interval' are unsigned.
> 
> max/min_interval are through all the code always unsigned. I don't
> know how min/max_sampl_rate in struct hws_qsi_info_block is spec'ed,
> but there it is unsigned too.
> 
> So the best would be to return qsi.min/max_sampl_rate in
> hwsampler_query_min/max_interval() directly with no error codes as
> unsigned longs and to change the code in oprofile_hwsampler_init() to
> check for null. Both functions hwsampler_query_min/max_interval()
> could be moved to hwsampler.h as static inline functions. This makes
> the code also easier.
> 
> This patch does not handle the null value case and the data truncation
> by casting from unsigned to singed is not fixed.

Ok, the improved patch now looks like this:
--
Subject: [PATCH] s390: oprofile: fix min/max interval query checks

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

oprofile_min_interval and oprofile_max_interval are unsigned, checking
for negative values doesn't work. Change hwsampler_query_min_interval
and hwsampler_query_max_interval to return an unsigned long and
check for a zero value instead.

Reported-by: Nicolas Kaiser <nikai@nikai.net>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/oprofile/hwsampler.c |   14 ++++----------
 arch/s390/oprofile/hwsampler.h |    4 ++--
 arch/s390/oprofile/init.c      |    8 ++------
 3 files changed, 8 insertions(+), 18 deletions(-)

diff -urpN linux-2.6/arch/s390/oprofile/hwsampler.c linux-2.6-patched/arch/s390/oprofile/hwsampler.c
--- linux-2.6/arch/s390/oprofile/hwsampler.c	2011-05-10 10:53:04.000000000 +0200
+++ linux-2.6-patched/arch/s390/oprofile/hwsampler.c	2011-05-10 10:53:11.000000000 +0200
@@ -1021,20 +1021,14 @@ deallocate_exit:
 	return rc;
 }
 
-long hwsampler_query_min_interval(void)
+unsigned long hwsampler_query_min_interval(void)
 {
-	if (min_sampler_rate)
-		return min_sampler_rate;
-	else
-		return -EINVAL;
+	return min_sampler_rate;
 }
 
-long hwsampler_query_max_interval(void)
+unsigned long hwsampler_query_max_interval(void)
 {
-	if (max_sampler_rate)
-		return max_sampler_rate;
-	else
-		return -EINVAL;
+	return max_sampler_rate;
 }
 
 unsigned long hwsampler_get_sample_overflow_count(unsigned int cpu)
diff -urpN linux-2.6/arch/s390/oprofile/hwsampler.h linux-2.6-patched/arch/s390/oprofile/hwsampler.h
--- linux-2.6/arch/s390/oprofile/hwsampler.h	2011-05-10 10:53:04.000000000 +0200
+++ linux-2.6-patched/arch/s390/oprofile/hwsampler.h	2011-05-10 10:53:11.000000000 +0200
@@ -102,8 +102,8 @@ int hwsampler_setup(void);
 int hwsampler_shutdown(void);
 int hwsampler_allocate(unsigned long sdbt, unsigned long sdb);
 int hwsampler_deallocate(void);
-long hwsampler_query_min_interval(void);
-long hwsampler_query_max_interval(void);
+unsigned long hwsampler_query_min_interval(void);
+unsigned long hwsampler_query_max_interval(void);
 int hwsampler_start_all(unsigned long interval);
 int hwsampler_stop_all(void);
 int hwsampler_deactivate(unsigned int cpu);
diff -urpN linux-2.6/arch/s390/oprofile/init.c linux-2.6-patched/arch/s390/oprofile/init.c
--- linux-2.6/arch/s390/oprofile/init.c	2011-05-10 10:53:04.000000000 +0200
+++ linux-2.6-patched/arch/s390/oprofile/init.c	2011-05-10 10:53:11.000000000 +0200
@@ -145,15 +145,11 @@ static int oprofile_hwsampler_init(struc
 	 * create hwsampler files only if hwsampler_setup() succeeds.
 	 */
 	oprofile_min_interval = hwsampler_query_min_interval();
-	if (oprofile_min_interval < 0) {
-		oprofile_min_interval = 0;
+	if (oprofile_min_interval == 0)
 		return -ENODEV;
-	}
 	oprofile_max_interval = hwsampler_query_max_interval();
-	if (oprofile_max_interval < 0) {
-		oprofile_max_interval = 0;
+	if (oprofile_max_interval == 0)
 		return -ENODEV;
-	}
 
 	if (oprofile_timer_init(ops))
 		return -ENODEV;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

