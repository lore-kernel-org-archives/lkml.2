Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab2DESge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 14:36:34 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50369 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2DESgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 14:36:33 -0400
Message-ID: <4F7DE60B.5000904@windriver.com>
Date: Thu, 5 Apr 2012 14:35:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Fabio Estevam <festevam@gmail.com>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <linux@arm.linux.org.uk>,
        <sam@ravnborg.org>, Fabio Estevam <fabio.estevam@freescale.com>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH v2] compiler.h: Include <linux/bug.h> to avoid build breakage
 with ARRAY_SIZE()
References: <1330436499-17190-1-git-send-email-fabio.estevam@freescale.com> <1330650922-24143-1-git-send-email-festevam@gmail.com> <CAP=VYLpd5EFmD+8Yo_jm-9N7O5zkLTsTwGjgmxG4u_G6t=4fag@mail.gmail.com> <4F50D78A.1020209@windriver.com> <20120404142924.GA15647@pengutronix.de>
In-Reply-To: <20120404142924.GA15647@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-04 10:29 AM, Uwe Kleine-König wrote:
> Hello,
> 
> On Fri, Mar 02, 2012 at 09:22:02AM -0500, Paul Gortmaker wrote:
>> On 12-03-01 10:13 PM, Fabio Estevam wrote:
>>> On Thu, Mar 1, 2012 at 11:49 PM, Paul Gortmaker
>>> <paul.gortmaker@windriver.com> wrote:
>>>
>>>> Thanks, but no.
>>>>
>>>> You missed the whole point of my previous comments -- that being
>>>> that we don't want to just jam headers into always-used headers.
>>>
>>> Yes, it is not clear for me how to fix this build error. I got
>>> different feedbacks from you, Russell and Sam.
>>
>> Understood, there was some discussion there.  Anyways it is already
>> dealt with in yesterday's linux-next tree, so you won't have the
>> build failure anymore.
> I hit that same problem in an not yet mainlined source file. A simple
> file containing only:

A quick check shows about 15000 instances in mainline.  Even if 1% of
those were blowing up, I'd expect a full mailbox.

> 
> 	#include <linux/kernel.h>
> 
> 	int array[3];
> 
> 	int func(void)
> 	{
> 		return ARRAY_SIZE(array);

Well, ARRAY_SIZE is just a convenient macro that uses BUG content.
Hiding it behind a name doesn't change the fact that you've
implicitly decided to use bug.h content.  Maybe you really don't
want to be using it.  Maybe we should have:

--------------------------------------
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -43,6 +43,7 @@
 #define PTR_ALIGN(p, a)                ((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)               (((x) & ((typeof(x))(a) - 1)) == 0)
 
+#define __ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
 /*
------------------------------------

and give people a choice?

Don't get me wrong.  I'm not all extremist about this.  If it turns
out that it seems to cause way too much grief, and someone like Andrew
says "Yeah, lets put #include <linux/bug.h> back in kernel.h" then I
won't hesitate to do that.  But given that code currently in mainline
isn't blowing up all over, I wasn't yet convinced we needed to do that.

Paul.

> 	}
> 
> fails to build on top of v3.4-rc1. Am I right that you saying "you won't
> have the build failure anymore" means that each of these is now needed
> to be fixed individually by adding
> 
> 	#include <linux/bug.h>
> 
> ? Otherwise it's not fixed for me.
> 
> Thanks
> Uwe
> 
