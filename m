Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2GTBLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:11:14 -0400
Received: from mail-we0-f202.google.com ([74.125.82.202]:62025 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2GTBLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:11:08 -0400
From: Todd Poynor <toddpoynor@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, <arve@android.com>,
        Todd Poynor <toddpoynor@google.com>
Subject: [PATCH v2] PM / Sleep: Print name of wakeup source that aborts suspend
Date: Thu, 19 Jul 2012 18:10:58 -0700
Message-Id: <1342746658-17388-1-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Todd Poynor <toddpoynor@google.com>
---
 drivers/base/power/wakeup.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

A driver or app may repeatedly request a wakeup source while the system
is attempting to enter suspend, which may indicate a bug or at least
point out a highly active system component that is responsible for
decreased battery life on a mobile device.  Even when the incidence
of suspend abort is not severe, identifying wakeup sources that
frequently abort suspend can be a useful clue for power management
analysis.

In some cases the existing stats can point out the offender where there is
an unexpectedly high activation count that stands out from the others, but
in other cases the wakeup source frequently taken just after the rest of
the system thinks its time to suspend might not stand out in the overall
stats.

It is also often useful to have information about what's been happening
recently, rather than totals of all activity for the system boot.

It's suggested to dump a line about which wakeup source
aborted suspend to aid analysis of these situations.
 
v2
use ktime_to_ns() instead of comparisons on .tv64 field

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index cbb463b..8a0a9ca 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -649,6 +649,31 @@ void pm_wakeup_event(struct device *dev, unsigned int msec)
 }
 EXPORT_SYMBOL_GPL(pm_wakeup_event);
 
+static void print_active_wakeup_sources(void)
+{
+	struct wakeup_source *ws;
+	int active = 0;
+	struct wakeup_source *last_activity_ws = NULL;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ws, &wakeup_sources, entry) {
+		if (ws->active) {
+			pr_info("active wakeup source: %s\n", ws->name);
+			active = 1;
+		} else if (!active &&
+			   (!last_activity_ws ||
+			    ktime_to_ns(ws->last_time) >
+			    ktime_to_ns(last_activity_ws->last_time))) {
+			last_activity_ws = ws;
+		}
+	}
+
+	if (!active && last_activity_ws)
+		pr_info("last active wakeup source: %s\n",
+			last_activity_ws->name);
+	rcu_read_unlock();
+}
+
 /**
  * pm_wakeup_pending - Check if power transition in progress should be aborted.
  *
@@ -671,6 +696,10 @@ bool pm_wakeup_pending(void)
 		events_check_enabled = !ret;
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
+
+	if (ret)
+		print_active_wakeup_sources();
+
 	return ret;
 }
 
-- 
1.7.7.3

