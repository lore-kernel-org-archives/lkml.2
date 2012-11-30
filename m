Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2K3C3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:29:06 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:54290 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2K3C3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:29:04 -0500
MIME-Version: 1.0
In-Reply-To: <20121130015810.GB18630@blaptop>
References: <1354001201-25537-1-git-send-email-ngupta@vflare.org>
	<20121129074538.GA5564@bbox>
	<50B72664.30000@vflare.org>
	<20121130000307.GA17427@blaptop>
	<CAPkvG_dn_Dpen79T7R6WVg_SDisVz1tDhd7=uz+cbwrHzQUNKw@mail.gmail.com>
	<20121130015810.GB18630@blaptop>
Date: Thu, 29 Nov 2012 18:29:03 -0800
Message-ID: <CAPkvG_cpXJWJbL6J7ynVRQ+QR2h5XJj2CibZrENaFrFuRCOofg@mail.gmail.com>
Subject: Re: [PATCH 1/2] zsmalloc: add function to query object size
From: Nitin Gupta <ngupta@vflare.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 5:58 PM, Minchan Kim <minchan@kernel.org> wrote:
> On Thu, Nov 29, 2012 at 04:53:15PM -0800, Nitin Gupta wrote:
>> On Thu, Nov 29, 2012 at 4:03 PM, Minchan Kim <minchan@kernel.org> wrote:
>> > On Thu, Nov 29, 2012 at 01:09:56AM -0800, Nitin Gupta wrote:
>> >> On 11/28/2012 11:45 PM, Minchan Kim wrote:
>> >> >On Mon, Nov 26, 2012 at 11:26:40PM -0800, Nitin Gupta wrote:
>> >> >>Adds zs_get_object_size(handle) which provides the size of
>> >> >>the given object. This is useful since the user (zram etc.)
>> >> >>now do not have to maintain object sizes separately, saving
>> >> >>on some metadata size (4b per page).
>> >> >>
>> >> >>The object handle encodes <page, offset> pair which currently points
>> >> >
>> >> >Nitpick.
>> >> >
>> >> ><page, index> in descrption would be proper instead of
>> >> ><page, offset>. You are going to replace <page, idx> with <page, offset>.
>> >> >
>> >>
>> >> I think 'offset' conveys the meaning more clearly; 'index' is after
>> >> all just a chopped-off version of offset :)
>> >
>> > In my perceptoin, offset means location from some point by some byte
>> > while index is thing we have to multiply sizeof(object) to get.
>> > So you used index before the patch but now you try to use offset instead of
>> > index.
>> >
>> > Anyway, it's minor nitpick. Never mind if you don't agree. :)
>> >
>> >>
>> >>
>> >> >>to the start of the object. Now, the handle implicitly stores the size
>> >> >>information by pointing to the object's end instead. Since zsmalloc is
>> >> >>a slab based allocator, the start of the object can be easily determined
>> >> >>and the difference between the end offset encoded in the handle and the
>> >> >>start gives us the object size.
>> >> >
>> >> >It's a good idea. Look at just minor comment below.
>> >> >
>> >> >Let's talk with another concern. This patch surely helps current
>> >> >customer's memory usage who should add 4 byte for accounting the
>> >> >statistics while zsmalloc could be slow down.
>> >> >Is it really valuable?
>> >> >
>> >> >Yes. zram/zcache had a tight coupling with zsmalloc so it already
>> >> >lost modularity. :( In this POV, this patch makes sense.
>> >> >But if someone are willing to remove statistics for performance?
>> >> >Although he remove it, zsmalloc is still slow down.
>> >> >
>> >> >Statistic for user of zsmalloc should be cost of user himself, not zsmalloc
>> >> >and it accelerates dependency with customer so it makes changing allocator
>> >> >hard in future. We already had such experience(xvmalloc->zsmalloc). Of course,
>> >> >it's not good that worry future things too early without any plan.
>> >> >So I'm not strong againt you. If any reviewer don't raise an eyebrow,
>> >> >I wil rely on your decision.
>> >> >
>> >>
>> >> Looking over the changes I do not expect any difference in
>> >> performance -- just a bit more arithmetic, however the use of
>> >> get_prev_page() which may dereference a few extra pointers might not
>> >> be really free. Also, my iozone test[1] shows very little difference
>> >> in performance:
>> >
>> > Iozone test isn't enough to prove the minor slow down because it would have
>> > many noise about I/O path and different compression ratio per I/O.
>> >
>> >>
>> >> With just the fix for crash (patch 1/2):
>> >> 9.28user 1159.84system 21:46.54elapsed 89%CPU (0avgtext+0avgdata
>> >> 50200maxresident)k
>> >> 212988544inputs+190660816outputs (1major+16706minor)pagefaults 0swaps
>> >>
>> >> With the new get_object_size() code (patch 1/2 + patch 2/2):
>> >> 9.20user 1112.63system 21:03.61elapsed 88%CPU (0avgtext+0avgdata
>> >> 50200maxresident)k
>> >> 194636568inputs+190500424outputs (1major+16707minor)pagefaults 0swaps
>> >>
>> >> I really cannot explain this ~40s speedup but anyways, I think
>> >> optimizing zsmalloc/zram should be taken up separately, at least
>> >> when this new code does not seem to have any significant effects.
>> >>
>> >>
>> >> [1] iozone test:
>> >>  - Create zram of size 1200m
>> >>  - Create ext4 fs
>> >>  - iozone -a -g 1G
>> >>  - In parallel: watch zram_stress
>> >>
>> >> # zram_stress
>> >> sync
>> >> echo 1 | sudo tee /proc/sys/vm/drop_caches
>> >>
>> >>
>> >> Surely, not the most accurate of the tests but gives an idea if
>> >> anything is making a significant difference.
>> >
>> > For more accurate test, it would be better to use zsmapbench by Seth.
>> > https://github.com/spartacus06/zsmapbench
>>
>> Thanks for the pointer. I also found fio which can generate I/O with different
>> levels of compressibility. These would help with future evaluations.
>>
>> > Frankly speaking, I don't expect it has a significant regression as you said.
>> > More concern to me is we are going to make tight coupling with zram/zcache +
>> > zsmalloc. It makes changing from zsmalloc to smarter allocator hard.
>>
>> I could not understand how this patch increasing zram + zsmalloc coupling.
>> All we need from any potential allocator replacement is an interface to
>> provide the object size given its handle.  If the new allocation cannot
>
> That's it. Why should general allocator support such special function?
>
>> support that then the we can create another size[] just like handle[] to
>> maintain sizes.  So, its really simple to replace zsmalloc. if required, at
>> least for the zram.
>
> You're right. It's simple now but the concern is that we are approaching to
> put the specific function which should be customer side to general allocator
> side. Although it's simple at the moment, it could be severe if such special
> functionalitys are accumulated.
>
>>
>>
>> > The reason I have a such concern is that I have a TODO which supports
>> > swap-over-zram pages migratin to storage swap when zram is full. Yes. It's a
>> > just plan, no schedule at the moment so I can't insist on but if i try it in
>> > future, I might want to replace zsmalloc to another. In case of that, tight
>> > coupling would be a another hurdle.
>>
>> For me, its hard to see what kind of issues you might face during this
>> zram-to-disk migration work, especially from the allocator side. Anyways, this
>
> The reason is that I want to make free pages via such migration when memory pressure
> is very severe. For it, we need some scheme to select victm zram objects like LRU.
> In case of that, although we migrate them, we can't get a free page if they are
> spread over lots of other zram pages. It's already problem in slab-based allocator.
>
> If I should develop a allocator for preventing above my concern, I never want to
> provide getting objsize function from new allocator.
>
>
>> would be an interesting feature, so please let me know if you get any issues
>> I can help with.
>>
>> > But as I mentioned, I shouldn't prevent your great work by my ideal plan which
>> > even don't have real schedule. So still I can follow your opinion.
>> > Please resend the patch with fix if you think it's really worthy. :)
>> >
>>
>> I didn't get it. Do you want any changes in this patch? or in patch 2/2?
>> In my opinion this patch should be included since you are getting get_size()
>> functionality for almost no cost.
>
> Hmm, You mentioned like below , so I guess you found some bug. No?
>                 With just the fix for crash (patch 1/2):
>

I was just wondering why you wanted a resend of these patches if there
were no issues about the changelog message or the code. Anyways, since
Greg wants a resend, I will do it soon.

Thanks,
Nitin
