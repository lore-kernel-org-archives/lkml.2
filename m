Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1ACF7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 00:59:34 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59598 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1ACF7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 00:59:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=b2tFv91V0gXLtAKsv9vZ70xJQ/3ejJhsKKFf1nPj2dQP/43B++zjx/V/ktSQ9Ug5Z5
         jmieV2K2WKVNVp/WbuE5LcXNnhMZCvi9xkEIwx5szo/4n6mpx4ji+0MDgiQlV2Yh+WRR
         Nr4GvBq2kEeKEv/1ljXJB7iUTUEfiFIVolzGs=
Date: Mon, 3 Jan 2011 08:59:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [patch 2/2] [SCSI] target: unlock on error path in configfs
Message-ID: <20110103055920.GV1886@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user wrote a wrong value to the file the it would lead to a dead
lock eventually.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index d7b977d..2764510 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -660,6 +660,7 @@ static ssize_t target_core_dev_store_attr_##_name(			\
 	}								\
 	ret = strict_strtoul(page, 0, &val);				\
 	if (ret < 0) {							\
+		spin_unlock(&se_dev->se_dev_lock);                      \
 		printk(KERN_ERR "strict_strtoul() failed with"		\
 			" ret: %d\n", ret);				\
 		return -EINVAL;						\
