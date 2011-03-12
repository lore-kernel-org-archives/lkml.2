Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1CLLuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 06:50:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46591 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab1CLLuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 06:50:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jBjb9lhCxirvvWKN9ZrnYnCm4mQNtCvmxgrpFSm4QtuS0i8iOI/Rn1QePX+OO9Qr5u
         /nTnv7YL8wkafYb8wAzXEPquFMzdtj1VSmvV2qpXBI3UAaen30D24i1GQbluAHDQXsu3
         ZsdRpBz8Vsp8FrkZyhLBSbQJjd6zvPkkaMmSc=
Date: Sat, 12 Mar 2011 12:50:46 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH tip:x86/mm 2/3] x86: Use this_cpu_has for thermal_interrupt
 current cpu
Message-ID: <20110312115046.GD2005@htj.dyndns.org>
References: <20110312115010.GC2005@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312115010.GC2005@htj.dyndns.org>
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
@@ -355,7 +355,6 @@ static void notify_thresholds(__u64 msr_
 static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 
@@ -367,19 +366,19 @@ static void intel_thermal_interrupt(void
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
