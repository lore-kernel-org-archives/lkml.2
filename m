Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1HYPlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:41:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab1HYPle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:41:34 -0400
Date: Thu, 25 Aug 2011 17:37:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Greg Kurz <gkurz@fr.ibm.com>, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
	when reboot
Message-ID: <20110825153732.GA4784@redhat.com>
References: <20110819152416.GA17034@redhat.com> <4E524B73.3050704@free.fr> <20110822154448.GA8527@redhat.com> <20110822183134.10390b46@neptune.home> <20110822173949.GA13242@redhat.com> <20110822211716.7c141d5c@neptune.home> <20110823133302.GA19582@redhat.com> <1314108566.3465.29.camel@bahia.local> <20110823142914.GA22593@redhat.com> <20110824214418.474b24c6@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110824214418.474b24c6@neptune.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Bruno Prémont wrote:
>
> On Tue, 23 August 2011 Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Just in case... instead of WIFSIGNALED/WTERMSIG we can also report
> > the exit code in the upper bits. I mean,
> >
> > 	switch (reboot_cmd) {
> > 	case LINUX_REBOOT_CMD_RESTART:
> > 		code = 1 << 16;
> > 		break;
> > 	case LINUX_REBOOT_CMD_HALT:
> > 		code = 2 << 16;
> > 		break;
> > 	}
>
> That looks nice and simple!

Great. To me, WIFSIGNALED() looks better, but this is subjective and
in any case this is up to you.

> > this can't be confused with the normal exit(code), just the parent
> > should be careful, I am not sure this can't confuse WIFEXITED/WEXITSTATUS
> > user-space macroses.
>
> For recent glibc (2.12.2):
> sys/wait.h and stdlib.h:
> # define WIFEXITED(status) __WIFEXITED (__WAIT_INT (status))
> # define WEXITSTATUS(status)       __WEXITSTATUS (__WAIT_INT (status))
> bits/waitstatus.h:
> #define     __WIFEXITED(status)     (__WTERMSIG(status) == 0)
> #define     __WTERMSIG(status)      ((status) & 0x7f)
> #define     __WEXITSTATUS(status)   (((status) & 0xff00) >> 8)

... and note that __WEXITSTATUS() does "& 0xff00", it uses the
lower 16 bits.

So the parent should read status "by hand". Not a problem, I think.
Say, a traced task reports the additional info this way.

Oleg.

