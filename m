Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2GQPd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:33:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14865 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2GQPct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:32:49 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=jPHEB6S5TygA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=4M0vJZQeAAAA:8 a=aJbRli_dN-S8RPQDehkA:9 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120717153243.850568822@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Jul 2012 11:31:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <mgalbraith@suse.de>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH RT 06/12] fs, jbd: pull your plug when waiting for space
References: <20120717153115.606116459@goodmis.org>
Content-Disposition: inline; filename=0006-fs-jbd-pull-your-plug-when-waiting-for-space.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <mgalbraith@suse.de>

With an -rt kernel, and a heavy sync IO load, tasks can jam
up on journal locks without unplugging, which can lead to
terminal IO starvation.  Unplug and schedule when waiting for space.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Theodore Tso <tytso@mit.edu>
Link: http://lkml.kernel.org/r/1341812414.7370.73.camel@marge.simpson.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/jbd/checkpoint.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 05f0754..d8efcbc 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -129,6 +129,8 @@ void __log_wait_for_space(journal_t *journal)
 		if (journal->j_flags & JFS_ABORT)
 			return;
 		spin_unlock(&journal->j_state_lock);
+		if (current->plug)
+			io_schedule();
 		mutex_lock(&journal->j_checkpoint_mutex);
 
 		/*
-- 
1.7.10.4


