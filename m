Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab1HWOcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:32:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1HWOcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:32:18 -0400
Date: Tue, 23 Aug 2011 16:29:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
	when reboot
Message-ID: <20110823142914.GA22593@redhat.com>
References: <20110815144744.GA9660@redhat.com> <4E4DA461.8030006@free.fr> <20110819152416.GA17034@redhat.com> <4E524B73.3050704@free.fr> <20110822154448.GA8527@redhat.com> <20110822183134.10390b46@neptune.home> <20110822173949.GA13242@redhat.com> <20110822211716.7c141d5c@neptune.home> <20110823133302.GA19582@redhat.com> <1314108566.3465.29.camel@bahia.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314108566.3465.29.camel@bahia.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23, Greg Kurz wrote:
>
> On Tue, 2011-08-23 at 15:33 +0200, Oleg Nesterov wrote:
> > [...]
> > At least now I understand why did you mention si_code/CLD before. You
> > meant waitid(). I thought you were talking about the death-notifications
> > which can't report CLD_ you need.
> >
> > I strongly object. We shouldn't uglify wait_task_zombie() to solve the
> > very specific problem.
> >
> > And once again. sub_init->parent does wiat(&status) and sees
> > WIFSIGNALED() && WTERMSIG(status) == SIGHUP. This can only mean that
> > sys_reboot(LINUX_REBOOT_CMD_RESTART) was called. It _can not_ be really
> > killed by SIGHUP, it must be CMD_RESTART.
> >
> > Why this can't work? Why do you want the additional complications?
> >
>
> I don't see either what could go wrong with you approach.

Thanks ;)

Just in case... instead of WIFSIGNALED/WTERMSIG we can also report
the exit code in the upper bits. I mean,

	switch (reboot_cmd) {
	case LINUX_REBOOT_CMD_RESTART:
		code = 1 << 16;
		break;
	case LINUX_REBOOT_CMD_HALT:
		code = 2 << 16;
		break;
	}

this can't be confused with the normal exit(code), just the parent
should be careful, I am not sure this can't confuse WIFEXITED/WEXITSTATUS
user-space macroses.

wait(&status) takes "int *", we have a room for additional info, and
wait_task_zombie() simply copies exit_code.

Oleg.

