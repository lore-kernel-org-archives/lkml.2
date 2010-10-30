Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0J3Mk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 08:40:56 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60721 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab0J3Mky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 08:40:54 -0400
To: eric.dumazet@gmail.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: Memory barrier question.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201010292223.IIF64065.tOLVFJFSQOMFOH@I-love.SAKURA.ne.jp>
	<20101029150908.GC2367@linux.vnet.ibm.com>
	<201010301448.ADJ35414.VOFHtQOJOFLSMF@I-love.SAKURA.ne.jp>
	<1288419071.2680.648.camel@edumazet-laptop>
In-Reply-To: <1288419071.2680.648.camel@edumazet-laptop>
Message-Id: <201010302140.DCE52148.FMJHOFFSVLQOOt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 30 Oct 2010 21:40:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Eric Dumazet wrote:
> Le samedi 30 octobre 2010 a 14:48 +0900, Tetsuo Handa a ecrit :
> > Then, what about list heads that are dynamically allocated/initialized?
> > 
> > sruct hashed_word {
> > 	struct list_head list;
> > 	void *key;
> > 	char *buf;
> > };
> > static struct list_head tables[1u << TABLEBIT];
> > static void (*some_callback) (void *);
> > 
> 
> typedef void (*some_callback_t) (void *);
> 
> static some_callback_t __rcu *some_callback;
> 
> > static void init(void)
> > {
> > 	int i;
> > 	/* Initialize the table. */
> > 	for (i = 0; i < (1u << TABLEBIT); i++)
> > 		INIT_LIST_HEAD(&tables[i]);
> > 	smp_wmb();
> > 	/* Allow other CPUs to access the table. */
> > 	some_callback = func;
> 
> rcu_assign_pointer(some_callback, func);
> 
This one is OK. But a bit different from what I want to do.

> > }
> > 
> > /*
> >  * This function is called by
> >  *
> >  *	if (some_callback)
> >  *		some_callback(some_ptr);
> >  *
> >  * rather than
> >  *
> >  *	func(some_ptr);
> 
> well no, see later.
> 
I want to split built-in part and module part. I'm happy to embed

	if (some_callback)
		some_callback(some_ptr);

into built-in part but I'm not happy to expose tables to built-in part.
I'm using function pointer to realize it (like LSM).

> >  *
> >  * .
> >  */
> > static void func(void *some_ptr)
> > {
> > 	struct hashed_word *ptr;
> > 	struct list_head *table = &tables[hash_ptr(some_ptr, TABLEBIT)];
> > 	/* We must make sure that readers see table->next != NULL. */
> 
> 
> > 	smp_rmb();
> Nope.. delete this
> 
> > 	rcu_read_lock();
> > 	list_for_each_entry_rcu(ptr, table, list) {
> > 		if (ptr->key != some_ptr)
> > 			continue;
> > 		printk("%s\n", ptr->buf);
> > 		break;
> > 	}
> > 	rcu_read_unlock();
> > }
> > 
> > How can I make sure INIT_LIST_HEAD() in init() takes effect?
> > Is smp_rmb() appropriate?
> 
> Please avoid smp_rmb()/smb_wmb() and use RCU api only.
> 
> some_callback_t *ptr;
> 
> rcu_read_lock();
> ptr = rcu_dereference(some_callback);
> if (ptr) {

I want to know how I can guarantee that "table->next != NULL"
by exposing only "some_callback" to built-in part.
Once the result of INIT_LIST_HEAD() became visible to readers,
readers no longer need to use RCU for guaranteeing table->next != NULL.

> 	list_for_each_entry_rcu(aux, table, list) {
>  		if (aux->key != ptr)
>  			continue;
>  		printk("%s\n", aux->buf);
>  		break;
>  	}
>  }
> rcu_read_unlock();

Regards.
