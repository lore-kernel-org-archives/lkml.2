Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081Ab0JXWzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:55:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38495 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0JXWzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cNf30qFSY6/4E3YC0BfmI+BLE2n0tMw2xDicbucAcsaPQP446x78SYpEudC/kScWyt
         ijP8mQZQISMQYvwCqg6/LoEbKpxGIcnOQMZO9ve5sY5gojTyJsW+0wZ7jTp6CoRrgCBK
         sMsUTtD5NYoMnwjkrLdEt/F64iR4tqtambic0=
MIME-Version: 1.0
In-Reply-To: <20101022045509.GA16804@localhost>
References: <20101022045509.GA16804@localhost>
Date: Mon, 25 Oct 2010 07:55:09 +0900
Message-ID: <AANLkTinU7UqBpoUOzE=JfMLtk006Ou=EVJ+6dB1KnBVj@mail.gmail.com>
Subject: Re: [PATCH] mm: Avoid possible deadlock caused by too_many_isolated()
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 1:55 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Neil find that if too_many_isolated() returns true while performing
> direct reclaim we can end up waiting for other threads to complete their
> direct reclaim.  If those threads are allowed to enter the FS or IO to
> free memory, but this thread is not, then it is possible that those
> threads will be waiting on this thread and so we get a circular
> deadlock.
>
> some task enters direct reclaim with GFP_KERNEL
>  => too_many_isolated() false
>    => vmscan and run into dirty pages
>      => pageout()
>        => take some FS lock
>          => fs/block code does GFP_NOIO allocation
>            => enter direct reclaim again
>              => too_many_isolated() true
>                  => waiting for others to progress, however the other
>                     tasks may be circular waiting for the FS lock..
>
> The fix is to let !__GFP_IO and !__GFP_FS direct reclaims enjoy higher
> priority than normal ones, by lowering the throttle threshold for the
> latter.
>
> Allowing ~1/8 isolated pages in normal is large enough. For example,
> for a 1GB LRU list, that's ~128MB isolated pages, or 1k blocked tasks
> (each isolates 32 4KB pages), or 64 blocked tasks per logical CPU
> (assuming 16 logical CPUs per NUMA node). So it's not likely some CPU
> goes idle waiting (when it could make progress) because of this limit:
> there are much more sleeping reclaim tasks than the number of CPU, so
> the task may well be blocked by some low level queue/lock anyway.
>
> Now !GFP_IOFS reclaims won't be waiting for GFP_IOFS reclaims to
> progress. They will be blocked only when there are too many concurrent
> !GFP_IOFS reclaims, however that's very unlikely because the IO-less
> direct reclaims is able to progress much more faster, and they won't
> deadlock each other. The threshold is raised high enough for them, so
> that there can be sufficient parallel progress of !GFP_IOFS reclaims.
>
> CC: Torsten Kaiser <just.for.lkml@googlemail.com>
> CC: Minchan Kim <minchan.kim@gmail.com>
> Tested-by: NeilBrown <neilb@suse.de>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>



-- 
Kind regards,
Minchan Kim
