Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1GHBP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 21:15:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2220 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1GHBP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 21:15:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6400"; a="102493489"
Message-ID: <4E165A48.9050003@codeaurora.org>
Date: Thu, 07 Jul 2011 18:15:52 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: Implement strict user copy checks for x86_64
References: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>	<1306865673-20560-4-git-send-email-sboyd@codeaurora.org> <20110707145413.90578915.akpm@linux-foundation.org>
In-Reply-To: <20110707145413.90578915.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 02:54 PM, Andrew Morton wrote:
> On Tue, 31 May 2011 11:14:32 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> Strict user copy checks are only really supported on x86_32 even
>> though the config option is selectable on x86_64. Add the
>> necessary support to the 64 bit code to trigger copy_from_user()
>> warnings at compile time.
>
> I'm still reluctant to go and throw a pile of warnings into many
> people's faces without having made an attempt to fix them.
>
>

I agree.

> We get a screen full of these:
>
>     inlined from 'pktgen_if_write' at net/core/pktgen.c:877:
> /usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
> In function 'copy_from_user',
>     inlined from 'pktgen_if_write' at net/core/pktgen.c:1145:
> /usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
> In function 'copy_from_user',
> ...
>
> and I don't immediately see a way of suppressing them without adding
> additional code.
>
> Ideas?

I think your compiler is newer than mine. I tried the 4.6.0 compilers
from kernel.org and only got the mempolicy warning. Ugh. When I sent the
series I was using a 4.4.1 gcc.

What happens if you inline strn_len()? I believe gcc can't prove to
itself that the function returns an int that is always less than the
size of f (or buf). This in turn requires it to generate the code for a
buffer overflow possibility (even though we can tell its never possible).

That's the thing with these strict user copy checks. First off we're
relying on aggressive dead code optimization. Second, the compiler can
easily get confused about constraints when function calls aren't
inlined. I'm tempted to say we should rewrite it from

                char f[32];
                memset(f, 0, 32);
                len = strn_len(&user_buffer[i], sizeof(f) - 1);
                if (len < 0)   
                        return len;

                if (copy_from_user(f, &user_buffer[i], len))


to

                int len = strn_len(&user_buffer[i], 31);
                char f[len + 1];
                memset(f, 0, sizeof(f));
                if (len < 0)   
                        return len;

                if (copy_from_user(f, &user_buffer[i], len))


so that gcc can easily see that f is always 1 more than len. But I can't
convince myself that is better (and it's actually broken with regards to
negative return values but you get the idea).

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

