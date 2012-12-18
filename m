Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2LRUBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:01:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2LRUBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:01:13 -0500
Date: Tue, 18 Dec 2012 12:01:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [Patch][resend] SGI-XP: Handle non-fatal traps.
Message-Id: <20121218120111.00d0adaf.akpm@linux-foundation.org>
In-Reply-To: <20121218175243.GP3452@sgi.com>
References: <20121218175243.GP3452@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, Linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org

It's stable@vger.kernel.org.

On Tue, 18 Dec 2012 11:52:43 -0600
Robin Holt <holt@sgi.com> wrote:

> We found a user code which was raising a divide-by-zero trap.  That trap
> would lead to XPC connections between system-partitions being torn down
> due to the die_chain notifier callouts it received.
> 
> This also revealed a different issue where multiple callers into
> xpc_die_deactivate() would all attempt to do the disconnect in parallel
> which would sometimes lock up but often overwhelm the console on very
> large machines as each would print at least one line of output at the
> end of the deactivate.
> 
> I reviewed all the users of the die_chain notifier and changed the code
> to ignore the notifier callouts for reasons which will not actually lead
> to a system to continue on to call die().
>
> ...
>
> --- linux.orig/drivers/misc/sgi-xp/xpc_main.c
> +++ linux/drivers/misc/sgi-xp/xpc_main.c
> @@ -53,6 +53,8 @@
>  #include <linux/kthread.h>
>  #include "xpc.h"
>  
> +#include <asm/traps.h>

You just broke ia64 ;)

As there was no cleaner alternative apparent to me, I did this:

--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-handle-non-fatal-traps-fix
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -53,7 +53,9 @@
 #include <linux/kthread.h>
 #include "xpc.h"
 
+#ifdef CONFIG_X86_64
 #include <asm/traps.h>
+#endif
 
 /* define two XPC debug device structures to be used with dev_dbg() et al */
 

But I worry that the change apparently hasn't been runtime tested on
ia64?


