Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1DDOke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 10:40:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60268 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1DDOkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:40:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Thilo-Alexander Ginkel" <thilo@ginkel.com>
Subject: Re: Soft lockup during suspend since ~2.6.36
Date: Mon, 4 Apr 2011 16:40:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com> <201104040502.52526.arnd@arndb.de> <BANLkTi=n4jLsjOYCd0L3hYb30sgPmdv_WA@mail.gmail.com>
In-Reply-To: <BANLkTi=n4jLsjOYCd0L3hYb30sgPmdv_WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104041640.15578.arnd@arndb.de>
X-Provags-ID: V02:K0:j4Td/gsXYpR5ZBeaQdrZsatGYWKnnC8+5abz19sgpME
 HO624gKKueOSAUupO6Id/9j52djbEii+zADCjRsSUUe3iOw4mc
 FzOSQDARI0+HhWmrkYZ/ZUXAGHZ4dS3KunBrwVSToxI68jtGye
 F8e/uRZeUiHhk05ZGt4Tujfi0dIzCCXoKBnp8FfLwkPy/l7ZCd
 OcmtdQNE8GTeduQQ6hEJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 April 2011, Thilo-Alexander Ginkel wrote:
> On Mon, Apr 4, 2011 at 05:02, Arnd Bergmann <arnd@arndb.de> wrote:

> Unfortunately, the output via a serial console becomes garbled after
> "Entering mem sleep", so I went for patching dumpstack_64.c and a
> couple of other source files to reduce the verbosity. I hope not to
> have stripped any essential information. The result is available in
> these pictures:
>   https://secure.tgbyte.de/dropbox/IeZalo4t-1.jpg
>   https://secure.tgbyte.de/dropbox/IeZalo4t-2.jpg
> 
> For both traces, the printed error message reads: "BUG: soft lockup -
> CPU#3 stuck for 67s! [kblockd:28]"
> 
> (After a bit of Googling I understand that a soft lockup is probably
> different from a deadlock - please correct me if that assumption is
> wrong)

My interpretation is that some process tries to use
kblockd_schedule_work() after the CPU for that workqueue has been
disabled. The work queue functions (worker_maybe_bind_and_lock)
is waiting for the CPU to become available, which it doesn't do.

You see different outputs every time the softlockup detection finds
this because the loop is in different states here. The reason why
the spin_unlock shows up here is because that is when the interrupts
get enabled and the softlockup detection notices the timeout.

I'm pretty sure that this has nothing to do with the bisected bug
that you initially found, but maybe somebody else can try analysing
this better.

> > Yet another idea would be to set /sys/kernel/printk_delay so that the
> > oops gets printed slower.
> 
> Hm, that file does not exist on my machine. Does it need a special
> compile-time config  option to be enabled?

Sorry, I meant /proc/sys/kernel/printk_delay.

	Arnd
