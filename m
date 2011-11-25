Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1KYLsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 06:48:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:53540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1KYLsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 06:48:21 -0500
Subject: Re: [PATCH] printk: fix recursion of logbuf_lock spinlock
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1322161455-21242-1-git-send-email-aarcange@redhat.com>
References: <1322161455-21242-1-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 12:49:06 +0100
Message-ID: <1322221746.2535.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 20:04 +0100, Andrea Arcangeli wrote:
>  kernel/printk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 1455a0d..fc3c831 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1259,9 +1259,9 @@ void console_unlock(void)
>  
>         console_may_schedule = 0;
>  
> -again:
>         for ( ; ; ) {
>                 raw_spin_lock_irqsave(&logbuf_lock, flags);
> +again:
>                 wake_klogd |= log_start - log_end;
>                 if (con_start == log_end)
>                         break;                  /* Nothing to print */ 

The better change would be the below one, since that avoid doing
console_trylock() while holding logbuf_lock. The problem is that
console_trylock() can do up() and thus result in a wakeup while holding
logbuf_lock and we're trying to get rid of locks nested under
logbug_lock.

---
Subject: printk: Avoid double lock acquire

Commit 4f2a8d3cf5e ("printk: Fix console_sem vs logbuf_lock unlock
race") introduced another silly bug where we would want to acquire an
already held lock. Avoid this.

Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index dfd8f73..187662f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1292,10 +1292,11 @@ void console_unlock(void)
 	raw_spin_lock(&logbuf_lock);
 	if (con_start != log_end)
 		retry = 1;
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
 	if (retry && console_trylock())
 		goto again;
 
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 	if (wake_klogd)
 		wake_up_klogd();
 }


