Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0GaR4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 13:56:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50575 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0GaRz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 13:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cMHKlLv/V5FlEQopYNBFMcP/jZQ2M/3WHIfCZdGQiuElp2sN2yR1nhqP9i1DiXiHMp
         VCTe0PyQKSs/ddpPrvsHe2bNckpQn6ogeFd67OE3JwhVfdGqy6zIl6xKmqAazYKb2+iY
         uT/F2GTR1tFD/METxVGPfZ9RSMFA2tqO2bVWA=
MIME-Version: 1.0
In-Reply-To: <20100731173328.GA21072@infradead.org>
References: <20100728071705.GA22964@localhost>
	<20100731161358.GA5147@localhost>
	<20100731173328.GA21072@infradead.org>
Date: Sat, 31 Jul 2010 20:55:57 +0300
X-Google-Sender-Auth: glecyYB5U-HIu0OMkZbSA6PoAW8
Message-ID: <AANLkTi=+muw_2jWq1QKsxp6A_fAtdhdns7MD_bKQo-72@mail.gmail.com>
Subject: Re: [PATCH] vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 8:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Aug 01, 2010 at 12:13:58AM +0800, Wu Fengguang wrote:
>> FYI I did some memory stress test and find there are much more order-1
>> (and higher) users than fork(). This means lots of running applications
>> may stall on direct reclaim.
>>
>> Basically all of these slab caches will do high order allocations:
>
> It looks much, much worse on my system.  Basically all inode structures,
> and also tons of frequently allocated xfs structures fall into this
> category,  None of them actually anywhere near the size of a page, which
> makes me wonder why we do such high order allocations:

Do you have CONFIG_SLUB enabled? It does high order allocations by
default for performance reasons.

> slabinfo - version: 2.1
> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
> nfsd4_stateowners      0      0    424   19    2 : tunables    0    0    0 : slabdata      0      0      0
> kvm_vcpu               0      0  10400    3    8 : tunables    0    0    0 : slabdata      0      0      0
> kmalloc_dma-512       32     32    512   16    2 : tunables    0    0    0 : slabdata      2      2      0
> mqueue_inode_cache     18     18    896   18    4 : tunables    0    0    0 : slabdata      1      1      0
> xfs_inode         279008 279008   1024   16    4 : tunables    0    0    0 : slabdata  17438  17438      0
> xfs_efi_item          44     44    360   22    2 : tunables    0    0    0 : slabdata      2      2      0
> xfs_efd_item          44     44    368   22    2 : tunables    0    0    0 : slabdata      2      2      0
> xfs_trans             40     40    800   20    4 : tunables    0    0    0 : slabdata      2      2      0
> xfs_da_state          32     32    488   16    2 : tunables    0    0    0 : slabdata      2      2      0
> nfs_inode_cache        0      0   1016   16    4 : tunables    0    0    0 : slabdata      0      0      0
> isofs_inode_cache      0      0    632   25    4 : tunables    0    0    0 : slabdata      0      0      0
> fat_inode_cache        0      0    664   12    2 : tunables    0    0    0 : slabdata      0      0      0
> hugetlbfs_inode_cache     14     14    584   14    2 : tunables    0    0    0 : slabdata      1      1      0
> ext4_inode_cache       0      0    968   16    4 : tunables    0    0    0 : slabdata      0      0      0
> ext2_inode_cache      21     21    776   21    4 : tunables    0    0    0 : slabdata      1      1      0
> ext3_inode_cache       0      0    800   20    4 : tunables    0    0    0 : slabdata      0      0      0
> rpc_inode_cache       19     19    832   19    4 : tunables    0    0    0 : slabdata      1      1      0
> UDP-Lite               0      0    768   21    4 : tunables    0    0    0 : slabdata      0      0      0
> ip_dst_cache         170    378    384   21    2 : tunables    0    0    0 : slabdata     18     18      0
> RAW                   63     63    768   21    4 : tunables    0    0    0 : slabdata      3      3      0
> UDP                   52     84    768   21    4 : tunables    0    0    0 : slabdata      4      4      0
> TCP                   60    100   1600   20    8 : tunables    0    0    0 : slabdata      5      5      0
> blkdev_queue          42     42   2216   14    8 : tunables    0    0    0 : slabdata      3      3      0
> sock_inode_cache     650    713    704   23    4 : tunables    0    0    0 : slabdata     31     31      0
> skbuff_fclone_cache     36     36    448   18    2 : tunables    0    0    0 : slabdata      2      2      0
> shmem_inode_cache   3620   3948    776   21    4 : tunables    0    0    0 : slabdata    188    188      0
> proc_inode_cache    1818   1875    632   25    4 : tunables    0    0    0 : slabdata     75     75      0
> bdev_cache            57     57    832   19    4 : tunables    0    0    0 : slabdata      3      3      0
> inode_cache         7934   7938    584   14    2 : tunables    0    0    0 : slabdata    567    567      0
> files_cache          689    713    704   23    4 : tunables    0    0    0 : slabdata     31     31      0
> signal_cache         301    342    896   18    4 : tunables    0    0    0 : slabdata     19     19      0
> sighand_cache        192    210   2112   15    8 : tunables    0    0    0 : slabdata     14     14      0
> task_struct          311    325   5616    5    8 : tunables    0    0    0 : slabdata     65     65      0
> idr_layer_cache      578    585    544   15    2 : tunables    0    0    0 : slabdata     39     39      0
> radix_tree_node    74738  74802    560   14    2 : tunables    0    0    0 : slabdata   5343   5343      0
> kmalloc-8192          29     32   8192    4    8 : tunables    0    0    0 : slabdata      8      8      0
> kmalloc-4096         194    208   4096    8    8 : tunables    0    0    0 : slabdata     26     26      0
> kmalloc-2048         310    352   2048   16    8 : tunables    0    0    0 : slabdata     22     22      0
> kmalloc-1024        1607   1616   1024   16    4 : tunables    0    0    0 : slabdata    101    101      0
> kmalloc-512          484    512    512   16    2 : tunables    0    0    0 : slabdata     32     32      0
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
