Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab2DIIat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:30:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34989 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab2DIIas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:30:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120408233835.GC4839@panacea>
References: <20120408233550.GA3791@panacea>
	<20120408233835.GC4839@panacea>
Date: Mon, 9 Apr 2012 11:30:47 +0300
X-Google-Sender-Auth: KVEEAsVc4rqNGNC161JQ9as5LJQ
Message-ID: <CAOJsxLHQv3xaa3JGPxu0vpSxNvD5gxxGVa=87w_6K0UcSpukWQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] vmevent: Implement cross event type
From: Pekka Enberg <penberg@kernel.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 2:38 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> This patch implements a new event type, it will trigger whenever a
> value crosses a user-specified threshold. It works two-way, i.e. when
> a value crosses the threshold from a lesser values side to a greater
> values side, and vice versa.
>
> We use the event type in an userspace low-memory killer: we get a
> notification when memory becomes low, so we start freeing memory by
> killing unneeded processes, and we get notification when memory hits
> the threshold from another side, so we know that we freed enough of
> memory.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  include/linux/vmevent.h              |    9 +++++++++
>  mm/vmevent.c                         |   21 +++++++++++++++++++++
>  tools/testing/vmevent/vmevent-test.c |   15 ++++++++++-----
>  3 files changed, 40 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/vmevent.h b/include/linux/vmevent.h
> index 64357e4..00cc04f 100644
> --- a/include/linux/vmevent.h
> +++ b/include/linux/vmevent.h
> @@ -22,6 +22,15 @@ enum {
>         * Sample value is less than user-specified value
>         */
>        VMEVENT_ATTR_STATE_VALUE_LT     = (1UL << 0),
> +       /*
> +        * Sample value crossed user-specified value
> +        */
> +       VMEVENT_ATTR_STATE_VALUE_CROSS  = (1UL << 2),
> +
> +       /* Last saved state, used internally by the kernel. */
> +       __VMEVENT_ATTR_STATE_LAST       = (1UL << 30),
> +       /* Not first sample, used internally by the kernel. */
> +       __VMEVENT_ATTR_STATE_NFIRST     = (1UL << 31),
>  };
>
>  struct vmevent_attr {
> diff --git a/mm/vmevent.c b/mm/vmevent.c
> index a56174f..f8fd2d6 100644
> --- a/mm/vmevent.c
> +++ b/mm/vmevent.c
> @@ -1,5 +1,6 @@
>  #include <linux/anon_inodes.h>
>  #include <linux/atomic.h>
> +#include <linux/compiler.h>
>  #include <linux/vmevent.h>
>  #include <linux/syscalls.h>
>  #include <linux/timer.h>
> @@ -94,6 +95,26 @@ static bool vmevent_match(struct vmevent_watch *watch)
>                if (attr->state & VMEVENT_ATTR_STATE_VALUE_LT) {
>                        if (value < attr->value)
>                                return true;
> +               } else if (attr->state & VMEVENT_ATTR_STATE_VALUE_CROSS) {
> +                       bool fst = !(attr->state & __VMEVENT_ATTR_STATE_NFIRST);
> +                       bool old = attr->state & __VMEVENT_ATTR_STATE_LAST;
> +                       bool new = value < attr->value;
> +                       bool chg = old ^ new;
> +                       bool ret = chg;
> +
> +                       /*
> +                        * This is not 'lt' or 'gt' match, so on the first
> +                        * sample assume we crossed the threshold.
> +                        */
> +                       if (unlikely(fst)) {
> +                               attr->state |= __VMEVENT_ATTR_STATE_NFIRST;
> +                               ret = true;
> +                       }
> +
> +                       attr->state &= ~__VMEVENT_ATTR_STATE_LAST;
> +                       attr->state |= new ? __VMEVENT_ATTR_STATE_LAST : 0;
> +
> +                       return ret;
>                }
>        }
>

Can't we implement this by specifying both VMEVENT_ATTR_STATE_VALUE_LT
and VMEVENT_ATTR_STATE_VALUE_GT in userspace? I assume the problem
with current approach is that you get more than one notifications,
right? We can implement a "single-shot" flag to deal with that.
