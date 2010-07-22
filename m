Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050Ab0GVWKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:10:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6427 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab0GVWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:09:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6051"; a="48342906"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Hans J. Koch" <hjk@linutronix.de>
Subject: [PATCH 3/6] Driver core: Fix memory leak on class_register error path
Date: Thu, 22 Jul 2010 15:09:03 -0700
Message-Id: <1279836546-26913-4-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This leak is the same as the bus path; cp's kobj name
is set, but kset_register fails, free'ing cp, but not
cp->class_subsys.kobj.name

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 drivers/base/class.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 8e231d0..045acaf 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -197,6 +197,7 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 
 	error = kset_register(&cp->class_subsys);
 	if (error) {
+		kfree(cp->class_subsys.kobj.name);
 		kfree(cp);
 		return error;
 	}
-- 
1.7.2

