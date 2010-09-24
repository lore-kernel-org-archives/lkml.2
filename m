Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0IXAo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 20:44:57 -0400
Received: from ozlabs.org ([203.10.76.45]:50158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab0IXAo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 20:44:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 03/11] jump label: Base patch for jump label
Date: Fri, 24 Sep 2010 10:14:34 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <20100923034910.867858597@goodmis.org> <20100923154852.GA12648@Krystal> <20100923184006.GE2825@redhat.com>
In-Reply-To: <20100923184006.GE2825@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009241014.35644.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 04:10:06 am Jason Baron wrote:
> @@ -2749,8 +2750,10 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
>  	mod->symtab = mod->core_symtab;
>  	mod->strtab = mod->core_strtab;
>  #endif
> -	module_free(mod, mod->module_init);
> +	init_code = mod->module_init;
>  	mod->module_init = NULL;
> +	synchronize_rcu();
> +	module_free(mod, init_code);
>  	mod->init_size = 0;
>  	mod->init_text_size = 0;
>  	mutex_unlock(&module_mutex);

When a patch requires more lkml mails than it has lines, it needs a comment.

But step back for a moment: what prompts the jump label update?  Why isn't
that simply done under the module lock, obviating any complexity?

If you're frobbing kernel text all over the place, you probable want the
module lock.  You wouldn't be the first: perhaps we should rename that to
kernel_text_lock...

Apologies if that's a dumb question,
Rusty.
