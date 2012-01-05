Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab2AECIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:08:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757099Ab2AECIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:08:36 -0500
Message-ID: <4F0506B1.1070909@cn.fujitsu.com>
Date: Thu, 05 Jan 2012 10:10:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 3/3] cgroup: remove extra calls to find_existing_css_set
References: <1325654312-32477-1-git-send-email-msb@chromium.org> <1325654312-32477-3-git-send-email-msb@chromium.org>
In-Reply-To: <1325654312-32477-3-git-send-email-msb@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-05 10:07:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-05 10:07:40,
	Serialize complete at 2012-01-05 10:07:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines wrote:
> In cgroup_attach_proc, we indirectly call find_existing_css_set 3
> times. It is an expensive call so we want to call it a minimum
> of times. This patch only calls it once and stores the result so
> that it can be used later on when we call cgroup_task_migrate.
> 
> This required modifying cgroup_task_migrate to take the new css_set
> (which we obtained from find_css_set) as a parameter. The nice side
> effect of this is that cgroup_task_migrate is now identical for
> cgroup_attach_task and cgroup_attach_proc. It also now returns a
> void since it can never fail.
> 
> Changes in V4:
> * https://lkml.org/lkml/2011/12/22/421 (Li Zefan)
>   * Avoid GFP_KERNEL (sleep) in rcu_read_lock by getting css_set in
>     a separate loop not under an rcu_read_lock
> Changes in V3:
> * https://lkml.org/lkml/2011/12/22/13 (Li Zefan)
>   * Fixed earlier bug by creating a seperate patch to remove tasklist_lock
> Changes in V2:
> * https://lkml.org/lkml/2011/12/20/372 (Tejun Heo)
>   * Move find_css_set call into loop which creates the flex array
> * Author
>   * Kill css_set_refs and use group_size instead
>   * Fix an off-by-one error in counting css_set refs
>   * Add a retval check in out_list_teardown
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> ---
>  kernel/cgroup.c |  142 +++++++++++-------------------------------------------
>  1 files changed, 29 insertions(+), 113 deletions(-)
