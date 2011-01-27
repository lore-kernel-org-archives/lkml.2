Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1A0S3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:29:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:49039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1A0S27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:28:59 -0500
Date: Thu, 27 Jan 2011 18:28:32 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, gorcunov@openvz.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4d3efb2f.1252d80a.1a80.ffffc83f@mx.google.com>
References: <4d3efb2f.1252d80a.1a80.ffffc83f@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix Pentium4 raw event validation
Message-ID: <tip-d038b12c6d773a4b9f69ca5243773bf6314f7ee9@git.kernel.org>
Git-Commit-ID: d038b12c6d773a4b9f69ca5243773bf6314f7ee9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 Jan 2011 18:28:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d038b12c6d773a4b9f69ca5243773bf6314f7ee9
Gitweb:     http://git.kernel.org/tip/d038b12c6d773a4b9f69ca5243773bf6314f7ee9
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 25 Jan 2011 17:32:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 27 Jan 2011 19:21:53 +0100

perf: Fix Pentium4 raw event validation

This patch fixes some issues with raw event validation on
Pentium 4 (Netburst) based processors.

As I was testing libpfm4 Netburst support, I ran into two
problems in the p4_validate_raw_event() function:

   - the shared field must be checked ONLY when HT is on
   - the binding to ESCR register was missing

The second item was causing raw events to not be encoded
correctly compared to generic PMU events.

With this patch, I can now pass Netburst events to libpfm4
examples and get meaningful results:

  $ task -e global_power_events:running:u  noploop 1
  noploop for 1 seconds
  3,206,304,898 global_power_events:running

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: peterz@infradead.org
Cc: paulus@samba.org
Cc: davem@davemloft.net
Cc: fweisbec@gmail.com
Cc: perfmon2-devel@lists.sf.net
Cc: eranian@gmail.com
Cc: robert.richter@amd.com
Cc: acme@redhat.com
Cc: gorcunov@gmail.com
Cc: ming.m.lin@intel.com
LKML-Reference: <4d3efb2f.1252d80a.1a80.ffffc83f@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index e56b9bf..f7a0993 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -682,7 +682,7 @@ static int p4_validate_raw_event(struct perf_event *event)
 	 * if an event is shared accross the logical threads
 	 * the user needs special permissions to be able to use it
 	 */
-	if (p4_event_bind_map[v].shared) {
+	if (p4_ht_active() && p4_event_bind_map[v].shared) {
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return -EACCES;
 	}
@@ -727,7 +727,8 @@ static int p4_hw_config(struct perf_event *event)
 		event->hw.config = p4_set_ht_bit(event->hw.config);
 
 	if (event->attr.type == PERF_TYPE_RAW) {
-
+		struct p4_event_bind *bind;
+		unsigned int esel;
 		/*
 		 * Clear bits we reserve to be managed by kernel itself
 		 * and never allowed from a user space
@@ -743,6 +744,13 @@ static int p4_hw_config(struct perf_event *event)
 		 * bits since we keep additional info here (for cache events and etc)
 		 */
 		event->hw.config |= event->attr.config;
+		bind = p4_config_get_bind(event->attr.config);
+		if (!bind) {
+			rc = -EINVAL;
+			goto out;
+		}
+		esel = P4_OPCODE_ESEL(bind->opcode);
+		event->hw.config |= p4_config_pack_cccr(P4_CCCR_ESEL(esel));
 	}
 
 	rc = x86_setup_perfctr(event);
