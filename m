Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab0FIFJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 01:09:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:1376 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab0FIFJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 01:09:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,388,1272870000"; 
   d="c'?scan'208";a="574608759"
Subject: Re: [RFC] kfifo writer side lock-less support
From: Huang Ying <ying.huang@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1276023707.4499.12.camel@wall-e.seibold.net>
References: <1275979513.3444.676.camel@yhuang-dev.sh.intel.com>
	 <1276023707.4499.12.camel@wall-e.seibold.net>
Content-Type: multipart/mixed; boundary="=-7GRdQ039xHWM2BMAst+5"
Date: Wed, 09 Jun 2010 13:09:07 +0800
Message-ID: <1276060147.3444.712.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7GRdQ039xHWM2BMAst+5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi, Stefani,

On Wed, 2010-06-09 at 03:01 +0800, Stefani Seibold wrote:
> Hi Huang,
> 
> it would be great if you could post an example code how to use your
> code.

The file attached is the testing code I used. Is it a good example from
your point of view?

Best Regards,
Huang Ying


--=-7GRdQ039xHWM2BMAst+5
Content-Disposition: attachment; filename="kfifo_test.c"
Content-Type: text/x-csrc; name="kfifo_test.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/* kfifo_test.c */

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/kfifo.h>
#include <linux/random.h>
#include <linux/sched.h>
#include <linux/kthread.h>

#define KTPFX		"kfifo_test: "

#define FIFO_SIZE	PAGE_SIZE

#define IN_LEN_BITS	8
#define IN_LEN_MASK	((1<<IN_LEN_BITS) - 1)
#define IN_LEN_SHIFT	13
#define IN_LEN_MAX	(1<<IN_LEN_BITS)

#define IN_LEN_MEAN	(IN_LEN_MAX >> 1)

#define RECORDS_MEAN	(FIFO_SIZE / IN_LEN_MEAN)

#define IO_NUM_MAX	(RECORDS_MEAN * 3 / 2)

static char fifo_page[FIFO_SIZE];

static int test_intvl = 10;

static struct timer_list test_timer;
static int test_exiting;
static struct kfifo test_fifo;

static atomic_t test_added;
static atomic_t test_deled;
static atomic_t test_timer_added;
static atomic_t test_overlapped;

static atomic_t test_freezed;

static int test_ptr;

static unsigned int random_inl(void)
{
	u32 rand;

	rand = random32();

	rand = (rand >> IN_LEN_SHIFT) & IN_LEN_MASK;
	if (!rand)
		rand = 1;
	return rand;
}

static unsigned int random_io_num(void)
{
	u32 rand;

	rand = random32();
	rand = ((rand&0xff)<<24) | ((rand&0xff00)<<8) |
		((rand&0xff0000)>>8) | ((rand&0xff000000)>>24);
	return rand % IO_NUM_MAX;
}

static unsigned int kfifo_ll_in_one_random(struct kfifo *fifo)
{
	unsigned char in_buf[IN_LEN_MAX];
	unsigned int i, inl, rc;

	inl = random_inl();
	for (i = 0; i < inl; i++)
		in_buf[i] = inl;
	rc = kfifo_ll_in(fifo, in_buf, inl);
	if (rc)
		atomic_inc(&test_added);
	return rc;
}

static unsigned int kfifo_check_and_skip_one(struct kfifo *fifo)
{
	unsigned char out_buf[IN_LEN_MAX];
	unsigned int i, skipl, len;

	len = kfifo_len(fifo);
	if (!len)
		return 0;
	i = kfifo_out_peek(fifo, out_buf, 1, 0);
	skipl = out_buf[0];
	if (len < skipl) {
		pr_info(KTPFX "len: %u, skipl: %u\n", len, skipl);
		BUG();
	}
	i = kfifo_out_peek(fifo, out_buf, skipl, 0);
	for (i = 0; i < skipl; i++)
		BUG_ON(out_buf[i] != skipl);
	kfifo_skip(fifo, skipl);
	atomic_inc(&test_deled);

	return skipl;
}

#define kfifo_check_ptr(fifo, p)					\
	{								\
	if (p < fifo->buffer || p + *p > fifo->buffer + fifo->size) {	\
		pr_info(KTPFX "fifo->buffer: %p, p: %p, *p: %u\n",	\
			fifo->buffer, p, *p);				\
		BUG();							\
	}								\
}

static unsigned int kfifo_ll_in_one_random_ptr(struct kfifo *fifo)
{
	unsigned char *p;
	unsigned int i, inl;

	inl = random_inl();
	preempt_disable();
	p = kfifo_reserve_continuous_ptr(fifo, &inl);
	if (!p) {
		preempt_enable_no_resched();
		return 0;
	}
	for (i = 0; i < inl; i++)
		p[i] = inl;
	kfifo_commit_ptr(fifo, p);
	kfifo_check_ptr(fifo, p);
	preempt_enable_no_resched();
	atomic_inc(&test_added);
	return inl;
}

static unsigned int kfifo_check_and_skip_one_ptr(struct kfifo *fifo)
{
	unsigned char *p;
	unsigned int i;
	struct kfifo_iter iter;

	kfifo_iter_init(&iter, fifo);
	p = kfifo_iter_get_ptr(&iter);
	if (!p)
		return 0;
#if 1
	while (p) {
		kfifo_check_ptr(fifo, p);
		for (i = 1; i < *p; i++)
			BUG_ON(p[i] != *p);
		kfifo_iter_advance(&iter, *p);
		p = kfifo_iter_get_ptr(&iter);
	}
	kfifo_iter_init(&iter, fifo);
	p = kfifo_iter_get_ptr(&iter);
#else
	for (i = 0; i < *p; i++)
		BUG_ON(p[i] != *p);
#endif
	kfifo_skip(fifo, *p);

	atomic_inc(&test_deled);

	return *p;
}

static void test_round(struct kfifo *fifo)
{
	unsigned int i, numi, numo;
	unsigned int old_added, old_deled, full, empty;

	numi = random_io_num();
	numo = random_io_num();

	old_added = atomic_read(&test_added);
	old_deled = atomic_read(&test_deled);

	full = kfifo_avail(fifo) < IN_LEN_MAX / 2;

	if (test_ptr) {
		for (i = 0; i < numi; i++)
			kfifo_ll_in_one_random_ptr(fifo);
	} else {
		for (i = 0; i < numi; i++)
			kfifo_ll_in_one_random(fifo);
	}

	if (!full && numi && old_added == atomic_read(&test_added))
		atomic_inc(&test_freezed);

	empty = kfifo_len(fifo) == 0;

	if (test_ptr) {
		for (i = 0; i < numo; i++)
			kfifo_check_and_skip_one_ptr(fifo);
	} else {
		for (i = 0; i < numo; i++)
			kfifo_check_and_skip_one(fifo);
	}

	if (!empty && numo && old_deled == atomic_read(&test_deled))
		atomic_inc(&test_freezed);
}

void test_fifo_init(void)
{
	kfifo_init(&test_fifo, fifo_page, sizeof(fifo_page));
	test_fifo.in = test_fifo.out = test_fifo.reserve = (~0U - PAGE_SIZE);
}

static void simple_test(void)
{
	int i;

	test_fifo_init();
	for (i = 0; i < 100; i++) {
		test_round(&test_fifo);
		schedule();
	}
}

static void test_timer_func(unsigned long data)
{
	if (test_ptr)
		kfifo_ll_in_one_random_ptr(&test_fifo);
	else
		kfifo_ll_in_one_random(&test_fifo);

	if (test_fifo.reserve != test_fifo.in)
		atomic_inc(&test_overlapped);
	atomic_inc(&test_timer_added);
	if (!test_exiting) {
		test_timer.expires = jiffies + 1;
		add_timer_on(&test_timer, 1);
	}
}

static int test_thread1(void *data)
{
	unsigned long until;
	struct completion *comp = data;
	unsigned int i = 0;

	until = jiffies;
	until += msecs_to_jiffies(MSEC_PER_SEC * test_intvl);

	do {
		test_round(&test_fifo);
		if ((i & 0xf) == 0)
			schedule();
	} while ((long)(until - jiffies) > 0);

	complete(comp);

	return 0;
}

static void full_test(void)
{
	struct task_struct *thd;
	struct completion comp;

	atomic_set(&test_added, 0);
	atomic_set(&test_deled, 0);
	atomic_set(&test_timer_added, 0);
	atomic_set(&test_overlapped, 0);
	atomic_set(&test_freezed, 0);

	test_fifo_init();

	test_timer.expires = jiffies + 1;
	add_timer_on(&test_timer, 1);

	init_completion(&comp);
	thd = kthread_create(test_thread1, &comp, "kfifo_tester1");
	if (IS_ERR(thd)) {
		pr_err(KTPFX "Failed to create thread!\n");
		return;
	}
	kthread_bind(thd, 1);
	wake_up_process(thd);
	wait_for_completion(&comp);

	del_timer_sync(&test_timer);

	pr_info(KTPFX
	"%s: added: %u, deled: %u, overlapped: %u of %u, freezed: %u\n",
		test_ptr ? "ptr" : "nor",
		atomic_read(&test_added), atomic_read(&test_deled),
		atomic_read(&test_overlapped), atomic_read(&test_timer_added),
		atomic_read(&test_freezed));
}

static int kfifo_test_init(void)
{
	init_timer(&test_timer);
	test_timer.function = test_timer_func;

	test_ptr = 0;
	simple_test();
	test_ptr = 1;
	simple_test();

	test_ptr = 0;
	full_test();
	test_ptr = 1;
	full_test();

	return 0;
}

static void kfifo_test_exit(void)
{
}

module_init(kfifo_test_init);
module_exit(kfifo_test_exit);

MODULE_LICENSE("GPL");

--=-7GRdQ039xHWM2BMAst+5--

