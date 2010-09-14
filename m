Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0INDRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 23:17:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44193
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071Ab0INDRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 23:17:12 -0400
Date: Mon, 13 Sep 2010 20:17:30 -0700 (PDT)
Message-Id: <20100913.201730.27805132.davem@davemloft.net>
To: mashirle@us.ibm.com
Cc: avi@redhat.com, arnd@arndb.de, mst@redhat.com, xiaohui.xin@intel.com,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284410883.13351.14.camel@localhost.localdomain>
References: <1284410580.13351.10.camel@localhost.localdomain>
	<1284410883.13351.14.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shirley Ma <mashirle@us.ibm.com>
Date: Mon, 13 Sep 2010 13:48:03 -0700

> +		base = (unsigned long)from->iov_base + offset1;
> +		size = ((base & ~PAGE_MASK) + len + ~PAGE_MASK) >> PAGE_SHIFT;
> +		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
> +		if ((num_pages != size) ||
> +		    (num_pages > MAX_SKB_FRAGS - skb_shinfo(skb)->nr_frags))
> +			/* put_page is in skb free */
> +			return -EFAULT;

What keeps the user from writing to these pages in it's address space
after the write call returns?

A write() return of success means:

	"I wrote what you gave to me"

not

	"I wrote what you gave to me, oh and BTW don't touch these
         pages for a while."

In fact "a while" isn't even defined in any way, as there is no way
for the write() invoker to know when the networking card is done with
those pages.
