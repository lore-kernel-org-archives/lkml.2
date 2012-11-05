Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2KETFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:05:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:36001 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab2KETFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:05:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,716,1344236400"; 
   d="scan'208";a="237514388"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v3 5/8] x86/ftrace: Use __pa_symbol instead of __pa on C
	visible symbols
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Date: Mon, 05 Nov 2012 11:05:53 -0800
Message-ID: <20121105190547.10205.29226.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com>
References: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
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

