Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab0DATv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:51:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758116Ab0DATvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:51:55 -0400
Date: Thu, 1 Apr 2010 12:51:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/12] drivers/char/amiserial.c: Add missing
 local_irq_restore
Message-Id: <20100401125131.8c9539e2.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.1003291733530.21896@ask.diku.dk>
References: <Pine.LNX.4.64.1003291733530.21896@ask.diku.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 17:34:11 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Add local_irq_restore after the labels that can be reached after a
> local_irq_save.
> 
> A simplified version of the semantic patch that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> expression E1;
> identifier f;
> @@
> 
> f (...) { <+...
> * local_irq_save (E1,...);
> ... when != E1
> * return ...;
> ...+> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/char/amiserial.c            |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
> index 6c32fbf..2131ecb 100644
> --- a/drivers/char/amiserial.c
> +++ b/drivers/char/amiserial.c
> @@ -2056,6 +2056,7 @@ fail_free_irq:
>  	free_irq(IRQ_AMIGA_TBE, state);
>  fail_unregister:
>  	tty_unregister_driver(serial_driver);
> +	local_irq_restore(flags);
>  fail_release_mem_region:
>  	release_mem_region(CUSTOM_PHYSADDR+0x30, 4);
>  fail_put_tty_driver:

We shouldn't be calling tty_unregister_driver() with local interrupts
disabled - it does mutex_lock() (at least), which will emit a
might_sleep() warning (at least).

I don't expect there was any need to disable irq's across the
request_irq() calls (?), hence:



From: Julia Lawall <julia@diku.dk>

rs_init() is failing to restore interrupts on two error paths, and is
incorrectly calling tty_unregister_driver() with local interrupts
disabled.

Fix these things by disabling interrupts later, after the reauest_irq()
calls.


A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* local_irq_save (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

[akpm@linux-foundation.org: reimplement the fix]
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/amiserial.c~drivers-char-amiserialc-add-missing-local_irq_restore drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~drivers-char-amiserialc-add-missing-local_irq_restore
+++ a/drivers/char/amiserial.c
@@ -2021,8 +2021,6 @@ static int __init rs_init(void)
 	state->baud_base = amiga_colorclock;
 	state->xmit_fifo_size = 1;
 
-	local_irq_save(flags);
-
 	/* set ISRs, and then disable the rx interrupts */
 	error = request_irq(IRQ_AMIGA_TBE, ser_tx_int, 0, "serial TX", state);
 	if (error)
@@ -2033,6 +2031,8 @@ static int __init rs_init(void)
 	if (error)
 		goto fail_free_irq;
 
+	local_irq_save(flags);
+
 	/* turn off Rx and Tx interrupts */
 	custom.intena = IF_RBF | IF_TBE;
 	mb();
_

