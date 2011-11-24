Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1KXNXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 08:23:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56372 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab1KXNXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 08:23:16 -0500
Message-ID: <1322140980.2921.49.camel@twins>
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Jason Baron <jbaron@redhat.com>, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 24 Nov 2011 14:23:00 +0100
In-Reply-To: <20111121131739.GF16853@redhat.com>
References: <20111117123029.GB16853@redhat.com>
	 <1321534159.27735.33.camel@twins> <20111121131739.GF16853@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 15:17 +0200, Gleb Natapov wrote:
> So how about throttling it like the patch below does until stop_machine()
> no longer needed for patching (and it is possible that new way of patching
> will still have significant overhead).
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index 66f23dc..a4687f6 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -3,12 +3,15 @@
>  
>  #include <linux/types.h>
>  #include <linux/compiler.h>
> +#include <linux/workqueue.h>
>  
>  #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
>  
>  struct jump_label_key {
>         atomic_t enabled;
>         struct jump_entry *entries;
> +       unsigned long rl_timeout;
> +       struct delayed_work rl_work;
>  #ifdef CONFIG_MODULES
>         struct jump_label_mod *next;


I'm not sure its worth it doing in generic code like this, it bloats the
jump_label_key structure quite significantly (and there's tons of those
around) for only 1 real user.

If we want to do this in generic code, I think its best to introduce
something like:

struct jump_label_key_deferred {
	struct jump_label_key key;
	unsigned long timeout;
	struct delayed_work work;
}

But is there really any other user for this? All the trace bits are root
only iirc and kvm itself only sets them on the guest kernel I think for
paravirt, so that's not a problem.


