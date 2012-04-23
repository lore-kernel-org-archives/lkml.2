Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2DWVyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:54:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2DWVyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:54:33 -0400
Date: Mon, 23 Apr 2012 14:54:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] spinlock_debug: Print kallsyms name for lock
Message-Id: <20120423145431.617c2b01.akpm@linux-foundation.org>
In-Reply-To: <1335217525-30709-2-git-send-email-sboyd@codeaurora.org>
References: <1335217525-30709-1-git-send-email-sboyd@codeaurora.org>
	<1335217525-30709-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012 14:45:25 -0700
Stephen Boyd <sboyd@codeaurora.org> wrote:

> When a spinlock warning is printed we usually get
> 
>  BUG: spinlock bad magic on CPU#0, modprobe/111
>   lock: 0xdff09f38, .magic: 00000000, .owner: /0, .owner_cpu: 0
> 
> but it's nicer to print the symbol for the lock if we have it so
> that we can avoid 'grep dff09f38 /proc/kallsyms' to find out
> which lock it was. Use kallsyms to print the symbol name so we
> get something a bit easier to read
> 
>  BUG: spinlock bad magic on CPU#0, modprobe/112
>   lock: test_lock, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> 
> If the lock is not in kallsyms %ps will fall back to printing the address
> directly.

hm.  Is this true?  From my reading of kallsyms_lookup(), it will fall
into module_address_lookup() whcih is a no-op if !CONFIG_MODULES.

> --- a/lib/spinlock_debug.c
> +++ b/lib/spinlock_debug.c
> @@ -58,7 +58,7 @@ static void spin_dump(raw_spinlock_t *lock, const char *msg)
>  	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
>  		msg, raw_smp_processor_id(),
>  		current->comm, task_pid_nr(current));
> -	printk(KERN_EMERG " lock: %p, .magic: %08x, .owner: %s/%d, "
> +	printk(KERN_EMERG " lock: %ps, .magic: %08x, .owner: %s/%d, "
>  			".owner_cpu: %d\n",
>  		lock, lock->magic,
>  		owner ? owner->comm : "<none>",

Maybe.  It will only do useful things for statically-allocated locks
which are rare and which we are unlikely to screw up as easily as locks
which lie in dynamically allocated memory.
