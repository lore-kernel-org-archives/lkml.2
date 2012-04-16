Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2DPVMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:12:25 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49284 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070Ab2DPVMX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:12:23 -0400
MIME-Version: 1.0
In-Reply-To: <201204161859.32436.arnd@arndb.de>
References: <201203301744.16762.arnd@arndb.de>
	<201204111557.14153.arnd@arndb.de>
	<CAKL-ytsXbe4=u94PjqvhZo=ZLiChQ0FmZC84GNrFHa0N1mDjFw@mail.gmail.com>
	<201204161859.32436.arnd@arndb.de>
Date: Mon, 16 Apr 2012 15:12:21 -0600
Message-ID: <CAKL-ytvC3dw6p=R1G3GOCst_6B=uOqRK2kWOH9jso_=bgtNOXA@mail.gmail.com>
Subject: Re: swap on eMMC and other flash
From: Stephan Uphoff <ups@google.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Minchan Kim <minchan@kernel.org>, linaro-kernel@lists.linaro.org,
        android-kernel@googlegroups.com, linux-mm@kvack.org,
        "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>, linux-kernel@vger.kernel.org,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Apr 16, 2012 at 12:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 16 April 2012, Stephan Uphoff wrote:
>> opportunity to plant a few ideas.
>>
>> In contrast to rotational disks read/write operation overhead and
>> costs are not symmetric.
>> While random reads are much faster on flash - the number of write
>> operations is limited by wearout and garbage collection overhead.
>> To further improve swapping on eMMC or similar flash media I believe
>> that the following issues need to be addressed:
>>
>> 1) Limit average write bandwidth to eMMC to a configurable level to
>> guarantee a minimum device lifetime
>> 2) Aim for a low write amplification factor to maximize useable write bandwidth
>> 3) Strongly favor read over write operations
>>
>> Lowering write amplification (2) has been discussed in this email
>> thread - and the only observation I would like to add is that
>> over-provisioning the internal swap space compared to the exported
>> swap space significantly can guarantee a lower write amplification
>> factor with the indirection and GC techniques discussed.
>
> Yes, good point.
>
>> I believe the swap functionality is currently optimized for storage
>> media where read and write costs are nearly identical.
>> As this is not the case on flash I propose splitting the anonymous
>> inactive queue (at least conceptually) - keeping clean anonymous pages
>> with swap slots on a separate queue as the cost of swapping them
>> out/in is only an inexpensive read operation. A variable similar to
>> swapiness (or a more dynamic algorithmn) could determine the
>> preference for swapping out clean pages or dirty pages. ( A similar
>> argument could be made for splitting up the file inactive queue )
>
> I'm not sure I understand yet how this would be different from swappiness.

As I see it swappiness determines the ratio for paging out file backed
as compared to anonymous, swap backed pages.
I would like to further be able to set the ratio for throwing away
clean anonymous pages with swap slots ( that are easy to read back in)
as compared to writing out dirty anonymous pages to swap.

>
>> The problem of limiting the average write bandwidth reminds me of
>> enforcing cpu utilization limits on interactive workloads.
>> Just as with cpu workloads - using the resources to the limit produces
>> poor interactivity.
>> When interactivity suffers too much I believe the only sane response
>> for an interactive device is to limit usage of the swap device and
>> transition into a low memory situation - and if needed - either
>> allowing userspace to reduce memory usage or invoking the OOM killer.
>> As a result low memory situations could not only be encountered on new
>> memory allocations but also on workload changes that increase the
>> number of dirty pages.
>
> While swap is just a special case for anonymous memory in writeback
> rather than file backed pages, I think what you want here is a tuning
> knob that decides whether we should discard a clean page or write back
> a dirty page under memory pressure. I have to say that I don't know
> whether we already have such a knob or whether we already treat them
> differently, but it is certainly a valid observation that on hard
> drives, discarding a clean page that is likely going to be needed
> again has about the same overhead as writing back a dirty page
> (i.e. one seek operation), while on flash the former would be much
> cheaper than the latter.

Exactly - as far as I see there is no such knob.
I mentioned splitting the anonymous inactive queue (in clean and
dirty) as I believe it would make it easier to implement such a knob
while maintaining the maximum of LRU information..

>
>> A wild idea to avoid some writes altogether is to see if
>> de-duplication techniques can be used to (partially?) match pages
>> previously written so swap.
>
> Interesting! We already have KSM (kernel samepage merging) to do
> the same thing in memory, but I don't know how that works
> during swapout. It might already be there, waiting to get switched
> on, or might not be possible until we implemnt an extra remapping
> layer in swap as has been proposed. It's certainly worth remembering
> this as we work on the design for that remapping layer.
>
>> In case of unencrypted swap  (or encrypted swap with a static key)
>> swap pages on eMMC could even be re-used across multiple reboots.
>> A simple version would just compare dirty pages with data in their
>> swap slots as I suspect (but really don't know) that some user space
>> algorithms (garbage collection?) dirty a page just temporarily -
>> eventually reverting it to the previous content.
>
> I think that would incur overhead for indexing the pages in swap space
> in a persistent way, something that by itself would contribute to
> write amplification because for every swapout, we would have to write
> both the page and the index (eventually), and that index would likely
> be a random write.

I agree - overhead may be too big.
Still unless it is too energy intensive I could see a case for an idle
task to match up anonymous pages to pre-existing swap data sometimes
after reboot ( and before memory is tight )
Unless memory layout is randomized I expect many anonymous pages to
end up with the same data boot after boot.

>
> Thanks for your thoughts!
>
>        Arnd

Thanks for working on this

Stephan
