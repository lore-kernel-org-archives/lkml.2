Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab0KXJJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 04:09:38 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33274 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab0KXJJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 04:09:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Ph8JhzRFoGnMRDUmPEPTigBh8jxvgIucqaPKdtI6fSKzcCW6Y20sxyqqu96W9AyVjx
         ZWrJMf72bu1dbUTqciE2zGdTJh3wd03WvvjZm2CEefXSdmVVso4dr4geiQb7uiXf6dWt
         K9ZKH6l/tEayRivBzb1WrvwNmXbqVoDVj+pd0=
MIME-Version: 1.0
In-Reply-To: <20101124081748.GV4693@pengutronix.de>
References: <20101011152516.GF27153@n2100.arm.linux.org.uk>
	<1290505382-16110-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20101123101210.GA18170@n2100.arm.linux.org.uk>
	<20101123103940.GN4693@pengutronix.de>
	<20101123105830.GO4693@pengutronix.de>
	<AANLkTinmky17XZZPh7QvcY_r=66f_PwzRYFPUSvhiJGK@mail.gmail.com>
	<20101124081748.GV4693@pengutronix.de>
Date: Wed, 24 Nov 2010 10:09:35 +0100
Message-ID: <AANLkTikLT0vuLLxb6pDLCcVP=ncwKfhkMcCxTqVTukkQ@mail.gmail.com>
Subject: Re: About multi-line printk and the need (not) to repeat loglevel
 markers [Was: Re: [PATCH] ARM: mx3/pcm037: properly allocate memory for mx3-camera]
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hello Linus,
>
> On Wed, Nov 24, 2010 at 07:16:06AM +0900, Linus Torvalds wrote:
>> 10/11/23 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>> >
>> > BTW, I just noticed that Linus wrote:
>> >
>> >        Additionally, if no newline existed, one is added (unless the
>> >        log-level is the explicit KERN_CONT marker, to explicitly show
>> >        that it's a continuation of a previous line).
>> >
>> > This seems to be unimplemented, otherwise the output of
>> >
>> >        printk(KERN_ERR "foo bar baz ");
>> >        printk("buz\n" KERN_WARNING "fiz\n");
>> >
>> > should be
>> >
>> >        "foo bar baz \n" at error level
>> >        "buz\n<4>fiz\n" at default level
>>
>> No. The KERN_WARNING in the middle of a string is always totally
>> bogus. There is no "should be". It's just wrong.
>>
>> The "\n" is added automatically iff there is a log-level marker at the
>> beginning of the string (with LOG_CONT being the exception).
> So
>
>        printk("anything that doesn't look like a loglevel marker");
>
> always behaves like
>
>        printk(KERN_CONT "anything that doesn't look like a loglevel marker");
>
> so unless someone wants to print a literal kernel marker we can just do
>
> -#define        KERN_CONT       "<c>"
> +#define        KERN_CONT       ""
>
> without any harm.
>
> I wonder why you implemented "iff there is a log-level marker at the
> beginning ot the string (with KERN_CONT being the exception)." and not
> "unless there is a KERN_CONT marker".
>
>>                                                              So
>>
>>    printk("foo bar baz ");
>>    printk(KERN_WARNING "fiz\n");
>>
>> should output two lines ("foo bar baz" with the default loglevel, and
>> "fiz" with KERN_WARNING). Even though there is no explicit "\n" there
>> for the first one.
>>
>> But KERN_XYZ anywhere but in the beginning of the string do not
>> matter. Adding newlines changes none of that. It doesn't make the
>> marker beginning of the string, it just makes it beginning of the
>> line.
> I see one reason to interpret markers after a newline.  In case
> recursion_bug is true, printk_buf is initialized with recursion_bug_msg
> and my message gets appended.  So currently the marker I pass with my
> message is ignored.
> Maybe wanting to fix that is just my addiction to overengineering :-)

Hello, Kernel Hackers!

I think that KERN_CONT and any other form of continuation printks() is
just source of trouble.

This is usually used in code like this:

int init_dev(...)
{
    ...
    printk("Initializing dev %s ... ", dev->name);
    /* do initialize, sleeping/scheduling is allowed */
    printk("%s.\n", ok ? "done" : "error");
    ...
}

When parallel initialization is done you might expect output like this:

Initializing dev A ...
Initializing dev B ... error.
done.

And now guess which one failed.

Second case against printk() continuations is netconsole. Every
printk() output is sent as separate packet with no ordering or
delivery guarantees, and usually logged as separate lines by remote
logging daemon. From the example code above, you might get this in
remote log:

Initializing dev A ...
done.
Initializing dev B ...
error.

When in reality A failed and B initialized properly. (Yes, I know this
is highly unlikely, but still - possible.)

Best Regards,
Micha³ Miros³aw
