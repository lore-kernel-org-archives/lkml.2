Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab1FAJAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:00:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:44110 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162145Ab1FAIRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:54 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:48 2011
Message-Id: <20110601080447.033759641@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:01:05 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tero Kristo <tero.kristo@nokia.com>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [129/146] cpuidle: menu: fixed wrapping timers at 4.294 seconds
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -237,6 +237,7 @@ static int menu_select(struct cpuidle_de
 	unsigned int power_usage = -1;
 	int i;
 	int multiplier;
+	struct timespec t;
 
 	if (data->needs_update) {
 		menu_update(dev);
@@ -251,8 +252,9 @@ static int menu_select(struct cpuidle_de
 		return 0;
 
 	/* determine the expected residency time, round up */
+	t = ktime_to_timespec(tick_nohz_get_sleep_length());
 	data->expected_us =
-	    DIV_ROUND_UP((u32)ktime_to_ns(tick_nohz_get_sleep_length()), 1000);
+		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
 
 
 	data->bucket = which_bucket(data->expected_us);


