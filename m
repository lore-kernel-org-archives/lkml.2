Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1KQF3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:29:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35771 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1KQF3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:29:18 -0500
Date: Thu, 17 Nov 2011 13:29:06 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH -rt] printk: Don't emit console_cpu_notify() for CPU_DYING
Message-ID: <20111117052906.GC14492@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20111116094219.GA9281@zhy>
 <1321453190.4181.21.camel@frodo>
 <alpine.LFD.2.02.1111161547560.4902@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111161547560.4902@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 03:48:11PM +0100, Thomas Gleixner wrote:
> On Wed, 16 Nov 2011, Steven Rostedt wrote:
> > Thomas, doesn't printk not print to serial in atomic contexts? Or did

I guess you mean console_trylock_for_printk() will fail in atomic context?
If so, yeah, that doesn't change.

But the issue is console_cpu_notify() call console_lock() directly.
That means below scenario could also happen in mainline:

	CPU A				CPU B

doing printk with console_sem held
				take_cpu_down();
				  cpu_notify(CPU_DYING);
				    console_cpu_notify();
				      console_lock();
				        down(&console_sem);
					  *bang*
  up(&console_sem);

Sounds I should also send this patch to mainline.

Thanks,
Yong
