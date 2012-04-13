Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762348Ab2DMApR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:45:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab2DMApP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:45:15 -0400
Date: Fri, 13 Apr 2012 02:44:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pidns: reboot_pid_ns: use SEND_SIG_FORCED instead of
	force_sig()
Message-ID: <20120413004446.GA8376@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cf3f8921 "pidns: add reboot_pid_ns() to handle the reboot syscall"
uses force_sig() to kill the SIGNAL_UNKILLABLE cinit, this was the
only choice.

After 629d362b we can use SEND_SIG_FORCED instead, force_sig() has
the special semantics and should be avoided if possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 57bc1fd..ef35e20 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -241,7 +241,7 @@ int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
 	}
 
 	read_lock(&tasklist_lock);
-	force_sig(SIGKILL, pid_ns->child_reaper);
+	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, pid_ns->child_reaper, true);
 	read_unlock(&tasklist_lock);
 
 	do_exit(0);

