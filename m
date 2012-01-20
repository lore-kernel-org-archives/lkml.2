Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2ATHz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 02:55:26 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45423 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab2ATHzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 02:55:19 -0500
Date: Fri, 20 Jan 2012 10:55:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] NVMe: handle allocation failure in nvme_map_user_pages()
Message-ID: <20120120075529.GB2295@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F191DE6.0042,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should return here and avoid a NULL dereference.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/nvme.c b/drivers/block/nvme.c
index f4996b0..d826726 100644
--- a/drivers/block/nvme.c
+++ b/drivers/block/nvme.c
@@ -1042,6 +1042,8 @@ static struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
 	offset = offset_in_page(addr);
 	count = DIV_ROUND_UP(offset + length, PAGE_SIZE);
 	pages = kcalloc(count, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
 
 	err = get_user_pages_fast(addr, count, 1, pages);
 	if (err < count) {
