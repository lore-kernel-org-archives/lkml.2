Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab1CXFiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 01:38:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64925 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1CXFiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 01:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WhP2GjUJ7GgN2YaKx0jGu8WXl7yb9YvbeesOEmr+9lhMivWP6nutCJkoGRjrMcCgFH
         KluVOQvCvj3e0ENJiPNfnW+u4FRFxxFYFhs6z1nUv9HPg4St+Xj0iZKdNVRDyK28s1pF
         J2pl8tN0TiBzBPTgFd5AlY0s27wPIvR3HrAOI=
MIME-Version: 1.0
In-Reply-To: <20110323205615.6984f974.akpm@linux-foundation.org>
References: <20110324135524.261bb5a9.sfr@canb.auug.org.au>
	<20110323205615.6984f974.akpm@linux-foundation.org>
Date: Thu, 24 Mar 2011 14:38:10 +0900
Message-ID: <AANLkTikagME334Y6PH4P_Nybf_h=fov5CiNBAY7KxYyN@mail.gmail.com>
Subject: Re: linux-next: manual merge of the cleancache tree with Linus' tree
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 12:56 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 24 Mar 2011 13:55:24 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>> Hi Dan,
>>
>> Today's linux-next merge of the cleancache tree got a conflict in
>> mm/truncate.c between commit 5adc7b518b54 ("mm: truncate: change
>> remove_from_page_cache") from Linus' tree and commit 03e838947c8a
>> ("mm/fs: add hooks to support cleancache") from the cleancache tree.
>>
>> I fixed it up (see below) but am really not sure of the fix.  I can carry
>> this fix as necessary.
>>
>> Is this stuff going to be merged into Linus' tree this time round?
>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>
>> diff --cc mm/truncate.c
>> index a956675,cd94607..0000000
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@@ -106,8 -108,13 +108,12 @@@ truncate_complete_page(struct address_s
>>       cancel_dirty_page(page, PAGE_CACHE_SIZE);
>>
>>       clear_page_mlock(page);
>>  -    remove_from_page_cache(page);
>>       ClearPageMappedToDisk(page);
>>  +    delete_from_page_cache(page);
>> +     /* this must be after the remove_from_page_cache which
>> +      * calls cleancache_put_page (and note page->mapping is now NULL)
>> +      */
>> +     cleancache_flush_page(mapping, page);
>>  -    page_cache_release(page);       /* pagecache ref */
>>       return 0;
>>   }
>
> I did the cleancache_flush_page() before the delete_from_page_cache(),
> in case the delete_from_page_cache() freed the page.  I didn't actually
> check whether that makes sense though.

I am not sure cleancache's put and flush semantic.
If I understand rightly with old __remove_from_page_cache's comment,
maybe cleancache_flush_page is to invalidate the page.(If I understand
right, I hope the name is changed to cleancache_invalidate_page)

"        /*
         * if we're uptodate, flush out into the cleancache, otherwise
         * invalidate any existing cleancache entries.  We can't leave
         * stale data around in the cleancache once our page is gone
         */
        if (PageUptodate(page))
                cleancache_put_page(page);
        else
                cleancache_flush_page(mapping, page); "

So I think cleancache_flush_page should be done after
delete_from_page_cache because delete_from_page_cache calls
cleancache_put_page(maybe this function would flush the content of
memory into cleancache's target) before we invalidates the page.

And it should not be a problem in case the delete_from_page_cache
freed the page since cleancache should have a reference the page but I
didn't check cleancahe always has a reference of page. If it isn't,
it's a critical problem.

Dan, Could you comment this?


-- 
Kind regards,
Minchan Kim
