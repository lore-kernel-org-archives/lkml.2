Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1AYQcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:32:53 -0500
Received: from smtp-out.google.com ([74.125.121.67]:36306 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1AYQcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:32:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=BQ+JiJhZTwqKbWN9nW5S78uABWLJa/aq7Y81V50bUVV4UROWzlOMiwf9YnSiI2okZl
         GLXBnORfc8UdqhfF0nHg==
Message-ID: <4d3efb2f.1252d80a.1a80.ffffc83f@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 25 Jan 2011 17:32:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        gorcunov@gmail.com, ming.m.lin@intel.com
Subject: [PATCH] perf_events: fix Pentium4 raw event validation
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes some issies with raw event validation on Pentium 4 (Netburst)
processors.

As I was testing libpfm4 Netburst support, I ran into two problems in the
p4_validate_raw_event() function:
   - the shared field must be checked ONLY when HT is on
   - the binding to ESCR register was missing

The second item was causing raw events to not be encoded correctly compared
to generic PMU events.

With this patch, I can now pass Netburst events to libpfm4 examples and
get meaningful results:
  $ task -e global_power_events:running:u  noploop 1
  noploop for 1 seconds
  3,206,304,898 global_power_events:running

Signed-off-by: Stephane Eranian <eranian@google.com>
---

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
