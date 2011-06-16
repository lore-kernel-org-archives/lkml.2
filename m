Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab1FPHLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:06 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33374 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756878Ab1FPHK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:56 -0400
X-Sasl-enc: zwqP1ZKn6/JPKGIL/Pv5Xenq8B5nvpvN9S1UMDrb2zKE 1308208255
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:07 2011
Message-Id: <20110616002907.725386806@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tero Kristo <tero.kristo@nokia.com>, Len Brown <len.brown@intel.com>
Subject: [39/85] cpuidle: menu: fixed wrapping timers at 4.294 seconds
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Tero Kristo <tero.kristo@nokia.com>

commit 7467571f4480b273007517b26297c07154c73924 upstream.

Cpuidle menu governor is using u32 as a temporary datatype for storing
nanosecond values which wrap around at 4.294 seconds. This causes errors
in predicted sleep times resulting in higher than should be C state
selection and increased power consumption. This also breaks cpuidle
state residency statistics.

Signed-off-by: Tero Kristo <tero.kristo@nokia.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpuidle/governors/menu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -185,6 +185,7 @@ static int menu_select(struct cpuidle_de
 	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	int multiplier;
+	struct timespec t;
 
 	if (data->needs_update) {
 		menu_update(dev);
@@ -199,8 +200,9 @@ static int menu_select(struct cpuidle_de
 		return 0;
 
 	/* determine the expected residency time, round up */
+	t = ktime_to_timespec(tick_nohz_get_sleep_length());
 	data->expected_us =
-	    DIV_ROUND_UP((u32)ktime_to_ns(tick_nohz_get_sleep_length()), 1000);
+		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
 
 
 	data->bucket = which_bucket(data->expected_us);


