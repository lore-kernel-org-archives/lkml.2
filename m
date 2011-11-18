Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab1KRPIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:08:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35552 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756415Ab1KRPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:08:08 -0500
Date: Fri, 18 Nov 2011 10:08:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: NamJae Jeon <linkinjeon@gmail.com>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Greg KH <greg@kroah.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NLS: improve UTF8 -> UTF16 string conversion routine
In-Reply-To: <CAKYAXd9fEJP7XsZtCMdCPszhhdgUrVhN=8RARrWs=Pq9uTw2aA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1111180956200.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011, NamJae Jeon wrote:

> 2011/11/18 Alan Stern <stern@rowland.harvard.edu>:
> > The utf8s_to_utf16s conversion routine needs to be improved.  Unlike
> > its utf16s_to_utf8s sibling, it doesn't accept arguments specifying
> > the maximum length of the output buffer or the endianness of its
> > 16-bit output.
> >
> > This patch (as1501) adds the two missing arguments, and adjusts the
> > only two places in the kernel where the function is called.  A
> > follow-on patch will add a third caller that does utilize the new
> > capabilities.
> >
> > The two conversion routines are still annoyingly inconsistent in the
> > way they handle invalid byte combinations.  But that's a subject for a
> > different patch.

> > Index: usb-3.2/fs/nls/nls_base.c
> > ===================================================================
> > --- usb-3.2.orig/fs/nls/nls_base.c
> > +++ usb-3.2/fs/nls/nls_base.c
> > @@ -114,34 +114,57 @@ int utf32_to_utf8(unicode_t u, u8 *s, in
> >  }
> >  EXPORT_SYMBOL(utf32_to_utf8);
> >
> > -int utf8s_to_utf16s(const u8 *s, int len, wchar_t *pwcs)
> > +static inline void put_utf16(wchar_t *s, unsigned c, enum utf16_endian endian)
> > +{
> > +       switch (endian) {
> > +       default:
> > +               *s = (wchar_t) c;
> > +               break;
> > +       case UTF16_LITTLE_ENDIAN:
> > +               *s = __cpu_to_le16(c);
> > +               break;
> > +       case UTF16_BIG_ENDIAN:
> > +               *s = __cpu_to_be16(c);
> > +               break;
> > +       }
> > +}
> > +
> > +int utf8s_to_utf16s(const u8 *s, int len, enum utf16_endian endian,
> > +               wchar_t *pwcs, int maxlen)
> >  {
> >        u16 *op;
> >        int size;
> >        unicode_t u;
> >
> >        op = pwcs;
> > -       while (*s && len > 0) {
> > +       while (len > 0 && maxlen > 0 && *s) {
> >                if (*s & 0x80) {
> >                        size = utf8_to_utf32(s, len, &u);
> >                        if (size < 0)
> >                                return -EINVAL;
> > +                       s += size;
> > +                       len -= size;
> Why did you move this code to here ?

Mainly in order to keep the counter updates near the place where the
character is read.  Also, in an earlier version of the patch, I used a
"continue" instead of the "break" statement three lines below.  For
that to work, the updates to s and len had to be moved up here.

> >                        if (u >= PLANE_SIZE) {
> > +                               if (maxlen < 2)
> > +                                       break;
> >                                u -= PLANE_SIZE;
> > -                               *op++ = (wchar_t) (SURROGATE_PAIR |
> > -                                               ((u >> 10) & SURROGATE_BITS));
> > -                               *op++ = (wchar_t) (SURROGATE_PAIR |
> > +                               put_utf16(op++, SURROGATE_PAIR |
> > +                                               ((u >> 10) & SURROGATE_BITS),
> > +                                               endian);
> > +                               put_utf16(op++, SURROGATE_PAIR |
> >                                                SURROGATE_LOW |
> > -                                               (u & SURROGATE_BITS));
> > +                                               (u & SURROGATE_BITS),
> > +                                               endian);
> > +                               maxlen -= 2;
> 
> Why did you use contants value(-2) instead of maxlen -= size; value ?

"maxlen -= size" would be completely wrong, because size is the length
of the utf8 input and maxlen is the number of 16-bit slots remaining
in the output buffer.  A surrogate pair uses two 16-bit values,
therefore maxlen has to be decreased by 2.

> >                        } else {
> > -                               *op++ = (wchar_t) u;
> > +                               put_utf16(op++, u, endian);
> > +                               maxlen--;
> >                        }
> > -                       s += size;
> > -                       len -= size;
> >                } else {
> > -                       *op++ = *s++;
> > +                       put_utf16(op++, *s++, endian);
> >                        len--;
> > +                       maxlen--;
> >                }
> >        }
> >        return op - pwcs;
> > Index: usb-3.2/fs/fat/namei_vfat.c
> > ===================================================================
> > --- usb-3.2.orig/fs/fat/namei_vfat.c
> > +++ usb-3.2/fs/fat/namei_vfat.c
> > @@ -512,7 +512,8 @@ xlate_to_uni(const unsigned char *name,
> >        int charlen;
> >
> >        if (utf8) {
> > -               *outlen = utf8s_to_utf16s(name, len, (wchar_t *)outname);
> > +               *outlen = utf8s_to_utf16s(name, len, UTF16_HOST_ENDIAN,
> > +                               (wchar_t *) outname, FAT_LFN_LEN + 2);
> Is there the reason why you plus 2 to FAT_LFN_LEN ?

So that the "(*outlen > FAT_LFN_LEN)" test below will work correctly.
If the maximum length were set to FAT_LFN_LEN then the test would
always fail.  If the maximum length were set to FAT_LFN_LEN + 1 then
the test would fail when the next character to be stored was a
surrogate pair.

> >                if (*outlen < 0)
> >                        return *outlen;
> >                else if (*outlen > FAT_LFN_LEN)
>                           return -ENAMETOOLONG;
> "else if (*outlen > FAT_LFN_LEN)" code  is needed ? Is there the case
> that *outlen is over FAT_LFN_LEN in your patch ?

I have no idea.  That test was already there, I didn't add or change it.

> Thanks.

Alan Stern

