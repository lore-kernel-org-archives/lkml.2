Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab0J3GLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 02:11:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49732 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab0J3GLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 02:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A3gozl+DwA3s+dPpP1/RJAti77EmkXVM0f3VTIcM+1tAuHIwc/bRLXQdvoCynuMEoW
         5a3lqleKoPF5JAWKBur8CC0NV7jU5D4rgbjSz6TmPu4Llp6s0dXBM/I/ISXtpCCutJRn
         eL8CYSTgupjSbl6uESPogj0iC5MrqVgfBnZJw=
Subject: Re: Memory barrier question.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <201010301448.ADJ35414.VOFHtQOJOFLSMF@I-love.SAKURA.ne.jp>
References: <201010292223.IIF64065.tOLVFJFSQOMFOH@I-love.SAKURA.ne.jp>
	 <20101029150908.GC2367@linux.vnet.ibm.com>
	 <201010301448.ADJ35414.VOFHtQOJOFLSMF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 08:11:11 +0200
Message-ID: <1288419071.2680.648.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 30 octobre 2010 à 14:48 +0900, Tetsuo Handa a écrit :
> Paul E. McKenney wrote:
> > For the CPU, let's take it by type of architecture...
> > 
> > First, let's get the UP-only architectures out of the way.  These would
> > always see their changes in order, so woiuld always see "hello".
> 
> Of course.
> 
> > Second, let's consider the TSO architectures, including x86, SPARC,
> > PA-RISC, and IBM Mainframe.  On these architectures, reads are not
> > reordered by the CPU, so if they see the new pointer, they will also
> > see the new characters -- hence "hello".
> 
> Yes.
> 
> > Next, let's consider weakly ordered systems that respect dependency
> > ordering (ARM, PowerPC, Itanium).  The load of the pointer would
> > always be ordered with respect to any dereference of the pointer,
> > so they would always see "hello".
> 
> I'm relieved to hear that.
> 
> > This leave DEC Alpha.  In this architecture, smp_read_barrier_depends()
> > expands to smp_rmb(), which forces the ordering as required.  So
> > Alpha also sees "hello."
> 
> Yes.
> 
> > I believe that this covers all of the cases.
> > 
> > Am I missing anything?
> 
> You are right. Regarding list elements, they are appropriately protected.
> 
> 
> 
> Then, what about list heads that are dynamically allocated/initialized?
> 
> sruct hashed_word {
> 	struct list_head list;
> 	void *key;
> 	char *buf;
> };
> static struct list_head tables[1u << TABLEBIT];
> static void (*some_callback) (void *);
> 

typedef void (*some_callback_t) (void *);

static some_callback_t __rcu *some_callback;

> static void init(void)
> {
> 	int i;
> 	/* Initialize the table. */
> 	for (i = 0; i < (1u << TABLEBIT); i++)
> 		INIT_LIST_HEAD(&tables[i]);
> 	smp_wmb();
> 	/* Allow other CPUs to access the table. */
> 	some_callback = func;

rcu_assign_pointer(some_callback, func);

> }
> 
> /*
>  * This function is called by
>  *
>  *	if (some_callback)
>  *		some_callback(some_ptr);
>  *
>  * rather than
>  *
>  *	func(some_ptr);

well no, see later.

>  *
>  * .
>  */
> static void func(void *some_ptr)
> {
> 	struct hashed_word *ptr;
> 	struct list_head *table = &tables[hash_ptr(some_ptr, TABLEBIT)];
> 	/* We must make sure that readers see table->next != NULL. */


> 	smp_rmb();
Nope.. delete this

> 	rcu_read_lock();
> 	list_for_each_entry_rcu(ptr, table, list) {
> 		if (ptr->key != some_ptr)
> 			continue;
> 		printk("%s\n", ptr->buf);
> 		break;
> 	}
> 	rcu_read_unlock();
> }
> 
> How can I make sure INIT_LIST_HEAD() in init() takes effect?
> Is smp_rmb() appropriate?

Please avoid smp_rmb()/smb_wmb() and use RCU api only.

some_callback_t *ptr;

rcu_read_lock();
ptr = rcu_dereference(some_callback);
if (ptr) {
	list_for_each_entry_rcu(aux, table, list) {
 		if (aux->key != ptr)
 			continue;
 		printk("%s\n", aux->buf);
 		break;
 	}
 }
rcu_read_unlock();



