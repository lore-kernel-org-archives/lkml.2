Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1CVTxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:53:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab1CVTxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:53:31 -0400
Date: Tue, 22 Mar 2011 20:44:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 7/8] job control: Notify the real parent of job control
	events regardless of ptrace
Message-ID: <20110322194416.GC28038@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-8-git-send-email-tj@kernel.org> <20110321174306.GA29895@redhat.com> <20110322080444.GM12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322080444.GM12003@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Tejun Heo wrote:
>
> On Mon, Mar 21, 2011 at 06:43:06PM +0100, Oleg Nesterov wrote:
> > Hmm... in fact I can't convince myself we really need to look at
> > child->group_leader, will recheck... Anyway, this is minor too.
>
> Care to elaborate?

child->real_parent must be equal to child->group_leader->real_parent.

What we need is ptrace_reparented(). But as I said, it should be
fixed first (I think) and this needs a separate patch/discussion.

So yes, we need a new helper.

Well, and look at get_signal_to_deliver(),

		leader = current->group_leader;
		if (task_ptrace(leader) && !real_parent_is_ptracer(leader))
			do_notify_parent_cldstop(leader, true, why);

Indeed. But in fact task_ptrace(leader) is not needed. If
real_parent_is_ptracer(tsk) returns false, then tsk must be ptraced.

So we could write

		if (!real_parent_is_ptracer(leader))
			do_notify_parent_cldstop(leader, true, why);

but now this looks confusing because of the naming. Compare with

		if (ptrace_reparented(leader))
			do_notify_parent_cldstop(leader);

Oleg.

