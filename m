Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2G1GfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 02:35:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57834 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2G1GfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 02:35:04 -0400
Message-ID: <50138834.5090907@gmail.com>
Date: Sat, 28 Jul 2012 08:35:32 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: Asias He <asias@redhat.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH V4 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <1343442065-15646-1-git-send-email-asias@redhat.com> <1343442065-15646-4-git-send-email-asias@redhat.com>
In-Reply-To: <1343442065-15646-4-git-send-email-asias@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2012 04:21 AM, Asias He wrote:
> This patch introduces bio-based IO path for virtio-blk.
> 
> Compared to request-based IO path, bio-based IO path uses driver
> provided ->make_request_fn() method to bypasses the IO scheduler. It
> handles the bio to device directly without allocating a request in block
> layer. This reduces the IO path in guest kernel to achieve high IOPS
> and lower latency. The downside is that guest can not use the IO
> scheduler to merge and sort requests. However, this is not a big problem
> if the backend disk in host side uses faster disk device.
> 
> When the bio-based IO path is not enabled, virtio-blk still uses the
> original request-based IO path, no performance difference is observed.
> 
> Performance evaluation:
> -----------------------------
> 1) Fio test is performed in a 8 vcpu guest with ramdisk based guest using
> kvm tool.
> 
> Short version:
>  With bio-based IO path, sequential read/write, random read/write
>  IOPS boost         : 28%, 24%, 21%, 16%
>  Latency improvement: 32%, 17%, 21%, 16%
> 
> Long version:
>  With bio-based IO path:
>   seq-read  : io=2048.0MB, bw=116996KB/s, iops=233991 , runt= 17925msec
>   seq-write : io=2048.0MB, bw=100829KB/s, iops=201658 , runt= 20799msec
>   rand-read : io=3095.7MB, bw=112134KB/s, iops=224268 , runt= 28269msec
>   rand-write: io=3095.7MB, bw=96198KB/s,  iops=192396 , runt= 32952msec
>     clat (usec): min=0 , max=2631.6K, avg=58716.99, stdev=191377.30
>     clat (usec): min=0 , max=1753.2K, avg=66423.25, stdev=81774.35
>     clat (usec): min=0 , max=2915.5K, avg=61685.70, stdev=120598.39
>     clat (usec): min=0 , max=1933.4K, avg=76935.12, stdev=96603.45
>   cpu : usr=74.08%, sys=703.84%, ctx=29661403, majf=21354, minf=22460954
>   cpu : usr=70.92%, sys=702.81%, ctx=77219828, majf=13980, minf=27713137
>   cpu : usr=72.23%, sys=695.37%, ctx=88081059, majf=18475, minf=28177648
>   cpu : usr=69.69%, sys=654.13%, ctx=145476035, majf=15867, minf=26176375
>  With request-based IO path:
>   seq-read  : io=2048.0MB, bw=91074KB/s, iops=182147 , runt= 23027msec
>   seq-write : io=2048.0MB, bw=80725KB/s, iops=161449 , runt= 25979msec
>   rand-read : io=3095.7MB, bw=92106KB/s, iops=184211 , runt= 34416msec
>   rand-write: io=3095.7MB, bw=82815KB/s, iops=165630 , runt= 38277msec
>     clat (usec): min=0 , max=1932.4K, avg=77824.17, stdev=170339.49
>     clat (usec): min=0 , max=2510.2K, avg=78023.96, stdev=146949.15
>     clat (usec): min=0 , max=3037.2K, avg=74746.53, stdev=128498.27
>     clat (usec): min=0 , max=1363.4K, avg=89830.75, stdev=114279.68
>   cpu : usr=53.28%, sys=724.19%, ctx=37988895, majf=17531, minf=23577622
>   cpu : usr=49.03%, sys=633.20%, ctx=205935380, majf=18197, minf=27288959
>   cpu : usr=55.78%, sys=722.40%, ctx=101525058, majf=19273, minf=28067082
>   cpu : usr=56.55%, sys=690.83%, ctx=228205022, majf=18039, minf=26551985
> 
> 2) Fio test is performed in a 8 vcpu guest with Fusion-IO based guest using
> kvm tool.
> 
> Short version:
>  With bio-based IO path, sequential read/write, random read/write
>  IOPS boost         : 11%, 11%, 13%, 10%
>  Latency improvement: 10%, 10%, 12%, 10%
> Long Version:
>  With bio-based IO path:
>   read : io=2048.0MB, bw=58920KB/s, iops=117840 , runt= 35593msec
>   write: io=2048.0MB, bw=64308KB/s, iops=128616 , runt= 32611msec
>   read : io=3095.7MB, bw=59633KB/s, iops=119266 , runt= 53157msec
>   write: io=3095.7MB, bw=62993KB/s, iops=125985 , runt= 50322msec
>     clat (usec): min=0 , max=1284.3K, avg=128109.01, stdev=71513.29
>     clat (usec): min=94 , max=962339 , avg=116832.95, stdev=65836.80
>     clat (usec): min=0 , max=1846.6K, avg=128509.99, stdev=89575.07
>     clat (usec): min=0 , max=2256.4K, avg=121361.84, stdev=82747.25
>   cpu : usr=56.79%, sys=421.70%, ctx=147335118, majf=21080, minf=19852517
>   cpu : usr=61.81%, sys=455.53%, ctx=143269950, majf=16027, minf=24800604
>   cpu : usr=63.10%, sys=455.38%, ctx=178373538, majf=16958, minf=24822612
>   cpu : usr=62.04%, sys=453.58%, ctx=226902362, majf=16089, minf=23278105
>  With request-based IO path:
>   read : io=2048.0MB, bw=52896KB/s, iops=105791 , runt= 39647msec
>   write: io=2048.0MB, bw=57856KB/s, iops=115711 , runt= 36248msec
>   read : io=3095.7MB, bw=52387KB/s, iops=104773 , runt= 60510msec
>   write: io=3095.7MB, bw=57310KB/s, iops=114619 , runt= 55312msec
>     clat (usec): min=0 , max=1532.6K, avg=142085.62, stdev=109196.84
>     clat (usec): min=0 , max=1487.4K, avg=129110.71, stdev=114973.64
>     clat (usec): min=0 , max=1388.6K, avg=145049.22, stdev=107232.55
>     clat (usec): min=0 , max=1465.9K, avg=133585.67, stdev=110322.95
>   cpu : usr=44.08%, sys=590.71%, ctx=451812322, majf=14841, minf=17648641
>   cpu : usr=48.73%, sys=610.78%, ctx=418953997, majf=22164, minf=26850689
>   cpu : usr=45.58%, sys=581.16%, ctx=714079216, majf=21497, minf=22558223
>   cpu : usr=48.40%, sys=599.65%, ctx=656089423, majf=16393, minf=23824409

What are the cases where we'll see a performance degradation with using the bio path? Could we measure performance for those as well?

> How to use:
> -----------------------------
> Add 'virtio_blk.use_bio=1' to kernel cmdline or 'modprobe virtio_blk
> use_bio=1' to enable ->make_request_fn() based I/O path.

If there are, in fact, no cases where performance is degraded, can use_bio=1 be the default?
