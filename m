Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2KPV6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:58:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:27112 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab2KPV6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:58:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="248440942"
Subject: [PATCH v4 6/8] x86/ftrace: Use __pa_symbol instead of __pa on C
 visible symbols
To: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 16 Nov 2012 13:57:32 -0800
Message-ID: <20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com>
In-Reply-To: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using __pa which is meant to be a general function for converting
virtual addresses to physical addresses we can use __pa_symbol which is the
preferred way of decoding kernel text virtual addresses to physical addresses.

In this case we are not directly converting C visible symbols however if we
know that the instruction pointer is somewhere between _text and _etext we
know that we are going to be translating an address form the kernel text
space.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 arch/x86/kernel/ftrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1d41402..42a392a 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -89,7 +89,7 @@ do_ftrace_mod_code(unsigned long ip, const void *new_code)
 	 * kernel identity mapping to modify code.
 	 */
 	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
-		ip = (unsigned long)__va(__pa(ip));
+		ip = (unsigned long)__va(__pa_symbol(ip));
 
 	return probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE);
 }
@@ -279,7 +279,7 @@ static int ftrace_write(unsigned long ip, const char *val, int size)
 	 * kernel identity mapping to modify code.
 	 */
 	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
-		ip = (unsigned long)__va(__pa(ip));
+		ip = (unsigned long)__va(__pa_symbol(ip));
 
 	return probe_kernel_write((void *)ip, val, size);
 }

