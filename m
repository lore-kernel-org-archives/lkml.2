Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2GDQJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:09:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab2GDQJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:09:01 -0400
Message-ID: <4FF46A92.3020009@redhat.com>
Date: Wed, 04 Jul 2012 18:08:50 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback
 and writethrough
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com> <20120704154220.GB27064@redhat.com> <4FF46728.7030302@redhat.com> <20120704160258.GB27271@redhat.com>
In-Reply-To: <20120704160258.GB27271@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2012 18:02, Michael S. Tsirkin ha scritto:
> On Wed, Jul 04, 2012 at 05:54:16PM +0200, Paolo Bonzini wrote:
>> Il 04/07/2012 17:42, Michael S. Tsirkin ha scritto:
>>> On Tue, Jul 03, 2012 at 03:19:37PM +0200, Paolo Bonzini wrote:
>>>> This patch adds support for the new VIRTIO_BLK_F_CONFIG_WCE feature,
>>>> which exposes the cache mode in the configuration space and lets the
>>>> driver modify it.  The cache mode is exposed via sysfs.
>>>>
>>>> Even if the host does not support the new feature, the cache mode is
>>>> visible (thanks to the existing VIRTIO_BLK_F_WCE), but not modifiable.
>>>>
>>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>>
>>> I note this has been applied but I think the userspace
>>> API is a bit painful to use. Let's fix it before
>>> it gets set in stone?
>>
>> I'm trying to mimic the existing userspace API for SCSI disks.  FWIW I
>> would totally agree with you.
> 
> Hmm. Want to try fixing scsi? Need to be compatible but it could
> maybe ignore spaces.

Honestly I'm not sure it's really worthwhile...  And you also have the
same problem when printing.  You cannot remove the spaces, because
clients will look for the "old" string, with the spaces.

>>>> +static int virtblk_get_cache_mode(struct virtio_device *vdev)
>>>
>>> Why are you converting u8 to int here?
>>
>> The fact that it is a u8 is really an internal detail.  Perhaps the bug
>> is using u8 in the callers.
> 
> Make it bool then?
> 
> You are using u8 in the config. So you could get any value
> besides 0 and 1, and you interpret that as 1.
> Is 1 always a safe value? If not maybe it's better to set
> to a safe value if it is not 0 or 1, that is we don't know how to interpret it.

That would be a host bug; the spec only gives meaning to 0 and 1.  In
any case, "have a cache" means "needs to flush", so it's always safe.
If you interpret another value as 0, you risk omitting flushes.

Paolo

