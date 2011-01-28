Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1A1QWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:22:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64539 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1A1QWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:22:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bNib3kta53kYPevKLAsUcaxBdaWKFe/RlflWI7Eoqa+ET1bOiN7uUfObbpbA/ybbcv
         69go3Z+qnm8RbN/bshyA4UqpikGPLCFb2aZOSJUyOVMbt9mdw9EW/Oicoj6K9V8G0gra
         DgJSuJs6S6Kg4W0gSbTdG4ikMFBbeTgUqrC3A=
Date: Fri, 28 Jan 2011 17:22:48 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com, rientjes@google.com
Subject: [PATCH] x86: fix build failure on X86_UP_APIC
Message-ID: <20110128162248.GA25746@htj.dyndns.org>
References: <1295789862-25482-1-git-send-email-tj@kernel.org>
 <20110128134549.GK24925@htj.dyndns.org>
 <20110128152919.GA8361@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128152919.GA8361@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4c321ff8 (x86: Replace cpu_2_logical_apicid[] with early percpu
variable) and following changes introduced and used
x86_cpu_to_logical_apicid percpu variable.  It was declared and
defined inside CONFIG_SMP && CONFIG_X86_32 but if CONFIG_X86_UP_APIC
is set UP configuration makes use of it and build fails.

Fix it by declaring and defining it inside CONFIG_X86_LOCAL_APIC &&
CONFIG_X86_32.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
Oops, forgot about UP apic.  This should fix the problem.  Thank you.

 arch/x86/include/asm/smp.h  |    2 +-
 arch/x86/kernel/apic/apic.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

Index: work/arch/x86/include/asm/smp.h
===================================================================
--- work.orig/arch/x86/include/asm/smp.h
+++ work/arch/x86/include/asm/smp.h
@@ -38,7 +38,7 @@ static inline struct cpumask *cpu_core_m
 
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_32)
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
 #endif
 
Index: work/arch/x86/kernel/apic/apic.c
===================================================================
--- work.orig/arch/x86/kernel/apic/apic.c
+++ work/arch/x86/kernel/apic/apic.c
@@ -79,7 +79,6 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu
 
 #ifdef CONFIG_X86_32
 
-#ifdef CONFIG_SMP
 /*
  * On x86_32, the mapping between cpu and logical apicid may vary
  * depending on apic in use.  The following early percpu variable is
@@ -87,7 +86,6 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu
  * actually diverge.  Let's keep it ugly for now.
  */
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid, BAD_APICID);
-#endif
 
 /*
  * Knob to control our willingness to enable the local APIC.
