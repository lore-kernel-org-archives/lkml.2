Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2FSPxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:53:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab2FSPtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:49:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Roland McGrath <roland@hack.frob.com>
Subject: [RFC 09/23] x86_64: Store userspace rsp in system_call fastpath
Date: Tue, 19 Jun 2012 17:48:00 +0200
Message-Id: <1340120894-9465-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I'd need help with this change.. basically it works, but I guess
I could alter the FIXUP_TOP_OF_STACK macro as well, so the rsp is
not initialized twice in slowpath.

But it seems quite complex.. so not really sure at the moment ;)

ideas?

thanks,
jirka

---
Storing the userspace rsp into the pt_regs struct for the
system_call fastpath (syscall instruction handler).

Following part of the pt_regs is allocated on stack:
(via KERNEL_STACK_OFFSET)

    unsigned long ip;
    unsigned long cs;
    unsigned long flags;
    unsigned long sp;
    unsigned long ss;

but only ip is actually saved for fastpath.

For perf post unwind we need at least ip and sp to be able to
start the unwind, so storing the old_rsp value to the sp.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Roland McGrath <roland@hack.frob.com>
---
 arch/x86/kernel/entry_64.S |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 111f6bb..0444917 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -516,6 +516,11 @@ GLOBAL(system_call_after_swapgs)
 	SAVE_ARGS 8,0
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
+#ifdef CONFIG_PERF_EVENTS
+	/* We need rsp in fast path for perf post unwind. */
+	movq  PER_CPU_VAR(old_rsp), %rcx
+	movq  %rcx,RSP-ARGOFFSET(%rsp)
+#endif
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
-- 
1.7.7.6

