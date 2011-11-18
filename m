Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1KRTBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:01:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1KRTBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:01:01 -0500
Date: Fri, 18 Nov 2011 11:01:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        James Morris <jmorris@namei.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kevin Cernekee <cernekee@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [PATCH] printk: Don't emit console_cpu_notify() for
 CPU_DYING
Message-Id: <20111118110100.1cedc784.akpm@linux-foundation.org>
In-Reply-To: <1321582764-22218-1-git-send-email-yong.zhang0@gmail.com>
References: <1321582764-22218-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 10:19:24 +0800
Yong Zhang <yong.zhang0@gmail.com> wrote:

> When running -rt, I got some warning when doing cpu hotplug,
> for details please check:
> http://marc.info/?l=linux-kernel&m=132143661616297&w=2
> 
> But seems the problem also exists in mainline, a typical
> scenario is:
> 
>         CPU A                           CPU B
> 
> doing printk with console_sem held
>                                 take_cpu_down();
>                                   cpu_notify(CPU_DYING);
>                                     console_cpu_notify();
>                                       console_lock();
>                                         down(&console_sem);
>                                           *BANG*
>   up(&console_sem);

This doesn't describe a deadlock.  For a deadlock to occur, something
must prevent CPU A from proceeding to the up().

Are you able to more fully describe this?  I'm suspecting that CPU A
got shut down by CPU B?  If so, shutting down a CPU while it holds
locks seems rather bad.  Or perhaps it's something else...


