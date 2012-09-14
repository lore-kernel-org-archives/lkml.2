Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2INNSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:18:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:54849 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2INNSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:18:13 -0400
Message-ID: <50532E99.8060507@parallels.com>
Date: Fri, 14 Sep 2012 17:18:17 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 0/6] fuse: allocate req->pages[] dynamically
References: <20120907172536.1343.80497.stgit@maximpc.sw.ru> <5050B336.1090500@parallels.com> <87har3w5j6.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87har3w5j6.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

09/12/2012 08:49 PM, Miklos Szeredi пишет:
> "Maxim V. Patlasov" <mpatlasov@parallels.com> writes:
>
>> Hi Miklos,
>>
>> So far as no objections appeared, I'll go ahead and replace fuse req->page with
>> req->pagevec. It will point to an array of structs:
>>
>> struct page_vec {
>>      struct page    *pv_page;
>>      unsigned int    pv_len;
>>      unsigned int    pv_offset;
>> };
>>
>> instead of 'struct page *' as it used to be. It seems to be what you suggested
>> in one of your comments. Are you OK about it?
> Yes, that's exactly what I was thinking.

I've encountered a problem while trying to follow this approach. 
fuse_get_user_pages() passes 'req->pages' to get_user_pages_fast(). 
get_user_pages_fast() and friends are not ready to get a pointer to 
array of page_vec-s from fuse. I can see five ways to solve the problem:

1. Re-work get_user_pages_fast() and friends adding ability to fill 
page_vec array. Too much work. Very ugly. I strongly dislike this way.

2. Allocate a temporary array of page pointers in fuse_get_user_pages() 
to use as argument to get_user_pages_fast(). Ugly and may have 
performance impact. I dislike this way too.

3. Call get_user_pages_fast() for each page (i.e. pass npages == 1 to 
it). Easy to implement but may have performance impact. I'd refrain from it.

4. Keep req->pages 'as is', but add req->page_descs pointing to an array 
of <offset, len> structures. Looks clumsy, straightforward, but quite 
doable.

5. Use a hack in fuse_get_user_pages(): temporarily cast req->pagevecs 
to 'struct page **pages', pass it get_user_pages_fast(), then transform 
the content of req->pagevecs[] to have page pointers stored in proper 
places (like 'for (i=...) pagevecs[i].pv_page = pages[i];').

What do you think?

Btw, thanks a lot for careful review of patch-set. I agree with your 
comments. Next version will have those findings fixed.

Thanks,
Maxim
