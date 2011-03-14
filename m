Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1CNLyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:54:54 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:60551 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1CNLyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:54:53 -0400
Message-ID: <4D7E020A.1020708@linux.vnet.ibm.com>
Date: Mon, 14 Mar 2011 12:54:50 +0100
From: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
CC: Neil Brown <neilb@suse.de>, akpm@linux-foundation.org, cotte@de.ibm.com,
        heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
        ehrhardt@linux.vnet.ibm.com, "Alasdair G. Kergon" <agk@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3] dm stripe: implement merge method
References: <201012271219.56476.mume@linux.vnet.ibm.com> <20101227225459.5a5150ab@notabene.brown> <201012271323.13406.mume@linux.vnet.ibm.com> <4D74AEF9.7050108@linux.vnet.ibm.com> <20110308022158.GA663@redhat.com> <4D76051E.5060303@linux.vnet.ibm.com> <20110308164849.GA5692@redhat.com> <4D78DA0F.4000001@linux.vnet.ibm.com> <20110312224222.GA6176@redhat.com>
In-Reply-To: <20110312224222.GA6176@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2011 11:42 PM, Mike Snitzer wrote:
> Hi Mustafa,
>
> On Thu, Mar 10 2011 at  9:02am -0500,
> Mustafa Mesanovic<mume@linux.vnet.ibm.com>  wrote:
>
>> On 03/08/2011 05:48 PM, Mike Snitzer wrote:
>>> In any case, it clearly helps your workload.
>>>
>>> Could you explain your config in more detail?
>>> - what is your chunk_size?
>>> - how many stripes (how many mpath devices)?
>>> - what is the performance, of your test workload, of a single underlying
>>>    mpath device?
>>>
>>> And, in particular, what is your test workload?
>>> - What is the nature of your IO (are you using a particular tool)?
>>> - Are you using AIO?
>>> - How many threads?
>>> - Are you driving deep queue depths? Etc.
>>>
>>> I have various configs that I'll be testing to help verify the benefit.
>>> The only other change Alasdair request is that the target version should
>>> be bumped to 1.4 (rather than 1.3.2).
>>>
>>> Given that I can put some time to this now: we should be able to sort
>>> all this out for upstream inclusion in 2.6.39.
>>>
>>> Thanks,
>>> Mike
>> Mike,
>>
>> the setup that I have used to verify and check upon the changes
>> consisted of:
>>
>> - Benchmark
>> iozone (seq write, seq read, random read and write),
>> filesize 2000m, with 32 processes (no AIO used).
>>
>> - Disk-Setup
>> 2 disks (queue_depth=192) ->   each disk with 8 paths
>> ->   multipathed (multibus, rr_min_io=1)
>>
>> And a striped LVM out of these two (chunk_size=64KiB).
>>
>> The benchmark then runs on this LV.
> What record size are you using?
> Which filesystem are you using?
> Also, were you using O_DIRECT?  If not then I'm having a hard time
> understanding why implementing stripe_merge was so beneficial for you.
> stripe_merge doesn't help buffered IO.
>
> Please share your exact iozone command line.
>
> In my testing with aio-stress I have seen the number of calls to
> stripe_map be inversely proportional to the record size (when record
> size is<= chunk_size).
>
> That is, with the following aio-stress commandline:
> aio-stress -O -o 0 -o 1 -r $RECORD_SIZE -d 64 -b 16 -i 16 -s 2048 /dev/snitm/striped_lv
>
> I varied the $RECORD_SIZE from 4k to 256k (striped_lv is using a 64k
> chunk_size across 8 mpath devices).
>
> The number of stripe_map_sector() calls resulting from having
> implemented stripe_merge is fixed at 1048560 (when reading and then
> writing 2048m).  And there is one stripe_map_sector() call for each
> stripe_map() call.
>
> The following table shows the stripe_map_sector and stripe_map call
> count for writes then reads of 2048m (using $record_size AIO).  AIO does
> make use of dm_merge_bvec and stripe_merge.
>
> record_size    stripe_map_sector calls    stripe_map calls
> 4k             2097152                    1048592
> 8k             1572864                    524304
> 16k            1310720                    262160
> 32k            1179648                    131088
> 64k            1114112                    65552
> 128k           1114112                    65552
> 256k           1114112                    65552
>
> The above shows that bios are being assembled using larger payloads (up
> to chunk_size) given that AIO does make use of stripe_merge.
>
> When I did the same accounting (via attached systemtap script) for a
> buffered iozone run with a file size of 2000m (using -i 0 -i 1 -i 2) I
> saw that dm_merge_bvec() was _never_ called and the number of
> stripe_map_sector calls was very close to the stripe_map calls.
>
> Mike
>
> p.s.
> All the above aside, one of our more elaborate benchmarks against XFS
> has seen a significant benefit from stripe_merge() being present... I
> still need to understand that benchmark's IO workload though.
I used 64k record size, and ext3 as filesystem.

No, I was not using O_DIRECT. But I have measured as well with O_DIRECT, and
the benefits there are significant too.

stripe_merge() helps a lot. The reason of splitting I/O records into 4KiB
chunks happens at dm_set_device_limits(), thats what I explained in my v1 patch.
If the target has no own merge_fn, max_sectors will be set to PAGE_SIZE, what
in my case is 4KiB. Then __bio_add_page checks upon max_sectors and does not
add any more pages to a bio. The bio stays at 4KiB.

Now by avoiding the "wrong" setting of max_sectors for the dm target,
__bio_add_page will be able to add more than one page to the bios.

So this is my iozone call:
  # iozone -s 2000m -r 64k -t 32 -e -w -R -C -i 0
                                         -F<mntpt>/Child0 ....<mntpt>/Child31
For direct I/O (O_DIRECT) add '-I'.

dm_merge_bvec/stripe_merge is being called only on reads, thats what I have
observed when I was testing the patch on my 2.6.32.x-stable kernel. Maybe it
depends if the I/O is page cached or aio based...this might be worth a
further analysis. On writes another path must be walked through, but I have
not further analysed it so far.

In think it helps to avoid "overhead" in passing always 4KiB bios to the
dm target. In my opinion it is "cheaper"/"faster" to pass one big bio
down to the dm target instead of passing 4KiB max each bio.

I used iostat to check on the devices and the sizes of the requests, just try
to start an iostat process which collects I/O statistics during your
runs. e.g. 'iostat -dmx 2>  outfile&' - check out "avgrq-sz".

And yes during my iostat runs I figured out that the writes are still dropping
into the dm in 4KiB chunks, this is what I will analyse next.
Maybe there will be another patch(es) to fix that.

Mustafa

ps:
aio-stress did not work for me, sorry but I did not have the time to check on that
and to search where the error might be...

