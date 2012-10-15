Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2JOTIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:08:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:37759 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2JOTIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:08:35 -0400
Date: Mon, 15 Oct 2012 21:08:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        devel@openvz.org
Subject: Re: [RFC PATCH] posix timers: allocate timer id per task
In-Reply-To: <20121015161559.7806.72762.stgit@localhost.localdomain>
Message-ID: <alpine.LFD.2.02.1210152105090.5541@ionos>
References: <20121015161559.7806.72762.stgit@localhost.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012, Stanislav Kinsbursky wrote:

> This patch is required CRIU project (www.criu.org).
> To migrate processes with posix timers we have to make sure, that we can
> restore posix timer with proper id.
> Currently, this is not true, because timer ids are allocated globally.
> So, this is precursor patch and it's purpose is make posix timer id to be
> allocated per task.

You can't allocate them per task. posix timers are process wide.

What's the reason why you did not make the posix timer ids per name
space instead of going down to the per process level ?

> Patch replaces global idr with global hash table for posix timers and
> makes timer ids unique not globally, but per task. Next free timer id is type
> of integer and stored on signal struct (posix_timer_id). If free timer id
> reaches negative value on timer creation, it will be dropped to zero and
> -EAGAIN will be returned to user.

So you want to allow 2^31 posix timers created for a single process?

> +static struct k_itimer *__posix_timers_find(struct hlist_head *head, struct signal_struct *sig, timer_t id)
> +{
> +	struct hlist_node *node;
> +	struct k_itimer *timer;
> +
> +	hlist_for_each_entry(timer, node, head, t_hash) {
> +		if ((timer->it_signal == sig) && (timer->it_id == id))
> +			return timer;
> +	}
> +	return NULL;
> +}
> +
> +static struct k_itimer *posix_timer_find(timer_t id, unsigned long *flags)
> +{
> +	struct k_itimer *timer;
> +	struct signal_struct *sig = current->signal;
> +	struct hlist_head *head = &posix_timers_hashtable[hash(sig, id)];
> +
> +	spin_lock_irqsave(&hash_lock, *flags);

This is not going to fly. You just reintroduced a massive scalability
problem. See commit 8af08871

Thanks,

	tglx
