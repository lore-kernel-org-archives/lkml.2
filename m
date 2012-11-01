Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965595Ab2KAUNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:13:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59030 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964Ab2KAUNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:13:02 -0400
MIME-Version: 1.0
In-Reply-To: <1351799279-23824-1-git-send-email-jwerner@chromium.org>
References: <20121101175217.GJ29270@xanatos>
	<1351799279-23824-1-git-send-email-jwerner@chromium.org>
Date: Thu, 1 Nov 2012 22:13:00 +0200
Message-ID: <CAHp75VfqYNMxxDKKvHOVOdtf0+ZkC_N3Zfy0Ahb0nNdG4Xh9xA@mail.gmail.com>
Subject: Re: [PATCH] xhci: fix null-pointer dereference when destroying
 half-built segment rings
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 9:47 PM, Julius Werner <jwerner@chromium.org> wrote:
> xhci_alloc_segments_for_ring() builds a list of xhci_segments and links
> the tail to head at the end (forming a ring). When it bails out for OOM
> reasons half-way through, it tries to destroy its half-built list with
> xhci_free_segments_for_ring(), even though it is not a ring yet. This
> causes a null-pointer dereference upon hitting the last element.
>
> Furthermore, one of its callers (xhci_ring_alloc()) mistakenly believes
> the output parameters to be valid upon this kind of OOM failure, and
> calls xhci_ring_free() on them. Since the (incomplete) list/ring should
> already be destroyed in that case, this would lead to a use after free.
>
> This patch fixes those issues by having xhci_alloc_segments_for_ring()
> destroy its half-built, non-circular list manually and destroying the
> invalid struct xhci_ring in xhci_ring_alloc() with a plain kfree().
>
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/host/xhci-mem.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> index 487bc08..fb51c70 100644
> --- a/drivers/usb/host/xhci-mem.c
> +++ b/drivers/usb/host/xhci-mem.c
> @@ -205,7 +205,12 @@ static int xhci_alloc_segments_for_ring(struct xhci_hcd *xhci,
>
>                 next = xhci_segment_alloc(xhci, cycle_state, flags);
>                 if (!next) {
> -                       xhci_free_segments_for_ring(xhci, *first);
> +                       prev = *first;
> +                       while (prev) {
> +                               next = prev->next;
> +                               xhci_segment_free(xhci, prev);
> +                               prev = next;
> +                       }

Is it just
for (prev = *first; prev; prev = prev->next)
    xhci_segment_free(xhci, prev);

?

>                         return -ENOMEM;
>                 }
>                 xhci_link_segments(xhci, prev, next, type);
> @@ -258,7 +263,7 @@ static struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci,
>         return ring;
>
>  fail:
> -       xhci_ring_free(xhci, ring);
> +       kfree(ring);
>         return NULL;
>  }
>
> --
> 1.7.8.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
With Best Regards,
Andy Shevchenko
