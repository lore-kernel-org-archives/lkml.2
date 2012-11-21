Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2KUCzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:55:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34036 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab2KUCzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:55:22 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6242967"
Message-ID: <50AC4291.7010108@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 10:55:13 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/11] pidns: Support unsharing the pid namespace.
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-11-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1353083750-3621-11-git-send-email-ebiederm@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:55:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:55:05,
	Serialize complete at 2012/11/21 10:55:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2012/11/17 00:35, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Unsharing of the pid namespace unlike unsharing of other namespaces
> does not take affect immediately.  Instead it affects the children
> created with fork and clone.  The first of these children becomes the init
> process of the new pid namespace, the rest become oddball children
> of pid 0.  From the point of view of the new pid namespace the process
> that created it is pid 0, as it's pid does not map.
> 
> A couple of different semantics were considered but this one was
> settled on because it is easy to implement and it is usable from
> pam modules.  The core reasons for the existence of unshare.
> 
> I took a survey of the callers of pam modules and the following
> appears to be a representative sample of their logic.
> {
> 	setup stuff include pam
> 	child = fork();
> 	if (!child) {
> 		setuid()
>                 exec /bin/bash
>         }
>         waitpid(child);
> 
>         pam and other cleanup
> }
> 
> As you can see there is a fork to create the unprivileged user
> space process.  Which means that the unprivileged user space
> process will appear as pid 1 in the new pid namespace.  Further
> most login processes do not cope with extraneous children which
> means shifting the duty of reaping extraneous child process to
> the creator of those extraneous children makes the system more
> comprehensible.
> 
> The practical reason for this set of pid namespace semantics is
> that it is simple to implement and verify they work correctly.
> Whereas an implementation that requres changing the struct
> pid on a process comes with a lot more races and pain.  Not
> the least of which is that glibc caches getpid().
> 
> These semantics are implemented by having two notions
> of the pid namespace of a proces.  There is task_active_pid_ns
> which is the pid namspace the process was created with
> and the pid namespace that all pids are presented to
> that process in.  The task_active_pid_ns is stored
> in the struct pid of the task.
> 
> Then there is the pid namespace that will be used for children
> that pid namespace is stored in task->nsproxy->pid_ns.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
