Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0IQWWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:22:42 -0400
Received: from lo.gmane.org ([80.91.229.12]:48803 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab0IQWWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:22:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Brett Russ <icycle+lkml@gmail.com>
Subject: Re: O_DIRECT reads appear to be cached on block device partition
 file?
Date: Fri, 17 Sep 2010 18:22:28 -0400
Message-ID: <i70pn6$otu$1@dough.gmane.org>
References: <i6mrcc$ers$1@dough.gmane.org> <20100914073643.GB15695@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 72.22.183.190
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
In-Reply-To: <20100914073643.GB15695@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Mon, Sep 13, 2010 at 11:49:32PM -0400, Brett Russ wrote:
>> If I run the above on the monitoring blade, then sync an update to
>> the sector in question from another blade, then re-reun the above
>> code on the monitoring blade, believe it or not I appear to be
>> reading stale data.  If I use dd with iflag=direct, reading the same
>> sector offset at the /dev/sdX3 partition file, I see the same stale
>> data as seen from the code above.  If, however, I instead access
>> this sector offset from the /dev/sdX device file using the (offset
>> of partition 3 + offset of the sector) I see the intended data,
>> which makes me believe some caching occurred locally for /dev/sdX3.
>
> What does blktrace tell you?

Thanks Dave for the pointer to blktrace.  I'd not used this before.

The short answer is that I now trust O_DIRECT.  The cause for me going 
down this path to begin with was caused by a stale cache in our application.

The longer answer of how my dd double-check could have gone wrong follows:

I've discovered that the start-of-partition LBA does not *always* agree 
between the kernel (reported by blktrace and sysfs) and utilities such 
as {fdisk|sfdisk}.  This means that my experiment of accessing the 
sector within the partition via the parent device may have been invalid, 
since I was trusting fdisk to determine the correct sector offset of the 
partition.

> spu0103# fdisk -l -u /dev/sdbk
...
> Units = sectors of 1 * 512 = 512 bytes
>
>     Device Boot      Start         End      Blocks  Id System
...
> /dev/sdbk3      1197742140  1944780704   373519282+ 83 Linux

> spu0103# sfdisk -uS -l /dev/sdbk
...
> Units = sectors of 512 bytes, counting from 0
>
>    Device Boot    Start       End   #sectors  Id  System
...
> /dev/sdbk3     1197742140 1944780704  747038565  83  Linux

> spu0103# cat /sys/block/sdbk/sdbk3/start
> 1197934920

The above discrepancy was also shown with blktrace:

> spu0103# blkparse -q 1
> Input file 1.blktrace.5 added
> Input file 1.blktrace.6 added
> Input file 1.blktrace.7 added
>

This command:

> spu0103# dd-7.1  if=/dev/sdbk3 bs=512 count=1 iflag=direct |hexdump -C

Produced this trace:

>  67,224  5        1     0.000000000 29726  A   R 1197934920 + 1 <- (67,227) 0

Note the kernel remapped the access to sdbk3 (offset 0) to sdbk (offset
1197934920) (see the major:minor numbers listed after the trace), which
is quite different from the partition start shown in fdisk of 1197742140.

>  67,224  5        2     0.000000564 29726  Q   R 1197934920 + 1 [dd-7.1]
>  67,224  5        3     0.000004032 29726  G   R 1197934920 + 1 [dd-7.1]
>  67,224  5        4     0.000006223 29726  P   N [dd-7.1]
>  67,224  5        5     0.000008152 29726  I   R 1197934920 + 1 [dd-7.1]
>  67,224  5        6     0.000009916 29726  U   N [dd-7.1] 1
>  67,224  5        7     0.000012286 29726  D   R 1197934920 + 1 [dd-7.1]
>  67,224  7        1     0.006802504     0  C   R 1197934920 + 1 [0]

And this command (accessing the start of partition using fdisk sector 
offset):

> spu0103# dd-7.1  if=/dev/sdbk skip=1197742140 bs=512 count=1 iflag=direct |hexdump -C

Produced this trace (as expected):

>  67,224  7        2    75.330506824 29924  Q   R 1197742140 + 1 [dd-7.1]
>  67,224  7        3    75.330509804 29924  G   R 1197742140 + 1 [dd-7.1]
>  67,224  7        4    75.330511985 29924  P   N [dd-7.1]
>  67,224  7        5    75.330513836 29924  I   R 1197742140 + 1 [dd-7.1]
>  67,224  7        6    75.330515495 29924  U   N [dd-7.1] 1
>  67,224  7        7    75.330517901 29924  D   R 1197742140 + 1 [dd-7.1]
>  67,224  6        1    75.340722638     0  C   R 1197742140 + 1 [0]

The aforementioned major/minor numbers:

> spu0103# ls -l /dev/|grep 67|grep '22[47]'
> brw-rw-rw-    1 root     root      67, 224 Sep 15 11:59 sdbk
> brw-rw-rw-    1 root     root      67, 227 Sep 15 11:59 sdbk3

*All* other drives in my system that I tested do show a match between 
the 3 methods above (fdisk, sfdisk, sysfs).

I don't know how this discrepancy with the partition start could have 
been introduced, but it is most likely a byproduct of my testing.

Thanks,
Brett

