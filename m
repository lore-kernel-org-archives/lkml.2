Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2A2JiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 04:38:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:54872 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2A2JiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 04:38:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100806980"
Date: Sun, 29 Jan 2012 17:28:06 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Bad SSD performance with recent kernels
Message-ID: <20120129092806.GA31723@localhost>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
 <20120128125108.GA9661@localhost>
 <1327757611.7199.6.camel@edumazet-laptop>
 <20120129055917.GB8513@localhost>
 <20120129084259.GI29272@MAIL.13thfloor.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120129084259.GI29272@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 09:42:59AM +0100, Herbert Poetzl wrote:
> On Sun, Jan 29, 2012 at 01:59:17PM +0800, Wu Fengguang wrote:
> > On Sat, Jan 28, 2012 at 02:33:31PM +0100, Eric Dumazet wrote:
> >> Le samedi 28 janvier 2012 à 20:51 +0800, Wu Fengguang a écrit :
> 
> >>> Would you please create a filesystem and large file on sda
> >>> and run the tests on the file? There was some performance bug
> >>> on reading the raw /dev/sda device file..
> 
> as promised, I did the tests on a filesystem, created on
> a partition of the disk, and here are the (IMHO quite
> interesting) results:
> 
> kernel    -- write ---  ------------------read -----------------
>           --- noop ---  --- noop ---  - deadline -  ---- cfs ---
>           [MB/s]  %CPU  [MB/s]  %CPU  [MB/s]  %CPU  [MB/s]  %CPU
> ----------------------------------------------------------------
> 2.6.38.8  268.76  49.6  169.20  11.3  169.17  11.3  167.89  11.4

Hmm, read performance drops between 2.6.38 and 2.6.39...

> 2.6.39.4  269.73  50.3  162.03  10.9  161.58  10.9  161.64  11.0
> 3.0.18    269.17  42.0  161.87   9.9  161.36  10.0  161.68  10.1

Between 3.0 and 3.1, the writeback chunk size is raised by commit
1a12d8bd7b2998b ("writeback: scale IO chunk size up to half device
bandwidth") which should be the main reason for the improved write
throughput.

> 3.1.10    271.62  43.1  161.91   9.9  161.68   9.9  161.25  10.1
> 3.2.2     270.95  42.6  162.36   9.9  162.63   9.9  162.65  10.1
> 
> so while the 'expected' performance should be somewhere around
> 300MB/s for read and write (raw disk access) we end up with
> good write performance and roughly half the read performance
> with 'dd bs=1M' on ext3

That could be explained by large write chunk size (>=4MB) and small
readahead size (128KB). Long time ago I collected some read
experiments on SSD and find it asks for 4MB readahead size to get
best performance: 

SSD 80G Intel x25-M SSDSA2M080 (reported by Li Shaohua)

        rasize  1st run         2nd run
        ----------------------------------
          4k    123 MB/s        122 MB/s
         16k    153 MB/s        153 MB/s
         32k    161 MB/s        162 MB/s
         64k    167 MB/s        168 MB/s
        128k    197 MB/s        197 MB/s
        256k    217 MB/s        217 MB/s
        512k    238 MB/s        234 MB/s
          1M    251 MB/s        248 MB/s
          2M    259 MB/s        257 MB/s
==>       4M    269 MB/s        264 MB/s
          8M    266 MB/s        266 MB/s

Note that ==> points to the readahead size that yields plateau throughput.

SSD 22G MARVELL SD88SA02 MP1F (reported by Jens Axboe)

        rasize  1st             2nd
        --------------------------------
          4k     41 MB/s         41 MB/s
         16k     85 MB/s         81 MB/s
         32k    102 MB/s        109 MB/s
         64k    125 MB/s        144 MB/s
        128k    183 MB/s        185 MB/s
        256k    216 MB/s        216 MB/s
        512k    216 MB/s        236 MB/s
        1024k   251 MB/s        252 MB/s
          2M    258 MB/s        258 MB/s
==>       4M    266 MB/s        266 MB/s
          8M    266 MB/s        266 MB/s

Thanks,
Fengguang
