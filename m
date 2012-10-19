Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab2JSVwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:52:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38737 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972Ab2JSVwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:52:13 -0400
From: Julius Werner <jwerner@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, khilman@ti.com,
        rjw@sisk.pl, deepthi@linux.vnet.ibm.com, akpm@linux-foundation.org,
        g.trinabh@gmail.com, snanda@chromium.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] acpi/cpuidle: reinitialize power_usage values when adding/removing C-states
Date: Fri, 19 Oct 2012 14:50:46 -0700
Message-Id: <1350683446-8244-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <507FBC20.50004@linaro.org>
References: <507FBC20.50004@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cpuidle drivers do not supply explicit power_usage values,
cpuidle/driver.c inserts dummy values instead. When a running processor
dynamically gains new C-states (e.g. after ACPI events), the power_usage
values of those states will stay uninitialized, and cpuidle governors
will never choose to enter them.

This patch ensures that the ACPI cpuidle driver sets those dummy power
values itself whenever it (re-)initializes its idle states.
Tested and verified on an Acer AC700 Chromebook, which supports the C3
state only when it switches from AC to battery power.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/acpi/processor_idle.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index e8086c7..078e22f 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1090,6 +1090,9 @@ static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
 		state->exit_latency = cx->latency;
 		state->target_residency = cx->latency * latency_factor;
 
+		/* reinitialize this in case new states are added after boot */
+		state->power_usage = -1 - count;
+
 		state->flags = 0;
 		switch (cx->type) {
 			case ACPI_STATE_C1:
-- 
1.7.8.6

