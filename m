Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1IODfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 23:35:37 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:58363 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1IODfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 23:35:36 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Wed, 14 Sep 2011 23:33:34 -0400
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: Acxo8lfuHB0gMHZ2TYComoolH0i7LQAmvWxwAnK8cBg=
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CAFE00221@USINDEVS02.corp.hds.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
	<20110901100650.6d884589.rdunlap@xenotime.net>
	<20110901152650.7a63cb8b@annuminas.surriel.com>
 <20110901145819.4031ef7c.akpm@linux-foundation.org>,<E1FA588BC672D846BDBB452FCA1E308C2389B4@USINDEVS02.corp.hds.com>
In-Reply-To: <E1FA588BC672D846BDBB452FCA1E308C2389B4@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1109140353
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 12:31 PM, Satoru Moriya wrote:
> On 09/01/2011 05:58 PM, Andrew Morton wrote:
>> On Thu, 1 Sep 2011 15:26:50 -0400
>> Rik van Riel <riel@redhat.com> wrote:
> Anyway, now I'm testing this patch and will report a test result later.

Sorry for late reply. Here is my test result.

I ran some sample workloads and measure memory allocation latency
(latency of __alloc_page_nodemask()).
The test is like following:

 - CPU: 1 socket, 4 core
 - Memory: 4GB

 - Background load:
   $ dd if=/dev/zero of=/tmp/tmp1
   $ dd if=/dev/zero of=/tmp/tmp2
   $ dd if=/dev/zero of=/tmp/tmp3

 - Main load:
   $ mapped-file-stream 1 $((1024 * 1024 * 640))  --(*)

 (*) This is made by Johannes Weiner
     https://lkml.org/lkml/2010/8/30/226

     It allocates/access 640MByte memory at a burst.

The result is follwoing:

                               |         |  extra   |
                               | default |  kbytes  |
--------------------------------------------------------------
min_free_kbytes                |    8113 |   8113   |
extra_free_kbytes              |       0 | 640*1024 | (KB)
--------------------------------------------------------------
worst latency                  | 517.762 |  20.775  | (usec)
--------------------------------------------------------------
vmstat result                  |         |          |
 nr_vmscan_write               |       0 |      0   |
 pgsteal_dma                   |       0 |      0   |
 pgsteal_dma32                 |  143667 | 144882   |
 pgsteal_normal                |   31486 |  27001   |
 pgsteal_movable               |       0 |      0   |
 pgscan_kswapd_dma             |       0 |      0   |
 pgscan_kswapd_dma32           |  138617 | 156351   |
 pgscan_kswapd_normal          |   30593 |  27955   |
 pgscan_kswapd_movable         |       0 |      0   |
 pgscan_direct_dma             |       0 |      0   |
 pgscan_direct_dma32           |    5050 |      0   |
 pgscan_direct_normal          |     896 |      0   |
 pgscan_direct_movable         |       0 |      0   |
 kswapd_steal                  |  169207 | 171883   |
 kswapd_inodesteal             |       0 |      0   |
 kswapd_low_wmark_hit_quickly  |      43 |     45   |
 kswapd_high_wmark_hit_quickly |       1 |      0   |
 allocstall                    |      32 |      0   |


As you can see, in the default case there were 32 direct reclaim (allocstall)
and its worst latency was 517.762 usecs. This value may be larger if
a process would sleep or issue I/O in the direct reclaim path. OTOH,
ii the other case where I add extra free bytes, there were no direct
reclaim and its worst latency was 20.775 usecs.

In this test case, we can avoid direct reclaim and keep a latency low.

Tested-by: Satoru Moriya <satoru.moriya@hds.com>
