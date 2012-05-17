Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762363Ab2EQS2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:28:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56810 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762338Ab2EQS2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:28:35 -0400
Date: Thu, 17 May 2012 11:28:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in tty_lock_pair
Message-ID: <20120517182830.GA5254@kroah.com>
References: <1337234296-23313-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337234296-23313-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 01:58:16PM +0800, Ming Lei wrote:
> Commit d29f3ef39be4eec0362b985305fc526d9be318cf(tty_lock:
> Localise the lock) introduces tty_lock_pair, in which
> may cause lockdep warning because two locks with same lock
> class are to be acquired one after another.
> 
> This patch uses mutex_lock_nest_lock annotation to avoid
> the warning.
> 
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/tty/tty_mutex.c |   21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
> index 69adc80..079f9d7 100644
> --- a/drivers/tty/tty_mutex.c
> +++ b/drivers/tty/tty_mutex.c
> @@ -10,6 +10,18 @@
>   * Getting the big tty mutex.
>   */
>  
> +static void __lockfunc tty_lock_nest_lock(struct tty_struct *tty,
> +		struct tty_struct *tty2)

Duplicating tty_lock() just for this one issue seems wrong and prone to
error, don't you think?

> +{
> +	if (tty->magic != TTY_MAGIC) {
> +		printk(KERN_ERR "L Bad %p\n", tty);
> +		WARN_ON(1);
> +		return;
> +	}
> +	tty_kref_get(tty);
> +	mutex_lock_nest_lock(&tty->legacy_mutex, &tty2->legacy_mutex);
> +}
> +
>  void __lockfunc tty_lock(struct tty_struct *tty)
>  {
>  	if (tty->magic != TTY_MAGIC) {
> @@ -43,11 +55,14 @@ void __lockfunc tty_lock_pair(struct tty_struct *tty,
>  {
>  	if (tty < tty2) {
>  		tty_lock(tty);
> -		tty_lock(tty2);
> +		tty_lock_nest_lock(tty2, tty);
>  	} else {
> -		if (tty2 && tty2 != tty)
> +		if (tty2 && tty2 != tty) {
>  			tty_lock(tty2);
> -		tty_lock(tty);
> +			tty_lock_nest_lock(tty, tty2);

This is wonky, and confusing, don't you think?

I don't like it, surely there's a better way to solve this?

thanks,

greg k-h
