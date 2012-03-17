Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946563Ab2CQArb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 20:47:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:33516 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946041Ab2CQAr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 20:47:26 -0400
Message-ID: <4F63DF17.3070603@linaro.org>
Date: Fri, 16 Mar 2012 17:47:19 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fadvise volatile fixes from Dmitry
References: <1331938267-13583-1-git-send-email-john.stultz@linaro.org> <1331938267-13583-3-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1331938267-13583-3-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031700-4242-0000-0000-00000112EDF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 03:51 PM, John Stultz wrote:
> This patch provides new fadvise flags that can be used to mark
> file pages as volatile, which will allow it to be discarded if the
> kernel wants to reclaim memory.
Right after sending this I realized I had forgotten to include
some fixes for issues Dmitry pointed out. So I've included them
here.

Signed-off-by: John Stultz<john.stultz@linaro.org>
---
  mm/volatile.c |    5 +++--
  1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/volatile.c b/mm/volatile.c
index e412a8b..f40c02e 100644
--- a/mm/volatile.c
+++ b/mm/volatile.c
@@ -220,11 +220,12 @@ long mapping_range_nonvolatile(struct address_space *mapping,
  			new->mapping = mapping;
  			new->range_node.start = end + 1;
  			new->range_node.end = node->end;
-			volatile_range_resize(vrange, node->start, start-1);
+			new->purged = vrange->purged;
  			range_tree_add(&mapping->volatile_root,
  						&new->range_node);
  			if (range_on_lru(new))
  				lru_add(new);
+			volatile_range_resize(vrange, node->start, start-1);

  			break;
  		}
@@ -263,7 +264,7 @@ void mapping_clear_volatile_ranges(struct address_space *mapping)
  static int volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
  {
  	struct volatile_range *range, *next;
-	unsigned long nr_to_scan = sc->nr_to_scan;
+	s64 nr_to_scan = sc->nr_to_scan;
  	const gfp_t gfp_mask = sc->gfp_mask;

  	if (nr_to_scan&&  !(gfp_mask&  __GFP_FS))
-- 
1.7.3.2.146.gca209



