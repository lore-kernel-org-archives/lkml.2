Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0GAPhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:37:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab0GAPgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=V46rBOk7zOXbBRoGZsjvOroRzIRpFyfp5HZASVc70ZrGGGO1IgaU/B8jI2pMHfSqEp
         Uxe6l6yqJBVDjKisXbM+kYbZU1uGVIDov9ioVFxPwe/diMLf8qZcm2grg7owQpqW6FJL
         cx9Ls0MiWEZp4fQ78RDLeSdiGrzBHnrTZ650s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Will Deacon <will.deacon@arm.com>, David Miller <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Borislav Petkov <bp@amd64.org>
Subject: [RFC PATCH 6/6] perf: Fix double put_ctx
Date: Thu,  1 Jul 2010 17:36:02 +0200
Message-Id: <1277998562-21366-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com>
References: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we call free_event on fail case of event creation, it
already put the context. The falldown goto, though, also
does a put_ctx, which might dereference a freed context.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: David Miller <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Borislav Petkov <bp@amd64.org>
---
 kernel/perf_event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b6e854f..925b53e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5364,6 +5364,8 @@ SYSCALL_DEFINE5(perf_event_open,
 
 err_free_put_context:
 	free_event(event);
+	fput_light(group_file, fput_needed);
+	goto err_fd;
 err_put_context:
 	fput_light(group_file, fput_needed);
 	put_ctx(ctx);
-- 
1.6.2.3

