Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab2JTA4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:56:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36123 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab2JTA4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:56:12 -0400
Date: Fri, 19 Oct 2012 17:55:38 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-1342798cc13e3b48d9b5738f0c8fa812ccea8101@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, gleb@redhat.com,
        robert.richter@amd.com, dsahern@gmail.com, tglx@linutronix.de,
        avi@redhat.com
Reply-To: gleb@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        avi@redhat.com
In-Reply-To: <1347569955-54626-2-git-send-email-dsahern@gmail.com>
References: <1347569955-54626-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tool: Precise mode requires exclude_guest
Git-Commit-ID: 1342798cc13e3b48d9b5738f0c8fa812ccea8101
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 17:55:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1342798cc13e3b48d9b5738f0c8fa812ccea8101
Gitweb:     http://git.kernel.org/tip/1342798cc13e3b48d9b5738f0c8fa812ccea8101
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Thu, 13 Sep 2012 14:59:13 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Oct 2012 12:43:31 -0300

perf tool: Precise mode requires exclude_guest

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
 
