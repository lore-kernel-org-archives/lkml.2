Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1FFQu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:50:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:55540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1FFQu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:50:56 -0400
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
Date: Mon, 06 Jun 2011 18:50:48 +0200
Message-ID: <1307379048.2322.199.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 18:44 +0200, Peter Zijlstra wrote:
> +void printk_tick(void)
> +{
> +       if (!__this_cpu_read(printk_pending))
> +               return;
> +
> +       /*
> +        * Try to acquire and then immediately release the
> +        * console semaphore. The release will do all the
> +        * actual magic (print out buffers, wake up klogd,
> +        * etc). 
> +        */
> +       if (console_trylock_for_printk(smp_processor_id())) {
> +               console_unlock();
> +               __this_cpu_write(printk_pending, 0);
> +       }
> +} 

Aside from not compiling (someone stuck a ref to wake_up_klogd somewhere
in lib/) this does delay the whole of printk() output by up to a jiffy,
if the machine dies funny you could be missing large parts of the
output :/


