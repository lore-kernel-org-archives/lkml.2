Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1CHUQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:53581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab1CHUQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:45 -0500
Date: Tue, 8 Mar 2011 20:16:15 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, jolsa@redhat.com,
        mingo@elte.hu
In-Reply-To: <1298298313-5980-3-git-send-email-jolsa@redhat.com>
References: <1298298313-5980-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Disabling optimized kprobes for entry text section
Message-ID: <tip-2a8247a2600c3e087a568fc68a6ec4eedac27ef1@git.kernel.org>
Git-Commit-ID: 2a8247a2600c3e087a568fc68a6ec4eedac27ef1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Mar 2011 20:16:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a8247a2600c3e087a568fc68a6ec4eedac27ef1
Gitweb:     http://git.kernel.org/tip/2a8247a2600c3e087a568fc68a6ec4eedac27ef1
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 21 Feb 2011 15:25:13 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Mar 2011 17:22:12 +0100

kprobes: Disabling optimized kprobes for entry text section

You can crash the kernel (with root/admin privileges) using kprobe tracer by running:

 echo "p system_call_after_swapgs" > ./kprobe_events
 echo 1 > ./events/kprobes/enable

The reason is that at the system_call_after_swapgs label, the
kernel stack is not set up. If optimized kprobes are enabled,
the user space stack is being used in this case (see optimized
kprobe template) and this might result in a crash.

There are several places like this over the entry code
(entry_$BIT). As it seems there's no any reasonable/maintainable
way to disable only those places where the stack is not ready, I
switched off the whole entry code from kprobe optimizing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com
Cc: fweisbec@gmail.com
Cc: ananth@in.ibm.com
Cc: davem@davemloft.net
Cc: a.p.zijlstra@chello.nl
Cc: eric.dumazet@gmail.com
Cc: 2nddept-manager@sdl.hitachi.co.jp
LKML-Reference: <1298298313-5980-3-git-send-email-jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index d91c477..c969fd9 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1276,6 +1276,14 @@ static int __kprobes can_optimize(unsigned long paddr)
 	if (!kallsyms_lookup_size_offset(paddr, &size, &offset))
 		return 0;
 
+	/*
+	 * Do not optimize in the entry code due to the unstable
+	 * stack handling.
+	 */
+	if ((paddr >= (unsigned long )__entry_text_start) &&
+	    (paddr <  (unsigned long )__entry_text_end))
+		return 0;
+
 	/* Check there is enough space for a relative jump. */
 	if (size - offset < RELATIVEJUMP_SIZE)
 		return 0;
