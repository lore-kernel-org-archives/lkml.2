Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0EJQdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:33:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:59382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab0EJQcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:32:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/4] perf session: create_kernel_maps should use ->host_machine
Date: Mon, 10 May 2010 13:32:20 -0300
Message-Id: <1273509141-15696-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273509141-15696-1-git-send-email-acme@infradead.org>
References: <1273509141-15696-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using machines__create_kernel_maps(..., HOST_KERNEL_ID) it would create
another machine instance for the host machine, and since 1f626bc we have
it out of the machines rb_tree.

Fix it by using machine__create_kernel_maps(&self->host_machine)
directly.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c088d8f..4130036 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -69,11 +69,10 @@ void perf_session__update_sample_type(struct perf_session *self)
 
 int perf_session__create_kernel_maps(struct perf_session *self)
 {
-	struct rb_root *machines = &self->machines;
-	int ret = machines__create_kernel_maps(machines, HOST_KERNEL_ID);
+	int ret = machine__create_kernel_maps(&self->host_machine);
 
 	if (ret >= 0)
-		ret = machines__create_guest_kernel_maps(machines);
+		ret = machines__create_guest_kernel_maps(&self->machines);
 	return ret;
 }
 
-- 
1.6.2.5

