Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1COJet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab1COJeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:25 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Maxim <maxim.patlasov@gmail.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/15] GFS2: Adding missing unlock_page()
Date: Tue, 15 Mar 2011 09:11:44 +0000
Message-Id: <1300180305-5993-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim <maxim.patlasov@gmail.com>

gfs2_write_begin() calls grab_cache_page_write_begin() that returns *locked*
page. Correspondent error-handling path lacks for unlock_page() call:

> out:
> 	if (error == 0)
> 		return 0;
>
> 	page_cache_release(page);

The whole system hangs if gfs2_unstuff_dinode() called from gfs2_write_begin()
failed for some reason.

Reported-by: Maxim <maxim.patlasov@gmail.com>
Signed-off-by: Maxim <maxim.patlasov@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 4f36f88..aad77e4 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -695,6 +695,7 @@ out:
 	if (error == 0)
 		return 0;
 
+	unlock_page(page);
 	page_cache_release(page);
 
 	gfs2_trans_end(sdp);
-- 
1.7.4

