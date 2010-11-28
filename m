Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0K1GvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 01:51:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35492 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab0K1GvK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 01:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=YZb6WnfMwO1bxuOFw7K43rM+9znY4zXl4DxwMdr6/oi7Etd/qyJrPwj9xE+FBEY13s
         Km37nyMbDBrNgfuuZ9oY5LHvKp8u0dtzfC40DZ3UmDe6b/EvRQJVapQhgrCGUtAbNjV0
         b9e6o9vBE0WoykN1QqJfiifQeWBUCWU20ObmE=
MIME-Version: 1.0
In-Reply-To: <20101127125742.GD4865@const.famille.thibault.fr>
References: <1290750825.2372.59.camel@cai.gentoo> <20101127125742.GD4865@const.famille.thibault.fr>
From: microcai <microcai@fedoraproject.org>
Date: Sun, 28 Nov 2010 14:50:49 +0800
X-Google-Sender-Auth: CfIioQQY7JWZlVvYChhI8vzbZak
Message-ID: <AANLkTikfS+c93skkUFNLVJNah0DsjAUPE2jFNAQCAnCg@mail.gmail.com>
Subject: Re: [PATCH] Kernel fbcon UNICODE font support
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        microcai <microcai@fedoraproject.org>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linuxconsole-dev@lists.sourceforge.net
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

I did more work,and found that , VGA console (non framebuffer) realy
need 8bit/8bit attrib/char , because that's how text mode VGA cards
interpreter them. changing to full type will break VGA drivers.
So, I add an u32 * unichars to con_putcs() parameter list, VGA drivers
just ignore that parameter , but fbcon can use it instead of unsigned
short *s as real char value. And allocate an backing store buffer to
store full UNICODE characters.
Also , I delete vc_hi_font_mask, VGA hardware that support 512 font
chars turn to use u32*unichars passed to con_putcs()

Will that acceptable ?
