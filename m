Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab0FBOda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:33:30 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37393 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab0FBOd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:33:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=w8ZXEs/XhCDqoaOiDOSh9hcgRJ8z0YhoKJxphr/CvyUqnElYXiPq0myNRogVDn4xB
	tU7RoULu32WdSIfxoeYuA==
Message-ID: <4c066bb2.5cebd80a.19ec.45d8@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 2 Jun 2010 16:31:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com, tzanussi@gmail.com
Subject: [PATCH] perf: avoid assertion for -p option in perf stat -a
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was possible to use perf stat in system-wide mode with -a
and still attach to a process (-p) or thread (-t). The issue
is that it is not possible to get a termination signal from
the attached task, thus the command never terminates.
Furthermore, passing -p -a was triggering the assertion in
read_counter().

This patch fixes the issue by aborting perf stat if the
parameters conflict.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a6b4d44..a3b6a5f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -573,6 +573,14 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	else
 		nr_cpus = 1;
 
+	/*
+	 * a system-wide session cannot be delimited via an attachment
+	 * because we cannot get a termination notification.
+	 * It also triggers the assertion in read_counter()
+	 */
+	if (system_wide && (target_tid != -1 || target_pid != -1))
+		usage_with_options(stat_usage, options);
+
 	if (nr_cpus < 1)
 		usage_with_options(stat_usage, options);
 
