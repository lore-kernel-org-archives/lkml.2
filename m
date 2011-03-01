Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1CAVrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:47:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756148Ab1CAVrN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:47:13 -0500
MIME-Version: 1.0
In-Reply-To: <20110228151736.GO22310@pengutronix.de>
References: <20101124085645.GW4693@pengutronix.de> <1290589070-854-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110228151736.GO22310@pengutronix.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 Mar 2011 13:46:52 -0800
Message-ID: <AANLkTi=VB5po9Yt2oCcCq01UNQxXNY+_6RBpjWRFkvxN@mail.gmail.com>
Subject: Re: [PATCH 5/6] mm: add some KERN_CONT markers to continuation lines
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kernel@pengutronix.de, Arjan van de Ven <arjan@infradead.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hello,
>
>
> On Wed, Nov 24, 2010 at 09:57:49AM +0100, Uwe Kleine-König wrote:
>> -                             printk("\n");
>> -                             printk("%spcpu-alloc: ", lvl);
>> +                             printk(KERN_CONT "\n");
>> +                             printk("%spcpu-alloc:", lvl);

So I hate this kind of "mindless search-and-replace" patch.

The whole point is that with the modern printk semantics, the above
kind of crazy cdoe shouldn't be needed. You should be able to just
write

     printk("%spcpu-alloc:", lvl);

without that "\n" at all, because printk() will insert the \n if
necessary. So the concept of

    printk(KERN_CONT "\n")

is just crazy: you're saying "I want to continue the line, in order to
print a newline". Whaa?

>> -                     printk("[%0*d] ", group_width, group);
>> +                     printk(KERN_CONT " [%0*d]", group_width, group);
>> -                                     printk("%0*d ", cpu_width,
>> +                                     printk(KERN_CONT " %0*d", cpu_width,
>> -                                     printk("%s ", empty_str);
>> +                                     printk(KERN_CONT " %s", empty_str);

These look ok, but:

>> -     printk("\n");
>> +     printk(KERN_CONT "\n");

Same deal. Why do KERN_CONT + "\n"?

Yes, yes, it does have semantic meaning ("do newline _now_"), and can
matter if you are going to use KERN_CONT exclusively around it. But it
still smells like just being silly to me. The point of the printk
changes was to make things simpler. I really would suggest just
removing those KERN_CONT "\n" lines. Doesn't it end up looking fine
that way too?

                     Linus
