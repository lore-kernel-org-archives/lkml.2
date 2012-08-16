Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab2HPWDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:03:06 -0400
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3234 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2HPWDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:03:04 -0400
X-Greylist: delayed 773 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2012 18:03:03 EDT
Message-ID: <502D6B0A.6090508@xs4all.net>
Date: Thu, 16 Aug 2012 23:50:02 +0200
From: Miquel van Smoorenburg <mikevs@xs4all.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: stan@hardwarefreak.com
CC: linux-kernel@vger.kernel.org
Subject: Re: O_DIRECT to md raid 6 is slow
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl> <502CD3F8.70001@hardwarefreak.com>
In-Reply-To: <502CD3F8.70001@hardwarefreak.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-08-12 1:05 PM, Stan Hoeppner wrote:
> On 8/15/2012 6:07 PM, Miquel van Smoorenburg wrote:
>> Ehrm no. If you modify, say, a 4K block on a RAID5 array, you just have
>> to read that 4K block, and the corresponding 4K block on the
>> parity drive, recalculate parity, and write back 4K of data and 4K
>> of parity. (read|read) modify (write|write). You do not have to
>> do I/O in chunksize, ehm, chunks, and you do not have to rmw all disks.
>
> See:  http://www.spinics.net/lists/xfs/msg12627.html
>
> Dave usually knows what he's talking about, and I didn't see Neil nor
> anyone else correcting him on his description of md RMW behavior.

Well he's wrong, or you're interpreting it incorrectly.

I did a simple test:

* created a 1G partition on 3 seperate disks
* created a md raid5 array with 512K chunksize:
   mdadm -C /dev/md0 -l 5 -c $((1024*512)) -n 3 /dev/sdb1 /dev/sdc1 
/dev/sdd1
* ran disk monitoring using 'iostat -k 5 /dev/sdb1 /dev/sdc1 /dev/sdd1'
* wrote a single 4K block:
   dd if=/dev/zero bs=4K count=1 oflag=direct seek=30 of=/dev/md0

Output from iostat over the period in which the 4K write was done. Look 
at kB read and kB written:

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sdb1              0.60         0.00         1.60          0          8
sdc1              0.60         0.80         0.80          4          4
sdd1              0.60         0.00         1.60          0          8

As you can see, a single 4K read, and a few writes. You see a few blocks 
more written that you'd expect because the superblock is updated too.

Mike.
