Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0DHMOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 08:14:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49038
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754341Ab0DHMOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:14:50 -0400
Date: Thu, 08 Apr 2010 05:14:53 -0700 (PDT)
Message-Id: <20100408.051453.231567150.davem@davemloft.net>
To: mschnell@lumino.de
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       nios2-dev@sopc.et.ntust.edu.tw
Subject: Re: atomic RAM ?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BBDC7D4.6040301@lumino.de>
References: <4BBD86A5.5030109@lumino.de>
	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>
	<4BBDC7D4.6040301@lumino.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Schnell <mschnell@lumino.de>
Date: Thu, 08 Apr 2010 14:11:00 +0200

> If one thread locks the "cpu_atomic_instruction_lock" and now the Kernel
> does a task switch and now a second thread tries to lock it as well,
> same would need to do a kernel call to do the waiting.

Using the spinlock array idea also doesn't work in userspace
because any signal handler that tries to do an atomic on the
same object will deadlock on the spinlock.

You'll have have to do this entirely in the kernel, and your
FUTEX implementation will have to always make the futex()
system call.

It's the only way to do this and have it work completely.

We have to do something similar on sparc32, and the signal handler
deadlocks are very real, many glibc testcases that use threads
and pthread mutexes will deadlock because of this very issue if
you try to do the spinlock trick in userspace.
