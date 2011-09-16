Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab1IPNNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:13:49 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55204 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1IPNNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:13:48 -0400
MIME-Version: 1.0
In-Reply-To: <1316177430-13167-2-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1316177430-13167-2-git-send-email-zohar@linux.vnet.ibm.com>
Date: Fri, 16 Sep 2011 16:13:47 +0300
Message-ID: <CAHp75VexDE3UXUQYv=i=nLtiVWJFwDuYwzDub2nG2nQHqFn9Pw@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/5] lib: add error checking to hex2bin
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Safford <safford@watson.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 3:50 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> hex2bin converts a hexadecimal string to its binary representation.
> The original version of hex2bin did not do any error checking.  This
> patch adds error checking and returns the result.
>
> Changelog:
> - use the new unpack_hex_byte()
> - add __must_check compiler option (Andy Shevchenko's suggestion)
> - change function API to return error checking result
>  (based on Tetsuo Handa's initial patch)
>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  include/linux/kernel.h |    2 +-
>  lib/hexdump.c          |   11 +++++++----
>  2 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d8ea13b..3021e64 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -382,7 +382,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
>  }
>
>  extern int hex_to_bin(char ch);
> -extern void hex2bin(u8 *dst, const char *src, size_t count);
> +extern bool __must_check hex2bin(u8 *dst, const char *src, size_t count);
>
>  /*
>  * unpack_hex_byte - convert 2 asii hex digits into a byte
> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index f5fe6ba..7711095 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -38,14 +38,17 @@ EXPORT_SYMBOL(hex_to_bin);
>  * @dst: binary result
>  * @src: ascii hexadecimal string
>  * @count: result length
> + *
> + * Returns true on success, false in case of bad input.
>  */
> -void hex2bin(u8 *dst, const char *src, size_t count)
> +bool hex2bin(u8 *dst, const char *src, size_t count)
>  {
>        while (count--) {
> -               *dst = hex_to_bin(*src++) << 4;
> -               *dst += hex_to_bin(*src++);
> -               dst++;
> +               if (!unpack_hex_byte(dst++, src))
> +                       return false;
> +               src += 2;
>        }
> +       return true;
>  }
>  EXPORT_SYMBOL(hex2bin);
>

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko
