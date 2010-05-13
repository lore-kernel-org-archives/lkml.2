Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0EMGEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:04:54 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38308 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0EMGEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:04:50 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ian Munsie <imunsie@au1.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 6/7] perf trace: Fix value truncation with 64bit kernel and 32bit userspace
Date: Thu, 13 May 2010 16:03:51 +1000
Message-Id: <1273730632-21008-7-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

On systems with a 64bit kernel and 32bit userspace, perf trace would
truncate pointers and longs down to 32 bits when displaying them. This
was due to calling printf("%p", (long long)val); or printf("%ld",
(long)val); which both would truncate the long to the size of a
userspace long in perf.

This patch adds a final parse of the format string in the event that the
size of a long in the kernel does not match the size of a long in
userspace (both 32bit => 64bit and vice versa. "%p" is explicitly
converted to "0x%llx" for 64=>32, or "0x%x" for 32=>64. "%l*" is
similarly converted to "%ll*" for 64=>32 or "%*" for 32=>64.

Running perf trace without the patch on a PPC machine with a 64bit
kernel and 32bit userspace produces output similar to the following
recording the timer:timer_start tracepoint:
  swapper-0     [000]  6420.045520: timer_start: timer=0xc0000000 function=sync_supers_timer_fn expires=612604 [timeout=600]
 events/0-27    [000]  6420.045547: timer_start: timer=0xc0000000 function=delayed_work_timer_fn expires=612104 [timeout=100]
  swapper-0     [000]  6420.135502: timer_start: timer=0xc0000000 function=neigh_timer_handler expires=613547 [timeout=1534]

With the patch, the timer value is no longer truncated:
  swapper-0     [000]  6420.045520: timer_start: timer=0xc000000000caffe8 function=sync_supers_timer_fn expires=612604 [timeout=600]
 events/0-27    [000]  6420.045547: timer_start: timer=0xc000000000e052f0 function=delayed_work_timer_fn expires=612104 [timeout=100]
  swapper-0     [000]  6420.135502: timer_start: timer=0xc0000000bce1e698 function=neigh_timer_handler expires=613547 [timeout=1534]

Similarly, running perf trace without the patch on a x86_64 kernel and
32bit perf recording a simple probe placed on schedule:
        events/0-7     [000] 24070.926153: schedule: (8159886b)

With the patch, the location of the probe is no longer truncated and
matches the location of schedule from kallsyms:
        events/0-7     [000] 24070.926153: schedule: (ffffffff8159886b)

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/trace-event-parse.c |   68 ++++++++++++++++++++++++++++++++--
 1 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index f9f80be..f74abdb 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2475,6 +2475,67 @@ static char *get_bprint_format(void *data, int size __unused, struct event *even
 	return format;
 }
 
+static void convert_kernel_host_format(char *kernel_format, int *ls)
+{
+	char user_format[32];
+	char *kptr = kernel_format;
+	char *uptr = user_format;
+	const char *newfmt;
+	int len;
+
+	if (sizeof(long) == long_size)
+		return;
+	if (long_size != 4 && long_size != 8) {
+		pr_warning("Invalid kernel long size %d, data may be truncated\n", long_size);
+		return;
+	}
+
+	while (*kptr) {
+		newfmt = NULL;
+		if (!strncmp(kptr, "%p", 2)) {
+			/* printf("%p") will treat pointer as userspace size */
+			if (long_size == 8) {
+				/* 64bit kernel => 32bit userspace, convert pointer => long long */
+				newfmt = "0x%llx";
+				*ls += 1;
+			} else {
+				/* 32bit kernel => 64bit userspace, convert pointer => int */
+				newfmt = "0x%x";
+			}
+			kptr += 2;
+		} else if (!strncmp(kptr, "%l", 2) && strncmp(kptr, "%ll", 3)) {
+			assert(*ls >= 1);
+			if (long_size == 8) {
+				/* 64bit kernel => 32bit userspace, convert long => long long */
+				newfmt = "%ll";
+				*ls += 1;
+			} else {
+				/* 32bit kernel => 64bit userspace, convert long => int */
+				newfmt = "%";
+				*ls -= 1;
+			}
+			kptr += 2;
+		}
+
+		if (newfmt) {
+			len = strlen(newfmt);
+			if (uptr - user_format + len + 1 >= 32)
+				/* should never happen */
+				die("overflow while converting long");
+			memcpy(uptr, newfmt, len);
+			uptr += len;
+		} else {
+			if (uptr - user_format + 1 >= 32)
+				/* should never happen */
+				die("overflow while converting long");
+			*uptr++ = *kptr++;
+		}
+	}
+	assert(uptr - user_format < 32);
+	*uptr++ = 0;
+	memcpy(kernel_format, user_format, uptr - user_format);
+}
+
 static void pretty_print(void *data, int size, struct event *event)
 {
 	struct print_fmt *print_fmt = &event->print_fmt;
@@ -2542,10 +2603,7 @@ static void pretty_print(void *data, int size, struct event *event)
 			case '0' ... '9':
 				goto cont_process;
 			case 'p':
-				if (long_size == 4)
-					ls = 1;
-				else
-					ls = 2;
+				ls = 1;
 
 				if (*(ptr+1) == 'F' ||
 				    *(ptr+1) == 'f') {
@@ -2572,6 +2630,8 @@ static void pretty_print(void *data, int size, struct event *event)
 				memcpy(format, saveptr, len);
 				format[len] = 0;
 
+				convert_kernel_host_format(format, &ls);
+
 				val = eval_num_arg(data, size, event, arg);
 				arg = arg->next;
 
-- 
1.7.1

