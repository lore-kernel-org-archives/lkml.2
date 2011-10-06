Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1JFFMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 01:12:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17675 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1JFFMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 01:12:07 -0400
MIME-Version: 1.0
Message-ID: <ce19ea02-45e6-465a-a4c8-b5d74bf8c2ad@default>
Date: Wed, 5 Oct 2011 22:11:58 -0700 (PDT)
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
To: <linux-x86_64@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpu idle ticks show twice in xen pvm guest
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A02020B.4E8D38A7.0021,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run below test on xen pvm.
# x=$(cat /proc/stat | grep cpu0 | awk '{print $5}') && sleep 60  \
&& y=$(cat /proc/stat | grep cpu0 | awk '{print $5}') \
&& echo -e  "X:$x\nY:$y\nIDLE:" $(echo "scale=3; ($y-$x)/6000*100" | bc)

@ X:58562301
@ Y:58574282
@ IDLE: 199.600

Normal idle percent should be around 100%.
xen_timer_interrupt called account_idle_ticks to account hypervisor stolen idle ticks 
but these ticks will be accounted again when idle ticks restarted.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Joe Jin <joe.jin@oracle.com>

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 163b467..5dcbc91 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -151,7 +151,6 @@ static void do_stolen_accounting(void)
 
 	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
 	__this_cpu_write(xen_residual_blocked, blocked);
-	account_idle_ticks(ticks);
 }
 
 /* Get the TSC speed from Xen */
