Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2GRLia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:38:30 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36661 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2GRLi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:38:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120718110731.GE5006@linux.vnet.ibm.com>
References: <CACV3sbLu81jrkfSXQxJ+_XtZHVTA6YfwJO3hjRxYsaDwbbLi6A@mail.gmail.com>
	<20120717105936.GC28744@somewhere>
	<20120717172736.GA6854@linux.vnet.ibm.com>
	<CACV3sbKBsj288s=2FKKM+zuoga7Jy9QOxgzciTwREFVHLgR=Lw@mail.gmail.com>
	<20120718110731.GE5006@linux.vnet.ibm.com>
Date: Wed, 18 Jul 2012 19:38:27 +0800
Message-ID: <CACV3sb+1=qaNu6ozHS+iRnKntoJw46zyamRPzcu-hWY34-qO8Q@mail.gmail.com>
Subject: Re: [offlist] uprobe: checking probe event include directory
From: Jovi Zhang <bookjovi@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 7:07 PM, Srikar Dronamraju
<srikar@linux.vnet.ibm.com> wrote:
> The patch looks good,
>
> Can you modify the description a bit. However you are free to ignore
> these comments. After knowing your response,  I will ack the patch.
>
> I would probably put this as:
>
> The subject could be
> tracing: Verify target file before registering a uprobe event
>
> Description:
> Without this patch, we can register a uprobe event for a directory.
> Enabling such a uprobe event would anyway fail.
>
> Example:
>
> $ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
>
> However directories cannot be valid targets for uprobe.
> Hence verify if the target is a regular file during the probe
> registration.

Thanks srikar, your description is more clear than mine.


>From fd5077196038cc271e2116e1fca359a0011e1669 Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Wed, 18 Jul 2012 18:16:44 +0800
Subject: [PATCH] tracing: Verify target file before registering a uprobe
 event

Without this patch, we can register a uprobe event for a directory.
Enabling such a uprobe event would anyway fail.

Example:
$ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events

However dirctories cannot be valid targets for uprobe.
Hence verify if the target is a regular file during the probe
registration.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_uprobe.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 85158fa..3b5f646 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -259,6 +259,10 @@ static int create_trace_uprobe(int argc, char **argv)
 		goto fail_address_parse;

 	inode = igrab(path.dentry->d_inode);
+	 if (!S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)) {
+		ret = -EINVAL;
+		goto fail_address_parse;
+	}

 	argc -= 2;
 	argv += 2;
@@ -358,7 +362,7 @@ fail_address_parse:
 	if (inode)
 		iput(inode);

-	pr_info("Failed to parse address.\n");
+	pr_info("Failed to parse address or file.\n");

 	return ret;
 }
-- 
1.7.9.7
