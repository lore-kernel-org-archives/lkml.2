Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab0EJX1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:27:11 -0400
Received: from kroah.org ([198.145.64.141]:33436 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562Ab0EJWxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:04 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:27 2010
Message-Id: <20100510223327.308351633@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Arjan van de Ven <arjan@linux.intel.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [110/117] cpuidle: Fix incorrect optimization
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan van de Ven <arjan@linux.intel.com>

commit 1c6fe0364fa7bf28248488753ee0afb6b759cd04 upstream.

commit 672917dcc78 ("cpuidle: menu governor: reduce latency on exit")
added an optimization, where the analysis on the past idle period moved
from the end of idle, to the beginning of the new idle.

Unfortunately, this optimization had a bug where it zeroed one key
variable for new use, that is needed for the analysis.  The fix is
simple, zero the variable after doing the work from the previous idle.

During the audit of the code that found this issue, another issue was
also found; the ->measured_us data structure member is never set, a
local variable is always used instead.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpuidle/governors/menu.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -101,7 +101,6 @@ struct menu_device {
 
 	unsigned int	expected_us;
 	u64		predicted_us;
-	unsigned int	measured_us;
 	unsigned int	exit_us;
 	unsigned int	bucket;
 	u64		correction_factor[BUCKETS];
@@ -187,14 +186,14 @@ static int menu_select(struct cpuidle_de
 	int i;
 	int multiplier;
 
-	data->last_state_idx = 0;
-	data->exit_us = 0;
-
 	if (data->needs_update) {
 		menu_update(dev);
 		data->needs_update = 0;
 	}
 
+	data->last_state_idx = 0;
+	data->exit_us = 0;
+
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0))
 		return 0;
@@ -294,7 +293,7 @@ static void menu_update(struct cpuidle_d
 	new_factor = data->correction_factor[data->bucket]
 			* (DECAY - 1) / DECAY;
 
-	if (data->expected_us > 0 && data->measured_us < MAX_INTERESTING)
+	if (data->expected_us > 0 && measured_us < MAX_INTERESTING)
 		new_factor += RESOLUTION * measured_us / data->expected_us;
 	else
 		/*


