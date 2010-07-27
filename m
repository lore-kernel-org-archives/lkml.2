Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0G0IQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:16:00 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44313 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab0G0IP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A9nsHN1jwAfOP+uKtZVJitAPKye6mN8TGO1MUIopxdmXCfhFzQM0/0FWZWDU1VTkYe
         WuQMIyLaBk+pJeTJYoVLEW/KirgGygYuLwikJx6GVNo91BEzOKsCqEz3sLYWD2H83lkG
         SSGZE4vTD0Eep6bYd13+kWpLXmgxzr9xKeYXg=
Date: Tue, 27 Jul 2010 01:15:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH] sysrq: don't hold the sysrq_key_table_lock during
 the handler
Message-ID: <20100727081552.GB32084@core.coreip.homeip.net>
References: <1280138042-1576-1-git-send-email-dfeng@redhat.com>
 <20100726105148.GB14198@hmsreliant.think-freely.org>
 <20100726174153.GD14609@core.coreip.homeip.net>
 <20100726203420.GB18789@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726203420.GB18789@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 04:34:20PM -0400, Neil Horman wrote:
> On Mon, Jul 26, 2010 at 10:41:54AM -0700, Dmitry Torokhov wrote:
> > On Mon, Jul 26, 2010 at 06:51:48AM -0400, Neil Horman wrote:
> > > On Mon, Jul 26, 2010 at 05:54:02PM +0800, Xiaotian Feng wrote:
> > > > sysrq_key_table_lock is used to protect the sysrq_key_table, make sure
> > > > we get/replace the right operation for the sysrq. But in __handle_sysrq,
> > > > kernel will hold this lock and disable irqs until we finished op_p->handler().
> > > > This may cause false positive watchdog alert when we're doing "show-task-states"
> > > > on a system with many tasks.
> > > > 
> > > > Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> > > > Cc: Ingo Molnar <mingo@elte.hu>
> > > > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Cc: Neil Horman <nhorman@tuxdriver.com>
> > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > ---
> > > >  drivers/char/sysrq.c |    4 +++-
> > > >  1 files changed, 3 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> > > > index 878ac0c..0856e2e 100644
> > > > --- a/drivers/char/sysrq.c
> > > > +++ b/drivers/char/sysrq.c
> > > > @@ -520,9 +520,11 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
> > > >  		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
> > > >  			printk("%s\n", op_p->action_msg);
> > > >  			console_loglevel = orig_log_level;
> > > > +			spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
> > > >  			op_p->handler(key, tty);
> > > >  		} else {
> > > >  			printk("This sysrq operation is disabled.\n");
> > > > +			spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
> > > >  		}
> > > >  	} else {
> > > >  		printk("HELP : ");
> > > > @@ -541,8 +543,8 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
> > > >  		}
> > > >  		printk("\n");
> > > >  		console_loglevel = orig_log_level;
> > > > +		spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
> > > >  	}
> > > > -	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
> > > >  }
> > > >  
> > > >  void handle_sysrq(int key, struct tty_struct *tty)
> > > > -- 
> > > > 1.7.2
> > > > 
> > > > 
> > > 
> > > This creates the possibility of a race in the handler.  Not that it happens
> > > often, but sysrq keys can be registered and unregistered dynamically.  If that
> > > lock isn't held while we call the keys handler, the code implementing that
> > > handler can live in a module that gets removed while its executing, leading to
> > > an oops, etc.  I think the better solution would be to use an rcu lock here.
> > 
> > I'd simply changed spinlock to a mutex.
> > 
> I don't think you can do that safely in this path, as sysrqs will be looked up
> in both process (echo t > /proc/sysrq-trigger) context and in interrupt
> (alt-sysrq-t) context.  If a mutex is locked and you try to take it in interrupt
> context, you get a sleeping-in-interrupt panic IIRC
> 

Yes, indeed. But then even RCU will not really help us since keyboard
driver will have inpterrupts disabled anyways.

-- 
Dmitry
