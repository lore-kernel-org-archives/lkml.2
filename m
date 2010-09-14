Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab0INJMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 05:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab0INJMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:12:36 -0400
Message-ID: <4C8F3C77.7010302@redhat.com>
Date: Tue, 14 Sep 2010 11:12:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mashirle@us.ibm.com, arnd@arndb.de, mst@redhat.com, xiaohui.xin@intel.com,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
References: <1284410580.13351.10.camel@localhost.localdomain>	<1284410883.13351.14.camel@localhost.localdomain> <20100913.201730.27805132.davem@davemloft.net>
In-Reply-To: <20100913.201730.27805132.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/14/2010 05:17 AM, David Miller wrote:
> From: Shirley Ma<mashirle@us.ibm.com>
> Date: Mon, 13 Sep 2010 13:48:03 -0700
>
>> +		base = (unsigned long)from->iov_base + offset1;
>> +		size = ((base&  ~PAGE_MASK) + len + ~PAGE_MASK)>>  PAGE_SHIFT;
>> +		num_pages = get_user_pages_fast(base, size, 0,&page[i]);
>> +		if ((num_pages != size) ||
>> +		    (num_pages>  MAX_SKB_FRAGS - skb_shinfo(skb)->nr_frags))
>> +			/* put_page is in skb free */
>> +			return -EFAULT;
> What keeps the user from writing to these pages in it's address space
> after the write call returns?
>
> A write() return of success means:
>
> 	"I wrote what you gave to me"
>
> not
>
> 	"I wrote what you gave to me, oh and BTW don't touch these
>           pages for a while."
>
> In fact "a while" isn't even defined in any way, as there is no way
> for the write() invoker to know when the networking card is done with
> those pages.

That's what io_submit() is for.  Then io_getevents() tells you what "a 
while" actually was.

-- 
error compiling committee.c: too many arguments to function

