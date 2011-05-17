Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1EQGfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 02:35:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37867 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1EQGfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 02:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xYpx7kv2FfOGdA7hUV7SPFwKCnrN8yUX/dqY7BePG+LYEGyYpO4LOh8oLiZl0GW8Q8
         cJ+dyiC/d5PNW6nXxtlkBB+NbAM1YyoFfOqzE3KLLPxTP4K9DVd3Fc2CehETxfANchyt
         XHAJQqVOy7UbxoWBJWfcN3ph4h4xCRr8cG6oQ=
MIME-Version: 1.0
In-Reply-To: <20110517060001.GC24069@localhost>
References: <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
	<20110512054631.GI6008@one.firstfloor.org>
	<BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com>
	<BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com>
	<20110514165346.GV6008@one.firstfloor.org>
	<BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com>
	<20110514174333.GW6008@one.firstfloor.org>
	<BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com>
	<20110515152747.GA25905@localhost>
	<BANLkTim-AnEeL=z1sYm=iN7sMnG0+m0SHw@mail.gmail.com>
	<20110517060001.GC24069@localhost>
Date: Tue, 17 May 2011 15:35:50 +0900
Message-ID: <BANLkTin9hDuY1qyyz3p=M_r5RpHupu7Y2w@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Lutomirski <luto@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 3:00 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Sun, May 15, 2011 at 12:12:36PM -0400, Andrew Lutomirski wrote:
>> On Sun, May 15, 2011 at 11:27 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > On Sun, May 15, 2011 at 09:37:58AM +0800, Minchan Kim wrote:
>> >> On Sun, May 15, 2011 at 2:43 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> >> > Copying back linux-mm.
>> >> >
>> >> >> Recently, we added following patch.
>> >> >> https://lkml.org/lkml/2011/4/26/129
>> >> >> If it's a culprit, the patch should solve the problem.
>> >> >
>> >> > It would be probably better to not do the allocations at all under
>> >> > memory pressure.  Even if the RA allocation doesn't go into reclaim
>> >>
>> >> Fair enough.
>> >> I think we can do it easily now.
>> >> If page_cache_alloc_readahead(ie, GFP_NORETRY) is fail, we can adjust
>> >> RA window size or turn off a while. The point is that we can use the
>> >> fail of __do_page_cache_readahead as sign of memory pressure.
>> >> Wu, What do you think?
>> >
>> > No, disabling readahead can hardly help.
>> >
>> > The sequential readahead memory consumption can be estimated by
>> >
>> >                2 * (number of concurrent read streams) * (readahead window size)
>> >
>> > And you can double that when there are two level of readaheads.
>> >
>> > Since there are hardly any concurrent read streams in Andy's case,
>> > the readahead memory consumption will be ignorable.
>> >
>> > Typically readahead thrashing will happen long before excessive
>> > GFP_NORETRY failures, so the reasonable solutions are to
>> >
>> > - shrink readahead window on readahead thrashing
>> >  (current readahead heuristic can somehow do this, and I have patches
>> >  to further improve it)
>> >
>> > - prevent abnormal GFP_NORETRY failures
>> >  (when there are many reclaimable pages)
>> >
>> >
>> > Andy's OOM memory dump (incorrect_oom_kill.txt.xz) shows that there are
>> >
>> > - 8MB   active+inactive file pages
>> > - 160MB active+inactive anon pages
>> > - 1GB   shmem pages
>> > - 1.4GB unevictable pages
>> >
>> > Hmm, why are there so many unevictable pages?  How come the shmem
>> > pages become unevictable when there are plenty of swap space?
>>
>> That was probably because one of my testcases creates a 1.4GB file on
>> ramfs.  (I can provoke the problem without doing evil things like
>> that, but the test script is rather reliable at killing my system and
>> it works fine on my other machines.)
>
> Ah I didn't read your first email.. I'm now running
>
> ./test_mempressure.sh 1500 1400 1
>
> with mem=2G and no swap, but cannot reproduce OOM.
>
> What's your kconfig?
>
>> If you want, I can try to generate a trace that isn't polluted with
>> the evil ramfs file.
>
> No, thanks. However it would be valuable if you can retry with this
> patch _alone_ (without the "if (need_resched()) return false;" change,
> as I don't see how it helps your case).

Yes. I was curious about that. The experiment would be very valuable.

In case of James, he met the problem again without need_resched.
https://lkml.org/lkml/2011/5/12/547.

But I am not sure what's exact meaning of 'livelock' he mentioned.
I expect he met softlockup, again.

Still I think the possibility that skip cond_resched spared in
vmscan.c is _very_ low. How come such softlockup happens?
So I am really curious about what's going on under my sight.

>
> @@ -2286,7 +2290,7 @@ static bool sleeping_prematurely(pg_data_t
> *pgdat, int order, long remaining,
>        * must be balanced
>        */
>       if (order)
> -               return pgdat_balanced(pgdat, balanced, classzone_idx);
> +               return !pgdat_balanced(pgdat, balanced, classzone_idx);
>       else
>               return !all_zones_ok;
>  }
>
> Thanks,
> Fengguang
>



-- 
Kind regards,
Minchan Kim
