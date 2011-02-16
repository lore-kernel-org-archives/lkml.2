Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1BPRTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:19:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63745 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab1BPRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:19:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A+w55ATz6dmboOxEo3229UT1B8Bo59nNnBIyq5tQfNzNyyK4jrtxYlvkfPMPW3e4Q3
         dbHfFFJiZzCDyRoARlrqC9Av7eptB0nYreFWI4iMQQLpch3c75AYAebxUbHrWb4aHoky
         5vAG5HChcO/iRISgWBKNrIQttbkbqZ8Rngy6U=
Date: Wed, 16 Feb 2011 18:19:04 +0100
From: Tejun Heo <tj@kernel.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ray Jui <rjui@broadcom.com>
Subject: [PATCH wq#fixes-2.6.38] workqueue: make sure
 MAYDAY_INITIAL_TIMEOUT is at least 2 jiffies long
Message-ID: <20110216171904.GK19830@htj.dyndns.org>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C2EAC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110209102847.GE3770@htj.dyndns.org>
 <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C3163@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110214130300.GH18742@htj.dyndns.org>
 <8628FE4E7912BF47A96AE7DD7BAC0AADDDF03CDD8A@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110216165255.GJ19830@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216165255.GJ19830@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAYDAY_INITIAL_TIMEOUT is defined as HZ / 100 and depending on
configuration may end up 0 or 1.  Even when it's 1, depending on when
the mayday timer is added in the current jiffy interval, it may expire
way before a jiffy has passed.

Make sure MAYDAY_INITIAL_TIMEOUT is at least two to guarantee that at
least a full jiffy has passed before calling rescuers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ray Jui <rjui@broadcom.com>
Cc: stable@kernel.org
---
 kernel/workqueue.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 88a3e34..ee6578b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -79,7 +79,9 @@ enum {
 	MAX_IDLE_WORKERS_RATIO	= 4,		/* 1/4 of busy can be idle */
 	IDLE_WORKER_TIMEOUT	= 300 * HZ,	/* keep idle ones for 5 mins */
 
-	MAYDAY_INITIAL_TIMEOUT	= HZ / 100,	/* call for help after 10ms */
+	MAYDAY_INITIAL_TIMEOUT  = HZ / 100 >= 2 ? HZ / 100 : 2,
+						/* call for help after 10ms
+						   (min two ticks) */
 	MAYDAY_INTERVAL		= HZ / 10,	/* and then every 100ms */
 	CREATE_COOLDOWN		= HZ,		/* time to breath after fail */
 	TRUSTEE_COOLDOWN	= HZ / 10,	/* for trustee draining */
-- 
1.7.1

