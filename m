Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab0KXISE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:18:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36527 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab0KXISB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:18:01 -0500
Date: Wed, 24 Nov 2010 09:17:48 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: About multi-line printk and the need (not) to repeat loglevel
	markers [Was: Re: [PATCH] ARM: mx3/pcm037: properly allocate memory
	for mx3-camera]
Message-ID: <20101124081748.GV4693@pengutronix.de>
References: <20101011152516.GF27153@n2100.arm.linux.org.uk> <1290505382-16110-1-git-send-email-u.kleine-koenig@pengutronix.de> <20101123101210.GA18170@n2100.arm.linux.org.uk> <20101123103940.GN4693@pengutronix.de> <20101123105830.GO4693@pengutronix.de> <AANLkTinmky17XZZPh7QvcY_r=66f_PwzRYFPUSvhiJGK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinmky17XZZPh7QvcY_r=66f_PwzRYFPUSvhiJGK@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Wed, Nov 24, 2010 at 07:16:06AM +0900, Linus Torvalds wrote:
> 10/11/23 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> >
> > BTW, I just noticed that Linus wrote:
> >
> >        Additionally, if no newline existed, one is added (unless the
> >        log-level is the explicit KERN_CONT marker, to explicitly show
> >        that it's a continuation of a previous line).
> >
> > This seems to be unimplemented, otherwise the output of
> >
> >        printk(KERN_ERR "foo bar baz ");
> >        printk("buz\n" KERN_WARNING "fiz\n");
> >
> > should be
> >
> >        "foo bar baz \n" at error level
> >        "buz\n<4>fiz\n" at default level
> 
> No. The KERN_WARNING in the middle of a string is always totally
> bogus. There is no "should be". It's just wrong.
> 
> The "\n" is added automatically iff there is a log-level marker at the
> beginning of the string (with LOG_CONT being the exception).
So

	printk("anything that doesn't look like a loglevel marker"); 

always behaves like

	printk(KERN_CONT "anything that doesn't look like a loglevel marker");

so unless someone wants to print a literal kernel marker we can just do

-#define        KERN_CONT       "<c>"
+#define        KERN_CONT       ""

without any harm.

I wonder why you implemented "iff there is a log-level marker at the
beginning ot the string (with KERN_CONT being the exception)." and not
"unless there is a KERN_CONT marker".

>                                                              So
> 
>    printk("foo bar baz ");
>    printk(KERN_WARNING "fiz\n");
> 
> should output two lines ("foo bar baz" with the default loglevel, and
> "fiz" with KERN_WARNING). Even though there is no explicit "\n" there
> for the first one.
> 
> But KERN_XYZ anywhere but in the beginning of the string do not
> matter. Adding newlines changes none of that. It doesn't make the
> marker beginning of the string, it just makes it beginning of the
> line.
I see one reason to interpret markers after a newline.  In case
recursion_bug is true, printk_buf is initialized with recursion_bug_msg
and my message gets appended.  So currently the marker I pass with my
message is ignored.
Maybe wanting to fix that is just my addiction to overengineering :-)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
