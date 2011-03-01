Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab1CAPlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:41:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab1CAPlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:41:10 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: ntl@pobox.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Oren Laadan <orenl@cs.columbia.edu>, linux-aio@kvack.org
Subject: Re: [PATCH 02/10] Introduce mm_has_pending_aio() helper
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
	<1298936432-29607-3-git-send-email-ntl@pobox.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 01 Mar 2011 10:40:18 -0500
In-Reply-To: <1298936432-29607-3-git-send-email-ntl@pobox.com>
	(ntl@pobox.com's message of "Mon, 28 Feb 2011 17:40:24 -0600")
Message-ID: <x494o7mrgrh.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[added linux-aio@kvack.org to the cc list]

ntl@pobox.com writes:

> From: Nathan Lynch <ntl@pobox.com>
>
> Support for AIO is on the to-do list, but until that is implemented,
> checkpoint will have to fail if a mm_struct has outstanding AIO
> contexts.  Add a mm_has_pending_aio() helper function for this
> purpose.

Just because a process has an io context, doesn't mean that the process
has active outstanding requests.  So, is this really what you wanted to
test?

Cheers,
Jeff

> Based on original "check_for_outstanding_aio" patch by Serge Hallyn.
>
> Signed-off-by: Serge E. Hallyn <serge@hallyn.com>
> [ntl: changed name and return type to clearly express semantics]
> [ntl: added kerneldoc]
> Signed-off-by: Nathan Lynch <ntl@pobox.com>
> ---
>  fs/aio.c            |   27 +++++++++++++++++++++++++++
>  include/linux/aio.h |    2 ++
>  2 files changed, 29 insertions(+), 0 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 8c8f6c5..1acbc99 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1847,3 +1847,30 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
>  	asmlinkage_protect(5, ret, ctx_id, min_nr, nr, events, timeout);
>  	return ret;
>  }
> +
> +/**
> + * mm_has_pending_aio() - check for outstanding AIO operations
> + * @mm:		The mm_struct to check.
> + *
> + * Returns true if there is at least one non-dead kioctx on
> + * @mm->ioctx_list.  Note that the result of this function is
> + * unreliable unless the caller has ensured that new requests cannot
> + * be submitted against @mm (e.g. through freezing the associated
> + * tasks).
> + */
> +bool mm_has_pending_aio(struct mm_struct *mm)
> +{
> +	struct kioctx *ctx;
> +	struct hlist_node *n;
> +	bool has_aio = false;
> +
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list) {
> +		if (!ctx->dead) {
> +			has_aio = true;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return has_aio;
> +}
> diff --git a/include/linux/aio.h b/include/linux/aio.h
> index 7a8db41..39d9936 100644
> --- a/include/linux/aio.h
> +++ b/include/linux/aio.h
> @@ -214,6 +214,7 @@ struct mm_struct;
>  extern void exit_aio(struct mm_struct *mm);
>  extern long do_io_submit(aio_context_t ctx_id, long nr,
>  			 struct iocb __user *__user *iocbpp, bool compat);
> +extern bool mm_has_pending_aio(struct mm_struct *mm);
>  #else
>  static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
>  static inline int aio_put_req(struct kiocb *iocb) { return 0; }
> @@ -224,6 +225,7 @@ static inline void exit_aio(struct mm_struct *mm) { }
>  static inline long do_io_submit(aio_context_t ctx_id, long nr,
>  				struct iocb __user * __user *iocbpp,
>  				bool compat) { return 0; }
> +static inline bool mm_has_pending_aio(struct mm_struct *mm) { return false; }
>  #endif /* CONFIG_AIO */
>  
>  static inline struct kiocb *list_kiocb(struct list_head *h)
