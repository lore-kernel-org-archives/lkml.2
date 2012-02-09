Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2BIGJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:09:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41709 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2BIGJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:09:53 -0500
MIME-Version: 1.0
In-Reply-To: <4F31DEA2.7000702@am.sony.com>
References: <4F31DC31.6040303@am.sony.com>
	<4F31DEA2.7000702@am.sony.com>
Date: Wed, 8 Feb 2012 22:09:52 -0800
X-Google-Sender-Auth: si2venWDUGb-y2c7HlTQlHoIYbo
Message-ID: <CAPz4a6DpEUN_0wHdLdDT3fxmFr3j38sMn379+0hMFTdWRFDcFw@mail.gmail.com>
Subject: Re: [PATCH 4/5] logger: clarify code in clock_interval
From: Dima Zavin <dima@android.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be honest, i don't find the new logic code much different or
cleaner than the old code. I think just documenting (as well as the
function rename) as you've done without inverting the logic would be
sufficient. The ascii art helps immensely.

--Dima

On Tue, Feb 7, 2012 at 6:32 PM, Tim Bird <tim.bird@am.sony.com> wrote:
> Add commentary, rename the function and make the code easier to read.
>
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  drivers/staging/android/logger.c |   28 ++++++++++++++++++++--------
>  1 files changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index 54b7cdf..8d9d4f1 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -242,16 +242,28 @@ static size_t get_next_entry(struct logger_log *log, size_t off, size_t len)
>  }
>
>  /*
> - * clock_interval - is a < c < b in mod-space? Put another way, does the line
> - * from a to b cross c?
> + * is_between - is a < c < b, accounting for wrapping of a, b, and c
> + *    positions in the buffer
> + *
> + * That is, if a<b, check for c between a and b
> + * and if a>b, check for c outside (not between) a and b
> + *
> + * |------- a xxxxxxxx b --------|
> + *               c^
> + *
> + * |xxxxx b --------- a xxxxxxxxx|
> + *    c^
> + *  or                    c^
>  */
> -static inline int clock_interval(size_t a, size_t b, size_t c)
> +static inline int is_between(size_t a, size_t b, size_t c)
>  {
> -       if (b < a) {
> -               if (a < c || b >= c)
> +       if (a < b) {
> +               /* is c between a and b? */
> +               if (a < c && c <= b)
>                        return 1;
>        } else {
> -               if (a < c && b >= c)
> +               /* is c outside of b through a? */
> +               if (c <= b || a < c)
>                        return 1;
>        }
>
> @@ -272,11 +284,11 @@ static void fix_up_readers(struct logger_log *log, size_t len)
>        size_t new = logger_offset(log, old + len);
>        struct logger_reader *reader;
>
> -       if (clock_interval(old, new, log->head))
> +       if (is_between(old, new, log->head))
>                log->head = get_next_entry(log, log->head, len);
>
>        list_for_each_entry(reader, &log->readers, list)
> -               if (clock_interval(old, new, reader->r_off))
> +               if (is_between(old, new, reader->r_off))
>                        reader->r_off = get_next_entry(log, reader->r_off, len);
>  }
>
> --
> 1.7.2.3
>
