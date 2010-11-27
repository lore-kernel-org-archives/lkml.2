Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0K0QSu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 11:18:50 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36470 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0K0QSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 11:18:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=mfdLe+mRVyI/fwTXy/5Q+A+Js2NfGwbfebzxsErijFU59R/X9PSQxFVWua0XU4E8dE
         IixHzphDeLmbOGkZpOcKWLkcCLJodHQyU45INS6m7y3BYa+khjPQm/hvqSeN5WPvVwKy
         2DmWfO6H2D3RrG4XfOtgGnqOouGBDIWksqWTQ=
MIME-Version: 1.0
In-Reply-To: <20101127125742.GD4865@const.famille.thibault.fr>
References: <1290750825.2372.59.camel@cai.gentoo> <20101127125742.GD4865@const.famille.thibault.fr>
From: microcai <microcai@fedoraproject.org>
Date: Sun, 28 Nov 2010 00:18:13 +0800
X-Google-Sender-Auth: meOHtl-fEW8ZTEf4bmt6BruXc6Y
Message-ID: <AANLkTi=bo4TjPFkiR8SMu3Rf06bnxXoKHCH6Ksvd7T_e@mail.gmail.com>
Subject: Re: [PATCH] Kernel fbcon UNICODE font support
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/27 Samuel Thibault <samuel.thibault@ens-lyon.org>:
> Hello,
>
> Microcai, le Fri 26 Nov 2010 13:53:45 +0800, a écrit :
>>  I know there are most people speaking only English, and never meet
>> non-ASCII characters on console. But, hey , what about others ?
>
> Well, you can't deny that there _is_ some support for non-ASCII. But
> just at most 512 glyphs and single width, indeed.
>
>>  The first thing I need to handle is that, currently there is no room
>> for adding UNICODE font, only 8bit for characters, how can you do?
>
> (or 9bit, but no more indeed)
Then 15bit for attribute, so few.

I'm working on it now. making it 64bit width, 32bit for char and 32bit
for attributes. Indeed, 31bit for char, 1 bit for double/single width
select.

>
>>  Also , some characters are double-width. So the solution is  make an
>> backing store. 0xFE and 0xFF stands for character value store else
>> where, and 0xFF means , left-half of the else where character, and 0xFE
>> means right-half of the else where character.
>>
>>  This is a basic solution, the best is that making vc->vc_screenbuf
>> store full UNICODE/attribute value, But changing it may break some
>> drivers, so , currently I won't try that way.
>
> I'd much prefer the full unicode way, however.  Trying to hack around
> with 0xFE/0xFF will just bring hard-to-fix bugs, while it's quite easy
> to make sure we capture not-up-to-date drivers by changing field names
> for instance.  I'd say we should first do that, and then it'll be
> easy to move the old vgaposition/glyph translation cruft into the few
> drivers that need it.  Yes, this seems to be the hard way.  But that's
> the short-term hard then mid-term easy way, which is way easier to
> accept than the short-term easy then mid/long-term tedious way that you
> propose.
>
>> The UNICODE font just too large to be included in e-mail, please follow
>
> There is no way we want to include a big unicode font in the kernel :)
>
>> In future, we don't have to compile  that big font into kernel, we
>> should use setfont to load UNICODE font.
>
> Yes.
>
>> But, .psf does not support that much charcount (or maybe yes, and  I
>> need some search? )
>
> That's just a matter of fixing tools: the newer version of the psf
> format already supports 2^16 glyphs.

So, new psf file format is just fine. I'll search(wirte if not exist)
some tools to generate PSF unicode font file. ^_^

>
>> So, here is the patch that add UNICODE font handling functionary.
>
> I've just had a quick glance over it, and there are quite a few things
> that bother me, including:
>
>> @@ -296,6 +295,8 @@ int set_selection(const struct tiocl_selection
>> __user *sel, struct tty_struct *t
>>                       }
>>                       obp = bp;
>>               }
>> +             if (c > 0x80)
>> +                     i += 2;
>>       }
>>       sel_buffer_lth = bp - sel_buffer;
>>       return 0;
>
> That is the kind of hack that really shows your current approach will
> most probably just bring us bugs.
>
>> @@ -2171,6 +2205,8 @@ static int do_con_write(struct tty_struct *tty,
>> const unsigned char *buf, int co
>>               rescan = 0;
>>               inverse = 0;
>>               width = 1;
>> +             vc->vc_utf = 1;
>
> ?!
> There is now way we can accept to systematically switch to utf-8.
>
>> -             vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
>> +             vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size * 2, GFP_NOWAIT);
>

Yeah, First I just want it works .. ASAP. Then , adjust it, use the painful way.
I must sure that kernel guys like the idea , or , I don't want to wast my time.
(Think about TuxOnIce ? another topic ;) )

> With a proper switch to a "unicode character" type, this would rather be
> "* sizeof(something)", so that choosing between 16bit unicode and 32bit
> unicode would even be trivial.
>

So the hard works begins right after ugly hack work.

----

BTW， this patch only works on tty1 , I just happen to forget
font.charcont in the copy_font stuff .  so font_bits() will always
think current font is not UNICODE.
here is the patch.


>From db2e58c1e304d53a8bfc97fdf58e1e14a89c0fcd Mon Sep 17 00:00:00 2001
From: microcai <microcaicai@gmail.com>
Date: Sat, 27 Nov 2010 16:13:19 +0800
Subject: [PATCH] fix "CJK only works on tty1"
Signed-off-by: microcai <microcaicai@gmail.com>
---
 drivers/video/console/fbcon.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 04c60f4..9959a10 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1061,6 +1061,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 						    fvc->vc_font.data);
 			vc->vc_font.width = fvc->vc_font.width;
 			vc->vc_font.height = fvc->vc_font.height;
+			vc->vc_font.charcount = fvc->vc_font.charcount;
 			p->userfont = t->userfont;

 			if (p->userfont)
@@ -1351,6 +1352,7 @@ static void fbcon_set_disp(struct fb_info *info,
struct fb_var_screeninfo *var,
 		vc->vc_font.data = (void *)(p->fontdata = t->fontdata);
 		vc->vc_font.width = (*default_mode)->vc_font.width;
 		vc->vc_font.height = (*default_mode)->vc_font.height;
+		vc->vc_font.charcount = (*default_mode)->vc_font.charcount;
 		p->userfont = t->userfont;
 		if (p->userfont)
 			REFCOUNT(p->fontdata)++;
-- 
1.7.3.1
