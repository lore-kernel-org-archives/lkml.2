Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1HQVW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:22:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630Ab1HQVWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:22:55 -0400
Date: Wed, 17 Aug 2011 14:22:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, "Don Zickus" <dzickus@redhat.com>,
        "Matthew Garrett" <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: pstore: change mutex locking to spin_locks
Message-Id: <20110817142225.8645fff7.akpm@linux-foundation.org>
In-Reply-To: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
References: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Aug 2011 10:54:51 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:

> From: Don Zickus <dzickus@redhat.com>
> 
> pstore was using mutex locking to protect read/write access to the
> backend plug-ins.  This causes problems when pstore is executed in
> an NMI context through panic() -> kmsg_dump().
> 
> This patch changes the mutex to a spin_lock_irqsave then also checks to
> see if we are in an NMI context.  If we are in an NMI and can't get the
> lock, just print a message stating that and blow by the locking.
> 
> All this is probably a hack around the bigger locking problem but it
> solves my current situation of trying to sleep in an NMI context.
> 
> Tested by loading the lkdtm module and executing a HARDLOCKUP which
> will cause the machine to panic inside the nmi handler.
> 
> ...
>
> +	if (in_nmi()) {
> +		is_locked = spin_trylock(&psinfo->buf_lock);
> +		if (!is_locked)
> +			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
> +	} else
> +		spin_lock_irqsave(&psinfo->buf_lock, flags);
>  	oopscount++;
>  	while (total < kmsg_bytes) {
>  		dst = psinfo->buf;
> @@ -123,7 +131,11 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>  		total += l1_cpy + l2_cpy;
>  		part++;
>  	}
> -	mutex_unlock(&psinfo->buf_mutex);
> +	if (in_nmi()) {
> +		if (is_locked)
> +			spin_unlock(&psinfo->buf_lock);
> +	} else
> +		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
>  }

It's still bad if lockdep is enabled.  See
kernel/lockdep.c:lock_acquire() and lock_release().  They aren't
NMI-safe.

One approach would be to switch to bit_spin_lock().  Which will break
if/when bit spinlocks get lockdep-enabled, so don't do that.

A better approach would be to use the underlying spinlock functions
which bypass lockdep, but I cannot immediately locate those amongst
the misama of spinlock interface mess.

This problem of locking-vs-NMIs has been "solved" several times before
but I don't recall any standardized approach being developed.  Does
anyone have a favorite implementation to look at?
