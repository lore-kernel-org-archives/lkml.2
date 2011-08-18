Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1HRCSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:18:37 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58878 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab1HRCSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:18:36 -0400
MIME-Version: 1.0
In-Reply-To: <201108111938.25836.vda.linux@googlemail.com>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com>
 <CAK1hOcN7q=F=UV=aCAsVOYO=Ex34X0tbwLHv9BkYkA=ik7G13w@mail.gmail.com>
 <1313075625.50520.YahooMailNeo@web111715.mail.gq1.yahoo.com> <201108111938.25836.vda.linux@googlemail.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Wed, 17 Aug 2011 22:18:06 -0400
Message-ID: <CAG1a4rsO7JDqmYiwyxPrAHdLNbJt+wqymSzU9i1dv5w5C2OFog@mail.gmail.com>
Subject: Re: running of out memory => kernel crash
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Mahmood Naderan <nt_mahmood@yahoo.com>,
        David Rientjes <rientjes@google.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        "\"linux-mm@kvack.org\"" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys,

>> Why "killing" does not appear here? Why it try to "find some
>> recently used page"?
>
> Because killing is the last resort. As long as kernel can free
> a page by dropping an unmodified file-backed page, it will do that.
> When there is nothing more to drop, and still more free pages
> are needed, _then_ kernel will start oom killing.

I have a little concern about this explanation of yours. Suppose we
have some amount of more or less actively executing processes in the
system. Suppose they started to use lots of resident memory. Amount of
memory they use is less than total available physical memory but when
we add total size of code for those processes it would be several
pages more than total size of physical memory. As I understood from
your explanation in such situation one process will execute its time
slice, kernel will switch to other one, find that its code was pushed
out of RAM, read it from disk, execute its time slice, switch to next
process, read its code from disk, execute and so on. So system will be
virtually unusable because of constantly reading from disk just to
execute next small piece of code. But oom will never be firing in such
situation. Is my understanding correct? Shouldn't it be considered as
an unwanted behavior?


Pavel


On Thu, Aug 11, 2011 at 1:38 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> On Thursday 11 August 2011 17:13, Mahmood Naderan wrote:
>> >What it can possibly do if there is no swap and therefore it
>>
>> >can't free memory by writing out RAM pages to swap?
>>
>>
>> >the disk activity comes from constant paging in (reading)
>> >of pages which contain code of running binaries.
>>
>> Why the disk activity does not appear in the first scenario?
>
> Because there is nowhere to write dirty pages in order to free
> some RAM (since you have no swap) and reading in more stuff
> from disk can't possibly help with freeing RAM.
>
> (What kernel does in order to free RAM is it drops unmodified
> file-backed pages, and doing _that_ doesn't require disk I/O).
>
> Thus, no reading and no writing is necessary/possible.
>
>
>> >Thus the only option is to find some not recently used page
>> > with read-only, file-backed content (usually some binary's
>>
>> >text page, but can be any read-only file mapping) and reuse it.
>> Why "killing" does not appear here? Why it try to "find some
>>
>> recently used page"?
>
> Because killing is the last resort. As long as kernel can free
> a page by dropping an unmodified file-backed page, it will do that.
> When there is nothing more to drop, and still more free pages
> are needed, _then_ kernel will start oom killing.
