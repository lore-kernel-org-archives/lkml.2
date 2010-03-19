Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0CSX1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 19:27:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:54470 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab0CSX1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 19:27:34 -0400
Message-ID: <4BA407B8.7070503@kernel.org>
Date: Fri, 19 Mar 2010 16:24:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v3] x86: do not free zero sized per cpu areas
References: <4B914A61.20409@kernel.org> <4BA3F82D.5090807@kernel.org> <4BA3F8ED.2090600@zytor.com>
In-Reply-To: <4BA3F8ED.2090600@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 03:21 PM, H. Peter Anvin wrote:
> On 03/19/2010 03:18 PM, Yinghai Lu wrote:
>> From: Ian Campbell <ian.campbell@citrix.com>
>>
>> This avoids an infinite loop in free_early_partial().
>>
>> Add a warning to free_early_partial to catch future problems.
>>
>> -v3: according to hpa, don't bother caller.
>>
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> ---
>>  kernel/early_res.c             |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/early_res.c b/kernel/early_res.c
>> index 3cb2c66..f3a861b 100644
>> --- a/kernel/early_res.c
>> +++ b/kernel/early_res.c
>> @@ -333,6 +333,11 @@ void __init free_early_partial(u64 start, u64 end)
>>  	struct early_res *r;
>>  	int i;
>>  
>> +	if (WARN_ONCE(start >= end,
>> +		      "free_early_partial got wrong start/end %#llx/%#llx\n",
>> +		      start, end))
>> +		return;
>> +
>>  try_next:
>>  	i = find_overlapped_early(start, end);
>>  	if (i >= max_early_res)
> 
> No, that's wrong.
> 
> The workaround is still needed for the case of equality to avoid the
> infinite loop.
> 
> So you need an:
> 
> 	if (start == end)
> 		return;
> 

confused, do you mean like this
if (start < end), find_overlapped_early will stop the loop.

From: Ian Campbell <ian.campbell@citrix.com>

This avoids an infinite loop in free_early_partial().

Add a warning to free_early_partial to catch future problems.

-v3: according to hpa, don't bother caller.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/early_res.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/kernel/early_res.c
===================================================================
--- linux-2.6.orig/kernel/early_res.c
+++ linux-2.6/kernel/early_res.c
@@ -333,6 +333,14 @@ void __init free_early_partial(u64 start
 	struct early_res *r;
 	int i;
 
+	if (start >= end) {
+		WARN_ONCE(1,
+		      "free_early_partial got wrong start/end %#llx/%#llx\n",
+		      start, end);
+
+		return;
+	}
+
 try_next:
 	i = find_overlapped_early(start, end);
 	if (i >= max_early_res)
