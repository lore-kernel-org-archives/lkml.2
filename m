Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1HORjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:39:14 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:45284 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751302Ab1HORjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:39:13 -0400
Date: Mon, 15 Aug 2011 17:39:40 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, akpm@linux-foundation.org,
        bonbons@linux-vserver.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
 when reboot
Message-ID: <20110815173940.GA19620@hallyn.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
 <20110814161707.GB30846@redhat.com>
 <20110814213642.GB13799@hallyn.com>
 <20110815144744.GA9660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815144744.GA9660@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 08/14, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > On 08/11, Daniel Lezcano wrote:
> > > >
> > > > In the case of a VPS, when we shutdown/halt/reboot the container, the
> > > > reboot utility will invoke the sys_reboot syscall which has the bad
> > > > effect to reboot the host.
> > >
> > > Stupid question. Can't sys_reboot() simply kill init (and thus the whole
> > > pid_ns) in this case?
> >
> > The goal is to be able to distinguish a request for reboot from shutdown.
> > If we just kill the init, then the parent of init (the container monitor)
> > cannot restart the container to emulate reboot.
> 
> OK, thanks.
> 
> What if init reports the reason it was killed?
> 
> Ignoring LINUX_REBOOT_CMD_CAD_/etc, I mean, roughly,
> 
> 	- add "int reboot_cmd" into struct pid_namespace
> 
> 	- sys_reboot(cmd) does
> 
> 		if (!global_namespace) {
> 			task_active_pid_ns(current)->reboot_cmd = cmd;
> 			sigkill_my_init();
> 		}
> 
> 	- change zap_pid_ns_processes() to do
> 
> 		if (pid_ns->reboot_cmd)	// approximately
> 			current->exit_state = pid_ns->reboot_cmd;
> 
> Then its parent can look at status after wait(&status).

That looks good to me.  Daniel, is there a reason this wouldn't work?

> Not that I think this is very nice, but signals are not reliable.
> And once again, SIGCHLD doesn't queue. And, perhaps this doesn't
> matter, but sys_reboot() sends SIGCHLD and returns -EPERM, this
> can confuse the container.

I think you're looking at an older (Aug 11) version.  Daniel's newer
patch should do the right thing (but I don't seem to have it in front
of me atm)

> In any case. If you want to send a signal, please do not introduce
> SA_CLDREBOOT. Please do not play with ptrace or __wake_up_parent, this
> is meaningless. Just fill siginfo and send SIGCHLD unconditionally.
> 
> Oleg.

Thanks for the help, Oleg.

-serge
