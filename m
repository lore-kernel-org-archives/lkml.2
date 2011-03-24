Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab1CXDLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:11:42 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40883 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab1CXDLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:11:40 -0400
Message-ID: <4D8AB65F.9060108@us.ibm.com>
Date: Wed, 23 Mar 2011 22:11:27 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Rusty Russell <rusty@rustcorp.com.au>, kwolf@redhat.com,
        stefanha@gmail.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, Christian Borntraeger <borntraeger@de.ibm.com>,
        prerna@linux.vnet.ibm.com
Subject: Re: [Qemu-devel] Re: [PATCH, RFC] virtio_blk: add cache control support
References: <20110315141049.GA30627@lst.de> <20110315141644.GA30803@lst.de> <87y64fhfjw.fsf@rustcorp.com.au> <20110316140958.GB21877@lst.de> <877hbygwu7.fsf@rustcorp.com.au> <20110317142122.GA27717@lst.de>
In-Reply-To: <20110317142122.GA27717@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 09:21 AM, Christoph Hellwig wrote:
> On Thu, Mar 17, 2011 at 03:36:08PM +1030, Rusty Russell wrote:
>>> I'm happ to switch strcmp.
>> Of course, that's assuming buf is nul terminated.
> It's the string the user writes into it, which normally should be
> nul-terminated.
>
>>> No, it's intentional.  config space writes can't return errors, so we need
>>> to check that the value has really changed.  I'll add a comment explaining it.
>> OK, under what circumstances could it fail?
>>
>> If you're using this mechanism to indicate that the host doesn't support
>> the feature, that's making an assumption about the nature of config
>> space writes which isn't true for non-PCI virtio.
>>
>> ie. lguest and S/390 don't trap writes to config space.
>>
>> Or perhaps they should?  But we should be explicit about needing it...
> We have the features flag to indicate if updating the caching mode is
> supported, but we we could still fail it for other reasons - e.g. we could fail
> to reopen the file with/without O_SYNC.  But if lguest or S/390 don't support
> trapping config space write this feature won't work for them at all.  As do
> other features that make use of config space write, e.g. updating the MAC
> address for virtio-net.

QEMU does not rely on config space writes for supporting mac address 
updates.

Whenever the config space is updated, we update the mac address in the 
virtio-net structure but since PCI only supports 4 byte accesses, it 
will only be partially updated at certain points in time.

This is okay though because as long as a guest updates it before we send 
a network packet out, when we refer to the mac address, it will be 
correct.  We could just as well have the config space be in shared 
memory and only refer to the mac address in that shared memory area when 
transmitting a packet.

So the fact that we respond to config space writes doesn't mean that 
writes have a side effect other than updating the config space, which is 
really what I think the important point is here.

Regards,

Anthony Liguori


