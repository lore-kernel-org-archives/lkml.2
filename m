Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393Ab0J2PJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:09:29 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49676 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323Ab0J2PJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:09:28 -0400
Date: Fri, 29 Oct 2010 08:09:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Memory barrier question.
Message-ID: <20101029150908.GC2367@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201010292223.IIF64065.tOLVFJFSQOMFOH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010292223.IIF64065.tOLVFJFSQOMFOH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 10:23:41PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I got a question regarding memory barrier.
> 
> sruct word {
> 	struct list_head list;
> 	char *buf;
> };
> 
> static LIST_HEAD(wordlist);
> static DEFINE_SPINLOCK(wordlist_lock);
> 
> --- On CPU 0 ---
> 
> struct word *hello = kzalloc(sizeof(*hello), GFP_KERNEL);
> hello->buf = kstrdup("hello", GFP_KERNEL);
> spin_lock(&wordlist_lock);
> list_add_rcu(&hello.list, &wordlist);
> spin_unlock(&wordlist_lock);
> 
> --- On CPU 1 ---
> 
> struct word *ptr;
> rcu_read_lock();
> list_for_each_entry_rcu(ptr, &wordlist, list) {
> 	char *str = ptr->buf;
> 	printk("%s\n", str);
> }
> rcu_read_unlock();
> 
> Use of rcu_assign_pointer() and rcu_dereference() guarantees that
> CPU 1 gets &hello->list by reading wordlist.next only after
> CPU 1 can get kstrdup()ed pointer by reading hello->buf.
> But what guarantees that CPU 1 gets "hello" by reading kstrdup()ed pointer?
> 
> Say, kstrdup("hello", GFP_KERNEL) stores
> 
>   'h' -> 0xC0000000
>   'e' -> 0xC0000001
>   'l' -> 0xC0000002
>   'l' -> 0xC0000003
>   'o' -> 0xC0000004
>   '\0' -> 0xC0000005
> 
> and hello->buf = kstrdup() stores
> 
>   0xC0000000 -> hello->buf
> 
> .
> 
> If ordered by smp_wmb() by CPU 0 and smp_rmb() by CPU 1,
> str = ptr->buf will load
> 
>   0xC0000000 -> str
> 
> and printk("%s\n", str) will load
> 
>   0xC0000000 -> 'h'
>   0xC0000001 -> 'e'
>   0xC0000002 -> 'l'
>   0xC0000003 -> 'l'
>   0xC0000004 -> 'o'
>   0xC0000005 -> '\0'
> 
> .
> 
> Since CPU 0 issued smp_wmb() (inside list_add_rcu()) but CPU 1 did not issue
> smp_rmb() (inside list_for_each_entry_rcu()), I think CPU 1 would see bogus
> values like
> 
>   0xC0000000 -> 'h'
>   0xC0000001 -> 'a'
>   0xC0000002 -> 'l'
>   0xC0000003 -> '1'
>   0xC0000004 -> 'o'
>   0xC0000005 -> 'w'
>   0xC0000006 -> 'e'
>   0xC0000007 -> 'e'
>   0xC0000008 -> 'n'
>   0xC0000009 -> '\0'

Timely string value, given this coming Sunday in USA.  ;-)

> .
> 
> It seems to me that people do not call smp_rmb() before reading memory
> which was dynamically allocated/initialized. What am I missing?

There is the compiler and the CPU.  The compiler is prohibited from
reordering the reads due to the ACCESS_ONCE().

For the CPU, let's take it by type of architecture...

First, let's get the UP-only architectures out of the way.  These would
always see their changes in order, so woiuld always see "hello".

Second, let's consider the TSO architectures, including x86, SPARC,
PA-RISC, and IBM Mainframe.  On these architectures, reads are not
reordered by the CPU, so if they see the new pointer, they will also
see the new characters -- hence "hello".

Next, let's consider weakly ordered systems that respect dependency
ordering (ARM, PowerPC, Itanium).  The load of the pointer would
always be ordered with respect to any dereference of the pointer,
so they would always see "hello".

This leave DEC Alpha.  In this architecture, smp_read_barrier_depends()
expands to smp_rmb(), which forces the ordering as required.  So
Alpha also sees "hello."

I believe that this covers all of the cases.

Am I missing anything?

							Thanx, Paul
