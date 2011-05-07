Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1EGDW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 23:22:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab1EGDW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 23:22:27 -0400
Date: Fri, 6 May 2011 20:28:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH 1/1] coredump: use task comm instead of (unknown)
Message-Id: <20110506202826.68850d88.akpm@linux-foundation.org>
In-Reply-To: <201105071114.CJH64556.FOOVFHOQJSFLtM@I-love.SAKURA.ne.jp>
References: <4DC0FFAB.1000805@gmail.com>
	<1304494354-21487-1-git-send-email-jslaby@suse.cz>
	<20110505150601.a4457970.akpm@linux-foundation.org>
	<201105062126.DIE34311.OJHtFMFFSQLVOO@I-love.SAKURA.ne.jp>
	<20110506123328.d0a707b7.akpm@linux-foundation.org>
	<201105071114.CJH64556.FOOVFHOQJSFLtM@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 May 2011 11:14:14 +0900 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Andrew Morton wrote:
> > > char *strncpy(char *dest, const char *src, size_t n)
> > > {
> > > 	size_t len = __strnend(src, n) - src;
> 
> If src was overwritten by prctl(PR_SET_NAME) at this moment (i.e. after len was
> calculated),
> 
> > > 	__builtin_memset(dest + len, 0, n - len);
> > > 	__builtin_memcpy(dest, src, len);
> 
> won't this result in inconsistent copying of src when length of src has changed
> by prctl(PR_SET_NAME)?
> 
> > > 	return dest;
> > > }
> 
> This strncpy() assumes that length of src won't change within the function.
> I thought prctl(PR_SET_NAME) might break such assumption.

PR_SET_NAME uses set_task_comm() which has appropriate locking to
protect against get_task_comm().  

If kernel code directly accesses task->comm without taking task_lock()
then yes, it's racy.

