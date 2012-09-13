Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab2IMKVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:21:14 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:29870
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138Ab2IMKVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:21:08 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12bdh12e5h1155h)
X-WSS-ID: 0MAAA2Z-02-2FC-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] perf record: Change error message on failure
Date: Thu, 13 Sep 2012 12:20:54 +0200
Message-ID: <1347531654-16024-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only report

 No CONFIG_PERF_EVENTS=y kernel support configured?

if the syscall fails with ENOSYS. In other cases CONFIG_PERF_EVENTS is
set and might confuse users. The default message is now:

 Not all events could be opened.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-record.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ae7c1c9..0290c91 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -305,19 +305,19 @@ try_again:
 			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
 			      err, strerror(err));
 
+			if (err == ENOSYS)
+				pr_err("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
 #if defined(__i386__) || defined(__x86_64__)
-			if (attr->type == PERF_TYPE_HARDWARE &&
-			    err == EOPNOTSUPP) {
+			else if (attr->type == PERF_TYPE_HARDWARE &&
+				 err == EOPNOTSUPP)
 				pr_err("No hardware sampling interrupt available."
 				       " No APIC? If so then you can boot the kernel"
 				       " with the \"lapic\" boot parameter to"
 				       " force-enable it.\n");
-				rc = -err;
-				goto out;
-			}
 #endif
+			else
+				pr_err("Not all events could be opened.\n");
 
-			pr_err("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
 			rc = -err;
 			goto out;
 		}
-- 
1.7.8.6


