Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab1CNOdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:33:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab1CNOdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:33:20 -0400
Date: Mon, 14 Mar 2011 10:33:06 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com, Neil Brown <neilb@suse.de>, akpm@linux-foundation.org,
        cotte@de.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, ehrhardt@linux.vnet.ibm.com,
        "Alasdair G. Kergon" <agk@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3] dm stripe: implement merge method
Message-ID: <20110314143305.GA16939@redhat.com>
References: <201012271219.56476.mume@linux.vnet.ibm.com>
 <20101227225459.5a5150ab@notabene.brown>
 <201012271323.13406.mume@linux.vnet.ibm.com>
 <4D74AEF9.7050108@linux.vnet.ibm.com>
 <20110308022158.GA663@redhat.com>
 <4D76051E.5060303@linux.vnet.ibm.com>
 <20110308164849.GA5692@redhat.com>
 <4D78DA0F.4000001@linux.vnet.ibm.com>
 <20110312224222.GA6176@redhat.com>
 <4D7E020A.1020708@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7E020A.1020708@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14 2011 at  7:54am -0400,
Mustafa Mesanovic <mume@linux.vnet.ibm.com> wrote:

> On 03/12/2011 11:42 PM, Mike Snitzer wrote:
> >What record size are you using?
> >Which filesystem are you using?
> >Also, were you using O_DIRECT?  If not then I'm having a hard time
> >understanding why implementing stripe_merge was so beneficial for you.
> >stripe_merge doesn't help buffered IO.

To clarify (thanks to the clue about dropping caches):
stripe_merge doesn't help _cached_ buffered IO ;)

> I used 64k record size, and ext3 as filesystem.
> 
> No, I was not using O_DIRECT. But I have measured as well with O_DIRECT, and
> the benefits there are significant too.
> 
> stripe_merge() helps a lot. The reason of splitting I/O records into 4KiB
> chunks happens at dm_set_device_limits(), thats what I explained in my v1 patch.
> If the target has no own merge_fn, max_sectors will be set to PAGE_SIZE, what
> in my case is 4KiB. Then __bio_add_page checks upon max_sectors and does not
> add any more pages to a bio. The bio stays at 4KiB.
>
> Now by avoiding the "wrong" setting of max_sectors for the dm target,
> __bio_add_page will be able to add more than one page to the bios.

Right, I understand the limitation that the patch addresses.  But given
that I hadn't dropped caches I was missing _why_ it was helping you so
much for buffered IO.

> So this is my iozone call:
>  # iozone -s 2000m -r 64k -t 32 -e -w -R -C -i 0
>                                         -F<mntpt>/Child0 ....<mntpt>/Child31
> For direct I/O (O_DIRECT) add '-I'.

I've been using a comparable iozone commandline (except I was using -i 0
-i 1 -i 2 in a single iozone run).  If I write (-i 0), drop caches, and
then read (-i 1) I see the benefit associated with stripe_merge() and
buffered reads:

iozone -s 2000m -r 64k -t 8 -e -w -i 0 -F ...

dm_merge_bvec_count calls: 192
stripe_map_sector calls: 8192527
stripe_map calls: 8192921

(do _not_ drop_caches)

iozone -s 2000m -r 64k -t 8 -e -w -i 1 -F ...

dm_merge_bvec_count calls: 0
stripe_map_sector calls: 6
stripe_map calls: 262

echo 3 > /proc/sys/vm/drop_caches
iozone -s 2000m -r 64k -t 8 -e -w -i 1 -F ...
...

dm_merge_bvec_count calls: 8147899
stripe_map_sector calls: 4205979
stripe_map calls: 247675

> dm_merge_bvec/stripe_merge is being called only on reads, thats what I have
> observed when I was testing the patch on my 2.6.32.x-stable kernel. Maybe it
> depends if the I/O is page cached or aio based...this might be worth a
> further analysis. On writes another path must be walked through, but I have
> not further analysed it so far.

Direct I/O (and AIO) writes do use dm_merge_bvec/stripe_merge:

iozone -s 2000m -r 64k -t 8 -e -w -I -i 0 -F ...

dm_merge_bvec_count calls: 16344806
stripe_map_sector calls: 8683179
stripe_map calls: 511595

> In think it helps to avoid "overhead" in passing always 4KiB bios to the
> dm target. In my opinion it is "cheaper"/"faster" to pass one big bio
> down to the dm target instead of passing 4KiB max each bio.
> 
> I used iostat to check on the devices and the sizes of the requests, just try
> to start an iostat process which collects I/O statistics during your
> runs. e.g. 'iostat -dmx 2>  outfile&' - check out "avgrq-sz".
> 
> And yes during my iostat runs I figured out that the writes are still dropping
> into the dm in 4KiB chunks, this is what I will analyse next.

Yes, for buffered writes that is definitely the case.

My iostat runs show this too, e.g.:

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
dm-50             0.00 11970.00    0.00   45.50     0.00 23264.00  1022.59   175.31 1398.88  21.98 100.00
dm-52             0.00 11967.50    0.00   41.50     0.00 20742.00   999.61   170.87 1330.83  24.10 100.00
dm-56             0.00 11962.00    0.00   47.50     0.00 24320.00  1024.00   167.65 1324.91  21.05 100.00
dm-57             0.00 11970.00    0.00   45.00     0.00 23040.00  1024.00   174.03 1409.62  22.22 100.00
dm-58             0.00 11970.00    0.00   47.00     0.00 23808.00  1013.11   176.86 1415.36  21.28 100.00
dm-60             0.00 11962.00    0.00   45.00     0.00 23040.00  1024.00   171.99 1375.34  22.22 100.00
dm-62             0.00 11962.00    0.00   59.50     0.00 29952.00  1006.79   139.20 1129.12  16.81 100.00
dm-64             0.00 11967.50    0.00   63.50     0.00 32510.00  1023.94   136.29 1116.40  15.75 100.00
dm-66             0.00     0.00    0.00 96459.50     0.00 385838.00     8.00 167097.20  675.99   0.01 100.00

NOTE: dm-66 is the bio-based striped_lv volume, the other dm-* are the
underlying request-based mpath devices.

> Maybe there will be another patch(es) to fix that.

Doubtful, and it certainly isn't a DM-only phenomenon.  writeback is
always done in terms of PAGE_SIZE IOs.

> Mustafa
> 
> ps:
> aio-stress did not work for me, sorry but I did not have the time to check on that
> and to search where the error might be...

Odd, works fine for me.  I'm using the following commndline:
aio-stress -O -o 0 -o 1 -r 64 -d 128 -b 16 -i 16 -s 2048 /dev/snitm/striped_lv

Can you share how you're using it and what the error is?
