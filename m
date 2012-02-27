Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2B0Rd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:33:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62757 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2B0Rdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:33:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.180.83.70 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
Date: Mon, 27 Feb 2012 18:33:51 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        mingo@elte.hu, joro@8bytes.org, gleb@redhat.com
Subject: [PATCH] perf tools: fix guest mode monitoring on AMD
Message-ID: <20120227173351.GA6945@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit:

1aed267 perf kvm: Do guest-only counting by default
 
introduced a bug on AMD systems whereby simple commands:

$ perf stat ls
Performance counter stats for 'ls':
                 0 cycles                    #    0.000 GHz                    
       0.003704596 seconds time elapsed

would not count anything anymore. Same results for perf record.

I tracked it down to guest mode exclusion being enabled
by default leading to attr->exclude_guest = 1. When
not operating under any sort of virtualization, this
causes the PMU not to count anything.

The fix disables guest exclusion by default.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8109a90..c1017b3 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -6,7 +6,7 @@
  * XXX We need to find a better place for these things...
  */
 bool perf_host  = true;
-bool perf_guest = false;
+bool perf_guest = true;
 
 void event_attr_init(struct perf_event_attr *attr)
 {
