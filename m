Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1IFJAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 05:00:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50749 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab1IFI7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:59:55 -0400
Message-ID: <4E65E132.9090201@cn.fujitsu.com>
Date: Tue, 06 Sep 2011 17:00:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: rjw@sisk.pl, paul@paulmenage.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, matthltc@us.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCHSET cgroup] extend threadgroup locking
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
In-Reply-To: <1315159280-25032-1-git-send-email-htejun@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-06 16:58:46,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-06 16:58:49,
	Serialize complete at 2011-09-06 16:58:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> cgroup currently only blocks new threads from joining the target
> threadgroup during migration, and on-going migration could race
> against exec and exit leading to interesting problems - the symmetry
> between various attach methods, task exiting during method execution,
> ->exit() racing against attach methods, migrating task switching basic
> properties during exec and so on.
> 
> This patchset extends threadgroup locking such that it covers all
> operations which can alter the threadgroup - fork, exit and exec, and
> update cgroup to take advantage of it.  rwsem read ops are added to
> exit path but exec is excluded by grabbing the existing
> cred_guard_mutex from threadgroup locking helper.
> 
> This makes threadgroup locking complete and resolves cgroup issues
> stemming from the target taskset being unstable.
> 
> This patchset is on top of the current pm-freezer + "freezer: fixes &
> simplifications" patchset and contains the following four patches.
> Patch list and diffstat follow.
> 
> Thanks.
> 
>  [PATCH 1/4] cgroup: change locking order in attach_task_by_pid()
>  [PATCH 2/4] threadgroup: rename signal->threadgroup_fork_lock to
>  [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover exit and
>  [PATCH 4/4] cgroup: always lock threadgroup during migration
> 

I've read through the whole patchset, and it looks good to me.

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

>  include/linux/init_task.h |    9 ++----
>  include/linux/sched.h     |   58 ++++++++++++++++++++++++++++---------------
>  kernel/cgroup.c           |   62 +++++++++++++++++++++-------------------------
>  kernel/exit.c             |   16 ++++++++---
>  kernel/fork.c             |    8 ++---
>  5 files changed, 88 insertions(+), 65 deletions(-)
> 
> --
> tejun
> 
> [1] http://thread.gmane.org/gmane.linux.kernel/1187553
> 
