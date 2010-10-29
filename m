Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab0J2AFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:05:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61709 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab0J2AFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:05:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oaXoJrZU5vap3Q2Zj4OGS4acyNypf+vbzi+WvV2FjA4xQXGCUlNtrJ9lZ1sq/51kQa
         ldVOajv+iHPDwwUCcb8w==
MIME-Version: 1.0
In-Reply-To: <4CC14756.5010504@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	<4CC14756.5010504@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 17:05:05 -0700
Message-ID: <AANLkTi=wS8aOuVQ-WBPGyP24oAigAqeZxKgAtpw8PnZY@mail.gmail.com>
Subject: Re: [PATCH 6/7] cgroups: Warn if a bindable subsystem calls css_get()
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe re-title this patch to BUG() if a bindable subsystem calls css_get() ?

Paul

On Fri, Oct 22, 2010 at 1:12 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> For now bindable subsystems should not use css_get/put(), so warn
> on this misuse.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/cgroup.h |    7 +++++--
>  kernel/cgroup.c        |    3 +++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 1e4e1df..10e4e02 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -80,13 +80,15 @@ struct cgroup_subsys_state {
>
>  /* bits in struct cgroup_subsys_state flags field */
>  enum {
> -       CSS_ROOT, /* This CSS is the root of the subsystem */
> -       CSS_REMOVED, /* This CSS is dead */
> +       CSS_ROOT,       /* This CSS is the root of the subsystem */
> +       CSS_REMOVED,    /* This CSS is dead */
> +       CSS_NO_GET,     /* Forbid calling css_get/put() */
>  };
>
>  /* Caller must verify that the css is not for root cgroup */
>  static inline void __css_get(struct cgroup_subsys_state *css, int count)
>  {
> +       BUG_ON(test_bit(CSS_NO_GET, &css->flags));
>        atomic_add(count, &css->refcnt);
>  }
>
> @@ -119,6 +121,7 @@ static inline bool css_tryget(struct cgroup_subsys_state *css)
>  {
>        if (test_bit(CSS_ROOT, &css->flags))
>                return true;
> +       BUG_ON(test_bit(CSS_NO_GET, &css->flags));
>        while (!atomic_inc_not_zero(&css->refcnt)) {
>                if (test_bit(CSS_REMOVED, &css->flags))
>                        return false;
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 12c1f7c..88e265d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -936,6 +936,9 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
>        css->cgroup = cgrp;
>        atomic_set(&css->refcnt, 1);
>        css->flags = 0;
> +       /* For now, a bindable subsystem should not call css_get/put(). */
> +       if (ss->can_bind)
> +               set_bit(CSS_NO_GET, &css->flags);
>        css->id = NULL;
>        if (cgrp == dummytop)
>                set_bit(CSS_ROOT, &css->flags);
> --
> 1.7.0.1
>
>
