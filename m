Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1FFREq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:04:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:38900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1FFREn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:04:43 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <1307378649.2322.198.camel@twins>
References: <4DEB933C.1070900@die-jansens.de>
	 <20110605151323.GA30590@elte.hu> <1307349530.2353.7374.camel@twins>
	 <20110606145827.GD30348@elte.hu> <1307372989.2322.136.camel@twins>
	 <1307375227.2322.161.camel@twins> <20110606155236.GA7374@elte.hu>
	 <1307376039.2322.164.camel@twins> <20110606160810.GA16636@elte.hu>
	 <1307376771.2322.168.camel@twins>  <20110606161749.GA22157@elte.hu>
	 <1307378649.2322.198.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 19:04:31 +0200
Message-ID: <1307379871.2322.217.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 18:44 +0200, Peter Zijlstra wrote:
>  
> @@ -942,25 +953,13 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>                 if (*p == '\n')
>                         new_text_line = 1;
>         }
> +       spin_unlock(&logbuf_lock);
>  
> -       /*
> -        * Try to acquire and then immediately release the
> -        * console semaphore. The release will do all the
> -        * actual magic (print out buffers, wake up klogd,
> -        * etc). 
> -        *
> -        * The console_trylock_for_printk() function
> -        * will release 'logbuf_lock' regardless of whether it
> -        * actually gets the semaphore or not.
> -        */
> -       if (console_trylock_for_printk(this_cpu))
> -               console_unlock(); 

FWIW the existing printk recursion logic is broken, console_unlock()
clears printk_cpu but console_trylock_for_printk() can release
logbuf_lock and fail the trylock of console_sem, in which case a
subsequent printk() is perfectly valid and non-recursing.


