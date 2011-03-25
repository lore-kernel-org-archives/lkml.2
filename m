Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab1CZAS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:18:26 -0400
Received: from kroah.org ([198.145.64.141]:41780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab1CYXwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:11 2011
Message-Id: <20110325234511.722825151@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [37/63] sh: Fix ptrace fpu state initialisation
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Phil Edworthy <Phil.Edworthy@renesas.com>

commit c49b6ecf0870e78fa40497cd8b142915c1d5c7c9 upstream.

Commit 0ea820cf introduced the PTRACE_GETFPREGS/SETFPREGS cmds,
but gdb-server still accesses the FPU state using the
PTRACE_PEEKUSR/POKEUSR commands. In this case, xstate was not
initialised.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sh/kernel/ptrace_32.c |    6 ++++++
 arch/sh/kernel/ptrace_64.c |    6 ++++++
 2 files changed, 12 insertions(+)

--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -392,6 +392,9 @@ long arch_ptrace(struct task_struct *chi
 					tmp = 0;
 			} else {
 				unsigned long index;
+				ret = init_fpu(child);
+				if (ret)
+					break;
 				index = addr - offsetof(struct user, fpu);
 				tmp = ((unsigned long *)child->thread.xstate)
 					[index >> 2];
@@ -423,6 +426,9 @@ long arch_ptrace(struct task_struct *chi
 		else if (addr >= offsetof(struct user, fpu) &&
 			 addr < offsetof(struct user, u_fpvalid)) {
 			unsigned long index;
+			ret = init_fpu(child);
+			if (ret)
+				break;
 			index = addr - offsetof(struct user, fpu);
 			set_stopped_child_used_math(child);
 			((unsigned long *)child->thread.xstate)
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -403,6 +403,9 @@ long arch_ptrace(struct task_struct *chi
 		else if ((addr >= offsetof(struct user, fpu)) &&
 			 (addr <  offsetof(struct user, u_fpvalid))) {
 			unsigned long index;
+			ret = init_fpu(child);
+			if (ret)
+				break;
 			index = addr - offsetof(struct user, fpu);
 			tmp = get_fpu_long(child, index);
 		} else if (addr == offsetof(struct user, u_fpvalid)) {
@@ -442,6 +445,9 @@ long arch_ptrace(struct task_struct *chi
 		else if ((addr >= offsetof(struct user, fpu)) &&
 			 (addr <  offsetof(struct user, u_fpvalid))) {
 			unsigned long index;
+			ret = init_fpu(child);
+			if (ret)
+				break;
 			index = addr - offsetof(struct user, fpu);
 			ret = put_fpu_long(child, index, data);
 		}


