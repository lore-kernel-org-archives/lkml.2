Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab0FQBvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:51:53 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47633 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759112Ab0FQBvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/9] oom: oom_kill_process() doesn't select kthread child
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100616150232.GC9278@barrios-desktop>
References: <20100616203126.72DD.A69D9226@jp.fujitsu.com> <20100616150232.GC9278@barrios-desktop>
Message-Id: <20100617084154.FB33.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 16, 2010 at 08:32:08PM +0900, KOSAKI Motohiro wrote:
> > Now, select_bad_process() have PF_KTHREAD check, but oom_kill_process
> > doesn't. It mean oom_kill_process() may choose wrong task, especially,
> > when the child are using use_mm().
> Now oom_kill_process is called by three place. 
> 
> 1. mem_cgroup_out_of_memory
> 2. out_of_memory with sysctl_oom_kill_allocating_task
> 3. out_of_memory with non-sysctl_oom_kill_allocating_task
> 
> I think it's no problem in 1 and 3 since select_bad_process already checks
> PF_KTHREAD. The problem in in 2. 
> So How about put the check before calling oom_kill_process in case of
> sysctl_oom_kill_allocating task?
> 
> if (sysctl_oom_kill_allocating_task) {
>         if (!current->flags & PF_KTHREAD)
>                 oom_kill_process();
>                         
> It can remove duplicated PF_KTHREAD check in select_bad_process and
> oom_kill_process. 

This patch changed child selection logic. select_bad_process() doesn't
check victim's child. IOW, this is necessary when all 1-3.



