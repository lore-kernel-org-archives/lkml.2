Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2CBPWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:22:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56641 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab2CBPWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:22:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dennis Chen <kernel.org.gnu@gmail.com>
Subject: Re: [PATCH] <down,down_interruptible...>, kernel <3.2.9>
Date: Fri, 2 Mar 2012 15:22:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <CA+U0gVhRUv_dWkO2yntsLvG_L727c=0zrVRkN_ceiPUwoAGbBg@mail.gmail.com>
In-Reply-To: <CA+U0gVhRUv_dWkO2yntsLvG_L727c=0zrVRkN_ceiPUwoAGbBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021522.10518.arnd@arndb.de>
X-Provags-ID: V02:K0:TVWRjOYriJi8Xn6lz1vCvhRtgJoHQkuODzAHAcPt648
 4X+enlN7/hHVBfcA2dIXgVCSngbCblyZlkfFyaRFgId+3Z2HfB
 QLzapJOtDK1R/I7KxOXs0lv7xTtADROspjgHq+3uFBkkLKUvyf
 iuTPdYznF9nUEVxbie/tCTsJQyxAL0T805fI0Xb9BY/Ex4dhie
 oPC7pKhExBjWueqHDZoXnIUWdVucE22RK4Wkv6gGHA86KkHOOL
 I4J1lYP7ZqSeW4KgT/Z0Ny5tRZJN7ciizUp8h927y07KNszK9I
 Mh1Nz0pK6sK+4Ck+iDgSxEuULFW71Eeb71VklQo48/GmNBXxgw
 7t5KAtFTwxkPjr068l8Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2012, Dennis Chen wrote:
> Current down family functions use mismatch spin_lock pairs, this will
> incur some interrupt state chaos, for example,
> down_interruptible --
>      spin_lock_irqsave(&sem->lock, flags);              P1
>            __down_common--
>                  spin_unlock_irq(&sem->lock);              P2
>                 timeout = schedule_timeout(timeout);
>                 spin_lock_irq(&sem->lock);                  P3
> 
>      spin_unlock_irqrestore(&sem->lock, flags);       P4
> 
> Suppose 2 kernel thread A and B in an UP system call
> down_interruptible to get the semaphore, if the irq is OFF before A
> calls, in the section between P2 and P3,  the irq will be turned _ON_,
> then B begins to call down_interruptible, it will save a flag
> indicating irq is _ON_. So after A finish the path of
> down_interruptible, the irq is still _OFF_, but when B wakes up and
> finish the path, the irq will be _ON_. Actually, irq should be in on
> state before any down_interruptible calling, so
> spin_lock_irqsave/irqrestore is not necessary. Given it will make
> confusion for the reason of unmatched spin_lock pairs between
> down_interruptible and __down_common, so it's reason for the patch.
> Any comments?

You are right that the spin_lock_irqsave is unnecessary because
down() can only be called in non-atomic state with interrupts enabled.
Your patch will be tiny performance improvement on architectures where
saving the interrupt state does not come for free.

However, there is nothing in the code where we can end up with an
unexpected state, because both threads have their own copy of the
'flags' variable, which always contains the enabled state that gets
restored upon leaving the functions.

	Arnd
