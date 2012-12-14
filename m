Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2LNW0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:26:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:38039 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab2LNW0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:26:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>
Subject: [ 02/22] powerpc/ptrace: Fix build with gcc 4.6
Date: Fri, 14 Dec 2012 14:25:47 -0800
Message-Id: <20121214222250.332470446@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit e69b742a6793dc5bf16f6eedca534d4bc10d68b2 upstream.

gcc (rightfully) complains that we are accessing beyond the
end of the fpr array (we do, to access the fpscr).

The only sane thing to do (whether anything in that code can be
called remotely sane is debatable) is to special case fpscr and
handle it as a separate statement.

I initially tried to do it it by making the array access conditional
to index < PT_FPSCR and using a 3rd else leg but for some reason gcc
was unable to understand it and still spewed the warning.

So I ended up with something a tad more intricated but it seems to
build on 32-bit and on 64-bit with and without VSX.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/ptrace.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1497,9 +1497,14 @@ long arch_ptrace(struct task_struct *chi
 		if (index < PT_FPR0) {
 			tmp = ptrace_get_reg(child, (int) index);
 		} else {
+			unsigned int fpidx = index - PT_FPR0;
+
 			flush_fp_to_thread(child);
-			tmp = ((unsigned long *)child->thread.fpr)
-				[TS_FPRWIDTH * (index - PT_FPR0)];
+			if (fpidx < (PT_FPSCR - PT_FPR0))
+				tmp = ((unsigned long *)child->thread.fpr)
+					[fpidx * TS_FPRWIDTH];
+			else
+				tmp = child->thread.fpscr.val;
 		}
 		ret = put_user(tmp, datalp);
 		break;
@@ -1525,9 +1530,14 @@ long arch_ptrace(struct task_struct *chi
 		if (index < PT_FPR0) {
 			ret = ptrace_put_reg(child, index, data);
 		} else {
+			unsigned int fpidx = index - PT_FPR0;
+
 			flush_fp_to_thread(child);
-			((unsigned long *)child->thread.fpr)
-				[TS_FPRWIDTH * (index - PT_FPR0)] = data;
+			if (fpidx < (PT_FPSCR - PT_FPR0))
+				((unsigned long *)child->thread.fpr)
+					[fpidx * TS_FPRWIDTH] = data;
+			else
+				child->thread.fpscr.val = data;
 			ret = 0;
 		}
 		break;


