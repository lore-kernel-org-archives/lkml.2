Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1HXTpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 15:45:07 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:56522 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1HXTpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 15:45:05 -0400
Date: Wed, 24 Aug 2011 21:44:18 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg Kurz <gkurz@fr.ibm.com>, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
 when reboot
Message-ID: <20110824214418.474b24c6@neptune.home>
In-Reply-To: <20110823142914.GA22593@redhat.com>
References: <20110815144744.GA9660@redhat.com>
 <4E4DA461.8030006@free.fr>
 <20110819152416.GA17034@redhat.com>
 <4E524B73.3050704@free.fr>
 <20110822154448.GA8527@redhat.com>
 <20110822183134.10390b46@neptune.home>
 <20110822173949.GA13242@redhat.com>
 <20110822211716.7c141d5c@neptune.home>
 <20110823133302.GA19582@redhat.com>
 <1314108566.3465.29.camel@bahia.local>
 <20110823142914.GA22593@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 August 2011 Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/23, Greg Kurz wrote:
> >
> > On Tue, 2011-08-23 at 15:33 +0200, Oleg Nesterov wrote:
> > > [...]
> > > At least now I understand why did you mention si_code/CLD before. You
> > > meant waitid(). I thought you were talking about the death-notifications
> > > which can't report CLD_ you need.
> > >
> > > I strongly object. We shouldn't uglify wait_task_zombie() to solve the
> > > very specific problem.
> > >
> > > And once again. sub_init->parent does wiat(&status) and sees
> > > WIFSIGNALED() && WTERMSIG(status) == SIGHUP. This can only mean that
> > > sys_reboot(LINUX_REBOOT_CMD_RESTART) was called. It _can not_ be really
> > > killed by SIGHUP, it must be CMD_RESTART.
> > >
> > > Why this can't work? Why do you want the additional complications?
> > >
> >
> > I don't see either what could go wrong with you approach.
> 
> Thanks ;)
> 
> Just in case... instead of WIFSIGNALED/WTERMSIG we can also report
> the exit code in the upper bits. I mean,
> 
> 	switch (reboot_cmd) {
> 	case LINUX_REBOOT_CMD_RESTART:
> 		code = 1 << 16;
> 		break;
> 	case LINUX_REBOOT_CMD_HALT:
> 		code = 2 << 16;
> 		break;
> 	}

That looks nice and simple!

> this can't be confused with the normal exit(code), just the parent
> should be careful, I am not sure this can't confuse WIFEXITED/WEXITSTATUS
> user-space macroses.

For recent glibc (2.12.2):
sys/wait.h and stdlib.h:
# define WIFEXITED(status) __WIFEXITED (__WAIT_INT (status))
# define WEXITSTATUS(status)       __WEXITSTATUS (__WAIT_INT (status))
bits/waitstatus.h:
#define     __WIFEXITED(status)     (__WTERMSIG(status) == 0)
#define     __WTERMSIG(status)      ((status) & 0x7f)
#define     __WEXITSTATUS(status)   (((status) & 0xff00) >> 8)


For this version of glibc on x86 and amd64 it looks fine.
Would have to look at other versions and other libcs to make sure there
are no surprises.

Bruno

> wait(&status) takes "int *", we have a room for additional info, and
> wait_task_zombie() simply copies exit_code.
> 
> Oleg.
> 
