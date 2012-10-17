Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2JQRUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:20:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:46049 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab2JQRUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:20:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/11] perf tool: Precise mode requires exclude_guest
Date: Wed, 17 Oct 2012 14:19:37 -0300
Message-Id: <1350494387-10987-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350494387-10987-1-git-send-email-acme@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Summary of events per Peter:

  "Intel PEBS in VT-x context uses the DS address as a guest linear address,
  even though its programmed by the host as a host linear address. This
  either results in guest memory corruption and or the hardware faulting and
  'crashing' the virtual machine.  Therefore we have to disable PEBS on VT-x
  enter and re-enable on VT-x exit, enforcing a strict exclude_guest.

  AMB IBS does work but doesn't currently support exclude_* at all,
  setting an exclude_* bit will make it fail."

This patch handles userspace perf command, setting the exclude_guest
attribute if precise mode is requested, but only if a user has not
specified a request for guest or host only profiling (G or H attribute).

Kernel side AMD currently ignores all exclude_* bits, so there is no impact
to existing IBS code paths. Robert Richter has a patch where IBS code will
return EINVAL if an exclude_* bit is set. When this goes in it means use
of :p on AMD with IBS will first fail with EINVAL (because exclude_guest
will be set). Then the existing fallback code within perf will unset
exclude_guest and try again. The second attempt will succeed if the CPU
supports IBS profiling.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Robert Richter <robert.richter@amd.com>
Tested-by: Robert Richter <robert.richter@amd.com>
Reviewed-by: Robert Richter <robert.richter@amd.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Link: http://lkml.kernel.org/r/1347569955-54626-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index aed38e4..75c7b0f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -690,6 +690,9 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 			eH = 0;
 		} else if (*str == 'p') {
 			precise++;
+			/* use of precise requires exclude_guest */
+			if (!exclude_GH)
+				eG = 1;
 		} else
 			break;
 
-- 
1.7.1

