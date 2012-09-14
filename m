Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab2INOiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:38:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49718 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2INOiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:38:14 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
Cc: "fuse-devel\@lists.sourceforge.net" 
	<fuse-devel@lists.sourceforge.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel\@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 0/6] fuse: allocate req->pages[] dynamically
References: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
	<5050B336.1090500@parallels.com>
	<87har3w5j6.fsf@tucsk.pomaz.szeredi.hu>
	<50532E99.8060507@parallels.com>
Date: Fri, 14 Sep 2012 16:39:44 +0200
In-Reply-To: <50532E99.8060507@parallels.com> (Maxim V. Patlasov's message of
	"Fri, 14 Sep 2012 17:18:17 +0400")
Message-ID: <87a9ws1xe7.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Maxim V. Patlasov" <mpatlasov@parallels.com> writes:

> Hi Miklos,
>
> 09/12/2012 08:49 PM, Miklos Szeredi пишет:
>> "Maxim V. Patlasov" <mpatlasov@parallels.com> writes:
>>
>>> Hi Miklos,
>>>
>>> So far as no objections appeared, I'll go ahead and replace fuse req->page with
>>> req->pagevec. It will point to an array of structs:
>>>
>>> struct page_vec {
>>>      struct page    *pv_page;
>>>      unsigned int    pv_len;
>>>      unsigned int    pv_offset;
>>> };
>>>
>>> instead of 'struct page *' as it used to be. It seems to be what you suggested
>>> in one of your comments. Are you OK about it?
>> Yes, that's exactly what I was thinking.
>
> I've encountered a problem while trying to follow this
> approach. fuse_get_user_pages() passes 'req->pages' to
> get_user_pages_fast(). get_user_pages_fast() and friends are not ready to get a
> pointer to array of page_vec-s from fuse. I can see five ways to solve the
> problem:
>
> 1. Re-work get_user_pages_fast() and friends adding ability to fill page_vec
> array. Too much work. Very ugly. I strongly dislike this way.
>
> 2. Allocate a temporary array of page pointers in fuse_get_user_pages() to use
> as argument to get_user_pages_fast(). Ugly and may have performance impact. I
> dislike this way too.
>
> 3. Call get_user_pages_fast() for each page (i.e. pass npages == 1 to it). Easy
> to implement but may have performance impact. I'd refrain from it.
>
> 4. Keep req->pages 'as is', but add req->page_descs pointing to an array of
> <offset, len> structures. Looks clumsy, straightforward, but quite
> doable.
>
> 5. Use a hack in fuse_get_user_pages(): temporarily cast req->pagevecs to
> struct page **pages', pass it get_user_pages_fast(), then transform the content
> of req->pagevecs[] to have page pointers stored in proper places (like 'for
> (i=...) pagevecs[i].pv_page = pages[i];').
>
> What do you think?

I'd go for number 4.


Thanks,
Miklos
