Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab1CJGqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:46:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:60581 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab1CJGqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:46:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,295,1297065600"; 
   d="scan'208";a="611173986"
Message-ID: <4D7873B5.7090602@linux.intel.com>
Date: Wed, 09 Mar 2011 22:46:13 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Sharp <dhsharp@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional assignment
 of CC and AR"
References: <1299715137-22768-1-git-send-email-dhsharp@google.com> <1299715137-22768-3-git-send-email-dhsharp@google.com> <4D7828F9.7000906@linux.intel.com> <1299720997.15854.276.camel@gandalf.stny.rr.com> <4D783038.8080103@linux.intel.com> <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com> <1299725486.15854.281.camel@gandalf.stny.rr.com> <1299727594.15854.310.camel@gandalf.stny.rr.com> <AANLkTi=WRv2PekEyuEh5k9VOv9LmGCWa6KxXn0BeZVSk@mail.gmail.com>
In-Reply-To: <AANLkTi=WRv2PekEyuEh5k9VOv9LmGCWa6KxXn0BeZVSk@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 09:25 PM, David Sharp wrote:
> On Wed, Mar 9, 2011 at 7:26 PM, Steven Rostedt<rostedt@goodmis.org>  wrote:
>> On Wed, 2011-03-09 at 21:51 -0500, Steven Rostedt wrote:
>>
>>> I'll play with some other make tricks and see if I can come up with a
>>> better solution.
>>
>> OK, it didn't take me long to come up with "Makefiles suck" ;)
>
> Yes, except for very basic things.
>
>>
>> But I did come up with a solution:
>>
>> ifneq ("$(origin CC)", "environment")
>> CC = gcc
>> endif
>>
>> CC := $(CROSS_COMPILE)$(CC)
>>
>> This wont let make CC=xx work unless I also add a:
>>
>> ifneq ("$(origin CC)", "command line")
>>
>> around the above if, but do we care?
>>
>> -- Steve
>
> This seems to do it all:
>
> define allow-override
>    $(if $(or $(findstring environment,$(origin $(1))),
>              $(findstring command line,$(origin $(1)))),,\
>      $(eval $(1) = $(2)))
> endef
>
> $(call allow-override,CC,$(CROSS_COMPILE)gcc)
> $(call allow-override,AR,$(CROSS_COMPILE)ar)

Egads .... that's hideous :-) This level of complexity makes it very 
difficult for people to readily understand it. What does this offer over:

ifdef CROSS_COMPILE
CC = $(CROSS_COMPILE)gcc
AR = $(CROSS_COMPILE)ar
endif

besides being 3 lines longer with much more complex Makefile syntax and 
conditional statements?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
