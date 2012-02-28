Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab2B1BGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:06:48 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49705 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab2B1BGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.4 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010205.059228398@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 06/73] powerpc/perf: power_pmu_start restores incorrect values, breaking frequency events
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 9a45a9407c69d068500923480884661e2b9cc421 upstream.

perf on POWER stopped working after commit e050e3f0a71b (perf: Fix
broken interrupt rate throttling). That patch exposed a bug in
the POWER perf_events code.

Since the PMCs count upwards and take an exception when the top bit
is set, we want to write 0x80000000 - left in power_pmu_start. We were
instead programming in left which effectively disables the counter
until we eventually hit 0x80000000. This could take seconds or longer.

With the patch applied I get the expected number of samples:

          SAMPLE events:       9948

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/perf_event.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -865,6 +865,7 @@ static void power_pmu_start(struct perf_
 {
 	unsigned long flags;
 	s64 left;
+	unsigned long val;
 
 	if (!event->hw.idx || !event->hw.sample_period)
 		return;
@@ -880,7 +881,12 @@ static void power_pmu_start(struct perf_
 
 	event->hw.state = 0;
 	left = local64_read(&event->hw.period_left);
-	write_pmc(event->hw.idx, left);
+
+	val = 0;
+	if (left < 0x80000000L)
+		val = 0x80000000L - left;
+
+	write_pmc(event->hw.idx, val);
 
 	perf_event_update_userpage(event);
 	perf_pmu_enable(event->pmu);


