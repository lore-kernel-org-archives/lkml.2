Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0KOG4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:56:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62001 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab0KOG4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:56:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DXq0+Qha5BNmmLwQxtupFVItsjyfx/3Ywi7ZvemxI63ZXYmqADTdQYoY4ReFRjGiaA
         xrksioArWg3DIgw3Ez8CyIAUY7+0W21QuLW7rJcZ635v/UkfdbIEiIKJG0taU+MTRDBG
         uqssUWWDun2Ir3yNvD5KuvGCikFQz4R9b0lAE=
MIME-Version: 1.0
In-Reply-To: <20101115044820.GA8489@linux-sh.org>
References: <20101027093716.GD6062@bicker>
	<20101105134018.2c11f283.akpm@linux-foundation.org>
	<20101113100718.GB1795@bicker>
	<20101115044820.GA8489@linux-sh.org>
Date: Mon, 15 Nov 2010 07:56:05 +0100
X-Google-Sender-Auth: 8-KJXyjmnU10ydVLEKyWHkg8uCQ
Message-ID: <AANLkTin0T5FN6WhUj0csypR=j0UPRbeHN+HC3N9xnk7E@mail.gmail.com>
Subject: Re: [patch 2/2] fbcmap: integer overflow bug
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Dan Carpenter <error27@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 05:48, Paul Mundt <lethal@linux-sh.org> wrote:
> On Sat, Nov 13, 2010 at 01:07:18PM +0300, Dan Carpenter wrote:
>> @@ -256,8 +264,12 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>>       int rc, size = cmap->len * sizeof(u16);
>>       struct fb_cmap umap;
>>
>> +     if (cmap->len * 2 > INT_MAX)

Isn't that another integer overflow? I.e. should be "if (cmap->len >
INT_MAX / sizeof(u16))" instead?

>> +             return -EINVAL;
>> +
>>       memset(&umap, 0, sizeof(struct fb_cmap));
>> -     rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
>> +     rc = fb_alloc_cmap_gfp(&umap, cmap->len, cmap->transp != NULL,
>> +                             GFP_KERNEL);
>>       if (rc)
>>               return rc;
>>       if (copy_from_user(umap.red, cmap->red, size) ||
>
> This looks reasonable, but it probably makes more sense to use -E2BIG
> for the overflow case (as other cases are doing already), and also just
> to check size directly rather than open-coding the * 2.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
