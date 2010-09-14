Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab0INNfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 09:35:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40959 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0INNfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 09:35:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=aBNNKd9GE+vgsuyZ5RcAPOiTwVeAXd+GnKttGgE4MkSbkjIQM0oeAXKzaaOj1fnYc
	Ajq3ikRkxkyXXGTXcQUCQ==
Message-ID: <4c8f7a23.cae9d80a.2c11.0bb4@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 14 Sep 2010 15:34:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, dzickus@redhat.com
Subject: [PATCH] watchdog: avoid kernel crash when disabling watchdog
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case you boot with the watchdog disabled, i.e., nowatchdog, then,
if you try to disable it via /proc/sys/kernel/watchdog, you get
a kernel crash. The reason is that you are trying to cancel a hrtimer
which has never been initialized.

This patch fixes this by skipping execution of
watchdog_disable_all_cpus() when the watchdog is marked
disabled from boot.

Signed-off-by: Stephane Eranian <eranian@google.com>
--
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 69a3d44..f335067 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -473,6 +473,9 @@ static void watchdog_disable_all_cpus(void)
 {
 	int cpu;
 
+	if (no_watchdog)
+		return;
+
 	for_each_online_cpu(cpu)
 		watchdog_disable(cpu);
 
