Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2AaIy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:54:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:55827 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab2AaIyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:54:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="104472348"
Subject: Re: [PATCH] fix readahead pipeline break caused by block plug
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Herbert Poetzl <herbert@13thfloor.at>,
        Vivek Goyal <vgoyal@redhat.com>, Wu Fengguang <wfg@linux.intel.com>
In-Reply-To: <1327999722.2422.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1327996780.21268.42.camel@sli10-conroe>
	 <1327999722.2422.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 16:53:56 +0800
Message-ID: <1328000036.21268.52.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 09:48 +0100, Eric Dumazet wrote:
> Le mardi 31 janvier 2012 à 15:59 +0800, Shaohua Li a écrit :
> > Herbert Poetzl reported a performance regression since 2.6.39. The test
> > is a simple dd read, but with big block size. The reason is:
> > 
> > T1: ra (A, A+128k), (A+128k, A+256k)
> > T2: lock_page for page A, submit the 256k
> > T3: hit page A+128K, ra (A+256k, A+384). the range isn't submitted
> > because of plug and there isn't any lock_page till we hit page A+256k
> > because all pages from A to A+256k is in memory
> > T4: hit page A+256k, ra (A+384, A+ 512). Because of plug, the range isn't
> > submitted again.
> > T5: lock_page A+256k, so (A+256k, A+512k) will be submitted. The task is
> > waitting for (A+256k, A+512k) finish.
> > 
> > There is no request to disk in T3 and T4, so readahead pipeline breaks.
> > 
> > We really don't need block plug for generic_file_aio_read() for buffered
> > I/O. The readahead already has plug and has fine grained control when I/O
> > should be submitted. Deleting plug for buffered I/O fixes the regression.
> > 
> > One side effect is plug makes the request size 256k, the size is 128k
> > without it. This is because default ra size is 128k and not a reason we
> > need plug here.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > Tested-by: Herbert Poetzl <herbert@13thfloor.at>
> > Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Hmm, this is not exactly the patch I tested from Wu Fengguang 
> 
> I'll test this one before adding my "Tested-by: ..."
That added lines should not matter. We still need plug for direct-io
case.
Really sorry for this, I should ask you test it before adding the
Tested-by.

Thanks,
Shaohua

