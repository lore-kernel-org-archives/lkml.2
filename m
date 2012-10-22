Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2JVQa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:30:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:56235 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2JVQa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:30:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Luigi Semenzato <semenzato@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Namhyung Kim <namhyung@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Olof Johansson <olofj@chromium.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Stephane Eranian <eranian@google.com>,
        Stephen Wilson <wilsons@start.ca>, Tejun Heo <tj@kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] perf tools: do not flush maps on COMM for perf report
Date: Mon, 22 Oct 2012 14:30:24 -0200
Message-Id: <1350923425-15400-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350923425-15400-1-git-send-email-acme@infradead.org>
References: <1350923425-15400-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luigi Semenzato <semenzato@chromium.org>

This fixes a long-standing bug caused by the lack of separate COMM and EXEC
record types, which makes "perf report" lose track of symbols when a process
renames itself.

With this fix (suggested by Stephane Eranian), a COMM (rename) no longer
flushes the maps, which is the correct behavior.  An EXEC also no longer
flushes the maps, but this doesn't matter because as new mappings are created
(for the executable and the libraries) the old mappings are automatically
removed.  This is not by accident: the functionality is necessary because DLLs
can be explicitly loaded at any time with dlopen(), possibly on top of existing
text, so "perf report" handles correctly the clobbering of new mappings on top
of old ones.

An alternative patch (which I proposed earlier) would be to introduce a
separate PERF_RECORD_EXEC type, but it is a much larger change (about 300
lines) and is not necessary.

Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
Tested-by: Stephane Eranian <eranian@google.com>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Olof Johansson <olofj@chromium.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stephen Wilson <wilsons@start.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Link: http://lkml.kernel.org/r/1345585940-6497-1-git-send-email-semenzato@chromium.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fb4b7ea..8b3e593 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -39,7 +39,6 @@ int thread__set_comm(struct thread *self, const char *comm)
 	err = self->comm == NULL ? -ENOMEM : 0;
 	if (!err) {
 		self->comm_set = true;
-		map_groups__flush(&self->mg);
 	}
 	return err;
 }
-- 
1.7.1

