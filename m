Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab0HDMQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:16:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56063 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621Ab0HDMQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QjCmH/toAHTN0IpFe/9/aQR4162JCpVbHAMFGVFgXYnbuDm2v5mdqYRPshI6//+e0i
         5eCDOsPpr6j5NzaN1EWP2UyO49YooL85PdhGjA9PmE/7Ll72D25ffAO3Pf5zKod5ulTx
         No5QCZaiie4mzkTZ9hlM64yLelKNvWVQ10tLs=
MIME-Version: 1.0
In-Reply-To: <AANLkTil2-YNAa-jyOYD4cNtbJQ1XQJ6-v3iJ6wxpz7br@mail.gmail.com>
References: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>
	<20100621120613.86cad1a4.akpm@linux-foundation.org>
	<4C1FC35C.8090201@suse.cz>
	<AANLkTil2-YNAa-jyOYD4cNtbJQ1XQJ6-v3iJ6wxpz7br@mail.gmail.com>
Date: Wed, 4 Aug 2010 14:16:15 +0200
Message-ID: <AANLkTinC6Sqs7W--=14nmJFDcTS4HQn0=ysn7VhYDDX6@mail.gmail.com>
Subject: Re: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
From: Yegor Yefremov <yegorslists@googlemail.com>
To: Tiago Maluta <tiago.maluta@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 5:44 AM, Tiago Maluta <tiago.maluta@gmail.com> wrote:
> On Mon, Jun 21, 2010 at 4:54 PM, Michal Marek <mmarek@suse.cz> wrote:
>> On 21.6.2010 21:06, Andrew Morton wrote:
>>> On Thu, 17 Jun 2010 12:50:52 +0000
>>> Tiago Maluta <tiago.maluta@gmail.com> wrote:
>>>
>>>> Linux has an recent option to define CROSS_COMPILE in menuconfig.
>>>>
>>>> Typically, one of the options when building for another target is
>>>> ('arm' is just an example):
>>>>
>>>> # make ARCH=arm CROSS_COMPILE=arm-cc O=../build
>>>>
>>>> If I omit CROSS_COMPILE and use the new way in .config:
>>>> CONFIG_CROSS_COMPILE="arm-cc"
>>>>
>>>> I got:
>>>>
>>>>    cc1: error: unrecognized command line option "-mlittle-endian"
>>>>    cc1: error: unrecognized command line option "-mabi=aapcs-linux"
>>>>    cc1: error: unrecognized command line option "-mno-thumb-interwork"
>>>>    /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for
>>>> -march= switch
>>>>    /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for
>>>> -mtune= switch
>>>>    make[2]: *** [kernel/bounds.s] Error 1
>>>>    make[1]: *** [prepare0] Error 2
>>>>    make: *** [sub-make] Error 2
>>>>
>>>> Verbose output clearly says that I'm using the host compiler instead
>>>> cross compiler.
>>>> This patch fixed my problem:
>>>>
>>>> ---
>>>> __Makefile |______ 2 +-
>>>> __1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/Makefile b/Makefile
>>>> index d49d96c..5a6c7d5 100644
>>>> --- a/Makefile
>>>> +++ b/Makefile
>>>> @@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/
>>>> -e s/sun4u/sparc64/ \
>>>> __export KBUILD_BUILDHOST := $(SUBARCH)
>>>> __ARCH____________________ ?= $(SUBARCH)
>>>> __CROSS_COMPILE__ ?=
>>>> -CROSS_COMPILE__ ?= $(CONFIG_CROSS_COMPILE:"%"=%)
>>>> +CROSS_COMPILE__ := $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
>>>>
>>>> __# Architecture as present in compile.h
>>>> __UTS_MACHINE______ := $(ARCH)
>>>> --
>>>
>>> Perhaps the "%"=% thing isn't supported with your version of make(1).
>>> Which version are you using?
>>
>> My guess is that something expands $(CROSS_COMPILE) before make
>> silentoldconfig generates include/config/auto.conf (which is where the
>> makefile reads the CONFIG_* variables from). Tiago, can you try changing
>> the $(shell ...) line to
>>
>> CROSS_COMPILE := $(shell ls include/config/auto.conf >&2; \
>>    echo "CONFIG_CROSS_COMPILE $(CONFIG_CROSS_COMPILE) >&2; \
>>    grep CONFIG_CROSS_COMPILE .config | cut -d'"'  -f2)
>>
>> and tell us what it prints?
>
> I'm using GNU Make 3.81.
>
> I think you missed a quote in echo..., I using:
>
> CROSS_COMPILE := $(shell ls include/config/auto.conf >&2; \
>    echo "CONFIG_CROSS_COMPILE" $(CONFIG_CROSS_COMPILE) >&2; \
>    grep CONFIG_CROSS_COMPILE .config | cut -d'"'  -f2)
>
> And the output:
> $ make ARCH=arm O=../build
>
> include/config/auto.conf
> CONFIG_CROSS_COMPILE
>  Using /usr/src/linux as source for kernel
>  GEN     /usr/src/build/Makefile
>  CHK     include/linux/version.h
>  CHK     include/generated/utsrelease.h
> make[2]: `include/generated/mach-types.h' is up to date.
>  CALL    /usr/src/linux/scripts/checksyscalls.sh
>  CHK     include/generated/compile.h
>  CC      arch/arm/mm/init.o
>
> ^C
>
> Means that is nothing CONFIG_CROSS_COMPILE.
>
> I agree with Andrew, directly grepping .config isn't the right thing to do.
> I'd like to discuss a better solution.

What about such a solution:

just remove empty  CROSS_COMPILE  ?=

Regards,
Yegor

Fix CONFIG_CROSS_COMPILE issue in .config

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>

Index: b/Makefile
===================================================================
--- a/Makefile	2010-08-02 00:11:14.000000000 +0200
+++ b/Makefile	2010-08-04 14:08:51.000000000 +0200
@@ -189,7 +189,6 @@
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
 export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH		?= $(SUBARCH)
-CROSS_COMPILE	?=
 CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)

 # Architecture as present in compile.h
