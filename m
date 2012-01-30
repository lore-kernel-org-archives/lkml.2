Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2A3OPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:15:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:43796 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab2A3OPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:15:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101120675"
Date: Mon, 30 Jan 2012 22:05:38 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Li Shaohua <shaohua.li@intel.com>,
        Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: Bad SSD performance with recent kernels
Message-ID: <20120130140537.GA20349@localhost>
References: <1327757611.7199.6.camel@edumazet-laptop>
 <20120129055917.GB8513@localhost>
 <1327831380.14602.6.camel@edumazet-laptop>
 <20120129111645.GA5839@localhost>
 <1327842831.2718.2.camel@edumazet-laptop>
 <20120129161058.GA13156@localhost>
 <20120129201543.GJ29272@MAIL.13thfloor.at>
 <20120130111854.GA899@localhost>
 <1327926896.2288.34.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120130140109.GA15682@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130140109.GA15682@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - IO size is 256KB (which is not a problem in itself)
> 
> - The dispatch/complete pattern is
> 
>         submit IO for range 1
>         complete IO for range 1
>         <dd busy, disk idle>
>         submit IO for range 2
>         complete IO for range 2
> 
>   So we have periods that no IO is in flight at all, which leads to
>   under-utilized disk (which should show up in iostat as <100% disk util)
> 
> # grep '[DC]' blktrace
> 
>   8,16   1   770606     9.990039807  4580  D   R 4379392 + 512 (   14826) [dd]
>   8,16   1   770607     9.991083069     0  C   R 4379392 + 512 ( 1043262) [0]
> 
>   8,16   1   770739     9.991647434  4580  D   R 4379904 + 512 (   14433) [dd]
>   8,16   1   770740     9.992693317     0  C   R 4379904 + 512 ( 1045883) [0]
> 
>   8,16   1   770872     9.993256451  4580  D   R 4380416 + 512 (   14539) [dd]
>   8,16   1   770873     9.994299156     0  C   R 4380416 + 512 ( 1042705) [0]
> 
>   8,16   1   771005     9.994863680  4580  D   R 4380928 + 512 (   14344) [dd]
>   8,16   1   771006     9.995909291     0  C   R 4380928 + 512 ( 1045611) [0]
> 
>   8,16   1   771138     9.996470460  4580  D   R 4381440 + 512 (   14043) [dd]
>   8,16   1   771139     9.997514205     0  C   R 4381440 + 512 ( 1043745) [0]
> 
>   8,16   1   771271     9.998077269  4580  D   R 4381952 + 512 (   14928) [dd]
>   8,16   1   771272     9.999120396     0  C   R 4381952 + 512 ( 1043127) [0]

Some better pattern for comparison:

  8,0    1    42940     0.990199812  4084  D   R 1432808 + 256 [dd]
  8,0    1    42941     0.990858326     0  C   R 1432552 + 256 [0]
  8,0    1    43009     0.991192107  4084  D   R 1433064 + 256 [dd]
  8,0    3    14691     0.991853319     0  C   R 1432808 + 256 [0]
  8,0    3    14759     0.992189451  4084  D   R 1433320 + 256 [dd]
  8,0    1    43010     0.994473159     0  C   R 1433064 + 256 [0]

Where the life time for requests 1432808, 1432552, 1433064, ...
are *interleaved* so that the disk always has something to do.

Thanks,
Fengguang
