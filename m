Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1KSPwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 10:52:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53291 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1KSPww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 10:52:52 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1111191021390.995-100000@netrider.rowland.org>
References: <CAKYAXd8q+crqi9oAX84SJmkBEwWj2ycQ+kie0OSxmtdWB7v3Zg@mail.gmail.com>
	<Pine.LNX.4.44L0.1111191021390.995-100000@netrider.rowland.org>
Date: Sun, 20 Nov 2011 00:52:50 +0900
Message-ID: <CAKYAXd-sZrF0DD=cuRVAX3Uoivi6fYhpM5P=awaUUU=oQ8ZVow@mail.gmail.com>
Subject: Re: [PATCH] NLS: improve UTF8 -> UTF16 string conversion routine
From: NamJae Jeon <linkinjeon@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Greg KH <greg@kroah.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAJFr85K017126

2011/11/20 Alan Stern <stern@rowland.harvard.edu>:
> On Sat, 19 Nov 2011, NamJae Jeon wrote:
>
>> >> > +int utf8s_to_utf16s(const u8 *s, int len, enum utf16_endian endian,
>> >> > +               wchar_t *pwcs, int maxlen)
>> >> >  {
>> >> >        u16 *op;
>> >> >        int size;
>> >> >        unicode_t u;
>> >> >
>> >> >        op = pwcs;
>> >> > -       while (*s && len > 0) {
>> >> > +       while (len > 0 && maxlen > 0 && *s) {
>> >> >                if (*s & 0x80) {
>> >> >                        size = utf8_to_utf32(s, len, &u);
>> >> >                        if (size < 0)
>> >> >                                return -EINVAL;
>> >> > +                       s += size;
>> >> > +                       len -= size;
> ...
>> >> >                        if (u >= PLANE_SIZE) {
>> >> > +                               if (maxlen < 2)
>> >> > +                                       break;
>> >> >                                u -= PLANE_SIZE;
>> >> > -                               *op++ = (wchar_t) (SURROGATE_PAIR |
>> >> > -                                               ((u >> 10) & SURROGATE_BITS));
>> >> > -                               *op++ = (wchar_t) (SURROGATE_PAIR |
>> >> > +                               put_utf16(op++, SURROGATE_PAIR |
>> >> > +                                               ((u >> 10) & SURROGATE_BITS),
>> >> > +                                               endian);
>> >> > +                               put_utf16(op++, SURROGATE_PAIR |
>> >> >                                                SURROGATE_LOW |
>> >> > -                                               (u & SURROGATE_BITS));
>> >> > +                                               (u & SURROGATE_BITS),
>> >> > +                                               endian);
>> >> > +                               maxlen -= 2;
>> >>
>> >> Why did you use contants value(-2) instead of maxlen -= size; value ?
>> >
>> > "maxlen -= size" would be completely wrong, because size is the length
>> > of the utf8 input and maxlen is the number of 16-bit slots remaining
>> > in the output buffer.  A surrogate pair uses two 16-bit values,
>> > therefore maxlen has to be decreased by 2.
>> If so, len should also be minus -2 constant value like maxlen ?
>
> You seem to be confused.  "len" refers to the input string and "maxlen"
> refers to the output string.  They have no connection to one another.
> Would it help if "maxlen" were named "maxout" instead?
okay, I knew clearly. If you will, I'm grateful.
I suggest code is a little changed about maxout. how do you think ?
--------------------------------------------------------------------------------------------------------------
+                       s += size;
+                       len -= size;
+                       maxout--

                       if (u >= PLANE_SIZE) {
+                               if (maxlen < 2)
+                                       break;
                               u -= PLANE_SIZE;
-                               *op++ = (wchar_t) (SURROGATE_PAIR |
-                                               ((u >> 10) & SURROGATE_BITS));
-                               *op++ = (wchar_t) (SURROGATE_PAIR |
+                               put_utf16(op++, SURROGATE_PAIR |
+                                               ((u >> 10) & SURROGATE_BITS),
+                                               endian);
+                               put_utf16(op++, SURROGATE_PAIR |
                                               SURROGATE_LOW |
-                                               (u & SURROGATE_BITS));
+                                               (u & SURROGATE_BITS),
+                                               endian);
+                               maxlen--;
                       } else {
-                               *op++ = (wchar_t) u;
+                               put_utf16(op++, u, endian);
                     }

-----------------------------------------------------------------------------------------------------------------------------------------

>
>> and why does this code(if (maxlen < 2)) is needed ? If len is smaller than 2 ?
>
> If maxlen < 2 then there is room in the output buffer for only one more
> data value -- but a surrogate pair occupies two data values.  Hence
> there isn't room to store the pair in the output buffer, so the loop
> must terminate.
>
>> >> >                        } else {
>> >> > -                               *op++ = (wchar_t) u;
>> >> > +                               put_utf16(op++, u, endian);
>> >> > +                               maxlen--;
>> >> >                        }
>> >> > -                       s += size;
>> >> > -                       len -= size;
>> >> >                } else {
>> >> > -                       *op++ = *s++;
>> >> > +                       put_utf16(op++, *s++, endian);
>> >> >                        len--;
>> >> > +                       maxlen--;
>> >> >                }
>> >> >        }
>> >> >        return op - pwcs;
>> >> > Index: usb-3.2/fs/fat/namei_vfat.c
>> >> > ===================================================================
>> >> > --- usb-3.2.orig/fs/fat/namei_vfat.c
>> >> > +++ usb-3.2/fs/fat/namei_vfat.c
>> >> > @@ -512,7 +512,8 @@ xlate_to_uni(const unsigned char *name,
>> >> >        int charlen;
>> >> >
>> >> >        if (utf8) {
>> >> > -               *outlen = utf8s_to_utf16s(name, len, (wchar_t *)outname);
>> >> > +               *outlen = utf8s_to_utf16s(name, len, UTF16_HOST_ENDIAN,
>> >> > +                               (wchar_t *) outname, FAT_LFN_LEN + 2);
>> >> Is there the reason why you plus 2 to FAT_LFN_LEN ?
>> >
>> > So that the "(*outlen > FAT_LFN_LEN)" test below will work correctly.
>> > If the maximum length were set to FAT_LFN_LEN then the test would
>> > always fail.  If the maximum length were set to FAT_LFN_LEN + 1 then
>> > the test would fail when the next character to be stored was a
>> > surrogate pair.
>> Although we are using maxlen, I don't know why do we check case that
>> outlen is bigger than FAT_LFN_LEN.
>
> Probably because the filesystem code requires that the UTF16 string fit
> into a certain amount of space.  If *outlen > FAT_LFN_LEN then the
> string doesn't fit.
>
> Alan Stern
>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
