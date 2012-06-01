Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab2FASRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:17:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35859 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402Ab2FASRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:17:12 -0400
Subject: Re: [PATCH] tty: add lockdep annotations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1338456918.2760.1318.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
	 <1338456918.2760.1318.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jun 2012 20:17:07 +0200
Message-ID: <1338574627.2760.1545.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 11:35 +0200, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> tty_lock_pair() do the right thing to avoid deadlocks, but should
> instruct LOCKDEP of this to avoid a splat. 
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
> Latest Linus tree still hang on my machine, at least this patch removes
> the lockdep problem...

About 10% of boots on my machine, and this looks like (hand written)

general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
...
RIP : tty_shutdown+0x15/)x70

Call Trace:

	con_shutdown+0x3e/0x50
	queue_release_one_tty+0x24/0x70
	tty_kref_put+0x28/0x30
	tty_unlock+0x2a/0x60
	tty_open+0x4d8/0x620
	chrdev_open+0xb1/0x1a0
...

Sometime stack is :
memset()
alloc_tty_struct
pty_unix98_install
tty_init_dev
ptmx_open
chrdev_open


I suspect a refcounting problem, but am not familiar enough with tty
code....



