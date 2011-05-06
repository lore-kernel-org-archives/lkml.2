Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1EFWcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:32:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56836 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab1EFWcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:32:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/3] PM / Hibernate: Fix ioctl SNAPSHOT_S2RAM
Date: Sat, 7 May 2011 00:32:27 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alexandre Felipe Muller de Souza 
	<alexandrefm@mandriva.com.br>
References: <201105070029.44623.rjw@sisk.pl>
In-Reply-To: <201105070029.44623.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105070032.27540.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The SNAPSHOT_S2RAM ioctl used for implementing the feature allowing
one to suspend to RAM after creating a hibernation image is currently
broken, because it doesn't clear the "ready" flag in the struct
snapshot_data object handled by it.  As a result, the
SNAPSHOT_UNFREEZE doesn't work correctly after SNAPSHOT_S2RAM has
returned and the user space hibernate task cannot thaw the other
processes as appropriate.  Make SNAPSHOT_S2RAM clear data->ready
to fix this problem.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/user.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/power/user.c
===================================================================
--- linux-2.6.orig/kernel/power/user.c
+++ linux-2.6/kernel/power/user.c
@@ -381,6 +381,7 @@ static long snapshot_ioctl(struct file *
 		 * PM_HIBERNATION_PREPARE
 		 */
 		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		data->ready = 0;
 		break;
 
 	case SNAPSHOT_PLATFORM_SUPPORT:

