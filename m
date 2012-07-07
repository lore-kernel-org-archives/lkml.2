Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2GGB2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 21:28:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64715 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2GGB2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 21:28:12 -0400
MIME-Version: 1.0
In-Reply-To: <829BE905228AE14A9AE1A46E6F2E371605538D039F@VA3DIAXVS891.RED001.local>
References: <829BE905228AE14A9AE1A46E6F2E371605538D039F@VA3DIAXVS891.RED001.local>
Date: Sat, 7 Jul 2012 09:28:11 +0800
Message-ID: <CAM_iQpWEZWZ9UEVkB7OVeyztzX+GxuEZ5qwcGJDUy0ZDqxkGgg@mail.gmail.com>
Subject: Re: New Defect found by Coverity Scan based on code change in last
 1.5 week
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Scan Subscription <scan-subscription@coverity.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "jkosina@suse.cz" <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 7, 2012 at 1:32 AM, Scan Subscription
<scan-subscription@coverity.com> wrote:
> ________________________________________________________________________
> CID 200075: Free of array-typed value (BAD_FREE.array)
>
> /linux/fs/splice.c: 317 ( array_assign)
>    311     struct page *pages[PIPE_DEF_BUFFERS];
>    312     struct partial_page partial[PIPE_DEF_BUFFERS];
> ...
>    316     int error, page_nr;
>>>> CID 200075: Free of array-typed value (BAD_FREE.array)
>>>> Assigning: "spd.pages" = "pages".
>    317     struct splice_pipe_desc spd = {
>    318      .pages = pages,
>    319      .partial = partial,
>    320      .nr_pages_max = PIPE_DEF_BUFFERS,
>    321      .flags = flags,
>
> /linux/fs/splice.c: 503 ( incorrect_free)
>    500     if (spd.nr_pages)
>    501      error = splice_to_pipe(pipe, &spd);
>    502
>>>> "splice_shrink_spd" frees incorrect pointer "spd.pages".
>    503     splice_shrink_spd(&spd);
>    504     return error;
>    505    }
>    506
>    507    /**

This one should be bogus, splice_shrink_spd() only
frees it when spd->nr_pages_max > PIPE_DEF_BUFFERS
because splice_grow_spd() only allocates memory
in that case. Otherwise, the array allocated on stack is
used.

Thanks.
