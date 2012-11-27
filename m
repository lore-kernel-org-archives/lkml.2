Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2K0NPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:15:46 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48091 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2K0NPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:15:45 -0500
MIME-Version: 1.0
Date: Tue, 27 Nov 2012 21:15:44 +0800
Message-ID: <CAJd=RBD-5zq-7U3yPWCsb9P_AMzf_GoT47onxXiihgK9J7-wOA@mail.gmail.com>
Subject: [PATCH 2/3] balancenuma: set last_nid on newly allocated page
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, dhillf@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass last_nid from misplaced page to newly allocated migration target page.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/migrate.c	Tue Nov 27 20:16:48 2012
+++ b/mm/migrate.c	Tue Nov 27 20:19:12 2012
@@ -1457,6 +1457,9 @@ static struct page *alloc_misplaced_dst_
 					  __GFP_NOMEMALLOC | __GFP_NORETRY |
 					  __GFP_NOWARN) &
 					 ~GFP_IOFS, 0);
+	if (newpage)
+		page_xchg_last_nid(newpage, page_last_nid(page));
+
 	return newpage;
 }

@@ -1627,6 +1630,8 @@ int migrate_misplaced_transhuge_page(str
 		(GFP_TRANSHUGE | GFP_THISNODE) & ~__GFP_WAIT, HPAGE_PMD_ORDER);
 	if (!new_page)
 		goto out_dropref;
+
+	page_xchg_last_nid(new_page, page_last_nid(page));

 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
--
