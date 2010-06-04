Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0FDVKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 17:10:31 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:52243 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0FDVKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 17:10:30 -0400
Date: Fri, 4 Jun 2010 23:10:25 +0200
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] early_res: fix check in free_early_partial
Message-ID: <20100604211025.GA17881@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_early_partial must check the returned region of find_overlapped_early()
whether it is a region at all. Otherwise the function will indefinitely
loop.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
---
 kernel/early_res.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/early_res.c b/kernel/early_res.c
index 31aa933..9afcb4c 100644
--- a/kernel/early_res.c
+++ b/kernel/early_res.c
@@ -341,10 +341,11 @@ void __init free_early_partial(u64 start, u64 end)
 
 try_next:
 	i = find_overlapped_early(start, end);
-	if (i >= max_early_res)
+	r = &early_res[i];
+
+	if (i >= max_early_res || !r->end)
 		return;
 
-	r = &early_res[i];
 	/* hole ? */
 	if (r->end >= end && r->start <= start) {
 		drop_range_partial(i, start, end);
-- 
1.7.1
