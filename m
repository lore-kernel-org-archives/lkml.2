Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab1DHS4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:56:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab1DHS4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:56:00 -0400
Date: Fri, 8 Apr 2011 20:55:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110408185531.GA3697@redhat.com>
References: <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D99D6E6.4070008@aknet.ru> <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4D9EE899.5040109@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9EE899.5040109@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Stas Sergeev wrote:
>
> I updated patch to fix the race between wait_task_detached()
> and wait_task_zombie() by using is_detaching flag.
> Here's the patch.
> What problems do remain here?

Stas, sorry, I simply have no time to read this patch. Not to mention,
you know that I dislike it in any case.

I only quickly looked at the changes in sys_prctl and they are definitely
wrong.

> +			me->real_parent = pid_ns->child_reaper;
> +			if (thread_group_leader(me)) {
> +				list_move_tail(&me->sibling,
> +						&me->real_parent->children);
> +				/* reparent threads */
> +				p = me;
> +				while_each_thread(me, p) {
> +					if (!task_ptrace(p))
> +						p->parent = pid_ns->child_reaper;
> +					p->real_parent = pid_ns->child_reaper;

Why do you check thread_group_leader() ???? What if the caller is not
the leader?

I told this many times, and I got lost. If you reparent, you should
always reparent the whole group.

Also, you are doing do_signal_parent(me). I do not know what it does
(once again, I didn't read the patch), but this looks suspicious.
A sub-thread shouldn't notify the parent.

Oleg.

