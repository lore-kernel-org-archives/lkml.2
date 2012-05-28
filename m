Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab2E1KBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:01:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41423 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab2E1KBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <1338195605-22513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1337956368-30621-1-git-send-email-andrei.emeltchenko.news@gmail.com>
	<1338195605-22513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Date: Mon, 28 May 2012 13:01:05 +0300
Message-ID: <CAHp75Vc3sut7R7FF=xHQ0-3HaydPBh86sNnzRjKP8+ow=SOfLg@mail.gmail.com>
Subject: Re: [PATCHv2] vsprintf: Add %pMR for Bluetooth MAC address
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, adobriyan@gmail.com,
        andriy.shevchenko@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 12:00 PM, Andrei Emeltchenko
<Andrei.Emeltchenko.news@gmail.com> wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
>
> Bluetooth uses mostly LE byte order which is reversed for visual
> interpretation. Currently in Bluetooth in use unsafe batostr function.
>
> This is slightly modified version of Joe Perches <joe@perches.com>
> patch (sent Sat, Dec 4, 2010).
>
> Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> ---
>        v2: changed bluetooth to reversed, syntax fixes
>
>  lib/vsprintf.c |   22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index abbabec..d98b12d 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -557,17 +557,27 @@ char *mac_address_string(char *buf, char *end, u8 *addr,
>  {
>        char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
>        char *p = mac_addr;
> -       int i;
> +       int i, index;
>        char separator;
> +       bool reversed = false;
>
> -       if (fmt[1] == 'F') {            /* FDDI canonical format */
> +       switch (fmt[1]) {
> +       case 'F':
>                separator = '-';
> -       } else {
> +               break;
> +
> +       case 'R':
> +               reversed = true;
> +               /* fall through */
This solution looks a bit limited. On one hand it makes difficult to add another
case where format specifies colon separator with something else. On
the other hand
I don't see any troubles if you allow reverse as a modifier for both
cases %pMF & %pM

> +
> +       default:
>                separator = ':';
> +               break;
>        }
>
>        for (i = 0; i < 6; i++) {
> -               p = hex_byte_pack(p, addr[i]);
> +               index = !reversed ? i : 5 - i;
> +               p = hex_byte_pack(p, addr[index]);
I guess instead of using additional variable (index), you could use
just normal if () {} else {} sentence
here.

>                if (fmt[0] == 'M' && i != 5)
>                        *p++ = separator;
>        }
> @@ -830,6 +840,7 @@ int kptr_restrict __read_mostly;
>  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
>  * - 'MF' For a 6-byte MAC FDDI address, it prints the address
>  *       with a dash-separated hex notation
> + * - '[mM]R For a 6-byte MAC address, Reverse order (Bluetooth)
>  * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
>  *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
>  *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
> @@ -890,7 +901,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>                return resource_string(buf, end, ptr, spec, fmt);
>        case 'M':                       /* Colon separated: 00:01:02:03:04:05 */
>        case 'm':                       /* Contiguous: 000102030405 */
> -                                       /* [mM]F (FDDI, bit reversed) */
> +                                       /* [mM]F (FDDI) */
> +                                       /* [mM]R (Reverse order; Bluetooth) */
>                return mac_address_string(buf, end, ptr, spec, fmt);
>        case 'I':                       /* Formatted IP supported
>                                         * 4:   1.2.3.4



-- 
With Best Regards,
Andy Shevchenko
