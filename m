Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1AVKEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 05:04:16 -0500
Received: from www.tglx.de ([62.245.132.106]:47912 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab1AVKEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 05:04:15 -0500
Date: Sat, 22 Jan 2011 11:01:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torben Hohn <torbenh@gmx.de>
cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com
Subject: Re: [PATCH 09/18] frv: switch do_timer() to xtime_update()
In-Reply-To: <1295651224-29823-10-git-send-email-torbenh@gmx.de>
Message-ID: <alpine.LFD.2.00.1101221051570.2971@localhost6.localdomain6>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de> <1295651224-29823-10-git-send-email-torbenh@gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011, Torben Hohn wrote:

> this code looks like its protecting __set_LEDS() with this lock also.
> i dont think thats necessary.

This changelog is horrible. 

This code does not look like protecting the __set_LEDS() call with the
xtime_lock. The call happens to be inside the xtime_lock held region.

Now instead of bringing up a weak argument "I dont think ..." you
should provide a proper analysis why it's safe to move that code out.

It's pretty simple:

No other call site of __set_LEDS() is protected by xtime_lock, so
xtime_lock does not protect anything related to __set_LEDS(). It's
just inside the xtime_lock region for no good reason at all.

Please be more careful when writing change logs, so a reviewer can
understand the reasoning behind your change easily.

Also all arch/* patches are missing a "Cc: arch-maintainer@somewhere.xxx".

>  {
> @@ -61,10 +61,11 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
>  	 * CPU. We need to avoid to SMP race with it. NOTE: we don't need
>  	 * the irq version of write_lock because as just said we have irq
>  	 * locally disabled. -arca
> +	 *
> +	 * xtime_update takes the writelock.

  Errm. xtime_update write locks xtime_lock. Please be careful with comments.

Thanks,

	tglx
