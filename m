Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab0CRTWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:22:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:50716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab0CRTWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:22:23 -0400
Date: Thu, 18 Mar 2010 19:21:37 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4ba1568b.15185e0a.182a.7802@mx.google.com>
References: <4ba1568b.15185e0a.182a.7802@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix resource leak in x86 __hw_perf_event_init()
Message-ID: <tip-4b24a88b35e15e04bd8f2c5dda65b5dc8ebca05f@git.kernel.org>
Git-Commit-ID: 4b24a88b35e15e04bd8f2c5dda65b5dc8ebca05f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Mar 2010 19:21:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b24a88b35e15e04bd8f2c5dda65b5dc8ebca05f
Gitweb:     http://git.kernel.org/tip/4b24a88b35e15e04bd8f2c5dda65b5dc8ebca05f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 17 Mar 2010 23:21:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Mar 2010 18:39:40 +0100

perf_events: Fix resource leak in x86 __hw_perf_event_init()

If reserve_pmc_hardware() succeeds but reserve_ds_buffers()
fails, then we need to release_pmc_hardware. It won't be done
by the destroy() callback because we return before setting it
in case of error.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: <stable@kernel.org>
Cc: peterz@infradead.org
Cc: paulus@samba.org
Cc: davem@davemloft.net
Cc: fweisbec@gmail.com
Cc: robert.richter@amd.com
Cc: perfmon2-devel@lists.sf.net
LKML-Reference: <4ba1568b.15185e0a.182a.7802@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
--
 arch/x86/kernel/cpu/perf_event.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)
---
 arch/x86/kernel/cpu/perf_event.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 14eca80..f571f51 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -455,8 +455,11 @@ static int __hw_perf_event_init(struct perf_event *event)
 		if (atomic_read(&active_events) == 0) {
 			if (!reserve_pmc_hardware())
 				err = -EBUSY;
-			else
+			else {
 				err = reserve_ds_buffers();
+				if (err)
+					release_pmc_hardware();
+			}
 		}
 		if (!err)
 			atomic_inc(&active_events);
