Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab0J3Fsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 01:48:32 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60122 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab0J3Fsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 01:48:31 -0400
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Memory barrier question.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201010292223.IIF64065.tOLVFJFSQOMFOH@I-love.SAKURA.ne.jp>
	<20101029150908.GC2367@linux.vnet.ibm.com>
In-Reply-To: <20101029150908.GC2367@linux.vnet.ibm.com>
Message-Id: <201010301448.ADJ35414.VOFHtQOJOFLSMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 30 Oct 2010 14:48:26 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> For the CPU, let's take it by type of architecture...
> 
> First, let's get the UP-only architectures out of the way.  These would
> always see their changes in order, so woiuld always see "hello".

Of course.

> Second, let's consider the TSO architectures, including x86, SPARC,
> PA-RISC, and IBM Mainframe.  On these architectures, reads are not
> reordered by the CPU, so if they see the new pointer, they will also
> see the new characters -- hence "hello".

Yes.

> Next, let's consider weakly ordered systems that respect dependency
> ordering (ARM, PowerPC, Itanium).  The load of the pointer would
> always be ordered with respect to any dereference of the pointer,
> so they would always see "hello".

I'm relieved to hear that.

> This leave DEC Alpha.  In this architecture, smp_read_barrier_depends()
> expands to smp_rmb(), which forces the ordering as required.  So
> Alpha also sees "hello."

Yes.

> I believe that this covers all of the cases.
> 
> Am I missing anything?

You are right. Regarding list elements, they are appropriately protected.



Then, what about list heads that are dynamically allocated/initialized?

sruct hashed_word {
	struct list_head list;
	void *key;
	char *buf;
};
static struct list_head tables[1u << TABLEBIT];
static void (*some_callback) (void *);

static void init(void)
{
	int i;
	/* Initialize the table. */
	for (i = 0; i < (1u << TABLEBIT); i++)
		INIT_LIST_HEAD(&tables[i]);
	smp_wmb();
	/* Allow other CPUs to access the table. */
	some_callback = func;
}

/*
 * This function is called by
 *
 *	if (some_callback)
 *		some_callback(some_ptr);
 *
 * rather than
 *
 *	func(some_ptr);
 *
 * .
 */
static void func(void *some_ptr)
{
	struct hashed_word *ptr;
	struct list_head *table = &tables[hash_ptr(some_ptr, TABLEBIT)];
	/* We must make sure that readers see table->next != NULL. */
	smp_rmb();
	rcu_read_lock();
	list_for_each_entry_rcu(ptr, table, list) {
		if (ptr->key != some_ptr)
			continue;
		printk("%s\n", ptr->buf);
		break;
	}
	rcu_read_unlock();
}

How can I make sure INIT_LIST_HEAD() in init() takes effect?
Is smp_rmb() appropriate?

Well, I wish we can wait for all CPUs to see table->next != NULL
before proceeding to "some_callback = func;" so that readers are
guaranteed to see table->next != NULL without issuing memory barriers...

Regards.
