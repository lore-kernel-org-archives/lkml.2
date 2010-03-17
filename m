Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0CQWYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:24:20 -0400
Received: from smtp-out.google.com ([74.125.121.35]:8751 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab0CQWYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:24:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=SJ/O8d5RiCnAmikDlOjvmf44OKxpm505T6wWpiGJRR9eEABZ7MRHuVcSfB+e5xJxT
	efy/92NYAcLMAAwhojTIQ==
Message-ID: <4ba1568b.15185e0a.182a.7802@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 17 Mar 2010 23:21:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf_events: fix resource leak in x86 __hw_perf_event_init()
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	If reserve_pmc_hardware() succeeds but reserve_ds_buffers()
	fails, then we need to release_pmc_hardware. It won't be done
	by the destroy() callback because we return before setting it
	in case of error.

	Signed-off-by: Stephane Eranian <eranian@google.com>

--
 perf_event.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 978d297..8d9b152 100644
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
