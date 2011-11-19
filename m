Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987Ab1KSFQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 00:16:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62627 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1KSFQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 00:16:03 -0500
Date: Sat, 19 Nov 2011 13:15:37 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        James Morris <jmorris@namei.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kevin Cernekee <cernekee@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [PATCH] printk: Don't emit console_cpu_notify() for
 CPU_DYING
Message-ID: <20111119051537.GA2163@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1321582764-22218-1-git-send-email-yong.zhang0@gmail.com>
 <20111118110100.1cedc784.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111118110100.1cedc784.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 11:01:00AM -0800, Andrew Morton wrote:
> On Fri, 18 Nov 2011 10:19:24 +0800
> Yong Zhang <yong.zhang0@gmail.com> wrote:
> 
> > When running -rt, I got some warning when doing cpu hotplug,
> > for details please check:
> > http://marc.info/?l=linux-kernel&m=132143661616297&w=2
> > 
> > But seems the problem also exists in mainline, a typical
> > scenario is:
> > 
> >         CPU A                           CPU B
> > 
> > doing printk with console_sem held
> >                                 take_cpu_down();
> >                                   cpu_notify(CPU_DYING);
> >                                     console_cpu_notify();
> >                                       console_lock();
> >                                         down(&console_sem);
> >                                           *BANG*
> >   up(&console_sem);
> 
> This doesn't describe a deadlock.  For a deadlock to occur, something
> must prevent CPU A from proceeding to the up().

Hmm, after revisting the code, seems console_unlock() can't be
preempted when helding console_sem. IOW, stop_machine() can't
run if someone loops in printing something.

So the problem only affect -rt, sorry for the noise.

Thanks,
Yong

> 
> Are you able to more fully describe this?  I'm suspecting that CPU A
> got shut down by CPU B?  If so, shutting down a CPU while it holds
> locks seems rather bad.  Or perhaps it's something else...
