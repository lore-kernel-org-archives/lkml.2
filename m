Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852Ab0EDU7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:59:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49585 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933683Ab0EDU7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:59:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH tip/core/rcu 31/48] rcu: define __rcu address space modifier for sparse
Date: Tue, 4 May 2010 22:58:19 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00090-g1509e54-dirty; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Christopher Li <sparse@chrisli.org>
References: <20100504201934.GA19234@linux.vnet.ibm.com> <1273004398-19760-31-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1273004398-19760-31-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005042258.20390.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX185fRFyNq/X7X8Q7/dpDXrB1q5RgZSHV3z4sZE
 VllaUBn0LLS6vxyuEL8Mudu/z/ec/IQ64Vvh+UC/lrOgs6ce9Y
 uEv9A9hP8z/CtpN8gWWYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 May 2010 22:19:41 Paul E. McKenney wrote:
> This patch defines an __rcu annotation that permits sparse to check for
> correct use of RCU-protected pointers.  If a pointer that is annotated
> with __rcu is accessed directly (as opposed to via rcu_dereference(),
> rcu_assign_pointer(), or one of their variants), sparse can be made
> to complain.  To enable such complaints, use the new default-disabled
> CONFIG_SPARSE_RCU_POINTER kernel configuration option.  Please note that
> these sparse complaints are intended to be a debugging aid, -not- a
> code-style-enforcement mechanism.

To add more background, I was thinking that it might make sense to
always leave the address space attribute in place but to make part
part of the checking optional.

The idea would be that we always make sure that an __rcu annotated
pointer cannot be dereferenced or cast directly, while we would
only complain about non-annotated pointers being passed to rcu_dereference
and rcu_assign_pointer if CONFIG_SPARSE_RCU_POINTER is set.

Most of the work I had spent on my tree was about fixing all the
false positives from that, but more work would be needed to get
a clean build from it even with the modified CONFIG_SPARSE_RCU_POINTER
disabled. Since you managed to find the real bugs and fix them,
your series by itself is probably more useful than the full set
that I originally had.

> +/*
> + * Helper functions for rcu_dereference_check(), rcu_dereference_protected()
> + * and rcu_assign_pointer().  Some of these could be folded into their
> + * callers, but they are left separate in order to ease introduction of
> + * multiple flavors of pointers to match the multiple flavors of RCU
> + * (e.g., __rcu_bh, * __rcu_sched, and __srcu), should this make sense in
> + * the future.
> + */
> +#define __rcu_access_pointer(p, space) \
> +	({ \
> +		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> +		(void) (((typeof (*p) space *)p) == p); \
> +		((typeof(*p) __force __kernel *)(_________p1)); \
> +	})

Do you have specific plans to add these (__rcu_bh etc) back in the future,
or do you just want to leave the options open?

Anyway, good to see that you found your way through my patches and got them
into shape. 

	Arnd
