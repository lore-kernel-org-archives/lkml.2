Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2JTOdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:33:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab2JTOdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:33:42 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 01/11] perf: Add PERF_EVENT_IOC_ID ioctl to return event ID
Date: Sat, 20 Oct 2012 16:33:09 +0200
Message-Id: <1350743599-4805-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only way to get the event ID is by reading the event fd,
followed by parsing the ID value out of the returned data.

While this is ok for current read format used by perf tool,
it is not ok when we use PERF_FORMAT_GROUP format.

With this format the data are returned for the whole group
and there's no way to find out what ID belongs to our fd
(if we are not group leader event).

Adding a simple ioctl that returns event primary ID for given fd.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 include/linux/perf_event.h | 1 +
 kernel/events/core.c       | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 28f9cee..f11c967 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -314,6 +314,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
+#define PERF_EVENT_IOC_ID		_IOR('$', 7, u64 *)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2ba8904..32aec40 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3272,6 +3272,15 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_PERIOD:
 		return perf_event_period(event, (u64 __user *)arg);
 
+	case PERF_EVENT_IOC_ID:
+	{
+		u64 id = primary_event_id(event);
+
+		if (copy_to_user((void __user *)arg, &id, sizeof(id)))
+			return -EFAULT;
+		return 0;
+	}
+
 	case PERF_EVENT_IOC_SET_OUTPUT:
 	{
 		struct perf_event *output_event = NULL;
-- 
1.7.11.4

