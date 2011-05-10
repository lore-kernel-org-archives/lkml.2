Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1EJDqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:46:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57470 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab1EJDqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:46:13 -0400
Message-ID: <4DC8B5DE.1090103@cn.fujitsu.com>
Date: Tue, 10 May 2011 11:49:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] blk-throttle: Use task_subsys_state() to determine a
 task's blkio_cgroup
References: <20110509134915.GC5975@redhat.com>
In-Reply-To: <20110509134915.GC5975@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-10 11:46:28,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-10 11:46:28,
	Serialize complete at 2011-05-10 11:46:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Currentlly we first map the task to cgroup and then cgroup to
> blkio_cgroup. There is a more direct way to get to blkio_cgroup
> from task using task_subsys_state(). Use that.
> 
> The real reason for the fix is that it also avoids a race in generic
> cgroup code. During remount/umount rebind_subsystems() is called and
> it can do following with and rcu protection.
> 
> cgrp->subsys[i] = NULL;
> 
> That means if somebody got hold of cgroup under rcu and then it tried
> to do cgroup->subsys[] to get to blkio_cgroup, it would get NULL which
> is wrong. I was running into this race condition with ltp running on a
> upstream derived kernel and that lead to crash.
> 
> So ideally we should also fix cgroup generic code to wait for rcu
> grace period before setting pointer to NULL. Li Zefan is not very keen
> on introducing synchronize_wait() as he thinks it will slow
> down moun/remount/umount operations.
> 
> So for the time being atleast fix the kernel crash by taking a more
> direct route to blkio_cgroup.
> 
> One tester had reported a crash while running LTP on a derived kernel
> and with this fix crash is no more seen while the test has been
> running for over 6 days.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
