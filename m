Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1AJQt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:49:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45831 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1AJQtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:49:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IPcCrFlWJJ8OSxzJMp4Go2oBN2/ptb0a05sFAwnpFEq88mknbp9EayKiIM4VxMs7PU
         J+vEgh8ly2UaLcC6b0TnBPw0xWC7l0D8xoVh1mehJx6xMQQpOJ7GwsDascEbekCQ8aAF
         I2W8px85VUuSEEWYnGyFFAF7fnIhhBgMR/qf4=
Date: Mon, 10 Jan 2011 17:49:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "2.6.35.x stable" <stable@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -stable 2.6.35.x] perf session: Invalidate last_match when
 removing threads from rb_tree
Message-ID: <20110110164918.GB2570@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch was applied few releases ago but lacked a tag
for stable.

Is it possible to backport it for 2.6.35.x?

Thanks.

---

commit 70597f21f128b7dd6a2490078bea99d704b6f8c3
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Mon Aug 2 18:59:28 2010 -0300

perf session: Invalidate last_match when removing threads from rb_tree
    
If we receive two PERF_RECORD_EXIT for the same thread, we can end up
reusing session->last_match and trying to remove the thread twice from
the rb_tree, causing a segfault, so invalidade last_match in
perf_session__remove_thread.
  
Receiving two PERF_RECORD_EXIT for the same thread is a bug, but its a
harmless one if we make the tool more robust, like this patch does.
    
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: 2.6.35.x <stable@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5d2fd52..fa9d652 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -166,6 +166,7 @@ void perf_session__delete(struct perf_session *self)
 
 void perf_session__remove_thread(struct perf_session *self, struct thread *th)
 {
+	self->last_match = NULL;
 	rb_erase(&th->rb_node, &self->threads);
 	/*
 	 * We may have references to this thread, for instance in some hist_entry

