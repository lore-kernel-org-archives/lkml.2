Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0EXUto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:49:44 -0400
Received: from fifo99.com ([67.223.236.141]:37428 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab0EXUtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:49:43 -0400
Subject: Re: [PATCH 04/11] rwsem: lighter active count checks when waking
 up readers
From: Daniel Walker <dwalker@fifo99.com>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
In-Reply-To: <1274733081-4623-5-git-send-email-walken@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	 <1274733081-4623-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 13:49:16 -0700
Message-ID: <1274734156.11372.50.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 13:31 -0700, Michel Lespinasse wrote:
> In __rwsem_do_wake(), we can skip the active count check unless we come
> there from up_xxxx(). Also when checking the active count, it is not
> actually necessary to increment it; this allows us to get rid of the
> read side undo code and simplify the calculation of the final rwsem count
> adjustment once we've counted the reader threads to wake.
> 
> The basic observation is the following. When there are waiter threads
> on a rwsem and the spinlock is held, other threads can only increment the
> active count by trying to grab the rwsem in down_xxxx(). However down_xxxx()
> will notice there are waiter threads and take the down_failed path,
> blocking to acquire the spinlock on the way there. Therefore, a thread
> observing an active count of zero with waiters queued and the spinlock held,
> is protected against other threads acquiring the rwsem until it wakes the
> last waiter or releases the spinlock.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  lib/rwsem.c |   57 ++++++++++++++++++++++++++++++++-------------------------
>  1 files changed, 32 insertions(+), 25 deletions(-)
> 
> diff --git a/lib/rwsem.c b/lib/rwsem.c
> index 917fd94..94f2d7a 100644
> --- a/lib/rwsem.c
> +++ b/lib/rwsem.c
> @@ -36,6 +36,14 @@ struct rwsem_waiter {
>  #define RWSEM_WAITING_FOR_WRITE	0x00000002
>  };
>  
> +/* Wake types for __rwsem_do_wake().  Note that RWSEM_WAKE_NO_ACTIVE and
> + * RWSEM_WAKE_READ_OWNED imply that the spinlock must have been kept held
> + * since the rwsem value was observed.
> + */
> +#define RWSEM_WAKE_ANY        0 /* Wake whatever's at head of wait list */
> +#define RWSEM_WAKE_NO_ACTIVE  1 /* rwsem was observed with no active thread */
> +#define RWSEM_WAKE_READ_OWNED 2 /* rwsem was observed to be read owned */
> +
>  /*
>   * handle the lock release when processes blocked on it that can now run
>   * - if we come here from up_xxxx(), then:
> @@ -46,8 +54,8 @@ struct rwsem_waiter {
>   * - woken process blocks are discarded from the list after having task zeroed
>   * - writers are only woken if downgrading is false
>   */
> -static inline struct rw_semaphore *
> -__rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
> +static struct rw_semaphore *
> +__rwsem_do_wake(struct rw_semaphore *sem, int wake_type)

You could convert the "wake_type" into an enum along with the defines
above.

Daniel

