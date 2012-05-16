Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2EPPEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:04:24 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50688 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2EPPEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:04:22 -0400
Subject: Re: [V2 PATCH 2/9] macvtap: zerocopy: fix truesize underestimation
From: Shirley Ma <mashirle@us.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
In-Reply-To: <4FB3192E.4030803@redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120502034144.11782.88947.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <1337102809.8220.10.camel@oc3660625478.ibm.com>
	 <4FB3192E.4030803@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 May 2012 08:03:05 -0700
Message-ID: <1337180585.10741.6.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051615-6148-0000-0000-000005E56964
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 11:04 +0800, Jason Wang wrote:
> >> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> >> index bd4a70d..7cb2684 100644
> >> --- a/drivers/net/macvtap.c
> >> +++ b/drivers/net/macvtap.c
> >> @@ -519,6 +519,7 @@ static int zerocopy_sg_from_iovec(struct
> sk_buff
> >> *skb, const struct iovec *from,
> >>                  struct page *page[MAX_SKB_FRAGS];
> >>                  int num_pages;
> >>                  unsigned long base;
> >> +               unsigned long truesize;
> >>
> >>                  len = from->iov_len - offset;
> >>                  if (!len) {
> >> @@ -533,10 +534,11 @@ static int zerocopy_sg_from_iovec(struct
> sk_buff
> >> *skb, const struct iovec *from,
> >>                      (num_pages>  MAX_SKB_FRAGS -
> >> skb_shinfo(skb)->nr_frags))
> >>                          /* put_page is in skb free */
> >>                          return -EFAULT;
> >> +               truesize = size * PAGE_SIZE;
> > Here should be truesize = size * PAGE_SIZE - offset, right?
> >
> 
> We get the whole user page, so need to account them all. Also this is 
> aligned with skb_copy_ubufs(). 

Then this would double count the size of "first" offset left from
previous copy, both skb->len and truesize.

Thanks
Shirley

