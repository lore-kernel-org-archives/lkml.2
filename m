Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0JRK6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 06:58:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53006 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab0JRK6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 06:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fW0JyzUzRyujIeAnuLassgDBiPR9EzGXiVeZr4JXwVgq7yf0OUVQlCyIMttWAYyZ6n
         lF9JgCkoaZI9ucDSAAEGB1M3yoCYTerK8z+HsFAe5xXTrvd/Ny/+Fjjt1zOld/c0Ctxm
         5EtqGzxxrchnbJHT9bAuDB11jPJqhJJX4UpkQ=
MIME-Version: 1.0
In-Reply-To: <20101018151459.2b443221@notabene>
References: <20100915091118.3dbdc961@notabene>
	<4C90139A.1080809@redhat.com>
	<20100915122334.3fa7b35f@notabene>
	<20100915082843.GA17252@localhost>
	<20100915184434.18e2d933@notabene>
	<20101018151459.2b443221@notabene>
Date: Mon, 18 Oct 2010 12:58:17 +0200
Message-ID: <AANLkTimv_zXHdFDGa9ecgXyWmQynOKTDRPC59PZA9mvL@mail.gmail.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Neil Brown <neilb@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Li Shaohua <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 6:14 AM, Neil Brown <neilb@suse.de> wrote:
> Testing shows that this patch seems to work.
> The test load (essentially kernbench) doesn't deadlock any more, though it
> does get bogged down thrashing in swap so it doesn't make a lot more
> progress :-)  I guess that is to be expected.

I just noticed this thread, as your mail from today pushed it up.

In your original mail you wrote: " I recently had a customer (running
2.6.32) report a deadlock during very intensive IO with lots of
processes. " and " Some threads that are blocked there, hold some IO
lock (probably in the filesystem) and are trying to allocate memory
inside the block device (md/raid1 to be precise) which is allocating
with GFP_NOIO and has a mempool to fall back on."

I recently had the same problem (intense IO due to swapstorm created
by 20 gcc processes hung my system) and after initially blaming the
workqueue changes in 2.6.36 Tejun Heo determined that my problem was
not the workqueues getting locked up, but that it was cause by an
exhausted mempool:
http://marc.info/?l=linux-kernel&m=128655737012549&w=2

Instrumenting mm/mempool.c and retrying my workload showed that
fs_bio_set from fs/bio.c looked like the mempool to blame and the code
in drivers/md/raid1.c to be the misuser:
http://marc.info/?l=linux-kernel&m=128671179817823&w=2

I was even able to reproduce this hang with only using a normal RAID1
md device as swapspace and then using dd to fill a tmpfs until
swapping was needed:
http://marc.info/?l=linux-raid&m=128699402805191&w=2

Looking back in the history of raid1.c and bio.c I found the following
interesting parts:

 * the change to allocate more then one bio via bio_clone() is from
2005, but it looks like it was OK back then, because at that point the
fs_bio_set was allocation 256 entries
 * in 2007 the size of the mempool was changed from 256 to only 2
entries (5972511b77809cb7c9ccdb79b825c54921c5c546 "A single unit is
enough, lets scale it down to 2 just to be on the safe side.")
 * only in 2009 the comment "To make this work, callers must never
allocate more than 1 bio at the time from this pool. Callers that need
to allocate more than 1 bio must always submit the previously allocate
bio for IO before attempting to allocate a new one. Failure to do so
can cause livelocks under memory pressure." was added to bio_alloc()
that is the base from my reasoning that raid1.c is broken. (And such a
comment was not added to bio_clone() although both calls use the same
mempool)

So could please look someone into raid1.c to confirm or deny that
using multiple bio_clone() (one per drive) before submitting them
together could also cause such deadlocks?

Thank for looking

Torsten
