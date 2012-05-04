Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab2EDVQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:16:34 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab2EDUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:45:15 -0400
Message-Id: <20120504204226.622923241@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kratochvil <jan.kratochvil@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 26/75] i387: ptrace breaks the lazy-fpu-restore logic
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 089f9fba56faf33cc6dd2a6442b7ac92c58b8209 upstream.

Starting from 7e16838d "i387: support lazy restore of FPU state"
we assume that fpu_owner_task doesn't need restore_fpu_checking()
on the context switch, its FPU state should match what we already
have in the FPU on this CPU.

However, debugger can change the tracee's FPU state, in this case
we should reset fpu.last_cpu to ensure fpu_lazy_restore() can't
return true.

Change init_fpu() to do this, it is called by user_regset->set()
methods.

Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20120416204815.GB24884@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/i387.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -154,6 +154,7 @@ int init_fpu(struct task_struct *tsk)
 	if (tsk_used_math(tsk)) {
 		if (HAVE_HWFP && tsk == current)
 			unlazy_fpu(tsk);
+		tsk->thread.fpu.last_cpu = ~0;
 		return 0;
 	}
 


