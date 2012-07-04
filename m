Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2GDPyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:54:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab2GDPy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:54:26 -0400
Message-ID: <4FF46728.7030302@redhat.com>
Date: Wed, 04 Jul 2012 17:54:16 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback
 and writethrough
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com> <20120704154220.GB27064@redhat.com>
In-Reply-To: <20120704154220.GB27064@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2012 17:42, Michael S. Tsirkin ha scritto:
> On Tue, Jul 03, 2012 at 03:19:37PM +0200, Paolo Bonzini wrote:
>> This patch adds support for the new VIRTIO_BLK_F_CONFIG_WCE feature,
>> which exposes the cache mode in the configuration space and lets the
>> driver modify it.  The cache mode is exposed via sysfs.
>>
>> Even if the host does not support the new feature, the cache mode is
>> visible (thanks to the existing VIRTIO_BLK_F_WCE), but not modifiable.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> I note this has been applied but I think the userspace
> API is a bit painful to use. Let's fix it before
> it gets set in stone?

I'm trying to mimic the existing userspace API for SCSI disks.  FWIW I
would totally agree with you.

>> +static int virtblk_get_cache_mode(struct virtio_device *vdev)
> 
> Why are you converting u8 to int here?

The fact that it is a u8 is really an internal detail.  Perhaps the bug
is using u8 in the callers.

>> +static const char *virtblk_cache_types[] = {
>> +	"write through", "write back"
>> +};
>> +
> 
> I wonder whether something that lacks space would have been better,
> especially for show: shells might get confused and split
> a string at a space. How about we change it to writethrough,
> writeback before it's too late? It's part of a userspace API
> after all, and you see to prefer writeback in one word in your own
> code so let's not inflict pain on others :)
> 
> Also, would be nice to make it discoverable what the legal
> values are. Another attribute valid_cache_types with all values
> space separated?

We probably should add such an attribute to SCSI disks too... Even with
the spaces we could make the values \n-separated.

>> +static ssize_t
>> +virtblk_cache_type_store(struct device *dev, struct device_attribute *attr,
>> +			 const char *buf, size_t count)
>> +{
>> +	struct gendisk *disk = dev_to_disk(dev);
>> +	struct virtio_blk *vblk = disk->private_data;
>> +	struct virtio_device *vdev = vblk->vdev;
>> +	int i;
>> +	u8 writeback;
>> +
>> +	BUG_ON(!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_CONFIG_WCE));
>> +	for (i = ARRAY_SIZE(virtblk_cache_types); --i >= 0; )
>> +		if (sysfs_streq(buf, virtblk_cache_types[i]))
>> +			break;
>> +
>> +	if (i < 0)
>> +		return -EINVAL;
>> +
>> +	writeback = i;
>> +	vdev->config->set(vdev,
>> +			  offsetof(struct virtio_blk_config, wce),
>> +			  &writeback, sizeof(writeback));
>> +
>> +	virtblk_update_cache_mode(vdev);
>> +	return count;
>> +}
>> +
>> +static ssize_t
>> +virtblk_cache_type_show(struct device *dev, struct device_attribute *attr,
>> +			 char *buf)
>> +{
>> +	struct gendisk *disk = dev_to_disk(dev);
>> +	struct virtio_blk *vblk = disk->private_data;
>> +	u8 writeback = virtblk_get_cache_mode(vblk->vdev);
>> +
>> +	BUG_ON(writeback >= ARRAY_SIZE(virtblk_cache_types));
>> +	return snprintf(buf, 40, "%s\n", virtblk_cache_types[writeback]);
> 
> Why 40? Why snprintf? A plain sprintf won't do?

I plead guilty of cut-and-paste from drivers/scsi/sd.c. :)

Paolo
