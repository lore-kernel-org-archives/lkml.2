Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0EVQ2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 12:28:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:45635 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab0EVQ2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 12:28:40 -0400
Date: Sat, 22 May 2010 09:31:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: frank.rowand@am.sony.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuidle: Add a repeating pattern detector to the
 menu governor
Message-ID: <20100522093156.406eacd5@infradead.org>
In-Reply-To: <20100521124309.28e25866.akpm@linux-foundation.org>
References: <20100509160242.2e351e6a@infradead.org>
	<20100509160444.260ca9c9@infradead.org>
	<4BF44156.2070807@am.sony.com>
	<20100521124309.28e25866.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 12:43:09 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> > Should the following division by INTERVALS be moved up 6 lines to
> > before "if (avg > data->expected_us)"?
> 
> Quite possibly.

>From 7350a9007eee802eaa9e4c1878dd5a2ea4d6f7f9 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 22 May 2010 09:29:29 -0700
Subject: [PATCH] cpuidle: fix bug in the pattern detector as reported by Frank Rowand

Frank Rowand found a bug in the new pattern detector code where
the average value was looked at before the sum of values got divided
by the number of samples.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
CC: akpm@linux-foundation.org
CC: frank.rowand@am.sony.com
---
 drivers/cpuidle/governors/menu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f3d4783..52ff8aa 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -205,12 +205,12 @@ static void detect_repeating_patterns(struct menu_device *data)
 	/* first calculate average and standard deviation of the past */
 	for (i = 0; i < INTERVALS; i++)
 		avg += data->intervals[i];
+	avg = avg / INTERVALS;
 
 	/* if the avg is beyond the known next tick, it's worthless */
 	if (avg > data->expected_us)
 		return;
 
-	avg = avg / INTERVALS;
 	for (i = 0; i < INTERVALS; i++)
 		stddev += (data->intervals[i] - avg) *
 			  (data->intervals[i] - avg);
-- 
1.6.2.5

