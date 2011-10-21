Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1JUHSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 03:18:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:16919 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab1JUHSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 03:18:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,384,1315206000"; 
   d="scan'208";a="80284631"
From: "Xu, Anhua" <anhua.xu@intel.com>
To: Jiri Olsa <jolsa@redhat.com>, "acme@redhat.com" <acme@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "paulus@samba.org" <paulus@samba.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Oct 2011 15:18:31 +0800
Subject: RE: [PATCH] perf tools: Exit recording if events have non matching
 sample type
Thread-Topic: [PATCH] perf tools: Exit recording if events have non matching
 sample type
Thread-Index: Acx+wU++EoL6miekS5iQuYTBeiwkAwQ/5tHw
Message-ID: <1A42CE6F5F474C41B63392A5F80372B212DCA02CB2@shsmsx501.ccr.corp.intel.com>
References: <1317312068-10411-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1317312068-10411-1-git-send-email-jolsa@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I installed the latest kernel and found without such patch( not sure if other patches were added besides this one). That following command works fine.
perf record -o perf.data -e ext3:ext3_request_inode -e LLC-loads -- date '+%F'

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Jiri Olsa
Sent: Friday, September 30, 2011 12:01 AM
To: acme@redhat.com; a.p.zijlstra@chello.nl; mingo@elte.hu; paulus@samba.org
Cc: linux-kernel@vger.kernel.org; Jiri Olsa
Subject: [PATCH] perf tools: Exit recording if events have non matching sample type

The event processing relies on all events having the same sample_type.

This is being checked when the session is being opened read only.
It also needs to be checked when we do record, since events could be
read during processing build IDs at the end of the record command.

If we process events with different sample_type the processing might
skip some events or hang.

Following command hangs on my setup:
  ./perf record -o perf.data -e ext4:ext4_mb_new_group_pa \
   -e LLC-loads -- date '+%F'

because hardware and tracepoint events have different sample type.

With the patch applied the record command displays
"Non matching sample_type" message and exits.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f4c3fbe..71e2c4e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -832,6 +832,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
+	if (!perf_evlist__valid_sample_type(evsel_list)) {
+		pr_err("Non matching sample_type\n");
+		err = -EINVAL;
+		goto out_symbol_exit;
+	}
+
 	if (target_pid != -1)
 		target_tid = target_pid;
 
-- 
1.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
