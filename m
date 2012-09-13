Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab2IMU72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:59:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48818 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab2IMU7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:59:23 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 1/3] perf tool: precise mode requires exclude_guest
Date: Thu, 13 Sep 2012 14:59:13 -0600
Message-Id: <1347569955-54626-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Link: https://lkml.org/lkml/2012/7/9/264
---
 tools/perf/util/parse-events.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 44afcf4..696cc7e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -694,6 +694,9 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 			eH = 0;
 		} else if (*str == 'p') {
 			precise++;
+			/* use of precise requires exclude_guest */
+			if (!exclude_GH)
+				eG = 1;
 		} else
 			break;
 
-- 
1.7.10.1

