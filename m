Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2A3G57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 01:57:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62047 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab2A3G55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 01:57:57 -0500
Message-ID: <4F264013.1040603@cn.fujitsu.com>
Date: Mon, 30 Jan 2012 15:00:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH] cgroup: remove extra calls to find_existing_css_set
References: <1327429591-8507-1-git-send-email-msb@chromium.org>
In-Reply-To: <1327429591-8507-1-git-send-email-msb@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-30 14:56:32,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-30 14:56:35,
	Serialize complete at 2012-01-30 14:56:35
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
> Changes in V5:
> * https://lkml.org/lkml/2012/1/20/344 (Tejun Heo)
>   * Remove css_set_refs
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

Please add my ack in your changelog when you update the patch.

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
>  kernel/cgroup.c |  143 +++++++++++--------------------------------------------
>  1 files changed, 28 insertions(+), 115 deletions(-)
