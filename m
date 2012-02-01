Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2BAXVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:21:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab2BAXVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:21:13 -0500
Date: Wed, 1 Feb 2012 15:21:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, daniel.lezcano@free.fr,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: namespaces: Out-of-bounds array access
Message-Id: <20120201152112.d1ddda03.akpm@linux-foundation.org>
In-Reply-To: <4F063DE7.2080405@nod.at>
References: <4F063DE7.2080405@nod.at>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jan 2012 01:18:47 +0100
Richard Weinberger <richard@nod.at> wrote:

> Hi!
> 
> While searching a completely different bug I've found this problem:
> If CONFIG_NET_NS, CONFIG_UTS_NS and CONFIG_IPC_NS are disabled, ns_entries[]
> becomes empty and things like ns_entries[ARRAY_SIZE(ns_entries) - 1] will explode.
> 

Presumably this will fix it:

--- a/fs/proc/namespaces.c~a
+++ a/fs/proc/namespaces.c
@@ -156,15 +156,15 @@ static struct dentry *proc_ns_dir_lookup
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out;
 
-	last = &ns_entries[ARRAY_SIZE(ns_entries) - 1];
-	for (entry = ns_entries; entry <= last; entry++) {
+	last = &ns_entries[ARRAY_SIZE(ns_entries)];
+	for (entry = ns_entries; entry < last; entry++) {
 		if (strlen((*entry)->name) != len)
 			continue;
 		if (!memcmp(dentry->d_name.name, (*entry)->name, len))
 			break;
 	}
 	error = ERR_PTR(-ENOENT);
-	if (entry > last)
+	if (entry == last)
 		goto out;
 
 	error = proc_ns_instantiate(dir, dentry, task, *entry);
_

But I wonder why we compile this file at all when ns_entries[] is
empty?
