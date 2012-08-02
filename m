Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2HBQrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:47:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43394 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2HBQrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:47:40 -0400
Message-ID: <501AAF47.3090708@gmail.com>
Date: Thu, 02 Aug 2012 18:48:07 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
References: <50197460.8010906@gmail.com> <20120801182749.GD15477@google.com> <50197E4A.7020408@gmail.com> <20120801202432.GE15477@google.com> <5019B0B4.1090102@gmail.com> <20120801224556.GF15477@google.com> <501A4FC1.8040907@gmail.com> <20120802103244.GA23318@leaf> <501A633B.3010509@gmail.com> <501A7AD3.7000008@gmail.com> <20120802161556.GA25572@leaf>
In-Reply-To: <20120802161556.GA25572@leaf>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 06:15 PM, Josh Triplett wrote:
> On Thu, Aug 02, 2012 at 03:04:19PM +0200, Sasha Levin wrote:
>> On 08/02/2012 01:23 PM, Sasha Levin wrote:
>>>> #define DEFINE_HASH_TABLE(name, length) struct hash_table name = { .count = length, .buckets = { [0 ... (length - 1)] = HLIST_HEAD_INIT } }
>>> The limitation of this approach is that the struct hash_table variable must be 'static', which is a bit limiting - see for example the use of hashtable in 'struct user_namespace'.
>>>
>>
>> What if we just use two possible decelerations? One of static structs and one for regular ones.
>>
>> struct hash_table {
>>         size_t bits;
>>         struct hlist_head buckets[];
>> };
>>
>> #define DEFINE_HASHTABLE(name, bits)                                    \
>>         union {                                                         \
>>                 struct hash_table name;                                 \
>>                 struct {                                                \
>>                         size_t bits;                                    \
> 
> This shouldn't use "bits", since it'll get expanded to the macro
> argument.
> 
>>                         struct hlist_head buckets[1 << bits];           \
>>                 } __name;                                               \
> 
> __##name
> 
>>         }
>>
>> #define DEFINE_STATIC_HASHTABLE(name, bit)                              \
>>         static struct hash_table name = { .bits = bit,                  \
>>                 .buckets = { [0 ... (bit - 1)] = HLIST_HEAD_INIT } }
> 
> You probably wanted to change that to [0 ... ((1 << bit) - 1)] , to
> match DEFINE_HASHTABLE.

I wrote it by hand and didn't compile test, will fix all of those.

> Since your definition of DEFINE_HASHTABLE would also work fine when used
> statically, why not just always use that?
> 
> #define DEFINE_STATIC_HASHTABLE(name, bits) static DEFINE_HASHTABLE(name, bits) = { .name.bits = bits }

It will get defined fine, but it will be awkward to use. We'd need to pass anonymous union to all the functions that handle this hashtable, which isn't pretty.

