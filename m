Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab0GVWJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:09:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6427 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab0GVWJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:09:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6051"; a="48342911"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, Greg Kroah-Hartman <gregkh@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Emese Revfy <re.emese@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/6] kobj: Fix memory leak on error path of kset_create_and_add
Date: Thu, 22 Jul 2010 15:09:06 -0700
Message-Id: <1279836546-26913-7-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This leak is the same as the bus path; kset->kobj.name is
set, but kset_register fails, thus nothing will ever call
kset_unregister and name will be leaked

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 lib/kobject.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index f07c572..713b235 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -843,6 +843,7 @@ struct kset *kset_create_and_add(const char *name,
 		return NULL;
 	error = kset_register(kset);
 	if (error) {
+		kfree(kset->kobj.name);
 		kfree(kset);
 		return NULL;
 	}
-- 
1.7.2

