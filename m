Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1AGUcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:32:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab1AGUcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:32:19 -0500
Subject: Re: [Patch] kexec_load: check CAP_SYS_MODULE
From: Eric Paris <eparis@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
In-Reply-To: <m1k4igjwzf.fsf@fess.ebiederm.org>
References: <1294302325-22593-1-git-send-email-amwang@redhat.com>
	 <m1bp3uifln.fsf@fess.ebiederm.org>
	 <AANLkTinLhAuSny735kofonAkaqwJvjjDHMUed_r03rVc@mail.gmail.com>
	 <m1k4igjwzf.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 15:32:13 -0500
Message-ID: <1294432333.3237.107.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 12:10 -0800, Eric W. Biederman wrote:
> Eric Paris <eparis@parisplace.org> writes:

> >> CAP_SYS_BOOT is the correct capability.  Sure you can run any
> >> code but only after rebooting.  I don't see how this differs
> >> from any other reboot scenario.
> >
> > The difference is that after a reboot the bootloader and the system
> > control what code is run.  kexec_load() immediately runs the new
> > kernel which is not controlled by the bootloader or by the system.
> > Imagine a situation where the bootloader and the /boot directory are
> > RO (enforced by hardware).   kexec_load() would let you run any kernel
> > code you want on the box whereas reboot would not.
> 
> The scenario is imaginable (not common but imaginable) but I don't see
> how requiring CAP_SYS_MODULE makes anything better.
> 
> If I was building a configuration where I didn't want anyone to be able
> to direct the kernel into a different state by locking down the
> bootloaders I expect I would compile out the syscall as well.

As sad as it may sound the vast majority of people don't build their own
kernels.  And even those people who have the intelligence to do it are
often constrained by some non-technical policy to run 'approved'
kernels. 

> Most bootloaders have the option of booting something else the mechanism
> is just different. I really don't see what the addition of
> CAP_SYS_MODULE gains you.
> 
> Right now CAP_SYS_BOOT still makes sense to me and CAP_SYS_MODULE stills
> seems like nonsense in this context.

There is no question in my mind that CAP_SYS_BOOT makes sense.  We are
violently agreed on that point.  The problem is reboot() != kexec_load()
kexec_load() is as close to init_module() as it is to reboot().

Maybe I didn't make it clear how this is going to be used.  I plan to
drop CAP_SYS_MODULE to stop root from loading their own modules and
running their own code in the kernel.  I can control reboot() since I
control the platform and the bootloader.  I cannot control kexec().  I'm
also required to use a generic distro kernel (bet you can't guess which
one)

The only solution I see to solve the problem is to gate kexec on
CAP_SYS_MODULE.  Which makes sense since kexec() is in many respects
close to module_init() than it is to reboot().

-Eric

