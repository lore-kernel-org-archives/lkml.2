Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab0JDVvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:51:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152Ab0JDVvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:51:42 -0400
Date: Mon, 4 Oct 2010 14:51:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] serial8250: ratelimit "too much work" error
Message-Id: <20101004145101.b28fdc0a.akpm@linux-foundation.org>
In-Reply-To: <20101002110438.801F49D401B@zog.reactivated.net>
References: <20101002110438.801F49D401B@zog.reactivated.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  2 Oct 2010 12:04:38 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> Running a serial console, if too many kernel messages are generated within
> a short time causing a lot of serial I/O, the 8250 driver will generate
> another kernel message reporting this, which just adds to the I/O. It has
> a cascading effect and quickly results the system being brought to its knees
> by a flood of "too much work" messages.
> 
> Ratelimit the error message to avoid this.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/serial/8250.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 24110f6..d3c5855 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -1606,8 +1606,9 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
>  
>  		if (l == i->head && pass_counter++ > PASS_LIMIT) {
>  			/* If we hit this, we're dead. */
> -			printk(KERN_ERR "serial8250: too much work for "
> -				"irq%d\n", irq);
> +			if (printk_ratelimit())
> +				printk(KERN_ERR "serial8250: too much work for "
> +					"irq%d\n", irq);
>  			break;
>  		}
>  	} while (l != end);

printk_ratelimit() shares a common ratelimiting state between all
callers of printk_ratelimit().  This is pretty sucky because if one
printk_ratelimit() caller is going crazy then this can cause punishment
of other unrelated printk_ratelimit() callers who *aren't* going crazy.

So it's generally better to use printk_ratelimited(), which will
ratelimit this printkand no other printk, without affecting other
printk_ratelimit[ed]() users.

So, this:

--- a/drivers/serial/8250.c~serial8250-ratelimit-too-much-work-error-fix
+++ a/drivers/serial/8250.c
@@ -1606,9 +1606,8 @@ static irqreturn_t serial8250_interrupt(
 
 		if (l == i->head && pass_counter++ > PASS_LIMIT) {
 			/* If we hit this, we're dead. */
-			if (printk_ratelimit())
-				printk(KERN_ERR "serial8250: too much work for "
-					"irq%d\n", irq);
+			printk_ratelimited(KERN_ERR
+				"serial8250: too much work for irq%d\n", irq);
 			break;
 		}
 	} while (l != end);
_

which, interestingly, doesn't compile because someone stuck a
DEFINE_RATELIMIT_STATE() in include/linux/kernel.h and it ain't defined
anywhere.  Let me fix that up...

