Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1FNLWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:22:04 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63477 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1FNLWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=a7Stv1r2DW30gQLt16Tuz2kkfQ6dHPBAcPiNhZ6YarlL6qlj8zHm/x+PmYyUZyYcsY
         Kbc28z/P079nninTbJfAzRgC1vH1eO7+QfZVSAUq/4ZrmEzggqjoA211OBZzmM/ckPhh
         FB32oGxz9Ff8uYgei5C9NOo+UnKtPPInJkQz8=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1106140341070.29206@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
	<alpine.LSU.2.00.1106140341070.29206@sister.anvils>
Date: Tue, 14 Jun 2011 14:22:00 +0300
X-Google-Sender-Auth: eqMuWZ_bvhfeqk1zlx9Gh0fJJpQ
Message-ID: <BANLkTinGHSpn2aF-HM-R-eu12ZqMTpHQdQ@mail.gmail.com>
Subject: Re: [PATCH 1/12] radix_tree: exceptional entries and indices
From: Pekka Enberg <penberg@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh!

On Tue, Jun 14, 2011 at 1:42 PM, Hugh Dickins <hughd@google.com> wrote:
> @@ -39,7 +39,15 @@
>  * when it is shrunk, before we rcu free the node. See shrink code for
>  * details.
>  */
> -#define RADIX_TREE_INDIRECT_PTR        1
> +#define RADIX_TREE_INDIRECT_PTR                1
> +/*
> + * A common use of the radix tree is to store pointers to struct pages;
> + * but shmem/tmpfs needs also to store swap entries in the same tree:
> + * those are marked as exceptional entries to distinguish them.
> + * EXCEPTIONAL_ENTRY tests the bit, EXCEPTIONAL_SHIFT shifts content past it.
> + */
> +#define RADIX_TREE_EXCEPTIONAL_ENTRY   2
> +#define RADIX_TREE_EXCEPTIONAL_SHIFT   2
>
>  #define radix_tree_indirect_to_ptr(ptr) \
>        radix_tree_indirect_to_ptr((void __force *)(ptr))
> @@ -174,6 +182,28 @@ static inline int radix_tree_deref_retry
>  }
>
>  /**
> + * radix_tree_exceptional_entry        - radix_tree_deref_slot gave exceptional entry?
> + * @arg:       value returned by radix_tree_deref_slot
> + * Returns:    0 if well-aligned pointer, non-0 if exceptional entry.
> + */
> +static inline int radix_tree_exceptional_entry(void *arg)
> +{
> +       /* Not unlikely because radix_tree_exception often tested first */
> +       return (unsigned long)arg & RADIX_TREE_EXCEPTIONAL_ENTRY;
> +}
> +
> +/**
> + * radix_tree_exception        - radix_tree_deref_slot returned either exception?
> + * @arg:       value returned by radix_tree_deref_slot
> + * Returns:    0 if well-aligned pointer, non-0 if either kind of exception.
> + */
> +static inline int radix_tree_exception(void *arg)
> +{
> +       return unlikely((unsigned long)arg &
> +               (RADIX_TREE_INDIRECT_PTR | RADIX_TREE_EXCEPTIONAL_ENTRY));
> +}

Would something like radix_tree_augmented() be a better name for this
(with RADIX_TREE_AUGMENTED_MASK defined)? This one seems too easy to
confuse with radix_tree_exceptional_entry() to me which is not the
same thing, right?

                                Pekka
