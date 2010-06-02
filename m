Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab0FBNGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:06:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941Ab0FBNGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:06:37 -0400
Message-ID: <4C06574D.2080309@redhat.com>
Date: Wed, 02 Jun 2010 16:06:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org> <20100602112100.GA29697@redhat.com> <20100602121927.GA11162@8bytes.org> <4C064DA7.6060504@redhat.com> <20100602125049.GB11162@8bytes.org>
In-Reply-To: <20100602125049.GB11162@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 03:50 PM, Joerg Roedel wrote:
>
>> The problem with this is that it is assymetric, dev1 is treated
>> differently from dev[234].  It's an unintuitive API.
>>      
> Its by far more unintuitive that a process needs to explicitly bind a
> device to an iommu domain before it can do anything with it.

I don't really care about the iommu domain.  It's a side effect.  The 
kernel takes care of it.  I'm only worried about the API.

We have a memory map that is (often) the same for a set of devices.  If 
you were coding a non-kernel interface, how would you code it?

   struct memory_map;
   void memory_map_init(struct memory_map *mm, ...);
   struct device;
   void device_set_memory_map(struct device *device, struct memory_map *mm);

or

   struct device;
   void device_init_memory_map(struct device *dev, ...);
   void device_clone_memory_map(struct device *dev, struct device *other);

I wouldn't even think of the second one personally.

> If its
> required anyway the binding can happen implicitly. We could allow to do
> a nop 'ioctl(dev1, SHARE, dev1)' to remove the asymmetry.
>    

It's still special.  You define the memory map only for the first 
device.  You have to make sure dev1 doesn't go away while sharing it.

> Note that this way of handling userspace iommu mappings is also a lot
> simpler for most use-cases outside of KVM. If a developer wants to write
> a userspace driver all it needs to do is:
>
> dev = open();
> ioctl(dev, MAP, ...);
> /* use device with mappings */
> close(dev);
>
> Which is much easier than the need to create a domain explicitly.
>    

mm = open()
ioctl(mm, MAP, ...)
dev = open();
ioctl(dev, BIND, mm);
...
close(mm);
close(dev);

so yes, more work, but once you have multiple devices which come and go 
dynamically things become simpler.  The map object has global lifetime 
(you can even construct it if you don't assign any devices), the devices 
attach to it, memory hotplug updates the memory map but doesn't touch 
devices.

-- 
error compiling committee.c: too many arguments to function

