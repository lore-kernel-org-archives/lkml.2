Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2DXUIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:08:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34527 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757416Ab2DXUIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:08:18 -0400
Date: Wed, 25 Apr 2012 00:08:13 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        MEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH -mm] c/r: prctl: Return -EFAULT instead of -EINVAL in case if
 underlied VMA is not found
Message-ID: <20120424200813.GK21224@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if underlied VMA is not found prctl_set_mm will return -EINVAL,
but Michael proposed to return -EFAULT and Kosaki seconded.
Make it so.

Reported-by: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
Cc: Tejun Heo <tj@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/sys.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1838,8 +1838,10 @@ static int prctl_set_mm(int opt, unsigne
 	case PR_SET_MM_ARG_END:
 	case PR_SET_MM_ENV_START:
 	case PR_SET_MM_ENV_END:
-		if (!vma)
+		if (!vma) {
+			error = -EFAULT;
 			goto out;
+		}
 #ifdef CONFIG_STACK_GROWSUP
 		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSUP, 0))
 #else
