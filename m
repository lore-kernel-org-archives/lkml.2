Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2GQKMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:12:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64941 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2GQKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:12:29 -0400
MIME-Version: 1.0
Date: Tue, 17 Jul 2012 18:12:28 +0800
Message-ID: <CACV3sbLu81jrkfSXQxJ+_XtZHVTA6YfwJO3hjRxYsaDwbbLi6A@mail.gmail.com>
Subject: uprobe: checking probe event include directory
From: Jovi Zhang <bookjovi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 16ed13ee9098ae01705e8456005d1ad6d9909128 Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Wed, 18 Jul 2012 01:16:23 +0800
Subject: [PATCH] uprobe: checking probe event include directory

Currently below command run successful:
$ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events

this don't make sense, because /bin is a directory,
so make this checking earily, not report error untill probe enable.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 kernel/trace/trace_uprobe.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 85158fa..cf382de 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -259,6 +259,11 @@ static int create_trace_uprobe(int argc, char **argv)
 		goto fail_address_parse;

 	inode = igrab(path.dentry->d_inode);
+	 if (S_ISDIR(inode->i_mode)) {
+		ret = -EINVAL;
+		pr_info("probe file cannot be directory.\n");
+		goto fail_address_parse;
+	}

 	argc -= 2;
 	argv += 2;
-- 
1.7.9.7
