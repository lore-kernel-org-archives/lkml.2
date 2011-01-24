Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab1AXRYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:24:34 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52394 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab1AXRYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:24:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F1vL9Lczk2qh82T1BlMdSNRFNSl7HNj2FfhXfAqQ8AGK/sq6ZkB/zzwKtNOguGWW5W
         8fQl6Ezu+49bjRZFSsbGjQcc8P/rqrELRjGFAJFajqFqkFEFVM4Mis3ic5Dl054SpeG5
         Ap1OQF7g+kngXEe8yr8xxye2OjKN6mMz1HpIs=
Date: Mon, 24 Jan 2011 18:24:28 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: cl@linux.com, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org
Subject: [PATCH 2/3] x86: Use this_cpu_has for thermal_interrupt current cpu
Message-ID: <20110124172428.GJ27510@htj.dyndns.org>
References: <20110124172357.GI27510@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124172357.GI27510@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

It is more effective to use a segment prefix instead of calculating the
address of the current cpu area amd then testing flags.

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: work/arch/x86/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- work.orig/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ work/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -354,7 +354,6 @@ static void notify_thresholds(__u64 msr_
 static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 
@@ -366,19 +365,19 @@ static void intel_thermal_interrupt(void
 				CORE_LEVEL) != 0)
 		mce_log_therm_throt_event(CORE_THROTTLED | msr_val);
 
-	if (cpu_has(c, X86_FEATURE_PLN))
+	if (this_cpu_has(X86_FEATURE_PLN))
 		if (therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
 					CORE_LEVEL) != 0)
 			mce_log_therm_throt_event(CORE_POWER_LIMIT | msr_val);
 
-	if (cpu_has(c, X86_FEATURE_PTS)) {
+	if (this_cpu_has(X86_FEATURE_PTS)) {
 		rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
 		if (therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
 					THERMAL_THROTTLING_EVENT,
 					PACKAGE_LEVEL) != 0)
 			mce_log_therm_throt_event(PACKAGE_THROTTLED | msr_val);
-		if (cpu_has(c, X86_FEATURE_PLN))
+		if (this_cpu_has(X86_FEATURE_PLN))
 			if (therm_throt_process(msr_val &
 					PACKAGE_THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
