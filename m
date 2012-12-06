Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2LFWqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:46:31 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60148 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2LFWqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:46:30 -0500
MIME-Version: 1.0
In-Reply-To: <1354810806-81681-1-git-send-email-tim.gardner@canonical.com>
References: <1354810806-81681-1-git-send-email-tim.gardner@canonical.com>
Date: Thu, 6 Dec 2012 22:46:29 +0000
Message-ID: <CAPM=9ty_PfiQ9Cd5CRNnQbZ7Ea-69qCUR7JM=BA-n_egDnOE5g@mail.gmail.com>
Subject: Re: [PATCH 3.7-rc8] ttm: Fix possible _manager memory allocation oops
From: Dave Airlie <airlied@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        dri-devel@lists.freedesktop.org, David Howells <dhowells@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 4:20 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Memory for _manager is allocated using kzalloc() but the result is not checked.
>
> Free _manager on error lest memory become orphaned.
>
> I was led to scrutinize ttm_page_alloc_init() from a smatch warning:
>
> drivers/gpu/drm/ttm/ttm_page_alloc.c:799 ttm_page_alloc_init() error: potential null dereference '_manager'.  (kzalloc returns null)
>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Zhao Yakui <yakui.zhao@intel.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: stable@vger.kernel.org # 3.5+
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>
> This patch applies to stable 3.5 and newer.
>
>  drivers/gpu/drm/ttm/ttm_page_alloc.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> index bd2a3b4..2c73d0a 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> @@ -798,6 +798,10 @@ int ttm_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
>         pr_info("Initializing pool allocator\n");
>
>         _manager = kzalloc(sizeof(*_manager), GFP_KERNEL);
> +       if (!_manager) {
> +               pr_err("ttm: Could not allocate _manager.\n");
> +               return -ENOMEM;
> +       }

This is fine,
>
>         ttm_page_pool_init_locked(&_manager->wc_pool, GFP_HIGHUSER, "wc");
>
> @@ -817,6 +821,7 @@ int ttm_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
>                                    &glob->kobj, "pool");
>         if (unlikely(ret != 0)) {
>                 kobject_put(&_manager->kobj);
> +               kfree(_manager);
>                 _manager = NULL;

I don;t think this is, since the kobject_put shuold free it.

Dave.
