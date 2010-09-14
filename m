Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0INPF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:05:29 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51350 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab0INPF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:05:26 -0400
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
From: Shirley Ma <mashirle@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: David Miller <davem@davemloft.net>, arnd@arndb.de, mst@redhat.com,
        xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C8F3C77.7010302@redhat.com>
References: <1284410580.13351.10.camel@localhost.localdomain>
	 <1284410883.13351.14.camel@localhost.localdomain>
	 <20100913.201730.27805132.davem@davemloft.net>
	 <4C8F3C77.7010302@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 08:05:19 -0700
Message-ID: <1284476719.13351.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 11:12 +0200, Avi Kivity wrote:
> >> +            base = (unsigned long)from->iov_base + offset1;
> >> +            size = ((base&  ~PAGE_MASK) + len + ~PAGE_MASK)>>
> PAGE_SHIFT;
> >> +            num_pages = get_user_pages_fast(base, size,
> 0,&page[i]);
> >> +            if ((num_pages != size) ||
> >> +                (num_pages>  MAX_SKB_FRAGS -
> skb_shinfo(skb)->nr_frags))
> >> +                    /* put_page is in skb free */
> >> +                    return -EFAULT;
> > What keeps the user from writing to these pages in it's address
> space
> > after the write call returns?
> >
> > A write() return of success means:
> >
> >       "I wrote what you gave to me"
> >
> > not
> >
> >       "I wrote what you gave to me, oh and BTW don't touch these
> >           pages for a while."
> >
> > In fact "a while" isn't even defined in any way, as there is no way
> > for the write() invoker to know when the networking card is done
> with
> > those pages.
> 
> That's what io_submit() is for.  Then io_getevents() tells you what
> "a 
> while" actually was.

This macvtap zero copy uses iov buffers from vhost ring, which is
allocated from guest kernel. In host kernel, vhost calls macvtap
sendmsg. macvtap sendmsg calls get_user_pages_fast to pin these buffers'
pages for zero copy.

The patch is relying on how vhost handle these buffers. I need to look
at vhost code (qemu) first for addressing the questions here.

Thanks
Shirley

