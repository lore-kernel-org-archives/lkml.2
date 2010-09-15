Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab0IOBvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:51:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:35863 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0IOBv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:51:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,368,1280732400"; 
   d="scan'208";a="324657413"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Shirley Ma <mashirle@us.ibm.com>, Avi Kivity <avi@redhat.com>
CC: David Miller <davem@davemloft.net>, "arnd@arndb.de" <arnd@arndb.de>,
        "mst@redhat.com" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Sep 2010 09:50:22 +0800
Subject: RE: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
Thread-Topic: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
Thread-Index: ActUHkT3Lz1o5xmzR7qaQFOrFLng2QAWLuJA
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D792B8C8152A0@shsmsx502.ccr.corp.intel.com>
References: <1284410580.13351.10.camel@localhost.localdomain>
	 <1284410883.13351.14.camel@localhost.localdomain>
	 <20100913.201730.27805132.davem@davemloft.net>
	 <4C8F3C77.7010302@redhat.com>
 <1284476719.13351.35.camel@localhost.localdomain>
In-Reply-To: <1284476719.13351.35.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Shirley Ma [mailto:mashirle@us.ibm.com]
>Sent: Tuesday, September 14, 2010 11:05 PM
>To: Avi Kivity
>Cc: David Miller; arnd@arndb.de; mst@redhat.com; Xin, Xiaohui; netdev@vger.kernel.org;
>kvm@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host kernel
>
>On Tue, 2010-09-14 at 11:12 +0200, Avi Kivity wrote:
>> >> +            base = (unsigned long)from->iov_base + offset1;
>> >> +            size = ((base&  ~PAGE_MASK) + len + ~PAGE_MASK)>>
>> PAGE_SHIFT;
>> >> +            num_pages = get_user_pages_fast(base, size,
>> 0,&page[i]);
>> >> +            if ((num_pages != size) ||
>> >> +                (num_pages>  MAX_SKB_FRAGS -
>> skb_shinfo(skb)->nr_frags))
>> >> +                    /* put_page is in skb free */
>> >> +                    return -EFAULT;
>> > What keeps the user from writing to these pages in it's address
>> space
>> > after the write call returns?
>> >
>> > A write() return of success means:
>> >
>> >       "I wrote what you gave to me"
>> >
>> > not
>> >
>> >       "I wrote what you gave to me, oh and BTW don't touch these
>> >           pages for a while."
>> >
>> > In fact "a while" isn't even defined in any way, as there is no way
>> > for the write() invoker to know when the networking card is done
>> with
>> > those pages.
>>
>> That's what io_submit() is for.  Then io_getevents() tells you what
>> "a
>> while" actually was.
>
>This macvtap zero copy uses iov buffers from vhost ring, which is
>allocated from guest kernel. In host kernel, vhost calls macvtap
>sendmsg. macvtap sendmsg calls get_user_pages_fast to pin these buffers'
>pages for zero copy.
>
>The patch is relying on how vhost handle these buffers. I need to look
>at vhost code (qemu) first for addressing the questions here.
>
>Thanks
>Shirley

I think what David said is what we have thought before in mp device.
Since we are not sure the exact time the tx buffer was wrote though DMA operation.
But the deadline is when the tx buffer was freed. So we only notify the vhost stuff
about the write when tx buffer freed. But the deadline is maybe too late for performance.

Thanks
Xiaohui 

