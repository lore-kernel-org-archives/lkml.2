Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2JHISK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 04:18:10 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:23509 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab2JHISI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 04:18:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,551,1344211200"; 
   d="scan'208";a="14993615"
From: Frediano Ziglio <frediano.ziglio@citrix.com>
To: "smfrench@gmail.com" <smfrench@gmail.com>
CC: Frediano Ziglio <frediano.ziglio@citrix.com>,
        "sfrench@samba.org" <sfrench@samba.org>,
        "jlayton@redhat.com" <jlayton@redhat.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 8 Oct 2012 09:18:06 +0100
Subject: Re: [PATCH v2] Convert properly UTF-8 to UTF-16
Thread-Topic: [PATCH v2] Convert properly UTF-8 to UTF-16
Thread-Index: Ac2lLXGqU12b9A0fS1+cMIzT41d3hg==
Message-ID: <7CE799CC0E4DE04B88D5FDF226E18AC2E08D0408E8@LONPMAILBOX01.citrite.net>
References: <7CE799CC0E4DE04B88D5FDF226E18AC2CDFFB08D16@LONPMAILBOX01.citrite.net>
 <20120807064752.22e0da81@corrin.poochiereds.net>
 <7CE799CC0E4DE04B88D5FDF226E18AC2E07634EB82@LONPMAILBOX01.citrite.net>
 <7CE799CC0E4DE04B88D5FDF226E18AC2E08D0408DA@LONPMAILBOX01.citrite.net>
 <CAH2r5msLxJVTwVrD9vs8ZOjQdRpbVyhZus4V6Su-Y8-hT229Ug@mail.gmail.com>
In-Reply-To: <CAH2r5msLxJVTwVrD9vs8ZOjQdRpbVyhZus4V6Su-Y8-hT229Ug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q988IJwB030154

On Wed, 2012-10-03 at 14:49 -0500, Steve French wrote:
> Merged - but doesn't the reverse also have to be added in cifs_from_utf16?  ie
> 
>           utf16s_to_utf8s(uni, ... );
> 

Not strictly necessary, at least to be able to mount shares.

> I am glad that someone added these multiword handling routines into
> the kernel for FAT - this has been something we have wanted for a long
> time in cifs (and smb2/smb3).  Note the comment in
> fs/cifs/cifs_unicode.c
> 
> / * Note that some windows versions actually send multiword UTF-16 characters
>  * instead of straight UTF16-2. The linux nls routines however aren't able to
>  * deal with those characters properly. In the event that we get some of
>  * those characters, they won't be translated properly.
>  */
> int
> cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
>                  const struct nls_table *codepage, bool mapchar)
> 

Should not be UCS-2 instead of UTF16-2 ??

> 
> We could really use some nls test cases for cifs/smb2/smb3/nfs4 which
> basically did various file, directory, symlink create/rename/delete
> operations with various hard to map characters so we can test copying
> to and from the server and ensure that we get the name mappings right
> for these (and don't ever regress).   Fortunately smb2/smb3 is only
> unicode so we don't have to deal with mappings to other codepages from
> utf8
> 

Do you have some framework/hook to put these tests ?

Where did you merge ? I cannot find nothing at
http://gitweb.samba.org/?p=sfrench/cifs-2.6.git;a=summary

Regards
  Frediano


> On Wed, Oct 3, 2012 at 9:34 AM, Frediano Ziglio
> <frediano.ziglio@citrix.com> wrote:
> > On Tue, 2012-08-07 at 06:47 -0400, Jeff Layton wrote:
> >> On Tue, 7 Aug 2012 10:33:03 +0100
> >> Frediano Ziglio <frediano.ziglio@citrix.com> wrote:
> >>
> >> >
> >> > wchar_t is currently 16bit so converting a utf8 encoded characters
> > not
> >> > in plane 0 (>= 0x10000) to wchar_t (that is calling char2uni) lead
> > to a
> >> > -EINVAL return. This patch detect utf8 in cifs_strtoUTF16 and add
> > special
> >> > code calling utf8s_to_utf16s.
> >> >
> >> > Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
> >> > ---
> >> >  fs/cifs/cifs_unicode.c |   22 ++++++++++++++++++++++
> >> >  1 files changed, 22 insertions(+), 0 deletions(-)
> >> >
> >> > diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> >> > index 7dab9c0..1166b95 100644
> >> > --- a/fs/cifs/cifs_unicode.c
> >> > +++ b/fs/cifs/cifs_unicode.c
> >> > @@ -203,6 +203,27 @@ cifs_strtoUTF16(__le16 *to, const char *from,
> > int len,
> >> >     int i;
> >> >     wchar_t wchar_to; /* needed to quiet sparse */
> >> >
> >> > +   /* special case for utf8 to handle no plane0 chars */
> >> > +   if (!strcmp(codepage->charset, "utf8")) {
> >> > +           /*
> >> > +            * convert utf8 -> utf16, we assume we have enough space
> >> > +            * as caller should have assumed conversion does not
> > overflow
> >> > +            * in destination len is length in wchar_t units
> > (16bits)
> >> > +            */
> >> > +           i  = utf8s_to_utf16s(from, len, UTF16_LITTLE_ENDIAN,
> >> > +                                  (wchar_t *) to, len);
> >> > +
> >> > +           /* if success terminate and exit */
> >> > +           if (i >= 0)
> >> > +                   goto success;
> >> > +           /*
> >> > +            * if fails fall back to UCS encoding as this
> >> > +            * function should not return negative values
> >> > +            * currently can fail only if source contains
> >> > +            * invalid encoded characters
> >> > +            */
> >> > +   }
> >> > +
> >> >     for (i = 0; len && *from; i++, from += charlen, len -= charlen)
> > {
> >> >             charlen = codepage->char2uni(from, len, &wchar_to);
> >> >             if (charlen < 1) {
> >> > @@ -215,6 +236,7 @@ cifs_strtoUTF16(__le16 *to, const char *from,
> > int len,
> >> >             put_unaligned_le16(wchar_to, &to[i]);
> >> >     }
> >> >
> >> > +success:
> >> >     put_unaligned_le16(0, &to[i]);
> >> >     return i;
> >> >  }
> >>
> >> Looks reasonable...
> >>
> >> Acked-by: Jeff Layton <jlayton@redhat.com>
> >
> > Steve, could you consider my patch for inclusion into Linux?
> >
> > Thanks,
> >   Frediano
> >
> 
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
