Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab0DZOfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:35:21 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:42773 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0DZOfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=g4nYo7ijCG7y2keMYHks0gFCgyzdgwlEsfFe9U5AAo2rzsCxxCv2YeqLgk20INlyGh
         R9gavCDc0gm04OUN5wPagwaN6Tq4QroUmDecxbaxKwNfY4j/t7EjnrFhAh+Jlhn7pKms
         wwEC9CNZlhnaikX/24iThLYJ1Jr30cx1cPRVs=
MIME-Version: 1.0
In-Reply-To: <20100426140535.GA17135@ericsson.com>
References: <1271780217-27472-1-git-send-email-guenter.roeck@ericsson.com>
	 <4BD55E85.4020709@cs.helsinki.fi>
	 <20100426140535.GA17135@ericsson.com>
Date: Mon, 26 Apr 2010 17:35:16 +0300
X-Google-Sender-Auth: da64cf50bdb7cce0
Message-ID: <j2l84144f021004260735ib574b5f1t6c00a3a8a8f886ee@mail.gmail.com>
Subject: Re: [PATCH v3] x86: Do not write into VGA memory space if there is no 
	VGA device in the system
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 5:05 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> On Mon, Apr 26, 2010 at 05:36:05AM -0400, Pekka Enberg wrote:
>> Guenter Roeck kirjoitti:
>> > Ensure that early_printk() does not write into VGA memory space
>> > if there is not VGA device in the system.
>> >
>> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
>> > ---
>> > v3:
>> > Changes are now limited to early_printk.c. Functionality is retained, meaning
>> > there will still be output on the VGA console before setup_early_printk()
>> > is called, but only if a VGA device is known to exist in the system.
>> >
>> >  arch/x86/kernel/early_printk.c |   17 +++++++++++++----
>> >  1 files changed, 13 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
>> > index b9c830c..783cb25 100644
>> > --- a/arch/x86/kernel/early_printk.c
>> > +++ b/arch/x86/kernel/early_printk.c
>> > @@ -170,10 +170,13 @@ asmlinkage void early_printk(const char *fmt, ...)
>> >     int n;
>> >     va_list ap;
>> >
>> > -   va_start(ap, fmt);
>> > -   n = vscnprintf(buf, sizeof(buf), fmt, ap);
>> > -   early_console->write(early_console, buf, n);
>> > -   va_end(ap);
>> > +   if (early_console && (early_console_initialized ||
>> > +                         boot_params.screen_info.orig_video_isVGA == 1)) {
>> > +           va_start(ap, fmt);
>> > +           n = vscnprintf(buf, sizeof(buf), fmt, ap);
>> > +           early_console->write(early_console, buf, n);
>> > +           va_end(ap);
>> > +   }
>> >  }
>> >
>> >  static inline void early_console_register(struct console *con, int keep_early)
>> > @@ -233,6 +236,12 @@ static int __init setup_early_printk(char *buf)
>> >  #endif
>> >             buf++;
>> >     }
>> > +
>> > +   /* If there is no VGA device, don't try to use it as early console. */
>> > +   if (early_console == &early_vga_console &&
>> > +       boot_params.screen_info.orig_video_isVGA != 1)
>> > +           early_console = NULL;
>>
>> Wouldn't it be better to switch to, say, serial console here to avoid
>> the NULL check in early_printk()?
>>
> This would be another possibility.
>
> However, since the serial console was not explicitly selected, it would possibly
> not be initialized. My understanding is that Peter had a problem with that.
>
> One can argue that it would still be better to select the serial console in that case,
> even though it might not be initialized. Actually, most likely it is (if it exists),
> since the system must presumably have some means to communicate with the world.
>
> I am pretty much open to either option, if that results in the patch being accepted.
> Just let me know which way to go.

Peter?
