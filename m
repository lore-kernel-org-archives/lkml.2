Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934985Ab1ETSWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:22:15 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:58880 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934748Ab1ETSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:22:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:date:content-type:content-transfer-encoding:message-id
	:mime-version; q=dns; s=sasl; b=ZnJy8zdes8IUNeykBn1lS5mlkh3fSzWY
	QXadAnD6VnvNrW6B8VXuxR96wEN6VRDkxvmPytGOo39Y2AhkBgCJRYZpyZPrSWkQ
	5ZV6Bb1X2d6w2NbYYhS/HK+GDkMFbUtA24iCUIx7KwvW0YXbLdolbaTvmkLdjoE7
	KUW+89nbATE=
Subject: [trace-cmd patch] close open fds on exec
From: Nathan Lynch <ntl@pobox.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 May 2011 13:22:09 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1305915732.2429.4.camel@orca.stoopid.dyndns.org>
Mime-Version: 1.0
X-Pobox-Relay-ID: 60DF88E6-830E-11E0-85F5-BBB7F5B2FB1A-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace-cmd's record mode allows child processes to inherit
tracing-related file descriptors:

$ trace-cmd record -esched: ls -l /proc/self/fd

total 0
lrwx------. 1 root root 64 May 20 12:44 0 -> /dev/pts/11
lrwx------. 1 root root 64 May 20 12:44 1 -> /dev/pts/11
lrwx------. 1 root root 64 May 20 12:44 2 -> /dev/pts/11
lrwx------. 1 root root 64 May 20 12:44 3 -> /sys/kernel/debug/tracing/tracing_on
l-wx------. 1 root root 64 May 20 12:44 4 -> /sys/kernel/debug/tracing/set_ftrace_pid
l-wx------. 1 root root 64 May 20 12:44 5 -> /sys/kernel/debug/tracing/tracing_enabled
lr-x------. 1 root root 64 May 20 12:44 6 -> /proc/31036/fd

This can be problematic for applications (such as lxc) that
interrogate their open file descriptors.

Open these with O_CLOEXEC so they are not inherited.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 trace-record.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/trace-record.c b/trace-record.c
index fa23b82..c4a51d7 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -343,7 +343,7 @@ static void update_ftrace_pid(const char *pid, int reset)
 			path = tracecmd_get_tracing_file("set_ftrace_pid");
 		if (!path)
 			return;
-		fd = open(path, O_WRONLY | (reset ? O_TRUNC : 0));
+		fd = open(path, O_WRONLY | O_CLOEXEC | (reset ? O_TRUNC : 0));
 		if (fd < 0)
 			return;
 	}
@@ -795,7 +795,7 @@ static void check_tracing_enabled(void)
 
 	if (fd < 0) {
 		path = tracecmd_get_tracing_file("tracing_enabled");
-		fd = open(path, O_WRONLY);
+		fd = open(path, O_WRONLY | O_CLOEXEC);
 		tracecmd_put_tracing_file(path);
 
 		if (fd < 0)
@@ -815,7 +815,7 @@ static int open_tracing_on(void)
 		return fd;
 
 	path = tracecmd_get_tracing_file("tracing_on");
-	fd = open(path, O_RDWR);
+	fd = open(path, O_RDWR | O_CLOEXEC);
 	if (fd < 0)
 		die("opening '%s'", path);
 	tracecmd_put_tracing_file(path);
-- 
1.7.5.1



