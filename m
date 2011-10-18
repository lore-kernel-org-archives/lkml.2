Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab1JROUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:20:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:17648 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab1JROUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:20:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,365,1315206000"; 
   d="scan'208";a="63735836"
From: "Xu, Anhua" <anhua.xu@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 18 Oct 2011 22:20:28 +0800
Subject: perf tools: interface for improved PEBS ABI can accept wrong
 parameter
Thread-Topic: perf tools: interface for improved PEBS ABI can accept wrong
 parameter
Thread-Index: AcyNnwjJcllQcT+TSkaHfGlqI+oGrwAAegYA
Message-ID: <1A42CE6F5F474C41B63392A5F80372B212DC93637D@shsmsx501.ccr.corp.intel.com>
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

For the commit: ab60834 perf, x86: Improve the PEBS ABI
The precise_ip is restricted to 2 bits. The values larger than 3 are truncated less or equal to 3. This can effectively restricted value passing to syscall. 
But the user space interface can accept other wrong values which are larger than 3 and lowest 2 bits are 0 can meet the requirement.

# Here is an example, Monitor "All branches" events on Sandybridge platform( Please refer to SDM 3B Table 30-21 to check Sandybridge specific events )
perf top -e r04c4:p  # precise_ip = 1 , Correct
perf top -e r04c4:pp  # precise_ip =2, Correct
perf top -e r04c4:ppp  # not supported, Correct 
perf top -e r04c4:pppppp  # should not be supported, but after truncation , the number of 'p' treated as 2 which is accepted

Here is the patch:

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c816075..07d3cf9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -216,6 +216,7 @@ struct perf_event_attr {
 				 *
 				 *  See also PERF_RECORD_MISC_EXACT_IP
 				 */
+#define SAMPLE_IP_MAX	3 
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
 				sample_id_all  :  1, /* sample_type all events */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 928918b..a2068cc 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -775,7 +775,10 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 	attr->exclude_user   = eu;
 	attr->exclude_kernel = ek;
 	attr->exclude_hv     = eh;
-	attr->precise_ip     = precise;
+	if ( precise < SAMPLE_IP_MAX )
+		attr->precise_ip = precise;
+	else
+		return -1;
 
 	return 0;
 }
