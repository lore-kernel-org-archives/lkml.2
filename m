Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2BIFP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 00:15:28 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46861 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2BIFP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 00:15:27 -0500
MIME-Version: 1.0
In-Reply-To: <4F32C105.4060700@am.sony.com>
References: <4F31DC31.6040303@am.sony.com>
	<4F31DDC7.1050107@am.sony.com>
	<4F32C105.4060700@am.sony.com>
Date: Wed, 8 Feb 2012 21:15:26 -0800
X-Google-Sender-Auth: _iZqSPMpuEYvaQnRT0aeaZ0qFI8
Message-ID: <CAPz4a6CFd_L=hDw9uG56ZnhiqqnsPCLTR_3G=Zo5KDnTP=MwiA@mail.gmail.com>
Subject: Re: [PATCH 2/5 v2] logger: simplify and optimize get_entry_len
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

On Wed, Feb 8, 2012 at 10:37 AM, Tim Bird <tim.bird@am.sony.com> wrote:
> Make this code slightly easier to read, and eliminate calls
> to sub-routines.  Some of these were previously optimized away
> by the compiler, but one memcpy was not.
>
> In my testing, this makes the code about 20% smaller, and
> has no sub-routine calls and no branches (on ARM).
>
> v2 of this patch is, IMHO, easier to read than v1. Compared to
> that patch it uses __u8 instead of unsigned char, for
> consistency with the __u16 val data type, simplifies the
> conditional expression, adds a another comment, and
> moves a common statement out of the if.
>
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  drivers/staging/android/logger.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index 92456d7..3475cb7 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -93,20 +93,24 @@ static inline struct logger_log *file_get_log(struct file *file)
>  * get_entry_len - Grabs the length of the payload of the next entry starting
>  * from 'off'.
>  *
> + * An entry length is 2 bytes (16 bits) in host endian order.
> + * In the log, the length does not include the size of the log entry structure.
> + * This function returns the size including the log entry structure.
> + *
>  * Caller needs to hold log->mutex.
>  */
>  static __u32 get_entry_len(struct logger_log *log, size_t off)
>  {
>        __u16 val;

Could using a union here make things look a little cleaner in the meat
of the function? Something like

union {
    __u16 s;
    __u8 b[2];
} val;

>
> -       switch (log->size - off) {
> -       case 1:
> -               memcpy(&val, log->buffer + off, 1);
> -               memcpy(((char *) &val) + 1, log->buffer, 1);
> -               break;
> -       default:
> -               memcpy(&val, log->buffer + off, 2);
> -       }
> +       /* copy 2 bytes from buffer, in memcpy order, */
> +       /* handling possible wrap at end of buffer */
> +
> +       ((__u8 *)&val)[0] = log->buffer[off];
> +       if (likely(off+1 < log->size))
> +               ((__u8 *)&val)[1] = log->buffer[off+1];

spaces around the + in 'off+1' in the above two lines.

> +       else
> +               ((__u8 *)&val)[1] = log->buffer[0];
>
>        return sizeof(struct logger_entry) + val;
>  }
> --
> 1.7.2.3
>
