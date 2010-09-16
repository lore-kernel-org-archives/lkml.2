Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0IPRf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:35:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353Ab0IPRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <1284657194.2275.585.camel@laptop>
References: <20100915104855.41de3ebf@lilo> <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
 <1284654451.2275.579.camel@laptop> <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com>
 <1284657194.2275.585.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Sep 2010 10:34:53 -0700
Message-ID: <AANLkTikquj_2DE4UhTFAoDxL+1g=_BocCQJ5agrwC4NU@mail.gmail.com>
Subject: Re: [RFC][PATCH] Cross Memory Attach
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 10:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> Over a copy_to/from_user? Not bloody likely.
>
> Gah, indeed. OK, since its not nested kmap() should indeed work. The
> alternative is using get_user_pages() on both address spaces, but I
> guess that makes things unnecessarily complex.

.. and perform horribly badly. And since the whole point was to do
this really efficiently, that's not good.

What *would* work would be to have a fast case that does kmap_atomic()
together with a copy_to/from_user_atomic(). And when that fast-case
fails, do the full kmap. Slightly more complex than the suggested
patch, but not horribly so (just a few more lines, no fundamental
complexities).

Of course, these days I would seriously suggest against trying to
optimize the kmap() case. It only matters on crap hardware these days.
Anybody running HIGHMEM in 2010 and thinks that it makes sense
deserves the pain the get. We should not complicate the kernel further
for it, and sane architectures will have a no-op kmap().

So the real cost there is likely not the kmap as much as the
set_page_dirty_lock() for the copy_to case. But you'd need to profile
it to see how big of a hit it is compared to the copy itself.

                           Linus
