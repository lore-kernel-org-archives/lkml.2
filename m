Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2L1TQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:16:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54832 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062Ab2L1TQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:40 -0500
Message-Id: <20121228190330.511716895@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>
Subject: [ 002/173] freezer: PF_FREEZER_NOSIG should be  cleared along with PF_NOFREEZE
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

This patch is only for pre-v3.3 stable trees which backported
b40a7959 "freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD".
v3.3+ doesn't need this fix.

b40a7959 is the trivial bugfix, but unfortunately I forgot that
until 34b087e4 "freezer: kill unused set_freezable_with_signal()"
there were another only-for-kernel-threads flag, PF_FREEZER_NOSIG,
which should be cleared as well.

See https://bugs.launchpad.net/ubuntu/+source/v86d/+bug/1080530
The freezer fails because it expects that a PF_FREEZER_NOSIG task
doesn't need a signal. Before b40a7959 it wrongly succeeds leaving
the PF_NOFREEZE | PF_FREEZER_NOSIG task unfrozen.

Reported-and-tested-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
[bwh: Don't touch PF_FORKNOEXEC; it's cleared elsewhere]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1095,7 +1095,8 @@ int flush_old_exec(struct linux_binprm *
 	bprm->mm = NULL;		/* We're using it now */
 
 	set_fs(USER_DS);
-	current->flags &= ~(PF_RANDOMIZE | PF_KTHREAD | PF_NOFREEZE);
+	current->flags &=
+		~(PF_RANDOMIZE | PF_KTHREAD | PF_NOFREEZE | PF_FREEZER_NOSIG);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 


