Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2EaKdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:33:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2650 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab2EaKdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:33:10 -0400
Message-ID: <4FC748D3.8050606@parallels.com>
Date: Thu, 31 May 2012 14:32:51 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] pidns: guarantee that the pidns init will be the
 last pidns process reaped
References: <20120530175745.GA19327@redhat.com> <20120530181429.GA19989@redhat.com> <20120530181500.GA20130@redhat.com>
In-Reply-To: <20120530181500.GA20130@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 10:15 PM, Oleg Nesterov wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Today we have a two-fold bug.  Sometimes release_task on pid == 1 in a
> pid namespace can run before other processes in a pid namespace have had
> release task called.  With the result that pid_ns_release_proc can be
> called before the last proc_flus_task() is done using
> upid->ns->proc_mnt, resulting in the use of a stale pointer.  This same
> set of circumstances can lead to waitpid(...) returning for a processes
> started with clone(CLONE_NEWPID) before the every process in the pid
> namespace has actually exited.
> 
> To fix this modify zap_pid_ns_processess wait until all other processes
> in the pid namespace have exited, even EXIT_DEAD zombies.
> 
> The delay_group_leader and related tests ensure that the thread gruop
> leader will be the last thread of a process group to be reaped, or to
> become EXIT_DEAD and self reap.  With the change to zap_pid_ns_processes
> we get the guarantee that pid == 1 in a pid namespace will be the last
> task that release_task is called on.
> 
> With pid == 1 being the last task to pass through release_task
> pid_ns_release_proc can no longer be called too early nor can wait
> return before all of the EXIT_DEAD tasks in a pid namespace have exited.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

