Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab0JYUb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:31:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52653 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986Ab0JYUb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:31:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH] n_hdlc fix read and write locking
Date: Mon, 25 Oct 2010 22:31:06 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36+; KDE/4.5.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1288030959.19909.28.camel@x2.microgate.com>
In-Reply-To: <1288030959.19909.28.camel@x2.microgate.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010252231.06794.arnd@arndb.de>
X-Provags-ID: V02:K0:ISiTpzVYZOpnlkReOvOqnxDt/9x/aMcD2LK6b5Q1EN7
 QyfUbM1l8Kzp2+uYrFi9c4wNWcILPfSs5QrWgwFzsnnakNpXjj
 TdOUhhxB888hKwKD52mLqRadFcQBBVHYNDxdiPC+fJMMbQNPGc
 ALEIpyNKRjW9y3QNhhotwloPI8a8KcElm4QMFC9XyGcIm3tR7s
 Nsb4XGtEJboRXXveRu0dg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 October 2010 20:22:39 Paul Fulghum wrote:
> Fix locking in read and write code of n_hdlc line discipline.
> 
> 2.6.36 replaced lock_kernel() with tty_lock().
> The tty mutex is not dropped automatically when the thread
> sleeps like the BKL. This results in a blocked read or write holding
> the tty mutex and stalling operations by other devices that use
> the tty mutex.
> 
> A review of n_hdlc read and write code shows:
> 1. neither BKL or tty mutex are required for correct operation
> 2. read can block while read data is available if data is posted
>    between availability check and call to interruptible_sleep_on()
> 3. write does not set process state to TASK_INTERRUPTIBLE
>    on each pass through the processing loop which can cause
>    unneeded scheduling of the thread

Right. I must have missed this when I was not checking for
interruptible_sleep_on(). I did systematically check for
this problem with the wait_event family as well as
work_queues, mutexes, semaphores and hand-written schedule
loops, but for some reason I did not check for sleep_on :(

I've double-checked it now, and it seems that all other
instances of sleep_on are waiting for close_wait in
block_til_ready or open functions, and I remember that
I did check those and convinced myself that they are fine.

> Write corrected to set process state to
> TASK_INTERRUPTIBLE on each pass through processing loop.

Would it be possible to express the same using
wait_event_interruptible()?

	Arnd
