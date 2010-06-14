Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab0FNWVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:21:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55901 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab0FNWVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jQ/2lKX2rufKeZaU5P1cdMj3eNykLCS+XoGJlrTzC2AdrbujZB2g96/3EQdJ9LMjHn
         57ZkAVW/ckXln04zxlpSmiCQnqmuJS5vAHUMfsKkB4/ALfLtnER9C9dZT2s8oj2iSbHx
         +4Du+U/URvIDJnrH3L9vxJ5g1XR+Azr3ecMEw=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/6] perf: Fix errors path in perf_output_begin()
Date: Tue, 15 Jun 2010 00:21:24 +0200
Message-Id: <1276554087-3632-4-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
References: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

In case the sampling buffer has no "payload" pages,
nr_pages is 0. The problem is that the error path in
perf_output_begin() skips to a label which assumes
perf_output_lock() has been issued which is not the
case. That triggers a WARN_ON() in
perf_output_unlock().

This patch fixes the problem by skipping
perf_output_unlock() in case data->nr_pages is 0.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4bf13674.014fd80a.6c82.ffffb20c@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Upstream-commit: 00d1d0b095ba4e5c0958cb228b2a9c445d4a339d
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 43c1dfb..e353be2 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2933,7 +2933,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 	handle->sample	= sample;
 
 	if (!data->nr_pages)
-		goto fail;
+		goto out;
 
 	have_lost = atomic_read(&data->lost);
 	if (have_lost)
-- 
1.6.6.1

