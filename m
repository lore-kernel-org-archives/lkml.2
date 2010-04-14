Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0DNUrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:47:53 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:19837 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab0DNUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:47:50 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.52,206,1270425600"; 
   d="scan'208";a="115336172"
Message-ID: <4BC629F3.8040103@cisco.com>
Date: Wed, 14 Apr 2010 16:47:47 -0400
From: David VomLehn <dvomlehn@cisco.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: dvomlehn@cisco.com, linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
References: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net> <20100412120330.GA2566@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100412120330.GA2566@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Sun, Apr 11, 2010 at 11:06:09PM -0700, David VomLehn wrote:
>   
>> This patch makes panic() and die() registers available to, for example,
>> panic notifier functions.  Panic notifier functions are quite useful
>> for recording crash information, but they don't get passed the register
>> values. This makes it hard to print register contents, do stack
>> backtraces, etc. The changes in this patch save the register state when
>> panic() is called and introduce a function for die() to call that allows
>> it to pass in the registers it was passed.
>>
>> Following this patch are more patches, one per architecture. These include
>> two types of changes:
>> o  A save_ptregs() function for the processor. I've taken a whack at
>>    doing this for all of the processors. I have tested x86 and MIPS
>>    versions. I was able to find cross compilers for ARM, ... and the
>>    code compiles cleanly. Everything else, well, what you see is sheer
>>    fantasy. You are welcome to chortle with merriment.
>> o  When I could figure it out, I replaced the calls to panic() in
>>    exception handling functions with calls to panic_with_regs() so
>>    that everyone can leverage these changes without much effort. Again,
>>    not all the code was transparent, so there are likely some places
>>    that should have additional work done.
>>
>> Note that the pointer to the struct pt_regs may be NULL. This is to
>> accomodate those processors which don't have a working save_ptregs(). I'd
>> love to eliminate this case by providing a save_ptregs() for all
>> architectures, but I'll need help to so.
>>     
>
> Wouldn't it be much easier to implement panic with an illegal op and let
> the exception handler set up the pt regs structure instead? Just like some
> architectures do that already for warnings.
> Have a look at lib/bug.c and at various arch/<...>/include/asm/bug.h.
> BUG_FLAG_PANIC would do the trick.
>   
You could do this so long as your exception handler wasn't compromised. When
you get here, your system is already known to have failed, so the idea 
is to be
as gentle as possible.
> But I'm still wondering what the use case would be. You haven't posted any
> code that would actually use this.
>   
I'm working my way towards this, but the general idea is to be able to 
log all system
state from within a panic handler. So, you'd want to print the 
registers, the stack,
the window of memory around instructions, the stack trace, etc., all of 
which need
some set of the register values.
