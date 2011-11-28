Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1K1WrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:47:25 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:33265 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1K1WrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:47:21 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "nagar@watson.ibm.com" <nagar@watson.ibm.com>,
        "kobayashi.kk@ncos.nec.co.jp" <kobayashi.kk@ncos.nec.co.jp>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Mon, 28 Nov 2011 17:47:01 -0500
Subject: [PATCH 4/4] getdelays: show max CPU/IO/SWAP/RECLAIM delays
Thread-Topic: [PATCH 4/4] getdelays: show max CPU/IO/SWAP/RECLAIM delays
Thread-Index: AcyuHz1jOo2pA4gdSJ2m+oX/c0nTOAAAE/NQ
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB574E716@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB574E70D@USINDEVS02.corp.hds.com>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB574E70D@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1111280247
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, getdelays shows maximum delay which it gets from kernel
via taskstats interface.

Output example:
(on 100 concurrent dd reading sparse files with 1 dd writing a file)

CPU             count     real total  virtual total    delay total      delay_max  delay average
                  234       61990576       78703354         543649         138417          0.002ms
IO              count    delay total      delay max  delay average
                   16      184774999       61259321             11ms
SWAP            count    delay total      delay max  delay average
                    0              0              0              0ms
RECLAIM         count    delay total      delay_max  delay average
                   20        4249456         381288              0ms


Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>
---
 Documentation/accounting/getdelays.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index f6318f6..69d3ec4 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -197,32 +197,36 @@ static int get_family_id(int sd)
 
 static void print_delayacct(struct taskstats *t)
 {
-	printf("\n\nCPU   %15s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15llu%15llu%15.3fms\n"
-	       "IO    %15s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
-	       "SWAP  %15s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
-	       "RECLAIM  %12s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n",
+	printf("\n\nCPU   %15s%15s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15llu%15llu%15llu%15.3fms\n"
+	       "IO    %15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15llu%15llums\n"
+	       "SWAP  %15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15llu%15llums\n"
+	       "RECLAIM  %12s%15s%15s%15s\n"
+	       "      %15llu%15llu%15llu%15llums\n",
 	       "count", "real total", "virtual total",
-	       "delay total", "delay average",
+	       "delay total", "delay_max", "delay average",
 	       (unsigned long long)t->cpu_count,
 	       (unsigned long long)t->cpu_run_real_total,
 	       (unsigned long long)t->cpu_run_virtual_total,
 	       (unsigned long long)t->cpu_delay_total,
+	       (unsigned long long)t->cpu_delay_max,
 	       average_ms((double)t->cpu_delay_total, t->cpu_count),
-	       "count", "delay total", "delay average",
+	       "count", "delay total", "delay max", "delay average",
 	       (unsigned long long)t->blkio_count,
 	       (unsigned long long)t->blkio_delay_total,
+	       (unsigned long long)t->blkio_delay_max,
 	       average_ms(t->blkio_delay_total, t->blkio_count),
-	       "count", "delay total", "delay average",
+	       "count", "delay total", "delay max", "delay average",
 	       (unsigned long long)t->swapin_count,
 	       (unsigned long long)t->swapin_delay_total,
+	       (unsigned long long)t->swapin_delay_max,
 	       average_ms(t->swapin_delay_total, t->swapin_count),
-	       "count", "delay total", "delay average",
+	       "count", "delay total", "delay_max", "delay average",
 	       (unsigned long long)t->freepages_count,
 	       (unsigned long long)t->freepages_delay_total,
+	       (unsigned long long)t->freepages_delay_max,
 	       average_ms(t->freepages_delay_total, t->freepages_count));
 }
 
-- 
1.7.6.4


