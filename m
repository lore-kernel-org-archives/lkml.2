Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0FXRhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 13:37:40 -0400
Received: from mail.perches.com ([173.55.12.10]:1276 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab0FXRhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:37:38 -0400
Subject: Re: [PATCH] Staging: d53155_drv.c: cleanup fbuffer usage
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
       ss@aao.gov.au, gregkh@suse.de
In-Reply-To: <201006240931.13833.hartleys@visionengravers.com>
References: <201006240931.13833.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 10:37:32 -0700
Message-ID: <1277401052.1654.59.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 09:31 -0700, H Hartley Sweeten wrote:
> The global symbol dt3155_fbuffer[], declared in dt3155_isr.c, is really
> just a pointer to dt3155_status[].fbuffer. To improve readability, make
> some of the really long lines shorter, and make the buffer access more
> consistent, use &dt3155_status[].fbuffer to access the buffer structure.

I think this would be more consistent/intelligible
if the temporary wasn't
	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
but was
	struct dt3155_status *dts = &dt3155_status[minor];

> @@ -146,11 +148,11 @@ static void quick_stop (int minor)
>    dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
>    /* mark the system stopped: */
>    dt3155_status[minor].state |= DT3155_STATE_IDLE;
> -  dt3155_fbuffer[minor]->stop_acquire = 0;
> -  dt3155_fbuffer[minor]->even_stopped = 0;
> +  fb->stop_acquire = 0;
> +  fb->even_stopped = 0;
>  #else
>    dt3155_status[minor].state |= DT3155_STATE_STOP;
> -  dt3155_status[minor].fbuffer.stop_acquire = 1;
> +  fb->stop_acquire = 1;
>  #endif

becomes

  dts->state &= ~(DT3155_STATE_STOP|0xff);
  /* mark the system stopped: */
  dts->state |= DT3155_STATE_IDLE;
  dts->fbuffer.stop_acquire = 0;
  dts->fbuffer.even_stopped = 0;
#else
  dts->fbuffer.stop_acquire = 1;
#endif

Another option might be to use dereferencing inlines.

static inline struct dt3155_status *dts(int index)
{
	return &dt3155_status[index];
}
static inline struct dt3155_fbuffer *fb(int index)
{
	return &(dts(index)->fbuffer);
}

I think this isn't as good as the temporary because the
compiler sometimes doesn't reuse the intermediate addresses
and the inlines have file rather than function scope.

It becomes something like:

  dts(minor)->state &= ~(DT3155_STATE_STOP|0xff);
  /* mark the system stopped: */
  dts(minor)->state |= DT3155_STATE_IDLE;
  fb(minor)->stop_acquire = 0;
  fb(minor)->even_stopped = 0;
#else
  fb(minor)->stop_acquire = 1;
#endif

I think this isn't as good as the temporary because the
compiler sometimes doesn't reuse the intermediate addresses
and the macros have file rather than function scope.


