Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0HIJhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:37:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45660 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab0HIJhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=i5L3tZcnX2XmQk+9K+6luYzf6lpXEdjWN2TEbjXvvgDjBhLMH89L4+IP/bfDXDqytF
         KakWEH7ef7pvIjQgzRVrKlPOSybVdyvZftLHr40eeTWyVlWyDUu/De+LS2buYncWKC20
         uCb04a+sSyKWjWQL2g73S0BOOBXt8mDlVDbIA=
Message-ID: <4C5FCC14.6030901@gmail.com>
Date: Mon, 09 Aug 2010 11:36:20 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>, walt <w41ter@gmail.com>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH wq#for-linus] workqueue: workqueue_cpu_callback() should be
 cpu_notifier not hotcpu_notifier
References: <i3n3dh$t48$1@dough.gmane.org> <20100809063742.GA1632@arch.tripp.de> <20100809083053.GB2169@osiris.boeblingen.de.ibm.com> <20100809083451.GC2169@osiris.boeblingen.de.ibm.com> <4C5FC49B.9040208@kernel.org>
In-Reply-To: <4C5FC49B.9040208@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6ee0578b (workqueue: mark init_workqueues as early_initcall)
made workqueue SMP initialization depend on workqueue_cpu_callback(),
which however was registered as hotcpu_notifier() and didn't get
called if CONFIG_HOTPLUG_CPU is not set.  This made gcwqs on non-boot
CPUs not create their initial workers leading to boot failures.  Fix
it by making it a cpu_notifier.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-bisected-by: walt <w41ter@gmail.com>
---
So, something like this.  Can you please verify the fix?

Thanks.

 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index da6c482..2994a0e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3527,7 +3527,7 @@ static int __init init_workqueues(void)
 	unsigned int cpu;
 	int i;

-	hotcpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);
+	cpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);

 	/* initialize gcwqs */
 	for_each_gcwq_cpu(cpu) {
