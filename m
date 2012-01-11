Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092Ab2AKV6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:58:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933502Ab2AKV6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:58:49 -0500
Date: Wed, 11 Jan 2012 13:58:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>, linux-kernel@vger.kernel.org,
        Xiaotian Feng <dannyfeng@tencent.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] proc: fix null pointer deref in proc_pid_permission()
Message-Id: <20120111135847.d28425c6.akpm@linux-foundation.org>
In-Reply-To: <20120111204330.GT2618@outflux.net>
References: <1326307625-11561-1-git-send-email-xtfeng@gmail.com>
	<20120111204330.GT2618@outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012 12:43:30 -0800
Kees Cook <keescook@chromium.org> wrote:

> Hi,
> 
> On Wed, Jan 11, 2012 at 01:47:05PM -0500, Xiaotian Feng wrote:
> > get_proc_task() can fail to search the task and return NULL, put_task_struct()
> > will then bomb the kernel with following oops:
> > 
> > [ 1870.574045] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> > [ 1870.574065] IP: [<ffffffff81217d34>] proc_pid_permission+0x64/0xe0
> > [ 1870.574088] PGD 112075067 PUD 112814067 PMD 0
> > [ 1870.574106] Oops: 0002 [#1] PREEMPT SMP
> > 
> > This is a regression introduced by commit 0499680a, kernel should
> > return -ESRCH if get_proc_task() failed.
> 
> Nice catch!
> 
> However since this error is returned to userspace, shouldn't this be
> -ENOENT instead?
> 

Failed get_proc_task() frequently results in -ESRCH.  And less
frequently results in -ENOENT.

It seems odd that inode_operations.permission() would ever return
anything other than zero or -EPERM.

