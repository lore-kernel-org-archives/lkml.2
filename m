Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab2EZHQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:16:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:45352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2EZHQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:16:12 -0400
Message-ID: <1338016564.14636.4.camel@twins>
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in tty_lock_pair(v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
Date: Sat, 26 May 2012 09:16:04 +0200
In-Reply-To: <1338000869-15129-1-git-send-email-ming.lei@canonical.com>
References: <1338000869-15129-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-26 at 10:54 +0800, Ming Lei wrote:
> From: Ming Lei <tom.leiming@gmail.com>

> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Oh very much not!

> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
> v3:
> 	fix unlock order in tty_unlock_pair
> 
>  drivers/tty/tty_mutex.c |   28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
> index 69adc80..c7f4523 100644

> @@ -43,11 +49,14 @@ void __lockfunc tty_lock_pair(struct tty_struct *tty,
>  {
>  	if (tty < tty2) {
>  		tty_lock(tty);
> -		tty_lock(tty2);
> +		tty_lock_nested(tty2, SINGLE_DEPTH_NESTING);
>  	} else {
> -		if (tty2 && tty2 != tty)
> +		int nested = 0;
> +		if (tty2 && tty2 != tty) {
>  			tty_lock(tty2);
> -		tty_lock(tty);
> +			nested = SINGLE_DEPTH_NESTING;
> +		}
> +		tty_lock_nested(tty, nested);
>  	}
>  }
>  EXPORT_SYMBOL(tty_lock_pair);


I've still to hear what's wrong with a simple:


  if (!tty2 || tty == tty2) {
	tty_lock(tty);
	return;
  }

  if (tty > tty2)
	swap(tty, tty2);

  tty_lock(tty);
  tty_lock_nested(tty2, SINGLE_DEPTH_NESTING);


That's a lot more readable than the proposed code.

> @@ -55,8 +64,13 @@ EXPORT_SYMBOL(tty_lock_pair);
>  void __lockfunc tty_unlock_pair(struct tty_struct *tty,
>  						struct tty_struct *tty2)
>  {
> -	tty_unlock(tty);
> -	if (tty2 && tty2 != tty)
> +	if (tty < tty2) {
>  		tty_unlock(tty2);
> +		tty_unlock(tty);
> +	} else {
> +		tty_unlock(tty);
> +		if (tty2 && tty2 != tty)
> +			tty_unlock(tty2);
> +	}
>  }
>  EXPORT_SYMBOL(tty_unlock_pair);

This is complete crap, unlock order doesn't matter.

