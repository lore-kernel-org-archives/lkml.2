Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2AaUXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:23:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab2AaUXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:23:21 -0500
Date: Tue, 31 Jan 2012 15:23:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Herbert Poetzl <herbert@13thfloor.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Wu Fengguang <wfg@linux.intel.com>
Subject: Re: [PATCH] fix readahead pipeline break caused by block plug
Message-ID: <20120131202311.GB4378@redhat.com>
References: <1327996780.21268.42.camel@sli10-conroe>
 <20120131144734.GA4378@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131144734.GA4378@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 09:47:34AM -0500, Vivek Goyal wrote:
> On Tue, Jan 31, 2012 at 03:59:40PM +0800, Shaohua Li wrote:
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
> 
> Why IO is not submitted because of plug? Doesn't task now get scheduled
> out causing an unplug? IOW, are we now busy waiting somewhere preventing
> unplug?

Ok, after putting some trace points I think now I understand what is
happening.

We submit some readahead IO to device request queue but because of nested
plug, queue never gets unplugged. When read logic reaches a page which is
not in page cache, it waits for page to be read from the disk
(lock_page_killable()) and that time we flush the plug list.

So effectively read ahead logic is kind of broken in parts because of
nested plugging. Removing top level plug (generic_file_aio_read()) for
buffered reads, will allow unplugging queue earlier for readahead.

Thanks
Vivek 
