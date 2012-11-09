Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2KIS3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 13:29:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab2KIS3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 13:29:04 -0500
Date: Fri, 9 Nov 2012 19:29:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Amnon Shiloh <u3557@miso.sublimeip.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] arch_check_bp_in_kernelspace: fix the range check
Message-ID: <20121109182943.GA2789@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_check_bp_in_kernelspace() tries to avoid the overflow and does 2
TASK_SIZE checks but it needs OR, not AND. Consider va = TASK_SIZE -1
and len = 2 case.

Note: TASK_SIZE doesn't look right at least on x86, I think it should
be replaced by TASK_SIZE_MAX.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- x/arch/arm64/kernel/hw_breakpoint.c
+++ x/arch/arm64/kernel/hw_breakpoint.c
@@ -293,7 +293,7 @@ int arch_check_bp_in_kernelspace(struct 
 	va = info->address;
 	len = get_hbp_len(info->ctrl.len);
 
-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
 }
 
 /*
--- x/arch/arm/kernel/hw_breakpoint.c
+++ x/arch/arm/kernel/hw_breakpoint.c
@@ -464,7 +464,7 @@ int arch_check_bp_in_kernelspace(struct 
 	va = info->address;
 	len = get_hbp_len(info->ctrl.len);
 
-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
 }
 
 /*
--- x/arch/sh/kernel/hw_breakpoint.c
+++ x/arch/sh/kernel/hw_breakpoint.c
@@ -132,7 +132,7 @@ int arch_check_bp_in_kernelspace(struct 
 	va = info->address;
 	len = get_hbp_len(info->len);
 
-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
 }
 
 int arch_bp_generic_fields(int sh_len, int sh_type,
--- x/arch/x86/kernel/hw_breakpoint.c
+++ x/arch/x86/kernel/hw_breakpoint.c
@@ -200,7 +200,7 @@ int arch_check_bp_in_kernelspace(struct 
 	va = info->address;
 	len = get_hbp_len(info->len);
 
-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
 }
 
 int arch_bp_generic_fields(int x86_len, int x86_type,

