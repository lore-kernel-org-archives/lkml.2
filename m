Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab1EJOfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:35:38 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:54186
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153Ab1EJOfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:35:36 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZHV1-01-4A0-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] perf, core: Introduce attrs to count in either host or guest mode
Date: Tue, 10 May 2011 16:35:30 +0200
Message-ID: <1305038132-5080-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two new attributes exclude_guest and exclude_host can
bes used by user-space to tell the kernel to setup
performance counter to either only count while the CPU is in
guest or in host mode.
An additional check is also introduced to make sure
user-space does not try to exclude guest and host mode from
counting.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/perf_event.h |    5 ++++-
 kernel/perf_event.c        |    4 ++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ee9f1e7..3823f34 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -217,7 +217,10 @@ struct perf_event_attr {
 				mmap_data      :  1, /* non-exec mmap data    */
 				sample_id_all  :  1, /* sample_type all events */
 
-				__reserved_1   : 45;
+				exclude_host   :  1, /* don't count in host   */
+				exclude_guest  :  1, /* don't count in guest  */
+
+				__reserved_1   : 43;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8e81a98..1a9159b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6452,6 +6452,10 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
+	/* Can't exclude counting in guest and in host mode */
+	if (attr.exclude_host && attr.exclude_guest)
+		return -EINVAL;
+
 	/*
 	 * In cgroup mode, the pid argument is used to pass the fd
 	 * opened to the cgroup directory in cgroupfs. The cpu argument
-- 
1.7.4.1


