Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1IUPkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:40:08 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51791 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1IUPkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:40:06 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <trivial@kernel.org>,
        jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] Trivial: devtmpfsd: Setting task running/interruptible states
Date: Wed, 21 Sep 2011 21:09:33 +0530
Message-Id: <1316619573-9104-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch makes the following changes in devtmpfsd() :
- Set the state to TASK_INTERRUPTIBLE using __set_current_state
  instead of set_current_state as the spin_unlock is an implicit
  memory barrier.
- After return from schedule(), there is no need to set the current
  state to TASK_RUNNING as the wake_up_process() function call will
  do this for us.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 drivers/base/devtmpfs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index a4760e0..2bb4bff 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -413,10 +413,9 @@ static int devtmpfsd(void *p)
 			}
 			spin_lock(&req_lock);
 		}
-		set_current_state(TASK_INTERRUPTIBLE);
+		__set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock(&req_lock);
 		schedule();
-		__set_current_state(TASK_RUNNING);
 	}
 	return 0;
 out:
-- 
1.7.4.1

