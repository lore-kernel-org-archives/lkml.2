Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2DOKBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 06:01:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46561 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2DOKAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 06:00:44 -0400
MIME-Version: 1.0
In-Reply-To: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
Date: Sun, 15 Apr 2012 15:30:43 +0530
Message-ID: <CADUNaniCUmojcwA+LRf7yke730oqJt8u_Q_22Qk7eQ-z7h4U1A@mail.gmail.com>
Subject: Re: [NEW]: Introducing shrink_all_memory from user space
From: santosh <santosh.iitg@gmail.com>
To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please post your code here ?


--Santosh

On Sun, Apr 15, 2012 at 3:17 PM, PINTU KUMAR <pintu_agarwal@yahoo.com> wrote:
> Dear All,
>
> This is regarding a small proposal for shrink_all_memory( ) function which is found in mm/vmscan.c.
> For those who are not aware, this function helps in reclaiming specified amount of physical memory and returns number of freed pages.
>
> Currently this function is under CONFIG_HIBERNATION flag, so cannot be used by others without enabling hibernation.
> Moreover this function is not exported to the outside world, so no driver can use it directly without including EXPORT_SYMBOL(shrink_all_memory) and recompiling the kernel.
> The purpose of using it under hibernation(kernel/power/snapshot.c) is to regain enough physical pages to create hibernation image.
>
> The same can be useful for some drivers who wants to allocate large contiguous memory (in MBs) but his/her system is in very bad state and could not do so without rebooting.
> Due to this bad state of the system the user space application will be badly hurt on performance, and there could be a need to quickly reclaim all physical memory from user space.
> This could be very helpful for small embedded products and smart phones where rebooting is never a preferred choice.
>
> With this support in kernel, a small utility can be developed in user space which user can run and reclaim as many physical pages and noticed that his system performance is increased without rebooting.
>
> To make this work, I have performed a sample experiment on my ubuntu(10.x) machine running with kernel-3.3.0.
>
> Also I performed the similar experiment of one of our Samsung smart phones as well.
>
> Following are the results from Ubuntu:
>
> 1) I downloaded kernel3.3.0 and made the respective changes in mm/vmscan.c. That is added EXPORT_SYMBOL(shrink_all_memory) under the function shrink_all_memory( ).
>     (Note: CONFIG_HIBERNATION was already enabled for my system.)
>
> 2) Then I build the kernel and installed it on my Ubuntu PC.
>
> 3) After that I have developed a small kernel module (miscdevice: /dev/shrinkmem) to call shrink_all_memory( ) under my driver write( ) function.
>
> 4) Then from user space I just need to do this:
>
>     # echo 100 > /dev/shrinkmem   (To reclaim 100MB of physical memory without reboot)
>
>
> The results that were obtained with this experiment is as follows:
>
> 1) At some point of time, the buddyinfo and free pages on my Ubuntu were as follows:
> root@pintu-ubuntu:~/PintuHomeTest/KERNEL_ORG# cat /proc/buddyinfo ; free -tmNode 0, zone      DMA    468     23      0      0      0      0      0      0      0      0      0
> Node 0, zone   Normal    898    161     38      8      0      0      0      0      0      0      0
>                  total       used       free     shared    buffers     cached
> Mem:           497        489          7          0         37        405
> -/+ buffers/cache:         47        449
> Swap:         1458        158       1300
> Total:        1956        648       1308
>
>
> 2) After doing "echo 100 > /dev/shrinkmem" :
> [19653.833916] [SHRINKMEM]: memsize(in MB) = 100
> [19653.863618] <SHRINKMEM>: Number of Pages Freed: 26756
> [19653.863664] [SHRINKMEM] : Device is Closed....
>
> Node 0, zone      DMA    411    166     51      5      0      0      0      0      0      0      0
> Node 0, zone   Normal   2915   3792   2475   1335    730     23      0      0      0      0      0
>                  total       used       free     shared    buffers     cached
> Mem:           497        323        173          0         37        238
> -/+ buffers/cache:         47        449
> Swap:         1458        158       1300
> Total:        1956        481       1474
>
>
> 3) After running again with : echo 512 > /dev/shrinkmem
> [21961.064534] [SHRINKMEM]: memsize(in MB) = 512
> [21961.109497] <SHRINKMEM>: Number of Pages Freed: 61078
> [21961.109562] [SHRINKMEM] : Device is Closed....
> Node 0, zone      DMA    116     99     87     58     16      6      1      0      0      0      0
> Node 0, zone   Normal   6697   6939   5529   3756   1442    203     17      0      0      0      0
>                  total       used       free     shared    buffers     cached
> Mem:           497         87        410          0         37          9
> -/+ buffers/cache:         40        456
> Swap:         1458        158       1300
> Total:        1956        245       1711
>
>
> 4) Thus in both the cases huge number of free pages were reclaimed.
>
> 5) After running this on my system, the performance was improved quickly.
>
> 6) I performed the same experiment on our Samsung Smart phones as well. And I have seen a drastic improve in performance after running this for 3/4 times.
>     In case of phones it is more helpful as there is no swap space.
>
> 7) Your feedback and suggestion is important. Based on the feedback, I can plan to submit the patches officially after performing basic cleanups.
>
>
> Future Work
> ==========
> Our final goal is to use it during lowmem notifier where shrink_all_memory will be called automatically in background if the memory pressure falls below certain limit defined by the system.
> For example we can measure the percentage memory fragmentation level of the system across each zone and if the fragmentation percentage goes above say 80-85% during lowmem notifier, we can invoke shrink_all_memory() in background.
>
> This can be used by some application which requires large mmap or shared memory mapping.
>
> This can be even using inside the multimedia drivers that requires large contiguous memory to check if that many memory pages can be reclaimed or not.
>
>
> Please provide your valuable feedback and suggestion.
>
>
> Thank you very much !
>
>
> With Regards,
> Pintu Kumar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
