Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2DDVQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:16:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab2DDVQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:16:43 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/8] perf: Add PERF_EVENT_IOC_ID ioctl to return event ID
Date: Wed,  4 Apr 2012 23:16:11 +0200
Message-Id: <1333574176-11388-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
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
---
 include/linux/perf_event.h |    1 +
 kernel/events/core.c       |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ddbb6a9..3173ae2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -284,6 +284,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
+#define PERF_EVENT_IOC_ID		_IOR('$', 7, u64 *)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6a9ec4..3ef2a5f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3266,6 +3266,15 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
1.7.7.6

