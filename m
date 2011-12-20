Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1LTOug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:50:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab1LTOub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:50:31 -0500
Date: Tue, 20 Dec 2011 09:50:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Nate Custer <nate@cpanel.net>, Jens Axboe <axboe@kernel.dk>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH] blkio: alloc per cpu data from worker thread
 context( Re: kvm deadlock)
Message-ID: <20111220145024.GA16946@redhat.com>
References: <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
 <20111215194712.GA11194@redhat.com>
 <E73DB38E-AFC5-445D-9E76-DE599B36A814@cpanel.net>
 <20111216202907.GH7586@redhat.com>
 <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net>
 <20111219172717.GB7175@redhat.com>
 <20111219173519.GL24519@google.com>
 <20111219182717.GC7175@redhat.com>
 <20111219225635.GC6256@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219225635.GC6256@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 02:56:35PM -0800, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Mon, Dec 19, 2011 at 01:27:17PM -0500, Vivek Goyal wrote:
> > Ok, that's good to know. If per cpu allocator can support this use case,
> > it will be good for 3.3 onwards. This seems to be right way to go to fix
> > the problem.
> 
> Ummm... if we're gonna make percpu usable w/ GFP_NOIO, the right
> interim solution would be making a simplistic mempool so that later
> when percpu can do it, it can be swapped easily.  I really can't see
> much benefit of adding refcnting on top of everything just for this.

Ok. So are you suggesting that I should write a simple mempool kind of
implementation of my own for group and per cpu data allocation. Keep
certain number of elements in the cache and trigger a worker thread to
allocate more elements once minimum number of elements go below
threshold. If pool has run out of pre-allocated elements then allocation
will fail and IO will be accounted to root group?

I am looking at the mempool implementation (mempool_create()) and looks
like that is not suitable for my use case. mempool_alloc() will call into
alloc function provided by me and pass the flags. I can't implement an
alloc function and honor that flag as per cpu alloc does not take any
flags.

So IIUC, existing mempool implementation is not directly usable for my
requirement and I need to write some code of my own for the caching
layer which always allocates objects from reserve and fills in the
pool asynchronously with the help of a worker thread.

Thanks
Vivek
