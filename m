Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab0GMEaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 00:30:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab0GMEaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 00:30:01 -0400
Message-ID: <4C3BEBC4.6000902@redhat.com>
Date: Tue, 13 Jul 2010 07:29:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
In-Reply-To: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 08:24 AM, Giangiacomo Mariotti wrote:
> Hi, is it a known problem how much slow is Btrfs with kvm/qemu(meaning
> that the image kvm/qemu uses as the hd is on a partition formatted
> with Btrfs, not that the fs used by the hd inside the kvm environment
> is Btrfs, in fact inside kvm the / partition is formatted with ext3)?
> I haven't written down the exact numbers, because I forgot, but while
> I was trying to make it work, after I noticed how much longer than
> usual it was taking to just install the system, I took a look at iotop
> and it was reporting a write speed of the kvm process of approximately
> 3M/s, while the Btrfs kernel thread had an approximately write speed
> of 7K/s! Just formatting the partitions during the debian installation
> took minutes. When the actual installation of the distro started I had
> to stop it, because it was taking hours! The iotop results made me
> think that the problem could be Btrfs, but, to be sure that it wasn't
> instead a kvm/qemu problem, I cut/pasted the same virtual hd on an
> ext3 fs and started kvm with the same parameters as before. The
> installation of debian inside kvm this time went smoothly and fast,
> like normally it does. I've been using Btrfs for some time now and
> while it has never been a speed champion(and I guess it's not supposed
> to be one and I don't even really care that much about it), I've never
> had any noticeable performance problem before and it has always been
> quite stable. In this test case though, it seems to be doing very bad.
>
>    

Btrfs is very slow on sync writes:

$ fio --name=x --directory=/images --rw=randwrite --runtime=300 
--size=1G --filesize=1G --bs=4k --ioengine=psync --sync=1 --unlink=1
x: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=psync, iodepth=1
Starting 1 process
x: Laying out IO file(s) (1 file(s) / 1024MB)
Jobs: 1 (f=1): [w] [1.3% done] [0K/0K /s] [0/0 iops] [eta 06h:18m:45s]
x: (groupid=0, jobs=1): err= 0: pid=2086
   write: io=13,752KB, bw=46,927B/s, iops=11, runt=300078msec
     clat (msec): min=33, max=1,711, avg=87.26, stdev=60.00
     bw (KB/s) : min=    5, max=  105, per=103.79%, avg=46.70, stdev=15.86
   cpu          : usr=0.03%, sys=19.55%, ctx=47197, majf=0, minf=94
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued r/w: total=0/3438, short=0/0

      lat (msec): 50=3.40%, 100=75.63%, 250=19.14%, 500=1.40%, 750=0.35%
      lat (msec): 1000=0.06%, 2000=0.03%

Run status group 0 (all jobs):
   WRITE: io=13,752KB, aggrb=45KB/s, minb=46KB/s, maxb=46KB/s, 
mint=300078msec, maxt=300078msec

45KB/s, while 4-5MB/s traffic was actually going to the disk.  For every 
4KB that the the application writes, 400KB+ of metadata is written.

(It's actually worse, since it starts faster than the average and ends 
up slower than the average).

For kvm, you can try cache=writeback or cache=unsafe and get better 
performance (though still slower than ext*).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

