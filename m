Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030361Ab2GKWFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:05:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:35522 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030319Ab2GKWFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:05:22 -0400
Message-Id: <20120711215612.161878327@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 11 Jul 2012 22:05:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        RT-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <cbe@osadl.org>, Mike Galbraith <mgalbraith@suse.de>,
        Theodore Tso <tytso@mit.edu>
Subject: [patch RT 6/7] fs, jbd: pull your plug when waiting for space
References: <20120711214552.036760674@linutronix.de>
Content-Disposition: inline; filename=fs-jbd-pull-plug-when-waiting.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With an -rt kernel, and a heavy sync IO load, tasks can jam
up on journal locks without unplugging, which can lead to
terminal IO starvation.  Unplug and schedule when waiting for space.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Theodore Tso <tytso@mit.edu>
Link: http://lkml.kernel.org/r/1341812414.7370.73.camel@marge.simpson.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/jbd/checkpoint.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-stable-rt/fs/jbd/checkpoint.c
===================================================================
--- linux-stable-rt.orig/fs/jbd/checkpoint.c
+++ linux-stable-rt/fs/jbd/checkpoint.c
@@ -129,6 +129,8 @@ void __log_wait_for_space(journal_t *jou
 		if (journal->j_flags & JFS_ABORT)
 			return;
 		spin_unlock(&journal->j_state_lock);
+		if (current->plug)
+			io_schedule();
 		mutex_lock(&journal->j_checkpoint_mutex);
 
 		/*


