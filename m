Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0FAKvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:51:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab0FAKvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:51:19 -0400
Date: Tue, 1 Jun 2010 13:46:51 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100601104651.GA9415@redhat.com>
References: <20100530124949.GI27611@redhat.com> <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <4C04E0E0.3070006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C04E0E0.3070006@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 01:28:48PM +0300, Avi Kivity wrote:
> On 06/01/2010 12:55 PM, Michael S. Tsirkin wrote:
>>
>>>   It can't program the iommu.
>>> What
>>> the patch proposes is that userspace tells vfio about the needed
>>> mappings, and vfio programs the iommu.
>>>      
>> There seems to be some misunderstanding.  The userspace interface
>> proposed forces a separate domain per device and forces userspace to
>> repeat iommu programming for each device.  We are better off sharing a
>> domain between devices and programming the iommu once.
>>    
>
>   iommufd = open(/dev/iommu);
>   ioctl(iommufd, IOMMUFD_ASSIGN_RANGE, ...)
>   ioctl(vfiofd, VFIO_SET_IOMMU, iommufd)
>
> ?

Yes.

> If so, I agree.

Good.

>> The natural way to do this is to have an iommu driver for programming
>> iommu.
>>
>> This likely means we will have to pass the domain to 'vfio' or uio or
>> whatever the driver that gives userspace the access to device is called,
>> but this is only for security, there's no need to support programming
>> iommu there.
>>
>> And using this design means the uio framework changes
>> required would be minor, so we won't have to duplicate code.
>>    
>
> Since vfio would be the only driver, there would be no duplication.  But  
> a separate object for the iommu mapping is a good thing.  Perhaps we can  
> even share it with vhost (without actually using the mmu, since vhost is  
> software only).

Main difference is that vhost works fine with unlocked
memory, paging it in on demand. iommu needs to unmap
memory when it is swapped out or relocated.

> -- 
> error compiling committee.c: too many arguments to function
