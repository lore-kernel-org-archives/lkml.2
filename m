Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1AFAnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:43:55 -0500
Received: from kroah.org ([198.145.64.141]:35890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab1AFAaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:39 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:05 2011
Message-Id: <20110106002305.845832963@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [095/152] arch/tile: handle CLONE_SETTLS in copy_thread(), not user space
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit bc4cf2bb271b2d557fc510426755da786fc985be upstream.

Previously we were just setting up the "tp" register in the
new task as started by clone() in libc.  However, this is not
quite right, since in principle a signal might be delivered to
the new task before it had its TLS set up.  (Of course, this race
window still exists for resetting the libc getpid() cached value
in the new task, in principle.  But in any case, we are now doing
this exactly the way all other architectures do it.)

This change is important for 2.6.37 since the tile glibc we will
be submitting upstream will not set TLS in user space any more,
so it will only work on a kernel that has this fix.  It should
also be taken for 2.6.36.x in the stable tree if possible.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/tile/kernel/process.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -212,6 +212,13 @@ int copy_thread(unsigned long clone_flag
 	childregs->sp = sp;  /* override with new user stack pointer */
 
 	/*
+	 * If CLONE_SETTLS is set, set "tp" in the new task to "r4",
+	 * which is passed in as arg #5 to sys_clone().
+	 */
+	if (clone_flags & CLONE_SETTLS)
+		childregs->tp = regs->regs[4];
+
+	/*
 	 * Copy the callee-saved registers from the passed pt_regs struct
 	 * into the context-switch callee-saved registers area.
 	 * We have to restore the callee-saved registers since we may


