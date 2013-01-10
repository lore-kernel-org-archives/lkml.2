Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3AJL67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:58:59 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54393 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3AJL65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:58:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130109151354.GA17353@quack.suse.cz>
References: <1356847190-7986-1-git-send-email-linkinjeon@gmail.com>
	<20130105031817.GA8650@localhost>
	<CAKYAXd-kTOBwZfW=17Ta0wLB4HWzkk5ta3AdT0cPRK3z2zsLUA@mail.gmail.com>
	<20130109151354.GA17353@quack.suse.cz>
Date: Thu, 10 Jan 2013 20:58:56 +0900
Message-ID: <CAKYAXd_f_mZjpdJoMSJEBXC1jmfyP=2K01Y5Ttuxr5EpV0Pknw@mail.gmail.com>
Subject: Re: [PATCH] writeback: fix writeback cache thrashing
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        liwanp@linux.vnet.ibm.com, Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>,
        Dave Chinner <dchinner@redhat.com>,
        Simon Jeons <simon.jeons@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/10 Jan Kara <jack@suse.cz>:
> On Wed 09-01-13 17:26:36, Namjae Jeon wrote:
> <snip>
>> But in one normal scenario, the changes actually results in
>> performance degradation.
>>
>> Results for ‘dd’ thread on two devices:
>> Before applying Patch:
>> #> dd if=/dev/zero of=/mnt/sdb2/file1 bs=1048576 count=800 &
>> #> dd if=/dev/zero of=/mnt/sda6/file2 bs=1048576 count=2000 &
>> #>
>> #> 2000+0 records in
>> 2000+0 records out
>> 2097152000 bytes (2.0GB) copied, 77.205276 seconds, 25.9MB/s  -> USB
>> HDD WRITE Speed
>>
>> [2]+ Done dd if=/dev/zero of=/mnt/sda6/file2 bs=1048576 count=2000
>> #>
>> #>
>> #> 800+0 records in
>> 800+0 records out
>> 838860800 bytes (800.0MB) copied, 154.528362 seconds, 5.2MB/s -> USB
>> Flash WRITE Speed
>>
>> After applying patch:
>> #> dd if=/dev/zero of=/mnt/sdb2/file1 bs=1048576 count=800 &
>> dd if=/
>> #> dd if=/dev/zero of=/mnt/sda6/file2 bs=1048576 count=2000 &
>> #>
>> #> 2000+0 records in
>> 2000+0 records out
>> 2097152000 bytes (2.0GB) copied, 123.844770 seconds, 16.1MB/s ->USB
>> HDD WRITE Speed
>> 800+0 records in
>> 800+0 records out
>> 838860800 bytes (800.0MB) copied, 141.352945 seconds, 5.7MB/s -> USB
>> Flash WRITE Speed
>>
>> [2]+ Done dd if=/dev/zero of=/mnt/sda6/file2 bs=1048576 count=2000
>> [1]+ Done dd if=/dev/zero of=/mnt/sdb2/file1 bs=1048576 count=800
>>
>> So, after applying our changes:
>> 1) USB HDD Write speed dropped from 25.9 -> 16.1 MB/s
>> 2) USB Flash Write speed increased marginally from 5.2 -> 5.7 MB/s
>>
>> Normally if we have a USB Flash and HDD plugged in system. And if we
>> initiate the ‘dd’ on both the devices. Once dirty memory is more than
>> the background threshold, flushing starts for all BDI (The write-back
>> for the devices will be kicked by the condition):
>> If (global_page_state(NR_FILE_DIRTY) +
>> global_page_state(NR_UNSTABLE_NFS) > background_thresh))
>>       return true;
>> As the slow device and the fast device always make sure that there is
>> enough DIRTY data in memory to kick write-back.
>> Since, USB Flash is slow, the DIRTY pages corresponding to this device
>> is much higher, resulting in returning ‘true’ everytime from
>> over_bground_thresh. So, even though HDD might have only few KB of
>> dirty data, it is also flushed immediately.
>> This frequent flushing of HDD data results in gradually increasing the
>> bdi_dirty_limit() for HDD.
>   Interesting. Thanks for testing! So is this just a problem with initial
> writeout fraction estimation. I.e. if you first let dd to USB HDD run for a
> couple of seconds to ramp up its fraction and only then start writeout to
> USB flash, is there still a problem with USB HDD throughput with the
> changed over_bground_thresh() function?
#> dd if=/dev/zero of=/mnt/sda6/file2 bs=1048576 count=4000 &

-> sleep for 10 seconds so that USB HDD gets chance to fill cache and
its bdi_dirty_limit
becomes high.

#>
#> dd if=/dev/zero of=/mnt/sdb2/file1 bs=1048576 count=800 &
#> 800+0 records in
800+0 records out
838860800 bytes (800.0MB) copied, 146.240434 seconds, 5.5MB/s
4000+0 records in
4000+0 records out
4194304000 bytes (3.9GB) copied, 220.184229 seconds, 18.2MB/s

[2]+  Done                       dd if=/dev/zero of=/mnt/sdb2/file1
bs=1048576 count=800
[1]+  Done                       dd if=/dev/zero of=/mnt/sda6/file2
bs=1048576 count=4000

But still there is drop in USB HDD WRITE speed from 25 MB/s -> 18.2 MB/s

>
>> But, when we introduce the change to control per BDI i.e.,
>>  if (global_page_state(NR_FILE_DIRTY) +
>>          global_page_state(NR_UNSTABLE_NFS) > background_thresh &&
>>          reclaimable * 2 + bdi_stat_error(bdi) * 2 > bdi_bground_thresh)
>>
>> Now, in this case, when we consider the same scenario, writeback for
>> HDD will only be kicked only if ‘reclaimable * 2 + bdi_stat_error(bdi)
>> * 2 > bdi_bground_thresh’
>> But this condition is not true a lot many number of times, so
>> resulting in false.
>   I'm surprised it's not true so often... dd(1) should easily fill the
> caches. But maybe we are oscilating between below-background-threshold
> and at-dirty-limit situations rather quickly. Do you have recordings of
> BDI_RECLAIMABLE and BDI_DIRTY from the problematic run?

Yes. below is the log in problematic run with below change:

  if (global_page_state(NR_FILE_DIRTY) +
          global_page_state(NR_UNSTABLE_NFS) > background_thresh &&
          reclaimable * 2 + bdi_stat_error(bdi) * 2 > bdi_bground_thresh)

[Test Setup: ARM dual core cPU, 500 MB RAM, background_/dirty_ratio at
default setting]

#> dd if=/dev/zero of=/mnt/sda6/file2 bs=1048576 count=2000 &
#> dd if=/dev/zero of=/mnt/sdb2/file1 bs=1048576 count=800 &

[   97.257777] [1]:flush-8:0  : BDI_DIRTIED =      57152 KB,
BDI_RECLAIMABLE =   57088 KB, bdi_dirty_limit =       0 KB

                                                             ^ Initial
BDI dirty limit for HDD
[   97.296096] [1]:flush-8:16 : BDI_DIRTIED =        128 KB,
BDI_RECLAIMABLE =      64 KB, bdi_dirty_limit =       0 KB

                                                           ^ Initial
BDI dirty limit for FLASH
[   97.321764] [1]:flush-8:16 : BDI_DIRTIED =        704 KB,
BDI_RECLAIMABLE =     640 KB, bdi_dirty_limit =       0 KB
[   97.358775] [1]:flush-8:16 : BDI_DIRTIED =       1664 KB,
BDI_RECLAIMABLE =      64 KB, bdi_dirty_limit =       0 KB
[   97.382956] [1]:flush-8:16 : BDI_DIRTIED =       2176 KB,
BDI_RECLAIMABLE =     512 KB, bdi_dirty_limit =       0 KB
[   97.393325] [1]:flush-8:16 : BDI_DIRTIED =       2816 KB,
BDI_RECLAIMABLE =    1152 KB, bdi_dirty_limit =      52 KB
[   97.410622] [2]:flush-8:16 : BDI_DIRTIED =       4096 KB,
BDI_RECLAIMABLE =       0 KB, bdi_dirty_limit =     108 KB
[   97.422451] [1]:flush-8:16 : BDI_DIRTIED =       4224 KB,
BDI_RECLAIMABLE =     128 KB, bdi_dirty_limit =     108 KB
[   97.432777] [1]:flush-8:16 : BDI_DIRTIED =       4864 KB,
BDI_RECLAIMABLE =     768 KB, bdi_dirty_limit =     164 KB
[   97.447658] [2]:flush-8:16 : BDI_DIRTIED =       6016 KB,
BDI_RECLAIMABLE =       0 KB, bdi_dirty_limit =     164 KB
[   97.466556] [2]:flush-8:16 : BDI_DIRTIED =       6016 KB,
BDI_RECLAIMABLE =      64 KB, bdi_dirty_limit =     220 KB
[   97.485760] [1]:flush-8:16 : BDI_DIRTIED =       6528 KB,
BDI_RECLAIMABLE =     512 KB, bdi_dirty_limit =     272 KB
[   97.524776] [1]:flush-8:16 : BDI_DIRTIED =       7552 KB,
BDI_RECLAIMABLE =     384 KB, bdi_dirty_limit =     380 KB
[   97.535172] [1]:flush-8:16 : BDI_DIRTIED =       7808 KB,
BDI_RECLAIMABLE =     640 KB, bdi_dirty_limit =     380 KB
[   97.594639] [1]:flush-8:16 : BDI_DIRTIED =      11904 KB,
BDI_RECLAIMABLE =    3456 KB, bdi_dirty_limit =     484 KB
[   97.604975] [1]:flush-8:16 : BDI_DIRTIED =      12224 KB,
BDI_RECLAIMABLE =    3776 KB, bdi_dirty_limit =     536 KB
[   97.667729] [1]:flush-8:16 : BDI_DIRTIED =      16512 KB,
BDI_RECLAIMABLE =    3200 KB, bdi_dirty_limit =     696 KB
[   97.678127] [1]:flush-8:16 : BDI_DIRTIED =      17152 KB,
BDI_RECLAIMABLE =    3840 KB, bdi_dirty_limit =     696 KB
[   97.729258] [1]:flush-8:16 : BDI_DIRTIED =      20608 KB,
BDI_RECLAIMABLE =    1536 KB, bdi_dirty_limit =     744 KB
[   97.739654] [1]:flush-8:16 : BDI_DIRTIED =      20992 KB,
BDI_RECLAIMABLE =    1856 KB, bdi_dirty_limit =     740 KB
[   99.412177] [1]:flush-8:0  : BDI_DIRTIED =     102656 KB,
BDI_RECLAIMABLE =   36608 KB, bdi_dirty_limit =   14476 KB
[  100.942829] [1]:flush-8:0  : BDI_DIRTIED =     140288 KB,
BDI_RECLAIMABLE =   35840 KB, bdi_dirty_limit =   21392 KB
[  101.809082] [1]:flush-8:16 : BDI_DIRTIED =      86720 KB,
BDI_RECLAIMABLE =   51328 KB, bdi_dirty_limit =    4096 KB
[  102.266529] [1]:flush-8:0  : BDI_DIRTIED =     173056 KB,
BDI_RECLAIMABLE =   31232 KB, bdi_dirty_limit =   26304 KB
[  103.474246] [2]:flush-8:0  : BDI_DIRTIED =     189440 KB,
BDI_RECLAIMABLE =   16512 KB, bdi_dirty_limit =   30660 KB
[  104.100257] [2]:flush-8:0  : BDI_DIRTIED =     207616 KB,
BDI_RECLAIMABLE =   16704 KB, bdi_dirty_limit =   32220 KB
[  104.110758] [2]:flush-8:0  : BDI_DIRTIED =     207616 KB,
BDI_RECLAIMABLE =   16704 KB, bdi_dirty_limit =   32236 KB
[  104.808133] [2]:flush-8:0  : BDI_DIRTIED =     225856 KB,
BDI_RECLAIMABLE =   18240 KB, bdi_dirty_limit =   33536 KB
[  105.451483] [2]:flush-8:0  : BDI_DIRTIED =     244096 KB,
BDI_RECLAIMABLE =   18240 KB, bdi_dirty_limit =   34704 KB
[  108.993027] [2]:flush-8:0  : BDI_DIRTIED =     306048 KB,
BDI_RECLAIMABLE =   20352 KB, bdi_dirty_limit =   39888 KB
[  109.003379] [2]:flush-8:0  : BDI_DIRTIED =     306048 KB,
BDI_RECLAIMABLE =   20352 KB, bdi_dirty_limit =   39888 KB
[  109.707771] [2]:flush-8:0  : BDI_DIRTIED =     322432 KB,
BDI_RECLAIMABLE =   20352 KB, bdi_dirty_limit =   40512 KB
[  109.718185] [2]:flush-8:0  : BDI_DIRTIED =     322432 KB,
BDI_RECLAIMABLE =   20352 KB, bdi_dirty_limit =   40512 KB
[  110.682318] [2]:flush-8:0  : BDI_DIRTIED =     344320 KB,
BDI_RECLAIMABLE =   21888 KB, bdi_dirty_limit =   40832 KB
[  110.692868] [2]:flush-8:0  : BDI_DIRTIED =     344320 KB,
BDI_RECLAIMABLE =   21888 KB, bdi_dirty_limit =   40808 KB
[  112.607992] [1]:flush-8:16 : BDI_DIRTIED =     171328 KB,
BDI_RECLAIMABLE =   84544 KB, bdi_dirty_limit =    8416 KB
[  115.183151] [2]:flush-8:0  : BDI_DIRTIED =     402112 KB,
BDI_RECLAIMABLE =   20096 KB, bdi_dirty_limit =   40012 KB
[  115.193685] [2]:flush-8:0  : BDI_DIRTIED =     402112 KB,
BDI_RECLAIMABLE =   20096 KB, bdi_dirty_limit =   40012 KB
[  115.756987] [2]:flush-8:0  : BDI_DIRTIED =     416960 KB,
BDI_RECLAIMABLE =   22592 KB, bdi_dirty_limit =   40324 KB
[  115.767339] [2]:flush-8:0  : BDI_DIRTIED =     416960 KB,
BDI_RECLAIMABLE =   22592 KB, bdi_dirty_limit =   40324 KB
[  118.357719] [2]:flush-8:0  : BDI_DIRTIED =     440768 KB,
BDI_RECLAIMABLE =   20096 KB, bdi_dirty_limit =   40396 KB
[  118.377761] [2]:flush-8:0  : BDI_DIRTIED =     441600 KB,
BDI_RECLAIMABLE =   20928 KB, bdi_dirty_limit =   40388 KB
[  118.878817] [2]:flush-8:0  : BDI_DIRTIED =     453504 KB,
BDI_RECLAIMABLE =   20608 KB, bdi_dirty_limit =   40824 KB
[  118.892183] [2]:flush-8:0  : BDI_DIRTIED =     453632 KB,
BDI_RECLAIMABLE =   20736 KB, bdi_dirty_limit =   40828 KB
[  119.986119] [2]:flush-8:0  : BDI_DIRTIED =     477248 KB,
BDI_RECLAIMABLE =   21824 KB, bdi_dirty_limit =   41436 KB
[  119.996632] [2]:flush-8:0  : BDI_DIRTIED =     477248 KB,
BDI_RECLAIMABLE =   21824 KB, bdi_dirty_limit =   41436 KB
[  120.760551] [2]:flush-8:0  : BDI_DIRTIED =     499136 KB,
BDI_RECLAIMABLE =   21888 KB, bdi_dirty_limit =   42000 KB
[  120.771384] [2]:flush-8:0  : BDI_DIRTIED =     499904 KB,
BDI_RECLAIMABLE =   22592 KB, bdi_dirty_limit =   41952 KB
[  122.980263] [2]:flush-8:0  : BDI_DIRTIED =     561472 KB,
BDI_RECLAIMABLE =   21696 KB, bdi_dirty_limit =   43116 KB
[  122.995903] [2]:flush-8:0  : BDI_DIRTIED =     561728 KB,
BDI_RECLAIMABLE =   21888 KB, bdi_dirty_limit =   43124 KB
[  123.751970] [2]:flush-8:0  : BDI_DIRTIED =     574336 KB,
BDI_RECLAIMABLE =   22336 KB, bdi_dirty_limit =   43516 KB
[  123.776339] [2]:flush-8:0  : BDI_DIRTIED =     575616 KB,
BDI_RECLAIMABLE =   23680 KB, bdi_dirty_limit =   43456 KB
[  124.829712] [2]:flush-8:0  : BDI_DIRTIED =     598016 KB,
BDI_RECLAIMABLE =   21760 KB, bdi_dirty_limit =   43696 KB
[  124.841836] [2]:flush-8:0  : BDI_DIRTIED =     598144 KB,
BDI_RECLAIMABLE =   21888 KB, bdi_dirty_limit =   43704 KB
[  124.856201] [2]:flush-8:0  : BDI_DIRTIED =     599360 KB,
BDI_RECLAIMABLE =   23104 KB, bdi_dirty_limit =   43672 KB
[  125.966983] [2]:flush-8:0  : BDI_DIRTIED =     624640 KB,
BDI_RECLAIMABLE =   22912 KB, bdi_dirty_limit =   43816 KB
[  125.977299] [2]:flush-8:0  : BDI_DIRTIED =     624640 KB,
BDI_RECLAIMABLE =   22912 KB, bdi_dirty_limit =   43816 KB

                   ^ Max HDD BDI dirty limit during parallel write on
USB FLASH and HDD

[  130.396626] [1]:flush-8:16 : BDI_DIRTIED =     259904 KB,
BDI_RECLAIMABLE =   83072 KB, bdi_dirty_limit =   12644 KB
[  131.898466] [2]:flush-8:0  : BDI_DIRTIED =     684864 KB,
BDI_RECLAIMABLE =   21184 KB, bdi_dirty_limit =   40572 KB
[  131.908962] [2]:flush-8:0  : BDI_DIRTIED =     684864 KB,
BDI_RECLAIMABLE =   21184 KB, bdi_dirty_limit =   40572 KB
[  132.357273] [2]:flush-8:0  : BDI_DIRTIED =     692608 KB,
BDI_RECLAIMABLE =   20736 KB, bdi_dirty_limit =   40756 KB
[  132.367774] [2]:flush-8:0  : BDI_DIRTIED =     692608 KB,
BDI_RECLAIMABLE =   20736 KB, bdi_dirty_limit =   40756 KB
[  135.066501] [2]:flush-8:0  : BDI_DIRTIED =     713856 KB,
BDI_RECLAIMABLE =   21312 KB, bdi_dirty_limit =   40092 KB
[  135.076876] [2]:flush-8:0  : BDI_DIRTIED =     713856 KB,
BDI_RECLAIMABLE =   21312 KB, bdi_dirty_limit =   40084 KB
[  138.678435] [2]:flush-8:0  : BDI_DIRTIED =     755456 KB,
BDI_RECLAIMABLE =   20480 KB, bdi_dirty_limit =   38848 KB
[  138.688844] [2]:flush-8:0  : BDI_DIRTIED =     755456 KB,
BDI_RECLAIMABLE =   20480 KB, bdi_dirty_limit =   38848 KB
[  139.980078] [2]:flush-8:0  : BDI_DIRTIED =     763008 KB,
BDI_RECLAIMABLE =   19776 KB, bdi_dirty_limit =   38052 KB
[  139.990835] [2]:flush-8:0  : BDI_DIRTIED =     763008 KB,
BDI_RECLAIMABLE =   19776 KB, bdi_dirty_limit =   38020 KB
[  145.847841] [2]:flush-8:0  : BDI_DIRTIED =     797568 KB,
BDI_RECLAIMABLE =   18112 KB, bdi_dirty_limit =   36100 KB
[  145.859417] [2]:flush-8:0  : BDI_DIRTIED =     797568 KB,
BDI_RECLAIMABLE =   18112 KB, bdi_dirty_limit =   36104 KB
[  146.574201] [1]:flush-8:16 : BDI_DIRTIED =     336576 KB,
BDI_RECLAIMABLE =   76416 KB, bdi_dirty_limit =   19796 KB
[  147.284058] [1]:flush-8:16 : BDI_DIRTIED =     346176 KB,
BDI_RECLAIMABLE =   86016 KB, bdi_dirty_limit =   18892 KB
[  149.589827] [2]:flush-8:0  : BDI_DIRTIED =     819904 KB,
BDI_RECLAIMABLE =   16768 KB, bdi_dirty_limit =   33584 KB
[  149.604891] [2]:flush-8:0  : BDI_DIRTIED =     820736 KB,
BDI_RECLAIMABLE =   17600 KB, bdi_dirty_limit =   33576 KB
[  149.867466] [2]:flush-8:0  : BDI_DIRTIED =     825344 KB,
BDI_RECLAIMABLE =   18112 KB, bdi_dirty_limit =   33876 KB
[  149.877809] [2]:flush-8:0  : BDI_DIRTIED =     825344 KB,
BDI_RECLAIMABLE =   18112 KB, bdi_dirty_limit =   33848 KB
[  152.115439] [2]:flush-8:0  : BDI_DIRTIED =     843584 KB,
BDI_RECLAIMABLE =   18176 KB, bdi_dirty_limit =   33704 KB
[  152.125781] [2]:flush-8:0  : BDI_DIRTIED =     843584 KB,
BDI_RECLAIMABLE =   18176 KB, bdi_dirty_limit =   33692 KB
[  153.339221] [2]:flush-8:0  : BDI_DIRTIED =     861824 KB,
BDI_RECLAIMABLE =   18176 KB, bdi_dirty_limit =   34540 KB
[  153.349732] [2]:flush-8:0  : BDI_DIRTIED =     861824 KB,
BDI_RECLAIMABLE =   18176 KB, bdi_dirty_limit =   34540 KB
[  155.404477] [2]:flush-8:0  : BDI_DIRTIED =     880064 KB,
BDI_RECLAIMABLE =   18176 KB, bdi_dirty_limit =   34528 KB
[  155.414933] [2]:flush-8:0  : BDI_DIRTIED =     880064 KB,
BDI_RECLAIMABLE =   18176 KB, bdi_dirty_limit =   34528 KB
[  158.695935] [2]:flush-8:0  : BDI_DIRTIED =     896512 KB,
BDI_RECLAIMABLE =   16384 KB, bdi_dirty_limit =   32540 KB
[  158.706260] [2]:flush-8:0  : BDI_DIRTIED =     896512 KB,
BDI_RECLAIMABLE =   16384 KB, bdi_dirty_limit =   32540 KB
[  161.719063] [2]:flush-8:0  : BDI_DIRTIED =     912896 KB,
BDI_RECLAIMABLE =   16320 KB, bdi_dirty_limit =   32368 KB
[  161.729534] [2]:flush-8:0  : BDI_DIRTIED =     912896 KB,
BDI_RECLAIMABLE =   16320 KB, bdi_dirty_limit =   32368 KB
[  164.056751] [1]:flush-8:16 : BDI_DIRTIED =     434048 KB,
BDI_RECLAIMABLE =   86656 KB, bdi_dirty_limit =   22952 KB
[  166.220028] [2]:flush-8:0  : BDI_DIRTIED =     929088 KB,
BDI_RECLAIMABLE =   16128 KB, bdi_dirty_limit =   30928 KB
[  166.230538] [2]:flush-8:0  : BDI_DIRTIED =     929088 KB,
BDI_RECLAIMABLE =   16128 KB, bdi_dirty_limit =   30928 KB
[  166.241768] [2]:flush-8:0  : BDI_DIRTIED =     929088 KB,
BDI_RECLAIMABLE =   16128 KB, bdi_dirty_limit =   30912 KB
[  168.417606] [2]:flush-8:0  : BDI_DIRTIED =     945280 KB,
BDI_RECLAIMABLE =   16256 KB, bdi_dirty_limit =   31044 KB
[  168.427966] [2]:flush-8:0  : BDI_DIRTIED =     945280 KB,
BDI_RECLAIMABLE =   16256 KB, bdi_dirty_limit =   31044 KB
[  171.461426] [2]:flush-8:0  : BDI_DIRTIED =     961472 KB,
BDI_RECLAIMABLE =   16128 KB, bdi_dirty_limit =   29900 KB
[  171.471806] [2]:flush-8:0  : BDI_DIRTIED =     961472 KB,
BDI_RECLAIMABLE =   16128 KB, bdi_dirty_limit =   29880 KB
[  174.109197] [2]:flush-8:0  : BDI_DIRTIED =     976768 KB,
BDI_RECLAIMABLE =   15168 KB, bdi_dirty_limit =   29808 KB
[  174.119557] [2]:flush-8:0  : BDI_DIRTIED =     976768 KB,
BDI_RECLAIMABLE =   15168 KB, bdi_dirty_limit =   29792 KB
[  177.967806] [2]:flush-8:0  : BDI_DIRTIED =     991552 KB,
BDI_RECLAIMABLE =   14784 KB, bdi_dirty_limit =   28540 KB
[  177.978373] [2]:flush-8:0  : BDI_DIRTIED =     991552 KB,
BDI_RECLAIMABLE =   14784 KB, bdi_dirty_limit =   28544 KB
[  180.922946] [1]:flush-8:16 : BDI_DIRTIED =     518976 KB,
BDI_RECLAIMABLE =   84864 KB, bdi_dirty_limit =   26508 KB
[  180.933314] [1]:flush-8:16 : BDI_DIRTIED =     518976 KB,
BDI_RECLAIMABLE =   84864 KB, bdi_dirty_limit =   26508 KB

                   ^ Max FLASH BDI dirty limit during parallel write
on USB FLASH and HDD
[  182.799533] [2]:flush-8:0  : BDI_DIRTIED =    1006528 KB,
BDI_RECLAIMABLE =   14912 KB, bdi_dirty_limit =   28460 KB
[  182.809937] [2]:flush-8:0  : BDI_DIRTIED =    1006528 KB,
BDI_RECLAIMABLE =   14912 KB, bdi_dirty_limit =   28460 KB
[  185.829707] [2]:flush-8:0  : BDI_DIRTIED =    1020352 KB,
BDI_RECLAIMABLE =   13824 KB, bdi_dirty_limit =   27788 KB
[  185.852849] [2]:flush-8:0  : BDI_DIRTIED =    1021120 KB,
BDI_RECLAIMABLE =   14592 KB, bdi_dirty_limit =   27760 KB
[  190.442186] [2]:flush-8:0  : BDI_DIRTIED =    1045824 KB,
BDI_RECLAIMABLE =   14464 KB, bdi_dirty_limit =   28316 KB
[  190.452755] [2]:flush-8:0  : BDI_DIRTIED =    1045824 KB,
BDI_RECLAIMABLE =   14464 KB, bdi_dirty_limit =   28320 KB
[  193.282394] [2]:flush-8:0  : BDI_DIRTIED =    1060288 KB,
BDI_RECLAIMABLE =   14400 KB, bdi_dirty_limit =   28052 KB
[  193.292821] [2]:flush-8:0  : BDI_DIRTIED =    1060288 KB,
BDI_RECLAIMABLE =   14400 KB, bdi_dirty_limit =   28052 KB
[  193.849873] [2]:flush-8:0  : BDI_DIRTIED =    1074880 KB,
BDI_RECLAIMABLE =   14592 KB, bdi_dirty_limit =   29168 KB
[  193.860446] [2]:flush-8:0  : BDI_DIRTIED =    1074880 KB,
BDI_RECLAIMABLE =   14592 KB, bdi_dirty_limit =   29168 KB
[  194.456956] [2]:flush-8:0  : BDI_DIRTIED =    1091264 KB,
BDI_RECLAIMABLE =   16384 KB, bdi_dirty_limit =   30524 KB
[  194.470853] [2]:flush-8:0  : BDI_DIRTIED =    1092480 KB,
BDI_RECLAIMABLE =   17536 KB, bdi_dirty_limit =   30528 KB
[  195.117999] [2]:flush-8:0  : BDI_DIRTIED =    1111232 KB,
BDI_RECLAIMABLE =   16832 KB, bdi_dirty_limit =   32060 KB
[  195.128626] [2]:flush-8:0  : BDI_DIRTIED =    1111232 KB,
BDI_RECLAIMABLE =   16832 KB, bdi_dirty_limit =   32052 KB
[  195.582384] [2]:flush-8:0  : BDI_DIRTIED =    1129088 KB,
BDI_RECLAIMABLE =   16832 KB, bdi_dirty_limit =   33404 KB
[  195.593001] [2]:flush-8:0  : BDI_DIRTIED =    1129088 KB,
BDI_RECLAIMABLE =   16832 KB, bdi_dirty_limit =   33424 KB
[  198.305291] [1]:flush-8:16 : BDI_DIRTIED =     596928 KB,
BDI_RECLAIMABLE =   78016 KB, bdi_dirty_limit =   19580 KB
[  199.022989] [2]:flush-8:0  : BDI_DIRTIED =    1163904 KB,
BDI_RECLAIMABLE =   18240 KB, bdi_dirty_limit =   35628 KB
[  199.033513] [2]:flush-8:0  : BDI_DIRTIED =    1163904 KB,
BDI_RECLAIMABLE =   18240 KB, bdi_dirty_limit =   35628 KB
[  204.688042] [2]:flush-8:0  : BDI_DIRTIED =    1196800 KB,
BDI_RECLAIMABLE =   18240 KB, bdi_dirty_limit =   34556 KB
[  204.698595] [2]:flush-8:0  : BDI_DIRTIED =    1196800 KB,
BDI_RECLAIMABLE =   18240 KB, bdi_dirty_limit =   34524 KB
[  206.925717] [2]:flush-8:0  : BDI_DIRTIED =    1213888 KB,
BDI_RECLAIMABLE =   17088 KB, bdi_dirty_limit =   34332 KB
[  206.936049] [2]:flush-8:0  : BDI_DIRTIED =    1213888 KB,
BDI_RECLAIMABLE =   17088 KB, bdi_dirty_limit =   34332 KB
[  209.405238] [2]:flush-8:0  : BDI_DIRTIED =    1232320 KB,
BDI_RECLAIMABLE =   18368 KB, bdi_dirty_limit =   33764 KB
[  209.415601] [2]:flush-8:0  : BDI_DIRTIED =    1232320 KB,
BDI_RECLAIMABLE =   18368 KB, bdi_dirty_limit =   33744 KB
[  212.195798] [2]:flush-8:0  : BDI_DIRTIED =    1249216 KB,
BDI_RECLAIMABLE =   16896 KB, bdi_dirty_limit =   33256 KB
[  212.209552] [2]:flush-8:0  : BDI_DIRTIED =    1249536 KB,
BDI_RECLAIMABLE =   17152 KB, bdi_dirty_limit =   33240 KB
[  213.773098] [1]:flush-8:16 : BDI_DIRTIED =     680320 KB,
BDI_RECLAIMABLE =   83392 KB, bdi_dirty_limit =   22124 KB
[  213.783536] [1]:flush-8:16 : BDI_DIRTIED =     680320 KB,
BDI_RECLAIMABLE =   83392 KB, bdi_dirty_limit =   22124 KB
[  214.675144] [2]:flush-8:0  : BDI_DIRTIED =    1267776 KB,
BDI_RECLAIMABLE =   16704 KB, bdi_dirty_limit =   33116 KB
[  214.685498] [2]:flush-8:0  : BDI_DIRTIED =    1267776 KB,
BDI_RECLAIMABLE =   16704 KB, bdi_dirty_limit =   33128 KB
[  218.501301] [2]:flush-8:0  : BDI_DIRTIED =    1284224 KB,
BDI_RECLAIMABLE =   16384 KB, bdi_dirty_limit =   32932 KB
[  218.511646] [2]:flush-8:0  : BDI_DIRTIED =    1284224 KB,
BDI_RECLAIMABLE =   16384 KB, bdi_dirty_limit =   32904 KB
[  219.339245] [2]:flush-8:0  : BDI_DIRTIED =    1302272 KB,
BDI_RECLAIMABLE =   18048 KB, bdi_dirty_limit =   34132 KB
[  219.352808] [2]:flush-8:0  : BDI_DIRTIED =    1303168 KB,
BDI_RECLAIMABLE =   18944 KB, bdi_dirty_limit =   34104 KB
[  220.050747] [2]:flush-8:0  : BDI_DIRTIED =    1322368 KB,
BDI_RECLAIMABLE =   18240 KB, bdi_dirty_limit =   35176 KB
[  220.064885] [2]:flush-8:0  : BDI_DIRTIED =    1323264 KB,
BDI_RECLAIMABLE =   19136 KB, bdi_dirty_limit =   35188 KB
[  220.723480] [2]:flush-8:0  : BDI_DIRTIED =    1344256 KB,
BDI_RECLAIMABLE =   18944 KB, bdi_dirty_limit =   36832 KB
[  220.734171] [2]:flush-8:0  : BDI_DIRTIED =    1344256 KB,
BDI_RECLAIMABLE =   18944 KB, bdi_dirty_limit =   36832 KB
[  221.401320] [2]:flush-8:0  : BDI_DIRTIED =    1364352 KB,
BDI_RECLAIMABLE =   20032 KB, bdi_dirty_limit =   38000 KB
[  221.414822] [2]:flush-8:0  : BDI_DIRTIED =    1365440 KB,
BDI_RECLAIMABLE =   21184 KB, bdi_dirty_limit =   38000 KB
[  222.091724] [2]:flush-8:0  : BDI_DIRTIED =    1385792 KB,
BDI_RECLAIMABLE =   19584 KB, bdi_dirty_limit =   38760 KB
[  222.106450] [2]:flush-8:0  : BDI_DIRTIED =    1386048 KB,
BDI_RECLAIMABLE =   19840 KB, bdi_dirty_limit =   38740 KB
[  225.070245] [2]:flush-8:0  : BDI_DIRTIED =    1443328 KB,
BDI_RECLAIMABLE =   21248 KB, bdi_dirty_limit =   41072 KB
[  225.082125] [2]:flush-8:0  : BDI_DIRTIED =    1443328 KB,
BDI_RECLAIMABLE =   21248 KB, bdi_dirty_limit =   41044 KB
[  225.814516] [2]:flush-8:0  : BDI_DIRTIED =    1456128 KB,
BDI_RECLAIMABLE =   21760 KB, bdi_dirty_limit =   41092 KB
[  225.825050] [2]:flush-8:0  : BDI_DIRTIED =    1456128 KB,
BDI_RECLAIMABLE =   21760 KB, bdi_dirty_limit =   41076 KB
[  225.835457] [2]:flush-8:0  : BDI_DIRTIED =    1456128 KB,
BDI_RECLAIMABLE =   21760 KB, bdi_dirty_limit =   41080 KB
[  227.177970] [2]:flush-8:0  : BDI_DIRTIED =    1478272 KB,
BDI_RECLAIMABLE =   22080 KB, bdi_dirty_limit =   41208 KB
[  227.188482] [2]:flush-8:0  : BDI_DIRTIED =    1478272 KB,
BDI_RECLAIMABLE =   22080 KB, bdi_dirty_limit =   41208 KB
[  231.043363] [2]:flush-8:0  : BDI_DIRTIED =    1510528 KB,
BDI_RECLAIMABLE =   19456 KB, bdi_dirty_limit =   39068 KB
[  231.054717] [2]:flush-8:0  : BDI_DIRTIED =    1510528 KB,
BDI_RECLAIMABLE =   19456 KB, bdi_dirty_limit =   39076 KB
[  231.344643] [1]:flush-8:16 : BDI_DIRTIED =     757312 KB,
BDI_RECLAIMABLE =   76928 KB, bdi_dirty_limit =   16704 KB
[  231.494398] [2]:flush-8:0  : BDI_DIRTIED =    1519616 KB,
BDI_RECLAIMABLE =   20480 KB, bdi_dirty_limit =   39264 KB
[  231.505586] [2]:flush-8:0  : BDI_DIRTIED =    1519616 KB,
BDI_RECLAIMABLE =   20480 KB, bdi_dirty_limit =   39260 KB
[  234.975996] [2]:flush-8:0  : BDI_DIRTIED =    1561024 KB,
BDI_RECLAIMABLE =   20096 KB, bdi_dirty_limit =   39032 KB
[  234.987831] [2]:flush-8:0  : BDI_DIRTIED =    1561024 KB,
BDI_RECLAIMABLE =   20096 KB, bdi_dirty_limit =   39036 KB
[  235.468408] [2]:flush-8:0  : BDI_DIRTIED =    1570176 KB,
BDI_RECLAIMABLE =   20992 KB, bdi_dirty_limit =   39212 KB
[  235.480320] [2]:flush-8:0  : BDI_DIRTIED =    1570176 KB,
BDI_RECLAIMABLE =   20992 KB, bdi_dirty_limit =   39204 KB
[  240.183116] [2]:flush-8:0  : BDI_DIRTIED =    1606336 KB,
BDI_RECLAIMABLE =   19712 KB, bdi_dirty_limit =   37944 KB
[  240.194988] [2]:flush-8:0  : BDI_DIRTIED =    1606336 KB,
BDI_RECLAIMABLE =   19712 KB, bdi_dirty_limit =   37932 KB
[  242.622183] [2]:flush-8:0  : BDI_DIRTIED =    1626368 KB,
BDI_RECLAIMABLE =   20096 KB, bdi_dirty_limit =   37244 KB
[  242.632629] [2]:flush-8:0  : BDI_DIRTIED =    1626368 KB,
BDI_RECLAIMABLE =   20096 KB, bdi_dirty_limit =   37244 KB
[  243.988458] [2]:flush-8:0  : BDI_DIRTIED =    1662848 KB,
BDI_RECLAIMABLE =   19584 KB, bdi_dirty_limit =   38784 KB
[  244.002712] [2]:flush-8:0  : BDI_DIRTIED =    1663936 KB,
BDI_RECLAIMABLE =   20672 KB, bdi_dirty_limit =   38760 KB
[  244.307739] [2]:flush-8:0  : BDI_DIRTIED =    1672000 KB,
BDI_RECLAIMABLE =   20608 KB, bdi_dirty_limit =   39248 KB
[  244.322895] [2]:flush-8:0  : BDI_DIRTIED =    1673152 KB,
BDI_RECLAIMABLE =   21696 KB, bdi_dirty_limit =   39244 KB
[  245.009029] [2]:flush-8:0  : BDI_DIRTIED =    1695680 KB,
BDI_RECLAIMABLE =   20352 KB, bdi_dirty_limit =   40196 KB
[  245.023455] [2]:flush-8:0  : BDI_DIRTIED =    1696960 KB,
BDI_RECLAIMABLE =   21632 KB, bdi_dirty_limit =   40196 KB
[  246.891877] [1]:flush-8:16 : BDI_DIRTIED =     819200 KB,
BDI_RECLAIMABLE =   61888 KB, bdi_dirty_limit =   14336 KB
[  247.095847] [1]:flush-8:16 : BDI_DIRTIED =     819200 KB,
BDI_RECLAIMABLE =   61888 KB, bdi_dirty_limit =   14592 KB
[  247.255127] [2]:flush-8:0  : BDI_DIRTIED =    1719808 KB,
BDI_RECLAIMABLE =   20480 KB, bdi_dirty_limit =   41132 KB
[  247.269750] [2]:flush-8:0  : BDI_DIRTIED =    1720192 KB,
BDI_RECLAIMABLE =   20864 KB, bdi_dirty_limit =   41124 KB
[  248.087937] [2]:flush-8:0  : BDI_DIRTIED =    1741056 KB,
BDI_RECLAIMABLE =   20736 KB, bdi_dirty_limit =   41624 KB
[  248.098499] [2]:flush-8:0  : BDI_DIRTIED =    1741056 KB,
BDI_RECLAIMABLE =   20736 KB, bdi_dirty_limit =   41624 KB
800+0 records in
800+0 records out
838860800 bytes (800.0MB) copied, 152.778511 seconds, 5.2MB/s   ->
'dd' finished for USB flash

[  251.958577] [2]:flush-8:0  : BDI_DIRTIED =    1846656 KB,
BDI_RECLAIMABLE =   22400 KB, bdi_dirty_limit =   45012 KB
[  251.973748] [2]:flush-8:0  : BDI_DIRTIED =    1846976 KB,
BDI_RECLAIMABLE =   22720 KB, bdi_dirty_limit =   45024 KB
[  252.520107] [2]:flush-8:0  : BDI_DIRTIED =    1871360 KB,
BDI_RECLAIMABLE =   22464 KB, bdi_dirty_limit =   45136 KB
[  252.534412] [2]:flush-8:0  : BDI_DIRTIED =    1871744 KB,
BDI_RECLAIMABLE =   22784 KB, bdi_dirty_limit =   45120 KB
[  252.548297] [2]:flush-8:0  : BDI_DIRTIED =    1872256 KB,
BDI_RECLAIMABLE =   23360 KB, bdi_dirty_limit =   45120 KB
[  257.032160] [2]:flush-8:0  : BDI_DIRTIED =    2001536 KB,
BDI_RECLAIMABLE =   43712 KB, bdi_dirty_limit =   45680 KB
[  257.046248] [2]:flush-8:0  : BDI_DIRTIED =    2001856 KB,
BDI_RECLAIMABLE =   44032 KB, bdi_dirty_limit =   45652 KB


 ^^^^^^^^^^^^^
After USB flash write is finished, HDD takes over completely and its
BDI dirty limit is increased.

2000+0 records in
2000+0 records out
2097152000 bytes (2.0GB) copied, 161.683544 seconds, 12.4MB/s

>
>> This continuous failure to start write-back for HDD actually results
>> in lowering the bdi_dirty_limit for HDD, in a way PAUSING the writer
>> thread for HDD.
>> This is actually resulting in less number of WRITE operations per
>> second for HDD. As, the ‘dd’ on USB HDD will be put to long sleep(MAX
>> PAUSE) in balance_dirty_pages.
>>
>> While for USB Flash, its bdi_dirty_limit is kept on increasing as it
>> is getting more chance to flush dirty data in over_bground_thresh. As,
>> bdi_reclaimable > bdi_dirty_limit is true. So, resulting more number
>> of WRITE operation per second for USB Flash.
>> From these observations, we feel that these changes might not be
>> needed. Please let us know in case we are missing on any point here,
>> we can further check more on this.
>   Well, at least we know changing the condition has unexpected side
> effects. I'd like to understand those before discarding the idea - because
> in your setup flusher thread must end up writing rather small amount of
> pages in each run when it's running continuously and that's not too good
> either...
Yes, we were also surprised about drop in write speed with this change.
we are keen to check more on this, pls let us know if you need any
other information.

>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
