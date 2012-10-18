Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2JSAjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:39:11 -0400
Received: from ozlabs.org ([203.10.76.45]:53987 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab2JSAjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:39:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: Re: [PATCH] virtio: 9p: correctly pass physical address to userspace for high pages
In-Reply-To: <20121018094247.GA17296@mudshark.cambridge.arm.com>
References: <1350468877-7677-1-git-send-email-will.deacon@arm.com> <87lif4o739.fsf@rustcorp.com.au> <20121018094247.GA17296@mudshark.cambridge.arm.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 19 Oct 2012 10:09:51 +1030
Message-ID: <87wqynpcxk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon <will.deacon@arm.com> writes:
> On Thu, Oct 18, 2012 at 03:19:06AM +0100, Rusty Russell wrote:
>> We do have an alternate solution: masking out __GFP_HIGHMEM from the
>> kmalloc of desc.  If it fails, we will fall back to laying out the
>> virtio request directly inside the ring; if it doesn't fit, we'll wait
>> for the device to consume more buffers.
>
> Hmm, that will probably work for the vring but the zero-copy code for 9p may
> just give us an address from userspace if I'm understanding it correctly. In
> that case, we really have to do the translation as below (which is actually
> much cleaner because everything is page-aligned).
>
>> > @@ -325,7 +326,7 @@ static int p9_get_mapped_pages(struct virtio_chan *chan,
>> >  		int count = nr_pages;
>> >  		while (nr_pages) {
>> >  			s = rest_of_page(data);
>> > -			pages[index++] = virt_to_page(data);
>> > +			pages[index++] = kmap_to_page(data);
>> >  			data += s;
>> >  			nr_pages--;
>> >  		}
>
> So what do you reckon? How about I leave this hunk as a separate patch and
> have a play masking out __GFP_HIGHMEM for the vring descriptor?

Yes, I think so.  A scathing comment would be nice, too...

Thanks,
Rusty.
