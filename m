Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab2HQLQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:16:45 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2716 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2HQLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:16:44 -0400
Message-ID: <502E2817.8040306@xs4all.net>
Date: Fri, 17 Aug 2012 13:16:39 +0200
From: Miquel van Smoorenburg <mikevs@xs4all.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: stan@hardwarefreak.com
CC: linux-kernel@vger.kernel.org
Subject: Re: O_DIRECT to md raid 6 is slow
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl> <502CD3F8.70001@hardwarefreak.com> <502D6B0A.6090508@xs4all.net> <502DF357.8090205@hardwarefreak.com>
In-Reply-To: <502DF357.8090205@hardwarefreak.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 09:31 AM, Stan Hoeppner wrote:
> On 8/16/2012 4:50 PM, Miquel van Smoorenburg wrote:
>> I did a simple test:
>>
>> * created a 1G partition on 3 seperate disks
>> * created a md raid5 array with 512K chunksize:
>>    mdadm -C /dev/md0 -l 5 -c $((1024*512)) -n 3 /dev/sdb1 /dev/sdc1
>> /dev/sdd1
>> * ran disk monitoring using 'iostat -k 5 /dev/sdb1 /dev/sdc1 /dev/sdd1'
>> * wrote a single 4K block:
>>    dd if=/dev/zero bs=4K count=1 oflag=direct seek=30 of=/dev/md0
>>
>> Output from iostat over the period in which the 4K write was done. Look
>> at kB read and kB written:
>>
>> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
>> sdb1              0.60         0.00         1.60          0          8
>> sdc1              0.60         0.80         0.80          4          4
>> sdd1              0.60         0.00         1.60          0          8
>>
>> As you can see, a single 4K read, and a few writes. You see a few blocks
>> more written that you'd expect because the superblock is updated too.
>
> I'm no dd expert, but this looks like you're simply writing a 4KB block
> to a new stripe, using an offset, but not to an existing stripe, as the
> array is in a virgin state.  So it doesn't appear this test is going to
> trigger RMW.  Don't you need now need to do another write in the same
> stripe to to trigger RMW?  Maybe I'm just reading this wrong.

That shouldn't matter, but that is easily checked ofcourse, by writing 
some random random data first, then doing the dd 4K write also with 
random data somewhere in the same area:

# dd if=/dev/urandom bs=1M count=3 of=/dev/md0
3+0 records in
3+0 records out
3145728 bytes (3.1 MB) copied, 0.794494 s, 4.0 MB/s

Now the first 6 chunks are filled with random data, let write 4K 
somewhere in there:

# dd if=/dev/urandom bs=4k count=1 seek=25 of=/dev/md0
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 0.10149 s, 40.4 kB/s

Output from iostat over the period in which the 4K write was done:

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sdb1              0.60         0.00         1.60          0          8
sdc1              0.60         0.80         0.80          4          4
sdd1              0.60         0.00         1.60          0          8

Mike.
