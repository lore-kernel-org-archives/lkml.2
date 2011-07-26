Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1GZBFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:05:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55696 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GZBFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:05:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=CGPSxVNVFqHN9Si6qgorQes4wUpMJkql3ojAUSU27oS0IrX5fOJ5znwyB2dlKnLNo
	/vcL3+Xft94lGI7UozTNQ==
MIME-Version: 1.0
In-Reply-To: <1310393706-321-7-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com> <1310393706-321-7-git-send-email-fweisbec@gmail.com>
From: Paul Menage <menage@google.com>
Date: Mon, 25 Jul 2011 18:05:00 -0700
Message-ID: <CAJniumUGC5-KS5Rbg0SkHv5xD4XtAifYAaEM1-X-W7zbgCwCcg@mail.gmail.com>
Subject: Re: [PATCH 6/7] cgroups: Add res counter common ancestor searching
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 7:15 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Add a new API to find the common ancestor between two resource
> counters. This includes the passed resource counter themselves.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Paul Menage <menage@google.com>

There's something distasteful about doing an O(N^2) search on every
charge/uncharge operation, but I guess in general N isn't going to be
more than 2 or 3 so it's not worth optimizing.

If you wanted to avoid the N^2 search then you could add a "depth"
field in struct res_counter, which would be initialized to
parent->depth+1, and then easily get both r1 and r2 to the same depth
before proceeding up the tree in lock step, but that would bloat all
instances of res_counter, which might work out as more expensive in
the long run.

Paul

> Cc: Paul Menage <menage@google.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> ---
>  include/linux/res_counter.h |    2 ++
>  kernel/res_counter.c        |   19 +++++++++++++++++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index 8c421ac..354ed30 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -139,6 +139,8 @@ void res_counter_uncharge_until(struct res_counter *counter, struct res_counter
>                                unsigned long val);
>  void res_counter_uncharge(struct res_counter *counter, unsigned long val);
>
> +struct res_counter *res_counter_common_ancestor(struct res_counter *l, struct res_counter *r);
> +
>  /**
>  * res_counter_margin - calculate chargeable space of a counter
>  * @cnt: the counter
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 39f2513..1b2efd6 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -102,6 +102,25 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val)
>        res_counter_uncharge_until(counter, NULL, val);
>  }
>
> +struct res_counter *
> +res_counter_common_ancestor(struct res_counter *r1, struct res_counter *r2)
> +{
> +       struct res_counter *iter;
> +
> +       while (r1) {
> +               iter = r2;
> +               while (iter) {
> +                       if (iter == r1)
> +                               return iter;
> +                       iter = iter->parent;
> +               }
> +
> +               r1 = r1->parent;
> +       }
> +
> +       return NULL;
> +}
> +
>  static inline unsigned long long *
>  res_counter_member(struct res_counter *counter, int member)
>  {
> --
> 1.7.5.4
>
>
