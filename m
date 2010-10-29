Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859Ab0J2NXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:23:47 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56222 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626Ab0J2NXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:23:45 -0400
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Memory barrier question.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201010292223.IIF64065.tOLVFJFSQOMFOH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 29 Oct 2010 22:23:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I got a question regarding memory barrier.

sruct word {
	struct list_head list;
	char *buf;
};

static LIST_HEAD(wordlist);
static DEFINE_SPINLOCK(wordlist_lock);

--- On CPU 0 ---

struct word *hello = kzalloc(sizeof(*hello), GFP_KERNEL);
hello->buf = kstrdup("hello", GFP_KERNEL);
spin_lock(&wordlist_lock);
list_add_rcu(&hello.list, &wordlist);
spin_unlock(&wordlist_lock);

--- On CPU 1 ---

struct word *ptr;
rcu_read_lock();
list_for_each_entry_rcu(ptr, &wordlist, list) {
	char *str = ptr->buf;
	printk("%s\n", str);
}
rcu_read_unlock();

Use of rcu_assign_pointer() and rcu_dereference() guarantees that
CPU 1 gets &hello->list by reading wordlist.next only after
CPU 1 can get kstrdup()ed pointer by reading hello->buf.
But what guarantees that CPU 1 gets "hello" by reading kstrdup()ed pointer?

Say, kstrdup("hello", GFP_KERNEL) stores

  'h' -> 0xC0000000
  'e' -> 0xC0000001
  'l' -> 0xC0000002
  'l' -> 0xC0000003
  'o' -> 0xC0000004
  '\0' -> 0xC0000005

and hello->buf = kstrdup() stores

  0xC0000000 -> hello->buf

.

If ordered by smp_wmb() by CPU 0 and smp_rmb() by CPU 1,
str = ptr->buf will load

  0xC0000000 -> str

and printk("%s\n", str) will load

  0xC0000000 -> 'h'
  0xC0000001 -> 'e'
  0xC0000002 -> 'l'
  0xC0000003 -> 'l'
  0xC0000004 -> 'o'
  0xC0000005 -> '\0'

.

Since CPU 0 issued smp_wmb() (inside list_add_rcu()) but CPU 1 did not issue
smp_rmb() (inside list_for_each_entry_rcu()), I think CPU 1 would see bogus
values like

  0xC0000000 -> 'h'
  0xC0000001 -> 'a'
  0xC0000002 -> 'l'
  0xC0000003 -> '1'
  0xC0000004 -> 'o'
  0xC0000005 -> 'w'
  0xC0000006 -> 'e'
  0xC0000007 -> 'e'
  0xC0000008 -> 'n'
  0xC0000009 -> '\0'

.

It seems to me that people do not call smp_rmb() before reading memory
which was dynamically allocated/initialized. What am I missing?

Regards.
