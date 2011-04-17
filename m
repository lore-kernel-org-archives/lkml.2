Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1DQELZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 00:11:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36049 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1DQELT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 00:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=KOT8CWLGts3ub+yqso+5jd6YBUIFczaUNmDi7I1oJiaKuTkAyvNbN7Jq/6LLlGnsT4
         wWxOxgboay475zUWk18wtjxVpUv6uP7oZQozKgzJmmKGUV1ATSlNCS+sykUSXzHCI/IQ
         lrND+a2mBCfMEtTF6OZSPm5MrqoJml4BrdSHA=
MIME-Version: 1.0
Date: Sun, 17 Apr 2011 12:11:17 +0800
Message-ID: <BANLkTimWGDSWUzpXXrF1Xu2_=wu-y9J_HA@mail.gmail.com>
Subject: [PATCH] watchdog: disable nmi perf event in the error path of
 enabling watchdog
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In corner cases where softlockup watchdog is not setup successfully,
the relevant nmi perf event for hardlockup watchdog could be disabled,
then the status of the underlying hardware remains unchanged.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/watchdog.c	2011-03-30 03:09:48.000000000 +0800
+++ b/kernel/watchdog.c	2011-04-17 11:58:10.000000000 +0800
@@ -430,9 +430,12 @@ static int watchdog_enable(int cpu)
 		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
-			if (!err)
+			if (!err) {
 				/* if hardlockup hasn't already set this */
 				err = PTR_ERR(p);
+				/* and disable the perf event */
+				watchdog_nmi_disable(cpu);
+			}
 			goto out;
 		}
 		kthread_bind(p, cpu);
