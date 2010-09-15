Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0IOB4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:56:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:31754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab0IOB4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:56:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,368,1280732400"; 
   d="scan'208";a="657382689"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Arnd Bergmann <arnd@arndb.de>, Shirley Ma <mashirle@us.ibm.com>
CC: Avi Kivity <avi@redhat.com>, David Miller <davem@davemloft.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Sep 2010 09:56:10 +0800
Subject: RE: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
Thread-Topic: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
Thread-Index: ActUIId2Hye6+XQCSNaZANmJ5Su4BQAV/jIA
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D792B8C8152AA@shsmsx502.ccr.corp.intel.com>
References: <1284410580.13351.10.camel@localhost.localdomain>
 <4C8F3C77.7010302@redhat.com>
 <1284476719.13351.35.camel@localhost.localdomain>
 <201009141721.13202.arnd@arndb.de>
In-Reply-To: <201009141721.13202.arnd@arndb.de>
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

>From: Arnd Bergmann [mailto:arnd@arndb.de]
>Sent: Tuesday, September 14, 2010 11:21 PM
>To: Shirley Ma
>Cc: Avi Kivity; David Miller; mst@redhat.com; Xin, Xiaohui; netdev@vger.kernel.org;
>kvm@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host kernel
>
>On Tuesday 14 September 2010, Shirley Ma wrote:
>> On Tue, 2010-09-14 at 11:12 +0200, Avi Kivity wrote:
>>
>> > That's what io_submit() is for.  Then io_getevents() tells you what
>> > "a
>> > while" actually was.
>>
>> This macvtap zero copy uses iov buffers from vhost ring, which is
>> allocated from guest kernel. In host kernel, vhost calls macvtap
>> sendmsg. macvtap sendmsg calls get_user_pages_fast to pin these buffers'
>> pages for zero copy.
>>
>> The patch is relying on how vhost handle these buffers. I need to look
>> at vhost code (qemu) first for addressing the questions here.
>
>I guess the best solution would be to make macvtap_aio_write return
>-EIOCBQUEUED when a packet gets passed down to the adapter, and
>call aio_complete when the adapter is done with it.
>
>This would change the regular behavior of macvtap into a model where
>every write on the file blocks until the packet has left the machine,
>which gives us better flow control, but does slow down the traffic
>when we only put one packet at a time into the queue.
>
>It also allows the user to call io_submit instead of write in order
>to do an asynchronous submission as Avi was suggesting.
>

But currently, this patch is communicated with vhost-net, which is almost
in the kernel side. If it uses aio stuff, it should be communicate with user
space Backend. 
 
>	Arnd
