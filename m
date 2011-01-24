Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1AXPdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:33:20 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:35486 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab1AXPdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:33:19 -0500
Date: Mon, 24 Jan 2011 10:32:28 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Paul Menage <menage@google.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com, David Rientjes <rientjes@google.com>,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v7 2/3] cgroups: add atomic-context per-thread
 subsystem callbacks
Message-ID: <20110124153228.GB24303@ghc17.ghc.andrew.cmu.edu>
References: <20101224082226.GA13872@ghc17.ghc.andrew.cmu.edu>
 <20101226120919.GA28529@ghc17.ghc.andrew.cmu.edu>
 <20101226121100.GC28529@ghc17.ghc.andrew.cmu.edu>
 <AANLkTimytfrDnr_5SzBUFQu0SaGdAWDC0p38hiFiHrtU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimytfrDnr_5SzBUFQu0SaGdAWDC0p38hiFiHrtU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1700_1799 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, ECARD_KNOWN_DOMAINS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 12:38:06AM -0800, Paul Menage wrote:
> Hi Ben,
> 
> Finally finding a moment to actually look at these patches. Sorry it's
> been a while. Can you send the patches inline rather than as
> attachments in future?

Whoops, sure thing.

> 
> Reviewed-by: Paul Menage <menage@google.com>
> 
> This patch looks fine, although I think that freezer_can_attach_task()
> could be simplified to:
> 
> static int freezer_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
> {
>   if (__cgroup_freezing_or_frozen(tsk))
>     return -EBUSY;
>   return 0;
> }
> 
> since we guarantee that rcu_read_lock() is held across this call.

I put a note there that "rcu_read_lock allows recursive locking", to
denote that it's okay to double-lock when it's called from
cgroup_attach_proc. I guess this isn't very clear: the reason the lock
is there is because in cgroup_attach_task, I call it without
rcu_read_lock (not necessary in most cases), but freezer needs RCU there
in either case. I wrote in the documentation: "This may run in
rcu_read-side", which I guess isn't very clear either.

> 
> There appears to be a tiny bit of rot in kernel/cpu.c (due to the
> addition of the exit() callback) and memcontrol.c (due to some changes
> at the start of mem_cgroup_move_task()) but neither impact actual
> code.
> 
> I think that before actually pushing to mainline, we'll need to sort
> out the cpuset mempolicy yielding issue, since that could be a
> user-visible API change.
> 
> 
> Paul

Hmm. The quirks caused by this are specific to using cgroup.procs, and
since cgroup.procs is new, I wouldn't say this is an API "change"?

Thanks,
Ben
