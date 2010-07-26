Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0GZKzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:55:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55018 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab0GZKzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:55:11 -0400
Date: Mon, 26 Jul 2010 06:51:48 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH] sysrq: don't hold the sysrq_key_table_lock during
 the handler
Message-ID: <20100726105148.GB14198@hmsreliant.think-freely.org>
References: <1280138042-1576-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280138042-1576-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 05:54:02PM +0800, Xiaotian Feng wrote:
> sysrq_key_table_lock is used to protect the sysrq_key_table, make sure
> we get/replace the right operation for the sysrq. But in __handle_sysrq,
> kernel will hold this lock and disable irqs until we finished op_p->handler().
> This may cause false positive watchdog alert when we're doing "show-task-states"
> on a system with many tasks.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  drivers/char/sysrq.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> index 878ac0c..0856e2e 100644
> --- a/drivers/char/sysrq.c
> +++ b/drivers/char/sysrq.c
> @@ -520,9 +520,11 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
>  		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
>  			printk("%s\n", op_p->action_msg);
>  			console_loglevel = orig_log_level;
> +			spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
>  			op_p->handler(key, tty);
>  		} else {
>  			printk("This sysrq operation is disabled.\n");
> +			spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
>  		}
>  	} else {
>  		printk("HELP : ");
> @@ -541,8 +543,8 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
>  		}
>  		printk("\n");
>  		console_loglevel = orig_log_level;
> +		spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
>  	}
> -	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
>  }
>  
>  void handle_sysrq(int key, struct tty_struct *tty)
> -- 
> 1.7.2
> 
> 

This creates the possibility of a race in the handler.  Not that it happens
often, but sysrq keys can be registered and unregistered dynamically.  If that
lock isn't held while we call the keys handler, the code implementing that
handler can live in a module that gets removed while its executing, leading to
an oops, etc.  I think the better solution would be to use an rcu lock here.
Neil

