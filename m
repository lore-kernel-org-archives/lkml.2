Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab1KREPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:15:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59305 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab1KREPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:15:14 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1111171628260.1653-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1111171628260.1653-100000@iolanthe.rowland.org>
Date: Fri, 18 Nov 2011 13:15:12 +0900
Message-ID: <CAKYAXd9fEJP7XsZtCMdCPszhhdgUrVhN=8RARrWs=Pq9uTw2aA@mail.gmail.com>
Subject: Re: [PATCH] NLS: improve UTF8 -> UTF16 string conversion routine
From: NamJae Jeon <linkinjeon@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Greg KH <greg@kroah.com>, Clemens Ladisch <clemens@ladisch.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAI4FVLc008255

2011/11/18 Alan Stern <stern@rowland.harvard.edu>:
> The utf8s_to_utf16s conversion routine needs to be improved.  Unlike
> its utf16s_to_utf8s sibling, it doesn't accept arguments specifying
> the maximum length of the output buffer or the endianness of its
> 16-bit output.
>
> This patch (as1501) adds the two missing arguments, and adjusts the
> only two places in the kernel where the function is called.  A
> follow-on patch will add a third caller that does utilize the new
> capabilities.
>
> The two conversion routines are still annoyingly inconsistent in the
> way they handle invalid byte combinations.  But that's a subject for a
> different patch.
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Clemens Ladisch <clemens@ladisch.de>
>
> ---
>
>  drivers/hv/hv_kvp.c |   10 ++++++----
>  fs/fat/namei_vfat.c |    3 ++-
>  fs/nls/nls_base.c   |   43 +++++++++++++++++++++++++++++++++----------
>  include/linux/nls.h |    5 +++--
>  4 files changed, 44 insertions(+), 17 deletions(-)
>
> Index: usb-3.2/include/linux/nls.h
> ===================================================================
> --- usb-3.2.orig/include/linux/nls.h
> +++ usb-3.2/include/linux/nls.h
> @@ -43,7 +43,7 @@ enum utf16_endian {
>        UTF16_BIG_ENDIAN
>  };
>
> -/* nls.c */
> +/* nls_base.c */
>  extern int register_nls(struct nls_table *);
>  extern int unregister_nls(struct nls_table *);
>  extern struct nls_table *load_nls(char *);
> @@ -52,7 +52,8 @@ extern struct nls_table *load_nls_defaul
>
>  extern int utf8_to_utf32(const u8 *s, int len, unicode_t *pu);
>  extern int utf32_to_utf8(unicode_t u, u8 *s, int maxlen);
> -extern int utf8s_to_utf16s(const u8 *s, int len, wchar_t *pwcs);
> +extern int utf8s_to_utf16s(const u8 *s, int len,
> +               enum utf16_endian endian, wchar_t *pwcs, int maxlen);
>  extern int utf16s_to_utf8s(const wchar_t *pwcs, int len,
>                enum utf16_endian endian, u8 *s, int maxlen);
>
> Index: usb-3.2/fs/nls/nls_base.c
> ===================================================================
> --- usb-3.2.orig/fs/nls/nls_base.c
> +++ usb-3.2/fs/nls/nls_base.c
> @@ -114,34 +114,57 @@ int utf32_to_utf8(unicode_t u, u8 *s, in
>  }
>  EXPORT_SYMBOL(utf32_to_utf8);
>
> -int utf8s_to_utf16s(const u8 *s, int len, wchar_t *pwcs)
> +static inline void put_utf16(wchar_t *s, unsigned c, enum utf16_endian endian)
> +{
> +       switch (endian) {
> +       default:
> +               *s = (wchar_t) c;
> +               break;
> +       case UTF16_LITTLE_ENDIAN:
> +               *s = __cpu_to_le16(c);
> +               break;
> +       case UTF16_BIG_ENDIAN:
> +               *s = __cpu_to_be16(c);
> +               break;
> +       }
> +}
> +
> +int utf8s_to_utf16s(const u8 *s, int len, enum utf16_endian endian,
> +               wchar_t *pwcs, int maxlen)
>  {
>        u16 *op;
>        int size;
>        unicode_t u;
>
>        op = pwcs;
> -       while (*s && len > 0) {
> +       while (len > 0 && maxlen > 0 && *s) {
>                if (*s & 0x80) {
>                        size = utf8_to_utf32(s, len, &u);
>                        if (size < 0)
>                                return -EINVAL;
> +                       s += size;
> +                       len -= size;
Why did you move this code to here ?
>
>                        if (u >= PLANE_SIZE) {
> +                               if (maxlen < 2)
> +                                       break;
>                                u -= PLANE_SIZE;
> -                               *op++ = (wchar_t) (SURROGATE_PAIR |
> -                                               ((u >> 10) & SURROGATE_BITS));
> -                               *op++ = (wchar_t) (SURROGATE_PAIR |
> +                               put_utf16(op++, SURROGATE_PAIR |
> +                                               ((u >> 10) & SURROGATE_BITS),
> +                                               endian);
> +                               put_utf16(op++, SURROGATE_PAIR |
>                                                SURROGATE_LOW |
> -                                               (u & SURROGATE_BITS));
> +                                               (u & SURROGATE_BITS),
> +                                               endian);
> +                               maxlen -= 2;

Why did you use contants value(-2) instead of maxlen -= size; value ?

>                        } else {
> -                               *op++ = (wchar_t) u;
> +                               put_utf16(op++, u, endian);
> +                               maxlen--;
>                        }
> -                       s += size;
> -                       len -= size;
>                } else {
> -                       *op++ = *s++;
> +                       put_utf16(op++, *s++, endian);
>                        len--;
> +                       maxlen--;
>                }
>        }
>        return op - pwcs;
> Index: usb-3.2/fs/fat/namei_vfat.c
> ===================================================================
> --- usb-3.2.orig/fs/fat/namei_vfat.c
> +++ usb-3.2/fs/fat/namei_vfat.c
> @@ -512,7 +512,8 @@ xlate_to_uni(const unsigned char *name,
>        int charlen;
>
>        if (utf8) {
> -               *outlen = utf8s_to_utf16s(name, len, (wchar_t *)outname);
> +               *outlen = utf8s_to_utf16s(name, len, UTF16_HOST_ENDIAN,
> +                               (wchar_t *) outname, FAT_LFN_LEN + 2);
Is there the reason why you plus 2 to FAT_LFN_LEN ?
>                if (*outlen < 0)
>                        return *outlen;
>                else if (*outlen > FAT_LFN_LEN)
                          return -ENAMETOOLONG;
"else if (*outlen > FAT_LFN_LEN)" code  is needed ? Is there the case
that *outlen is over FAT_LFN_LEN in your patch ?

Thanks.
> Index: usb-3.2/drivers/hv/hv_kvp.c
> ===================================================================
> --- usb-3.2.orig/drivers/hv/hv_kvp.c
> +++ usb-3.2/drivers/hv/hv_kvp.c
> @@ -212,11 +212,13 @@ kvp_respond_to_host(char *key, char *val
>         * The windows host expects the key/value pair to be encoded
>         * in utf16.
>         */
> -       keylen = utf8s_to_utf16s(key_name, strlen(key_name),
> -                               (wchar_t *)kvp_data->data.key);
> +       keylen = utf8s_to_utf16s(key_name, strlen(key_name), UTF16_HOST_ENDIAN,
> +                               (wchar_t *) kvp_data->data.key,
> +                               HV_KVP_EXCHANGE_MAX_KEY_SIZE / 2);
>        kvp_data->data.key_size = 2*(keylen + 1); /* utf16 encoding */
> -       valuelen = utf8s_to_utf16s(value, strlen(value),
> -                               (wchar_t *)kvp_data->data.value);
> +       valuelen = utf8s_to_utf16s(value, strlen(value), UTF16_HOST_ENDIAN,
> +                               (wchar_t *) kvp_data->data.value,
> +                               HV_KVP_EXCHANGE_MAX_VALUE_SIZE / 2);
>        kvp_data->data.value_size = 2*(valuelen + 1); /* utf16 encoding */
>
>        kvp_data->data.value_type = REG_SZ; /* all our values are strings */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
