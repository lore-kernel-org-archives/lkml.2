Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1ANTr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:47:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab1ANTry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:47:54 -0500
Subject: Re: [Patch] kexec_load: check CAP_SYS_MODULE
From: Eric Paris <eparis@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Date: Fri, 14 Jan 2011 14:47:31 -0500
In-Reply-To: <m1k4ieesky.fsf@fess.ebiederm.org>
References: <1294302325-22593-1-git-send-email-amwang@redhat.com>
	 <m1bp3uifln.fsf@fess.ebiederm.org>
	 <AANLkTinLhAuSny735kofonAkaqwJvjjDHMUed_r03rVc@mail.gmail.com>
	 <m1k4igjwzf.fsf@fess.ebiederm.org>
	 <1294432333.3237.107.camel@localhost.localdomain>
	 <m18vywh1g7.fsf@fess.ebiederm.org>
	 <1294447189.3237.132.camel@localhost.localdomain>
	 <m1k4ieesky.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1295034466.2816.13.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-08 at 18:09 -0800, Eric W. Biederman wrote:
> Eric Paris <eparis@redhat.com> writes:

> What you are asking for if I understand this correctly is a way to
> disable sys_kexec_load?
> 
> What strange things are you trying to accomplish on top of a
> distribution kernel?

I've already described the situation.  We'd like to launch machines in
which root in unable to easily run their own kernel code.  This is
largely easy to do if you control the platform which holds the
bootloader and you drop CAP_SYS_MODULE and CAP_SYS_RAWIO before you
allow 'root' access to the machine.  Except kexec.  kexec seems to
believe that running any code you want in kernel space is the same as
rebooting a machine.  It's not.

> >> > The only solution I see to solve the problem is to gate kexec on
> >> > CAP_SYS_MODULE.  Which makes sense since kexec() is in many respects
> >> > close to module_init() than it is to reboot().
> >> 
> >> kexec_load is nothing like module_init().  All it does it puts data in
> >> memory for use by a subsequent reboot.  /sbin/kexec is a bootloader that
> >> runs inside of linux.  All you are noticing is that if you don't control
> >> /sbin/kexec you aren't controlling the bootloader.
> >
> > Does that mean you would instead prefer that we check CAP_SYS_MODULE in
> > sys_reboot() when LINUX_REBOOT_CMD_KEXEC is set (or really
> > kernel_kexec())?  It seems to me you indicate that is the more analogous
> > location since it is the actual place where we load new kernel code on
> > the running system (aka what sys_module was intended to protect)?
> 
> We aren't dealing with modules I think CAP_SYS_MODULE is totally
> irrelevant in the context of kexec.
> 
> I think to accomplish what you want we either need a way to disable
> sys_kexec_load or possibly a new very targeted capability bit.
> 
> You are making it so that giving someone CAP_SYS_MODULE is giving more
> than the ability to load kernel modules.  Which seems non-intuitive from
> a system management point of view.

I'm looking at what CAP_SYS_MODULE means in terms of operation of the
system and applying it where it fits.  A task with CAP_SYS_MODULE can
run any code they want in ring0 without any method for the hardware or
platform to determine or inspect what code is running or to realize that
the code it thought was running wasn't.  This is exactly what kexec()
allows.  Do you not see where these two operations are very similar?

I'm not giving anyone anything new.  I'm further restricting access.
Having CAP_SYS_MODULE alone won't let you use kexec.  And it's not like
anyone would have to grant any new permissions or make any userspace
changes for this to be backwards compatible (unless someone has an suid
kexec app which drops permissions explictly, which seems braindead, if
you don't trust that whole app your fscked anyway).  Maybe you don't
realize how caps work.  On nearly every system out there uid==0 means
you have all capabilities.  If you drop them, just exec something and
you get them back.

I'm willing to accept a way to disable kexec or even a new cap (since I
think CAP_SYS_REBOOT is really wrong) but I still think that the
operation CAP_SYS_MODULE was intended to mediate is the operation that's
happening here.

-Eric

