Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1GTVRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 17:17:46 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:32200 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751593Ab1GTVRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 17:17:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mBWKkOIVM1mwgwBItEevp0.PyVZs3UehO2AQYgLszfr8Abz
 i26MzmT4AWfsecElU3ogDjFApTXwneXLhdg87a80gjyL8OBNDT1H.sPhUFsL
 FRrr126kf97myVjynBCx3iC8pzzXVPC6Iy0KB_unU4LCmc4Mb30j1pzSKZHX
 coVZyh4HENb6Q8VBZirDxhx2.H7kh8MkcY0c3pkWl6OhHynbxSxH809H047o
 kpwDXW9gfUUrPFroJVXFaNLHNaShDn1BgUB73Mj_6omDr8z1XDbnu7OODnUA
 SWUseFXiQqu7az50_YN_bgiazjPZlOLcpOtaT11yktf_EyG1y
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 16:17:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
In-Reply-To: <alpine.DEB.2.00.1107201443400.1472@router.home>
Message-ID: <alpine.DEB.2.00.1107201617050.1472@router.home>
References: <1310742540-22780-1-git-send-email-mgorman@suse.de> <1310742540-22780-2-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1107180951390.30392@router.home> <20110718160552.GB5349@suse.de> <alpine.DEB.2.00.1107181208050.31576@router.home>
 <20110718211325.GC5349@suse.de> <alpine.DEB.2.00.1107181651000.31576@router.home> <alpine.DEB.2.00.1107190901120.1199@router.home> <alpine.DEB.2.00.1107201307530.1472@router.home> <20110720191858.GO5349@suse.de> <alpine.DEB.2.00.1107201425200.1472@router.home>
 <alpine.DEB.2.00.1107201443400.1472@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm... Maybe we can bypass the checks?

Subject: [page allocator] Do not check watermarks if there is a page available on the per cpu freelists

One should be able to grab a page from the per cpu freelists if available.
The pages on the per cpu freelists are not accounted for in VM statistics
so getting a page from there has no impact on reclaim.

Check for this condition in get_page_from_freelist and short circuit
to the call to buffered_rmqueue if so.

Note that there is a race here. We may deplete the reserve pools by
one page if either the process is rescheduled on a different processor
or if another process grabs the last page from the per cpu freelist.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/page_alloc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2011-07-20 15:27:20.544825852 -0500
+++ linux-2.6/mm/page_alloc.c	2011-07-20 15:30:05.314824797 -0500
@@ -1666,6 +1666,16 @@ zonelist_scan:
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				goto try_next_zone;

+		/*
+		 * Short circuit allocation if we have a usable object on
+		 * the percpu freelist. Note that this can only be an
+		 * optimization since there is no guarantee that we will
+		 * be executing on the same cpu. Another process could also
+		 * be scheduled and take the available page from us.
+		 */
+		if (order == 0 && this_cpu_read(zone->pageset->pcp.count))
+			goto try_this_zone;
+
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
 			unsigned long mark;
