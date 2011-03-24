Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab1CXDGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:06:10 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38687 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab1CXDGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:06:09 -0400
Message-ID: <4D8AB514.5020306@us.ibm.com>
Date: Wed, 23 Mar 2011 22:05:56 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Hellwig <hch@lst.de>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, stefanha@gmail.com, kwolf@redhat.com,
        prerna@linux.vnet.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH, RFC] virtio_blk: add cache control support
References: <20110315141049.GA30627@lst.de> <20110315141644.GA30803@lst.de> <87y64fhfjw.fsf@rustcorp.com.au> <20110316140958.GB21877@lst.de> <877hbygwu7.fsf@rustcorp.com.au>
In-Reply-To: <877hbygwu7.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 12:06 AM, Rusty Russell wrote:
> On Wed, 16 Mar 2011 15:09:58 +0100, Christoph Hellwig<hch@lst.de>  wrote:
>> On Wed, Mar 16, 2011 at 02:39:39PM +1030, Rusty Russell wrote:
>>>> +	if (strncmp(buf, "write through", sizeof("write through") - 1) == 0) {
>>>> +		;
>>>> +	} else if (strncmp(buf, "write back", sizeof("write back") - 1) == 0) {
>>>     Is there a reason we're not letting gcc and/or strcmp do the
>>> optimization work here?
>> I'm happ to switch strcmp.
> Of course, that's assuming buf is nul terminated.
>
>>>> +	vdev->config->set(vdev, offsetof(struct virtio_blk_config, features),
>>>> +	&features, sizeof(features));
>>>> +
>>>> +	vdev->config->get(vdev, offsetof(struct virtio_blk_config, features),
>>>> +			&features2, sizeof(features2));
>>>> +
>>>> +	if ((features&  VIRTIO_BLK_RT_WCE) !=
>>>> +	    (features2&  VIRTIO_BLK_RT_WCE))
>>>> +		return -EIO;
>>>     This seems like a debugging check you left in.  Or do you suspect
>>> some issues?
>> No, it's intentional.  config space writes can't return errors, so we need
>> to check that the value has really changed.  I'll add a comment explaining it.
> OK, under what circumstances could it fail?
>
> If you're using this mechanism to indicate that the host doesn't support
> the feature, that's making an assumption about the nature of config
> space writes which isn't true for non-PCI virtio.
>
> ie. lguest and S/390 don't trap writes to config space.
>
> Or perhaps they should?  But we should be explicit about needing it...

I don't think we ever operated on the assumption that config space 
writes would trap.

I don't think adding it is the right thing either because you can do 
byte access to the config space which makes atomicity difficult.

Any reason not to use a control queue to negotiate dynamic features?  
The authorative source of what the currently enabled features are can 
still be config space but the guest's enabling or disabling of a feature 
ought to be a control queue message.

Regards,

Anthony Liguori

> Thanks,
> Rusty.
>
>
>

