Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0KWWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:16:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576Ab0KWWQ6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:16:58 -0500
MIME-Version: 1.0
In-Reply-To: <20101123105830.GO4693@pengutronix.de>
References: <20101011152516.GF27153@n2100.arm.linux.org.uk>
 <1290505382-16110-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20101123101210.GA18170@n2100.arm.linux.org.uk> <20101123103940.GN4693@pengutronix.de>
 <20101123105830.GO4693@pengutronix.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Nov 2010 07:16:06 +0900
Message-ID: <AANLkTinmky17XZZPh7QvcY_r=66f_PwzRYFPUSvhiJGK@mail.gmail.com>
Subject: Re: About multi-line printk and the need (not) to repeat loglevel
 markers [Was: Re: [PATCH] ARM: mx3/pcm037: properly allocate memory for mx3-camera]
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

10/11/23 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>
> BTW, I just noticed that Linus wrote:
>
>        Additionally, if no newline existed, one is added (unless the
>        log-level is the explicit KERN_CONT marker, to explicitly show
>        that it's a continuation of a previous line).
>
> This seems to be unimplemented, otherwise the output of
>
>        printk(KERN_ERR "foo bar baz ");
>        printk("buz\n" KERN_WARNING "fiz\n");
>
> should be
>
>        "foo bar baz \n" at error level
>        "buz\n<4>fiz\n" at default level

No. The KERN_WARNING in the middle of a string is always totally
bogus. There is no "should be". It's just wrong.

The "\n" is added automatically iff there is a log-level marker at the
beginning of the string (with LOG_CONT being the exception). So

   printk("foo bar baz ");
   printk(KERN_WARNING "fiz\n");

should output two lines ("foo bar baz" with the default loglevel, and
"fiz" with KERN_WARNING). Even though there is no explicit "\n" there
for the first one.

But KERN_XYZ anywhere but in the beginning of the string do not
matter. Adding newlines changes none of that. It doesn't make the
marker beginning of the string, it just makes it beginning of the
line.

   Linus
