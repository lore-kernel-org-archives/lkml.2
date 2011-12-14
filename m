Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab1LNTXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:23:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab1LNTXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:23:01 -0500
Date: Wed, 14 Dec 2011 20:17:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, serge.hallyn@canonical.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Subject: Re: [PATCH][V4] Add reboot_pid_ns to handle the reboot syscall
Message-ID: <20111214191739.GA14693@redhat.com>
References: <1323649064-7960-1-git-send-email-daniel.lezcano@free.fr> <1323649064-7960-2-git-send-email-daniel.lezcano@free.fr> <20111213162242.1ab3cb1a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213162242.1ab3cb1a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Andrew Morton wrote:
>
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -444,6 +444,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
> >  	                magic2 != LINUX_REBOOT_MAGIC2C))
> >  		return -EINVAL;
> >
> > +	if (task_active_pid_ns(current) != &init_pid_ns)
> > +		return reboot_pid_ns(task_active_pid_ns(current), cmd);
> > +
> >  	/* Instead of trying to make the power_off code look like
> > 	 * halt when pm_power_off is not set do it the easy way.
> > 	 */
>
> I'll repeat my cruelly-ignored review comment for v3:
>
> This adds a bunch of useless code if CONFIG_PID_NS=n.

Agreed.

> It would be
> better to do
>
> #ifdef CONFIG_PID_NS
> extern void pidns_handle_reboot(int cmd);
> #else
> static inline void pidns_handle_reboot(int cmd)
> {
> }
> #endif

Can't resist.

Why the kernel always prefers to do it this way, adding the ugly
do-nothing inlines?

Isn't it better to simply call pidns_handle_reboot(cmd) under
CONFIG_PID_NS in sys_reboot() ?

	#ifdef CONFIG_PID_NS
	if (task_active_pid_ns(current) != &init_pid_ns)
		return reboot_pid_ns(cmd);
	#endif

This way, if you look at sys_reboot() you can immediately see what
happens, no need to inspect the !CONFIG_PID_NS definition. Plus this
doesn't add the "unnecesary" entry into tag file.

OK, </flame> ;)

Otherwise,

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

