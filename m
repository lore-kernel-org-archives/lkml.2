Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0FBFk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:40:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab0FBFk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:40:28 -0400
Message-ID: <4C05EEB6.7070007@redhat.com>
Date: Wed, 02 Jun 2010 08:40:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Tom Lyon <pugs@lyon-about.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com, alex.williamson@redhat.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <20100530124949.GI27611@redhat.com> <4C04E0E0.3070006@redhat.com> <20100601104651.GA9415@redhat.com> <201006011426.53563.pugs@lyon-about.com> <4C05C925.6080006@redhat.com> <20100602052907.GT8301@sequoia.sous-sol.org>
In-Reply-To: <20100602052907.GT8301@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 08:29 AM, Chris Wright wrote:
> * Avi Kivity (avi@redhat.com) wrote:
>    
>> On 06/02/2010 12:26 AM, Tom Lyon wrote:
>>      
>>> I'm not really opposed to multiple devices per domain, but let me point out how I
>>> ended up here.  First, the driver has two ways of mapping pages, one based on the
>>> iommu api and one based on the dma_map_sg api.  With the latter, the system
>>> already allocates a domain per device and there's no way to control it. This was
>>> presumably done to help isolation between drivers.  If there are multiple drivers
>>> in the user level, do we not want the same isoation to apply to them?
>>>        
>> In the case of kvm, we don't want isolation between devices, because
>> that doesn't happen on real hardware.
>>      
> Sure it does.  That's exactly what happens when there's an iommu
> involved with bare metal.
>    

But we are emulating a machine without an iommu.

When we emulate a machine with an iommu, then yes, we'll want to use as 
many domains as the guest does.

>> So if the guest programs
>> devices to dma to each other, we want that to succeed.
>>      
> And it will as long as ATS is enabled (this is a basic requirement
> for PCIe peer-to-peer traffic to succeed with an iommu involved on
> bare metal).
>
> That's how things currently are, i.e. we put all devices belonging to a
> single guest in the same domain.  However, it can be useful to put each
> device belonging to a guest in a unique domain.  Especially as qemu
> grows support for iommu emulation, and guest OSes begin to understand
> how to use a hw iommu.
>    

Right, we need to keep flexibility.

>>> And then there's the fact that it is possible to have multiple disjoint iommus on a system,
>>> so it may not even be possible to bring 2 devices under one domain.
>>>        
>> That's indeed a deficiency.
>>      
> Not sure it's a deficiency.  Typically to share page table mappings
> across multiple iommu's you just have to do update/invalidate to each
> hw iommu that is sharing the mapping.  Alternatively, you can use more
> memory and build/maintain identical mappings (as Tom alludes to below).
>    

Sharing the page tables is just an optimization, I was worried about 
devices in separate domains not talking to each other.  if ATS fixes 
that, great.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

