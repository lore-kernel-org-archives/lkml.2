Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab0JSU6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:58:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab0JSU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:58:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
Date: Tue, 19 Oct 2010 22:58:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-next-20101015+; KDE/4.5.1; x86_64; ; )
Cc: "Ohad Ben-Cohen" <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Simon Que <sque@ti.com>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com> <AANLkTimDdPUjo+65vBL0PTQ3b=5NpeVT28XrdkYqx3Ex@mail.gmail.com> <AANLkTinNfERyi_bTWc7LOKR1uRLC3E612ubFKBLxWB1E@mail.gmail.com>
In-Reply-To: <AANLkTinNfERyi_bTWc7LOKR1uRLC3E612ubFKBLxWB1E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010192258.27988.arnd@arndb.de>
X-Provags-ID: V02:K0:gUTvxmrPETi/r7zUqzwhWoMItCwvGo/lKDdrX0sSNYE
 L+EjO+bLgjYdaw4A4NlzueDJjYFT4qfMkALQwCmRJiV0pzBU+Z
 +FTguVuCD8fK0fIG6JHzp1B5b8ivBh/YC4v/tZy0eOidkbvXTO
 QYr4hOFo5fzm7RG4ylhjTgFWSzJupSdySy1tFVmWOLkz3Q953x
 UGXd7fq/ghyIZSnWg1Fbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 October 2010 22:43:34 Ohad Ben-Cohen wrote:
> > Disabling irqs might be a concern as a source of RT latency.  It
> > might be better to make the caller responsible for managing local spin
> > locks and irq disable/enable.
> 
> This a coming from an hardware requirement, rather than a choice the
> user should take.
> 
> If a hwspinlock is taken over a long period of time, its other user
> (with which we try to achieve synchronization) might be polling the
> OMAP interconnect for too long (trying to take the hwspinlock) and
> thus preventing it to be used for other transactions.

This sounds exactly like any other spinlock.

> To prevent such lengthy polling on the interconnect, the hwspinlock
> should only be used for very short period of times, with preemption
> and interrupts disabled.

Interrupts disabled in general might go a bit too far -- they are also
short and infrequent events unless you have seriously broken drivers.

When running with CONFIG_PREEMPT, I would guess you actually want to
turn the omap_hwspinlock into a sleeping operation, though that would
require much extra work to implement. Disabling preemption while the
hwspinlock is held is of course a correct implementation technically,
but it might not be what someone enabling CONFIG_PREEMPT expects.

> That's why we don't give users the choice whether to disable
> interrupts or not - it's simply not a decision they should take.

What about those cases where you already know that interrupts are
disabled, e.g. while holding a regular spin_lock_irq or inside
of an interrupt handler?

	Arnd
