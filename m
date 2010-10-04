Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab0JDUgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:36:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:38429 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932574Ab0JDUf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:35:58 -0400
Date: Mon, 4 Oct 2010 20:35:31 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4ca9a5d1.e8e9d80a.3dbb.ffff8f2e@mx.google.com>
References: <4ca9a5d1.e8e9d80a.3dbb.ffff8f2e@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix invalid pointer when pid is invalid
Message-ID: <tip-540804b5c52065a87d826f7714b18a3ec0b269f9@git.kernel.org>
Git-Commit-ID: 540804b5c52065a87d826f7714b18a3ec0b269f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:35:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  540804b5c52065a87d826f7714b18a3ec0b269f9
Gitweb:     http://git.kernel.org/tip/540804b5c52065a87d826f7714b18a3ec0b269f9
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 4 Oct 2010 12:00:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 4 Oct 2010 12:47:20 +0200

perf_events: Fix invalid pointer when pid is invalid

This patch fixes an error in perf_event_open() when the pid
provided by the user is invalid. find_lively_task_by_vpid()
does not return NULL on error but an error code. Without the
fix the error code was silently passed to find_get_context()
which would eventually cause a invalid pointer dereference.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: paulus@samba.org
Cc: davem@davemloft.net
Cc: fweisbec@gmail.com
Cc: perfmon2-devel@lists.sf.net
Cc: eranian@gmail.com
Cc: robert.richter@amd.com
LKML-Reference: <4ca9a5d1.e8e9d80a.3dbb.ffff8f2e@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c16158c..64507ea 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5616,8 +5616,13 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	if (pid != -1)
+	if (pid != -1) {
 		task = find_lively_task_by_vpid(pid);
+		if (IS_ERR(task)) {
+			err = PTR_ERR(task);
+			goto err_group_fd;
+		}
+	}
 
 	/*
 	 * Get the target context (task or percpu):
