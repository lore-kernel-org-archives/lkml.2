Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965767Ab2B1QoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:44:19 -0500
Received: from mail1.windriver.com ([147.11.146.13]:37187 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951Ab2B1QoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:44:15 -0500
Message-ID: <4F4D0438.9070200@windriver.com>
Date: Tue, 28 Feb 2012 11:43:36 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Fabio Estevam <fabio.estevam@freescale.com>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux@arm.linux.org.uk>
Subject: Re: [PATCH] kernel.h: Include <linux/bug.h> to avoid build	breakage
 with ARRAY_SIZE()
References: <1330436499-17190-1-git-send-email-fabio.estevam@freescale.com> <20120228155124.GA2827@merkur.ravnborg.org>
In-Reply-To: <20120228155124.GA2827@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-02-28 10:51 AM, Sam Ravnborg wrote:
> On Tue, Feb 28, 2012 at 10:41:39AM -0300, Fabio Estevam wrote:
>> Building imx_v6_v7_defconfig generated the following build error:
>>
>> arch/arm/mach-imx/cpu_op-mx51.c: In function 'mx51_get_cpu_op':
>> arch/arm/mach-imx/cpu_op-mx51.c:27: error: implicit declaration of function 'BUILD_BUG_ON_ZERO'
>>
>> commit 6f863554 (kernel.h: doesn't explicitly use bug.h, so don't include it.)
>> has removed asm/debug.h from linux/kernel.h.
>>
>> Quoting Russell King (http://www.spinics.net/lists/arm-kernel/msg161916.html)
>>
>> "linux/kernel.h _does_ use bug stuff - in ARRAY_SIZE().
>>
>> ARRAY_SIZE() uses __must_be_array(), which is defined in linux/compiler-gcc.h,
>> which is obtained via linux/compiler.h and linux/linkage.h.
>>
>> linux/compiler-gcc.h defines __must_be_array() to be:
>> #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
> 
> In which case linux/compiler-gcc.h uses bug.h - so this is where you
> should add the include.
> Not in kernel.h that just happens to use __must_be_array()
> We do not want to add "#include bug.h" to all header files
> that happens to use __must_be_array.

The approach I was taking was to consider something "used" if it was
actually in a static inline[1].  So in that sense, the kernel.h does
not "use" ARRAY_SIZE, but only defines it.  This seems to be what has
been done in the past, and folks have even converted trivial static
inline functions to macros just to use this concept of "used" to
help avoid tangling includes any further than they currently are.

If we expand the definition of used to cover the #define case, then
we'll pretty much have all headers implicitly present everywhere,
and folks won't have a clue what functions they are actually making
use of.  They'll be able to get away with including kernel.h and
largely nothing else - having everything implicitly present, I think.

rmk's example about the uncompressor code is a good one I think, in
terms of having to be explicit about what you are using/including,
since it forces people to think a bit more about what they are using.

So, sticking bug.h into another header that is largely present in
every compile was something that I was actually trying to avoid if
possible....  maybe I should abandon that goal?

Paul.

[1] https://lkml.org/lkml/2012/1/26/529

> 
> 	Sam
