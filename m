Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab1LJOHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 09:07:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41205 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1LJOHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 09:07:09 -0500
MIME-Version: 1.0
In-Reply-To: <20111210104840.295857663@chello.nl>
References: <20111210104341.592561407@chello.nl>
	<20111210104840.295857663@chello.nl>
Date: Sat, 10 Dec 2011 22:07:08 +0800
Message-ID: <CACVXFVPKgg98UBDaCC9eU605mRYrtCiPH6+zQLcvdY2Hp4LMYg@mail.gmail.com>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu, Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 10, 2011 at 6:43 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Commit 1b0b3b9980e ("kref: fix CPU ordering with respect to krefs")
> wrongly adds memory barriers to kref.
>
> It states:
>
>  some atomic operations are only atomic, not ordered. Thus a CPU is allowed
>  to reorder memory references to an object to before the reference is
>  obtained. This fixes it.
>
> While true, it fails to show why this is a problem. I say it is not a

IMO, the added two barriers are pairs of the implicit barrier in kref_put, so
that we can order between kref_init/kref_get and kref_put.

> problem because if there is a race with kref_put() such that we could
> end up referencing a free'd object without this memory barrier, we
> would still have that race with the memory barrier.
>
> The kref_put() in question could complete (and free the object) before
> the atomic_inc() and we'd still be up shit creek.
>
> The kref_init() case is even worse, if your object is published at this
> time you're so wrong the memory barrier won't make a difference what
> so ever. If its not published, the act of publishing should include
> the needed barriers/locks to make sure all writes prior to the act of
> publishing are complete such that others will only observe a complete
> object.
>
> Cc: adobriyan@gmail.com
> Cc: eric.dumazet@gmail.com
> Cc: mingo@elte.hu
> Cc: Oliver Neukum <oneukum@suse.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/kref.h |    2 --
>  1 file changed, 2 deletions(-)
>
> Index: linux-2.6/include/linux/kref.h
> ===================================================================
> --- linux-2.6.orig/include/linux/kref.h
> +++ linux-2.6/include/linux/kref.h
> @@ -28,7 +28,6 @@ struct kref {
>  static inline void kref_init(struct kref *kref)
>  {
>        atomic_set(&kref->refcount, 1);
> -       smp_mb();
>  }
>
>  /**
> @@ -39,7 +38,6 @@ static inline void kref_get(struct kref
>  {
>        WARN_ON(!atomic_read(&kref->refcount));
>        atomic_inc(&kref->refcount);
> -       smp_mb__after_atomic_inc();
>  }
>
>  /**
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


thanks,
-- 
Ming Lei
