Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab0FUTyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:54:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0FUTyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:54:11 -0400
Message-ID: <4C1FC35C.8090201@suse.cz>
Date: Mon, 21 Jun 2010 21:54:04 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Tiago Maluta <tiago.maluta@gmail.com>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
References: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com> <20100621120613.86cad1a4.akpm@linux-foundation.org>
In-Reply-To: <20100621120613.86cad1a4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.6.2010 21:06, Andrew Morton wrote:
> On Thu, 17 Jun 2010 12:50:52 +0000
> Tiago Maluta <tiago.maluta@gmail.com> wrote:
> 
>> Linux has an recent option to define CROSS_COMPILE in menuconfig.
>>
>> Typically, one of the options when building for another target is
>> ('arm' is just an example):
>>
>> # make ARCH=arm CROSS_COMPILE=arm-cc O=../build
>>
>> If I omit CROSS_COMPILE and use the new way in .config:
>> CONFIG_CROSS_COMPILE="arm-cc"
>>
>> I got:
>>
>>    cc1: error: unrecognized command line option "-mlittle-endian"
>>    cc1: error: unrecognized command line option "-mabi=aapcs-linux"
>>    cc1: error: unrecognized command line option "-mno-thumb-interwork"
>>    /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for
>> -march= switch
>>    /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for
>> -mtune= switch
>>    make[2]: *** [kernel/bounds.s] Error 1
>>    make[1]: *** [prepare0] Error 2
>>    make: *** [sub-make] Error 2
>>
>> Verbose output clearly says that I'm using the host compiler instead
>> cross compiler.
>> This patch fixed my problem:
>>
>> ---
>> __Makefile |______ 2 +-
>> __1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index d49d96c..5a6c7d5 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/
>> -e s/sun4u/sparc64/ \
>> __export KBUILD_BUILDHOST := $(SUBARCH)
>> __ARCH____________________ ?= $(SUBARCH)
>> __CROSS_COMPILE__ ?=
>> -CROSS_COMPILE__ ?= $(CONFIG_CROSS_COMPILE:"%"=%)
>> +CROSS_COMPILE__ := $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
>>
>> __# Architecture as present in compile.h
>> __UTS_MACHINE______ := $(ARCH)
>> --
> 
> Perhaps the "%"=% thing isn't supported with your version of make(1). 
> Which version are you using?

My guess is that something expands $(CROSS_COMPILE) before make
silentoldconfig generates include/config/auto.conf (which is where the
makefile reads the CONFIG_* variables from). Tiago, can you try changing
the $(shell ...) line to

CROSS_COMPILE := $(shell ls include/config/auto.conf >&2; \
    echo "CONFIG_CROSS_COMPILE $(CONFIG_CROSS_COMPILE) >&2; \
    grep CONFIG_CROSS_COMPILE .config | cut -d'"'  -f2)

and tell us what it prints?

Thanks,
Michal
