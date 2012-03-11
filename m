Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2CKRi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 13:38:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59229 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab2CKRiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 13:38:24 -0400
Message-ID: <1331487502.2449.20.camel@edumazet-laptop>
Subject: Re: [V2 PATCH 1/3] module: use rcu to protect module list read
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 11 Mar 2012 10:38:22 -0700
In-Reply-To: <1331463255-31019-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331463255-31019-1-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 11 mars 2012 à 18:54 +0800, Cong Wang a écrit :
> V2:
...
>  
> @@ -1639,7 +1639,7 @@ static void mod_sysfs_teardown(struct module *mod)
>  static int __unlink_module(void *_mod)
>  {
>  	struct module *mod = _mod;
> -	list_del(&mod->list);
> +	list_del_rcu(&mod->list);
>  	module_bug_cleanup(mod);
>  	return 0;
>  }
> @@

You mix too many different things in a single patch. 

For example, lets review this __unlink_module() change...

If this was really needed, it should be a single patch so that it can be
a stable submission.

As it is not needed (since its called from stop_machine()), this makes
your whole patch looking suspicious.

I suggest you make a 100% cleanup patch, changing the title as well,
because module code _already_ uses RCU.

"module: use rcu to protect module list read" makes no sense at all.

To meet current RCU API best pratices, you change preempt_enable() by
rcu_read_unlock_sched() and preempt_disable() by rcu_read_lock_sched()

Then, if you believe other changes are needed, submit them with an
explicit changelog explaining the change, not hiding them in a big
cleanup patch.

Ref: Documentation/SubmittingPatches section 3)



