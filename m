Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2L0Nxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 08:53:55 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44572 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2L0Nxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 08:53:52 -0500
MIME-Version: 1.0
In-Reply-To: <1354568322-29029-24-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
	<1354568322-29029-24-git-send-email-koverstreet@google.com>
Date: Thu, 27 Dec 2012 14:47:49 +0100
Message-ID: <CAJAFBLAh81+hC=FRMMSBhP=RrwsHEW8i3PgxakqyAEPapcQaSw@mail.gmail.com>
Subject: Re: [PATCH 23/26] Generic dynamic per cpu refcounting
From: Fubo Chen <fubo.chen@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 9:58 PM, Kent Overstreet <koverstreet@google.com> wrote:
> +#define pr_fmt(fmt) "%s: " fmt "\n", __func__

Dynamic debug already allows to insert the function name. Please
consider leaving this line out entirely and move the "\n" to the end
of individual printed lines.

> +#define PCPU_REF_PTR		0
> +#define PCPU_REF_NONE		1
> +#define PCPU_REF_DYING		2
> +#define PCPU_REF_DEAD		3

Why has "define" been used here instead of an enum ? Using "define"
prevents the compiler to verify whether all possible values have been
handled in a switch statement.

> +#define REF_STATUS(count)	((unsigned long) count & PCPU_STATUS_MASK)

Please leave out the cast in the above expression. It prevents that
the compiler performs type checking on "count". Also, why is
REF_STATUS() a define and not an inline function ?

> +struct percpu_ref {
> +       atomic64_t              count;
> +       unsigned __percpu       *pcpu_count;
> +};

pcpu_count can either be a jiffies value (unsigned long) or a pointer
to unsigned __percpu. So please consider using a union here. Has this
code been checked with sparse ? I'm afraid that the above structure
definition will confuse sparse a lot.

> +	if (now - last <= HZ << PCPU_STATUS_BITS) {

Please consider changing "HZ" into a symbolic name that makes it clear
that this value is the threshold in jiffies above which the switch is
made from a single atomic_t refcount to the per-cpu refcounting
scheme.

> +void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
> +{
> +	unsigned __percpu *pcpu_count;
> +	uint64_t v;
> +
> +	pcpu_count = rcu_dereference(ref->pcpu_count);
> +
> +	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
> +		__this_cpu_inc(*pcpu_count);
> +	} else {
> +		v = atomic64_add_return(1 + (1ULL << PCPU_COUNT_BITS),
> +					&ref->count);
> +
> +		if (!(v >> PCPU_COUNT_BITS) &&
> +		    REF_STATUS(pcpu_count) == PCPU_REF_NONE && alloc)
> +			percpu_ref_alloc(ref, pcpu_count);
> +	}
> +}

What will happen if another thread invokes percpu_ref_kill() after the
above rcu_dereference() call finished but before REF_STATUS() got
invoked ? Can that percpu_ref_kill() finish before
__this_cpu_inc(*pcpu_count) gets invoked ?
Documentation/RCU/checklist.txt says: "All RCU list-traversal
primitives, which include rcu_dereference(),
list_for_each_entry_rcu(), and list_for_each_safe_rcu(), must be
either within an RCU read-side critical section or must be protected
by appropriate update-side locks."

> +int percpu_ref_kill(struct percpu_ref *ref)

The meaning of the return value of this function has not been documented.

Thanks,

Fubo.
