Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab0FBNxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:53:19 -0400
Received: from 8bytes.org ([88.198.83.132]:35917 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab0FBNxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:53:18 -0400
Date: Wed, 2 Jun 2010 15:53:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602135317.GD11162@8bytes.org>
References: <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org> <20100602112100.GA29697@redhat.com> <20100602121927.GA11162@8bytes.org> <4C064DA7.6060504@redhat.com> <20100602125049.GB11162@8bytes.org> <4C06574D.2080309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C06574D.2080309@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 04:06:21PM +0300, Avi Kivity wrote:
> On 06/02/2010 03:50 PM, Joerg Roedel wrote:

>> Its by far more unintuitive that a process needs to explicitly bind a
>> device to an iommu domain before it can do anything with it.
>
> I don't really care about the iommu domain.  It's a side effect.  The  
> kernel takes care of it.  I'm only worried about the API.

The proposed memory-map object is nothing else than a userspace
abstraction of an iommu-domain.

> We have a memory map that is (often) the same for a set of devices.  If  
> you were coding a non-kernel interface, how would you code it?
>
>   struct memory_map;
>   void memory_map_init(struct memory_map *mm, ...);
>   struct device;
>   void device_set_memory_map(struct device *device, struct memory_map *mm);
>
> or
>
>   struct device;
>   void device_init_memory_map(struct device *dev, ...);
>   void device_clone_memory_map(struct device *dev, struct device *other);
>
> I wouldn't even think of the second one personally.

Right, a kernel-interface would be designed the first way. The IOMMU-API
is actually designed in this manner. But I still think we should keep it
simpler for userspace.

>> If its required anyway the binding can happen implicitly. We could
>> allow to do a nop 'ioctl(dev1, SHARE, dev1)' to remove the asymmetry.
>
> It's still special.  You define the memory map only for the first  
> device.  You have to make sure dev1 doesn't go away while sharing it.

Must be a misunderstanding. In my proposal the domain is not owned by
one device. It is owned by all devices that share it and will only
vanish if all devices that use it are unbound (which happens when the file
descriptor is closed, for example).

> so yes, more work, but once you have multiple devices which come and go  
> dynamically things become simpler.  The map object has global lifetime  
> (you can even construct it if you don't assign any devices), the devices  
> attach to it, memory hotplug updates the memory map but doesn't touch  
> devices.

I still think a userspace interface should be as simple as possible. But
since both ways will work I am not really opposed to Michael's proposal.
I just think its overkill for the common non-kvm usecase (a userspace
device driver).

	Joerg

