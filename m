Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2AQStP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:49:15 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33978 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab2AQStO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:49:14 -0500
Message-ID: <4F15C2A6.3010708@gmail.com>
Date: Tue, 17 Jan 2012 10:49:10 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] perf: Fix broken build by rearranging some #includes
References: <1326765685-7686-1-git-send-email-ddaney.cavm@gmail.com> <4F152255.4080409@gmail.com>
In-Reply-To: <4F152255.4080409@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 11:25 PM, Namhyung Kim wrote:
> Hi, again
>
> 2012-01-17 11:01 AM, David Daney wrote:
>> From: David Daney<david.daney@cavium.com>
>>
>> When building on my Debian/mips system, util/util.c fails to build
>> because commit 1aed2671738785e8f5aea663a6fda91aa7ef59b5 (perf kvm: Do
>> guest-only counting by default) indirectly includes stdio.h before the
>> feature selection in util.h is done. This prevents _GNU_SOURCE in
>> util.h from enabling the declaration of getline(), from now second
>> inclusion of stdio.h, and the build is broken.
>>
>> There is another breakage in util/evsel.c caused by include ordering,
>> but I didn't fully track down the commit that caused it.
>>
>> Since the #include situation is a little convoluted throughout perf, I
>> did the following:
>>
>> 1) Always include util/util.h before all other include files.
>>
>> 2) Remove all #define _GNU_SOURCE, as it is already done in util.h.
>>
>> 3) Remove all #undef _GNU_SOURCE, as they don't do what a naive person
>> might expect (or much of anything for that matter) and clutter up
>> the source.
>>
>> 4) #include ctype.h in util.h, so that ctype things have uniform
>> definitions throughout perf.
>>
>> 5) Remove #define of _FILE_OFFSET_BITS where util/util.h is already
>> providing it.
>>
>> This gives me a clean build on x86_64 (fc12) and mips (Debian).
>
> Instead of reordering, how about adding -D_GNU_SOURCE on Makefile and
> removing the line from util.h? If util.h would always be included at
> first, the end result should be same, right? And this way, we don't need
> to care about the ordering anymore.
>

Yeah, that is better.  I had tried it first, but then reversed course as 
I found so many random #define _GNU_SOURCE, that I thought there must 
have been a reason.

Upon further thought on the subject, I think you are right.  We need to 
present a consistent set of features.h defines to the entire perf program.

I withdraw this patch from consideration, and will send a new one soon, 
that does the -D_GNU_SOURCE.

David Daney
