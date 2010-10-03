Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0JCQcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 12:32:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46965 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0JCQcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 12:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=uIaDPkezUkjjv5UOoJJOB7BNCYZ8PCybWaExaI7+LzalMA/GXMk0Ws3I2qd6Yf+1Bv
         FoZSsP3H2bVEkUDiZmO2oftXbAgg8oRVMDAy+9o6cjXLWXjLLTLpOQmK674nVFThleao
         RF3edbNvveI/thKu6KqWYstiBBuEJIhRAtY2k=
MIME-Version: 1.0
In-Reply-To: <20101003055013.GB25397@liondog.tnic>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
	<20101003055013.GB25397@liondog.tnic>
Date: Sun, 3 Oct 2010 17:32:12 +0100
X-Google-Sender-Auth: U5D00IwhWFdYOaM3T3ek16WidlM
Message-ID: <AANLkTikhJ6sE=CZ9HytG0p9DN9A0D+kqYB-sP8EfBN85@mail.gmail.com>
Subject: Re: Dynamic nop selection breaks boot on Geode LX
From: Daniel Drake <dsd@laptop.org>
To: Borislav Petkov <bp@alien8.de>, Daniel Drake <dsd@laptop.org>,
        jbaron@redhat.com, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2010 06:50, Borislav Petkov <bp@alien8.de> wrote:
> maybe because the Geode doesn't have both the
> P6_NOP5 and the NOP with 4 0x66 prefixes:
> http://kerneltrap.org/mailarchive/linux-kernel/2010/8/27/4612336
>
> and for some reason the trap can't find the fixup address. You say
> "hangs" so you don't even get an "invalid opcode" OOPS?

The XO doesn't have standard VGA, so it is difficult to debug such
early crashes. This is crashing so early that kernel messages don't
even start to get sent over serial.

To debug these things, I checkpoint the code with various calls which
send individual characters over serial:

static void log_serial(char c)
{
   while ((inb(0x3fd) & 0x20) == 0) ;
   outb(c, 0x3f8);
   while ((inb(0x3fd) & 0x40) == 0) ;
}

So, I'm not really sure if/how it crashed or oops'd. However, I can
confirm that panic() does not get reached, since I put a character log
in there and it doesn't get sent. Let me know if you want me to put
character logging in other places.

I applied your two patches by hand and it doesn't solve the issue,
because the init_amd_k6() code is called long after
arch_init_ideal_nop5()

Daniel
