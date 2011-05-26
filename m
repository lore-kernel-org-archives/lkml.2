Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab1EZWrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:47:12 -0400
Received: from mail.southpole.se ([193.12.106.18]:43977 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab1EZWrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:47:10 -0400
X-Greylist: delayed 1142 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 18:47:10 EDT
From: jonas@southpole.se
To: linux-kernel@vger.kernel.org
Cc: linux@openrisc.net, joern.rennecke@embecosm.com,
        Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 1/1] Apply transparent_union attribute to union semun
Date: Fri, 27 May 2011 00:27:45 +0200
Message-Id: <1306448865-3142-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jonas Bonn <jonas@southpole.se>

The syscall handler for semctl is written under the assumption that the
toolchain will pass "small" unions as function parameters directly instead
of by reference.  The union semun is "small" and thus fits this description.

Since it is assumed that the union will be passed directly and not by
reference, it is safe to access the union members without going via
get_user.

The OpenRISC architecture, however, passes all unions by reference, thus
breaking the above assumption.

The technically correct fix here is to mark the union as being transparent
so that the ABI of the union's first element determines the parameter
passing method and thus make explicit what's already implied in the function
definition.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 include/linux/sem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index f2961af..6985c7d 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -48,7 +48,7 @@ union semun {
 	unsigned short __user *array;	/* array for GETALL & SETALL */
 	struct seminfo __user *__buf;	/* buffer for IPC_INFO */
 	void __user *__pad;
-};
+} __attribute__ ((transparent_union));
 
 struct  seminfo {
 	int semmap;
-- 
1.7.4.1

