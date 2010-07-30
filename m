Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0G3VK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 17:10:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:60874 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab0G3VKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 17:10:25 -0400
Message-ID: <4C533FA8.2010500@windriver.com>
Date: Fri, 30 Jul 2010 16:10:00 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Pedro Ribeiro <pedrib@gmail.com>
CC: Nigel Cunningham <nigel@tuxonice.net>, tuxonice-devel@tuxonice.net,
        kgdb-bugreport@lists.sourceforge.net,
        Kernel development list <linux-kernel@vger.kernel.org>,
        dm-crypt@saout.de
Subject: Re: [Kgdb-bugreport] kcryptd oops when resuming with TuxOnIce with
 KDBoops afterwards
References: <AANLkTikjSiVXW+iGX-ofBs00crqiyT_d+DLpCBzFk4Ne@mail.gmail.com>
In-Reply-To: <AANLkTikjSiVXW+iGX-ofBs00crqiyT_d+DLpCBzFk4Ne@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2010 21:10:02.0319 (UTC) FILETIME=[934C9DF0:01CB302B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 08:30 PM, Pedro Ribeiro wrote:
> Hi all,
>
> I hit a bug when resuming with TuxOnIce. At the middle of a resume, it
> says Compress Read -22 and locks up. I caught the stack trace with kdb
> and took photos of that.
> I'm running 2.6.35-rc6 on a Lenovo T400. I have an encrypted LUKS
> partition (aes-cbc-essiv-128) which contains an LVM2 with my root,
> swap and home partitions inside.
>
> It seems that kcryptd caused the trouble. I've had other lockups with
> TuxOnIce that relate to kcryptd too, but I never caught them with kdb,
>
> After printing the stack trace I decided to see the output of the ps
> command. As I was scrolling the processes shown, kdb oops'ed and
> called itself. I also took photos of that kdb's own stack trace. I
> then tried the ps command again, but this time the stack trace was
> looping every few seconds (I took another photo of that). After a
> while it just panicked and kept calling itself on a loop. I rebooted
> and was able to successfully resume the TuxOnIce image.
>
> The stack trace means little to me, but might be helpful to you.
>
> The photos are:
> kcryptd_oops [1,2,3] - TuxOnIce compress read -22 error
> kdb_oops [1,2,3,4] - KDB oopses when scrolling output of kdb ps command
>   

You don't happen to have the vmlinux file around which corresponded to
that crashed kernel do you?

If so, can you run:

addr2line -f -e vmlinux 0xffffffff81030512
addr2line -f -e vmlinux 0xffffffff810ad1d0
addr2line -f -e vmlinux 0xffffffff810add3c

And send me the output?

I have a pretty good idea about what the problem is but it would be
interesting to know the exact failure point if the vmlinux file will
tell us.    In a nut shell, the "ps" command in kdb does not use
probe_kernel_address() to safely read memory in all instances. 
Presently the ps function assumes that if the task struct was ok the
rest of memory accesses in this region would be ok as well.




> kdb_blows_up - final stack trace being shown in a cycle before PANIC:
>   
Once kdb oopses the system is pretty much toast.  There are some limited
things you can do at that point like at least get a stack trace so the
original problem can be found.

Jason.
