Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1K1H4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:56:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33193 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1K1H4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:56:32 -0500
MIME-Version: 1.0
In-Reply-To: <201111240608.31146.linux@kukkukk.com>
References: <CAKYAXd965Md2D4mnDbROoNcKZPQs2dERh8y7aDHtoJ+FJcK1QQ@mail.gmail.com>
	<20111123171245.3e3f18a7@lxorguk.ukuu.org.uk>
	<CADDb1s2OcfjwAJoTTbR6547hDL68PJFg_jD_vAs-nGmgiO6YWQ@mail.gmail.com>
	<201111240608.31146.linux@kukkukk.com>
Date: Mon, 28 Nov 2011 13:26:31 +0530
Message-ID: <CAOiN93nCXB_fi7Oh4X_GGysizRRqT=yMwEYXcAe5chymztXcxQ@mail.gmail.com>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
From: Ashish Sangwan <ashishsangwan2@gmail.com>
To: =?ISO-8859-1?Q?G=FCnter_Kukkukk?= <linux@kukkukk.com>
Cc: samba-technical@lists.samba.org, Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-cifs@vger.kernel.org,
        NamJae Jeon <linkinjeon@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>,
        Steve French <smfrench@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
        Anton Altaparmakov <aia21@cam.ac.uk>,
        Unix Support <unix-support@ucs.cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/24 Günter Kukkukk <linux@kukkukk.com>:
> On Wednesday 23 November 2011 19:00:16 Amit Sahrawat wrote:
>> Hi Alan,
>> Ok, translations cannot be added easily. But any idea why surrogate
>> pairs are not handled? I think handling for surrogate pairs can be
>> added by identifying proper points(there are not many I guess). Please
>> share your views.
>>
>> Regards,
>> Amit Sahrawat
>>
>> On Wed, Nov 23, 2011 at 10:42 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > On Wed, 23 Nov 2011 11:31:47 -0500 (EST)
>> >
>> > Alan Stern <stern@rowland.harvard.edu> wrote:
>> >> On Wed, 23 Nov 2011, NamJae Jeon wrote:
>> >> > Hi. Alan.
>> >> > Would you know why there is no upper/lower case table in nls utf8 ?
>> >> > And Currently Surrogate pair is not supported also in nls utf8. Is
>> >> > there the reason ?
>> >>
>> >> I don't know.
>> >
>> > For one case translations are locale specific and very very complicated.
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> > in the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>
> "Surrogate pairs" had to been implemented to extend the former
> 16 bit limit of UCS-2/UTF-16.
>
> Unicode has been limited to max 0x0010FFFF glyphs - which
> would not fit in UCS-2/UTF-16.
>
> To extend UTF-16, the "surrogate range" between D800 and DFFF was "stolen"
> from the one of the previously named "Private Use Areas" of UCS-2.
> -----
>
> Have those "surrogate pairs" any impact on _todays_ linux file name conventions?
>
> I think the easy answer is NO !
>
> AFAIK - _no_ current operating system is supporting this!
>
> We are talking here about "allowed dir/file name characters"!

How about Chinese/Japanese/Korean characters?
User won't be able to create new file with CJK/HAN chars if there is
no surrogate pair support.
>
> The main reason behind "Surrogate pairs" was to allow "userland" (!)
> applications to use worldwide special character glyphs!
> ---------
>
> Anyway - in nls_base.c
> .....
> static const struct utf8_table utf8_table[] =
> {
>    {0x80,  0x00,   0*6,    0x7F,           0,         /* 1 byte sequence */},
>    {0xE0,  0xC0,   1*6,    0x7FF,          0x80,      /* 2 byte sequence */},
>    {0xF0,  0xE0,   2*6,    0xFFFF,         0x800,     /* 3 byte sequence */},
>    {0xF8,  0xF0,   3*6,    0x1FFFFF,       0x10000,   /* 4 byte sequence */},
>    {0xFC,  0xF8,   4*6,    0x3FFFFFF,      0x200000,  /* 5 byte sequence */},
>    {0xFE,  0xFC,   5*6,    0x7FFFFFFF,     0x4000000, /* 6 byte sequence */},
>    {0,                                                /* end of table    */}
> };
> ........
> that configured range exceeds the max. allowed unicode range 0x0010FFFF
> and _must_ be changed to:
>
> static const struct utf8_table utf8_table[] =
> {
>    {0x80,  0x00,   0*6,    0x7F,           0,         /* 1 byte sequence */},
>    {0xE0,  0xC0,   1*6,    0x7FF,          0x80,      /* 2 byte sequence */},
>    {0xF0,  0xE0,   2*6,    0xFFFF,         0x800,     /* 3 byte sequence */},
>    {0xF8,  0xF0,   3*6,    0x1FFFFF,       0x10000,   /* 4 byte sequence */},
>    {0,                                                /* end of table    */}
> };
>
> Cheers, Günter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
