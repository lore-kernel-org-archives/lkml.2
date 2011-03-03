Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1CCJMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:12:17 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48652 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab1CCJMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:12:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YRG7zkFsngJCY8b9ElbxxuGX00FX+RLyS5lVkaSVpTRDDFET9lIwpwOrU3PzhMZAHh
         XXvypHrzNl4D76NlcGICV5/CGLdLOX3FlCJcpIwOWPDdNxyg1D+z7xCWdvgsIPLASVtt
         3CUcUeP5Gu/l3E8QR/AQmptkIdM7Zz/J1CVx8=
MIME-Version: 1.0
In-Reply-To: <20110302181223.GD9288@home.goodmis.org>
References: <4D6BB403.9000908@ladisch.de>
	<20110302181223.GD9288@home.goodmis.org>
Date: Thu, 3 Mar 2011 17:12:12 +0800
Message-ID: <AANLkTi=q72vKVi0frZefzBAS2_CfHKqOtTadWvyhGwcE@mail.gmail.com>
Subject: Re: (WARNING) possible deadlock in del_timer_sync, called from fbcon_del_cursor_timer
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 2:12 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, Feb 28, 2011 at 03:41:07PM +0100, Clemens Ladisch wrote:
>> While using the FB console, I tried to change the console log level
>> with SysRq, and got this warning that del_timer_sync() is used in
>> an interrupt handler:
>
> Ug, del_timer_sync() can be called from interrupt context:
>
> printk -> vt_console_print -> hide_cursor -> fbcon_cursor
> -> fbcon_del_cursor_time -> del_timer_sync()
>
> printk is allowed to be called from interrupt context. This is indeed a
> true bug.

Yeah.

And more explanation for that WARN_ON() :)

run_timer_softirq(SOFTIRQ context)
  cursor_timer_handler()
  Interrupt comes in(IRQ context)
    ...
      del_timer_sync()
        deadlock

So fbcon guys:
Could above situation happen?

Cc'ing people from:
./scripts/get_maintainer.pl -f drivers/video/console/fbcon.c

Thanks,
Yong


-- 
Only stand for myself
