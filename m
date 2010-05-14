Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0ENOzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:55:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0ENOzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:55:14 -0400
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU 
 utilization
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <AANLkTimu41pPmimFK10oQl0_Qh07vc3pJbxwNp-jDtTM@mail.gmail.com>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
	 <1273155640.5605.300.camel@twins> <20100506171141.GA5562@nowhere>
	 <1273167024.1642.256.camel@laptop> <1273220736.1642.318.camel@laptop>
	 <AANLkTimegTx_2wHCIhyLqcYbkIJEPi3SsdwgFxU4E7Rk@mail.gmail.com>
	 <1273226796.1642.333.camel@laptop>
	 <AANLkTimguldif-yCpPIPC65RL5bvp-HARuuhOHarxIf1@mail.gmail.com>
	 <1273230948.1642.351.camel@laptop>
	 <AANLkTimu41pPmimFK10oQl0_Qh07vc3pJbxwNp-jDtTM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 16:55:08 +0200
Message-ID: <1273848908.1626.315.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 11:41 +0200, Stephane Eranian wrote:
> Looks like a good solution, at least better than what is there right now.

Something like the below I guess, still need to make it an actual patch
though ;-)

The interesting bit is the schedule() function which tries to schedule
two queues fairly (cpu context and task context), and selects between
the two based on lag -- I'm not quite sure that that works out as
expected though, still have to do the actual math.

Also, I guess we should come up with a saner solution for the
per-task-per-cpu events (the unservicable stuff)

---


struct flexible_queue {
	struct rb_root waiting;
	struct rb_node *rb_leftmost;

	u64 min_service;
	u64 rel_avg;

	u64 clock;
	u64 running_stamp;

	struct list_head running;
	struct list_head unservicable;
	int unservicable_cpu;
	int nr_waiting;
};

enum flexible_type {
	flexible_waiting,
	flexible_running,
	flexible_unservicable,
};

struct flexible_event {
	union {
		struct rb_node rb_entry;
		struct list_head list_entry;
	};
	enum flexible_type type;

	u64 service;
};

static inline
s64 flexible_event_rel(struct flexible_queue *fq, struct flexible_event *fe)
{
	return fe->sevice - fq->min_service;
}

static void __enqueue_event(struct flexible_queue *fq, struct flexible_event *fe)
{
	struct rb_node **link = &fq->waiting.rb_node;
	struct rb_node *parent = NULL;
	struct flexible_event *entry;
	s64 rel = flexible_event_rel(fq, fe);
	int leftmost = 1;

	if (rel > 0) {
		fq->min_service += rel;
		fq->rel_avg -= fq->nr_waiting * rel;
		rel = 0;
	}

	fq->nr_waiting++;
	fq->rel_avg += rel;

	fe->type = flexible_waiting;

	while (*link) {
		parent = *link;
		entry = rb_entry(parent, struct flexible_event, rb_entry);
		/*
		 * We dont care about collisions. Nodes with
		 * the same rel stay together.
		 */
		if (rel < flexible_event_rel(fq, fe)) {
			link = &parent->rb_left;
		} else {
			link = &parent->rb_right;
			leftmost = 0;
		}
	}

	if (leftmost)
		cfs_rq->rb_leftmost = &se->rb_entry;

	rb_link_node(&fe->rb_entry, parent, link);
	rb_insert_color(&fe->rb_entry, &fq->waiting);
}

static void __dequeue_event(struct flexible_queue *fq, struct flexible_event *fe)
{
	if (fq->rb_leftmost == &fe->rb_entry) {
		struct rb_node *next_node;

		next_node = rb_next(&fe->rb_entry);
		fq->rb_leftmost = next_node;
	}

	rb_erase(&fe->rb_entry, &fq->waiting);

	fq->nr_waiting--;
	fq->rel_avg -= flexible_event_rel(fq, fe);
}

static void
flexible_event_add(struct flexible_queue *fq, struct flexible_event *fe)
{
	fe->service = fq->min_service + fq->rel_avg;
	__enqueue_event(fq, fe);
}

static void
flexible_event_del(struct flexible_queue *fq, struct flexible_event *fe)
{
	switch (fe->type) {
	case flexible_waiting:
		__dequeue_event(fq, fe);
		break;

	case flexible_running:
	case flexible_unservicable:
		list_del(&fe->list_entry);
		break;
	}
}

static void flexible_unschedule(struct flexible_queue *fq)
{
	struct flexible_event *fe, *tmp;
	s64 delta = (s64)(fq->clock - fq->running_stamp);

	list_for_each_entry_safe(fe, tmp, &fq->running, list_entry) {
		list_del(&fe->list_entry);
		fe->service += delta;
		__enqueue_event(fq, fe);
	}
}

static
s64 flexible_event_lag(struct flexible_queue *fq, struct flexible_event *fe)
{
	return fq->min_service + (fq->rel_avg / fq->nr_waiting) - fe->service;
}

static struct flexible_event *__pick_event(struct flexible_queue *fq)
{
	struct flexible_event *fe;

	if (!fq->rb_leftmost)
		return NULL;

	fe = rb_entry(fq->rb_leftmost, struct flexible_event, rb_entry);

	return fe;
}

static
int flexible_schedule(struct flexible_queue *fq1, struct flexible_queue *fq2)
{
	struct flexible_event *tmp, *fe;
	struct flexible_queue *fq;
	s64 tmp_lag, max_lag;

	if (fq->unservicable_cpu != smp_processor_id()) {
		list_for_each_entry_save(fe, tmp, &fq->unservicable, list_entry) {
			list_del(&fe->list_entry);
			flexible_event_add(fq, fe);
		}

		fq->unservicable_cpu = smp_processor_id();
	}

again:
	max_lag = 0;
	fe = NULL;

	tmp =__pick_event(fq1);
	if (tmp) {
		tmp_lag = flexible_event_lag(fq1, fe1);
		if (tmp_lag > max_lag) {
			fq = fq1;
			fe = fe1;
			max_lag = tmp_lag;
		}
	}

	tmp =__pick_event(fq2);
	if (tmp) {
		tmp_lag = flexible_event_lag(fq2, fe2);
		if (tmp_lag > max_lag) {
			fq = fq2;
			fe = fe2;
			max_lag = tmp_lag;
		}
	}

	if (!fe)
		return 1; /* no more events to schedule */

	fq->running_stamp = fq->clock;

	if (event_of(fe)->cpu != -1 && event_of(fe)->cpu != smp_processor_id()) {
		__dequeue_event(fq, fe);
		fe->type = flexible_unservicable;
		list_add(&fe->list_entry, &fq->unservicable);
		goto again; /* can't run this event, try another */
	}

	if (group_sched_in(event_of(fe), ...) == 0) {
		__dequeue_event(fq, fe);
		fe->type = flexible_running;
		list_add(&fe->list_entry, &fq->running);
		return 0; /* success */
	}

	return -EBUSY; /* doesn't fit */
}


