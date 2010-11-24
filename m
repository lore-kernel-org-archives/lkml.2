Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab0KXXzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:55:13 -0500
Received: from smtp-out.google.com ([74.125.121.35]:24845 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0KXXzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:55:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cNNd82c6mKzicNhwyn8hH2NGYhDqpLpfgKAHVeDD7eD4ehN4xjZs41s6gAtGu1PLLv
         OKH0NyiKKIRDGaX9LWow==
MIME-Version: 1.0
In-Reply-To: <1290577024-12347-1-git-send-email-ccross@android.com>
References: <AANLkTi=6nwDCdzDz7E2EaAw2pf3KUVjmKMRqGfz5zVhP@mail.gmail.com> <1290577024-12347-1-git-send-email-ccross@android.com>
From: Paul Menage <menage@google.com>
Date: Wed, 24 Nov 2010 15:54:38 -0800
Message-ID: <AANLkTimFqJ+qPidS_81DKd7ExSxDG7GNi0gjcUEEq_7j@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroup: Set CGRP_RELEASABLE when adding to a cgroup
To: Colin Cross <ccross@android.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 9:37 PM, Colin Cross <ccross@android.com> wrote:
> @@ -364,12 +372,8 @@ static void __put_css_set(struct css_set *cg, int taskexit)
>                struct cgroup *cgrp = link->cgrp;
>                list_del(&link->cg_link_list);
>                list_del(&link->cgrp_link_list);
> -               if (atomic_dec_and_test(&cgrp->count) &&
> -                   notify_on_release(cgrp)) {
> -                       if (taskexit)
> -                               set_bit(CGRP_RELEASABLE, &cgrp->flags);
> +               if (atomic_dec_and_test(&cgrp->count))
>                        check_for_release(cgrp);
> -               }

We seem to have lost some notify_on_release() checks - maybe move that
to check_for_release()?
>  /* Caller must verify that the css is not for root cgroup */
> +void __css_get(struct cgroup_subsys_state *css, int count)
> +{
> +       atomic_add(count, &css->refcnt);
> +       set_bit(CGRP_RELEASABLE, &css->cgroup->flags);
> +}

Is css_get() the right place to be putting this? It's not clear to me
why a subsystem taking a refcount on a cgroup's state should render it
releasable when it drops that refcount.

Should we maybe clear the CGRP_RELEASABLE flag right before doing the
userspace callback?

Paul
