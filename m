Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0ETTme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:42:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46649 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0ETTmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=HDrNwkB3u97g4usqFaTjTUcpgyW2Y3wftMsA/s+XFLH2TNE1pQNxgSW+U8+HyNEjOU
         /vR/vZvGDnIJaE0nBtoWFp9zeMMPWLvAMOdwFvYq3hd+vJz2R7u7Z0g7I7/vrBZlwl58
         YwnqNdSJGUKnbkB6LbRQX2WZ4kGQ9Ep+JCnC0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [GIT PULL] perf fix (preempt count imbalance on buffer)
Date: Thu, 20 May 2010 21:42:38 +0200
Message-Id: <1274384558-19680-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      perf: Fix forgotten preempt_enable by nested writers


 kernel/perf_event.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

---
commit acd35a463cb2a8d2b28e094d718cf6e653ad7191
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu May 20 21:28:34 2010 +0200

    perf: Fix forgotten preempt_enable by nested writers
    
    A writer that gets a reference to the buffer handle disables
    preemption. When we put that reference, we check if we are
    the outer most writer and if not, we simply return and defer
    the head update to the outer most writer. The problem here
    is that preemption is only reenabled by the outer most, that
    produces preemption count imbalance for every nested writer
    that exit.
    
    So just don't forget to always re-enable preemption when we
    put the buffer reference, whoever we are.
    
    Fixes lots of sleeping in atomic warnings, visible with lock
    events recording.
    
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Stephane Eranian <eranian@google.com>
    Cc: Robert Richter <robert.richter@amd.com>

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2a060be..45b7aec 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2933,7 +2933,7 @@ again:
 	 */
 
 	if (!local_dec_and_test(&data->nest))
-		return;
+		goto out;
 
 	/*
 	 * Publish the known good head. Rely on the full barrier implied
@@ -2954,6 +2954,7 @@ again:
 	if (handle->wakeup != local_read(&data->wakeup))
 		perf_output_wakeup(handle);
 
+ out:
 	preempt_enable();
 }
 
