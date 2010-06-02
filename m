Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab0FBDA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 23:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387Ab0FBDAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 23:00:55 -0400
Message-ID: <4C05C925.6080006@redhat.com>
Date: Wed, 02 Jun 2010 05:59:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tom Lyon <pugs@lyon-about.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com, alex.williamson@redhat.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <20100530124949.GI27611@redhat.com> <4C04E0E0.3070006@redhat.com> <20100601104651.GA9415@redhat.com> <201006011426.53563.pugs@lyon-about.com>
In-Reply-To: <201006011426.53563.pugs@lyon-about.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 12:26 AM, Tom Lyon wrote:
>
> I'm not really opposed to multiple devices per domain, but let me point out how I
> ended up here.  First, the driver has two ways of mapping pages, one based on the
> iommu api and one based on the dma_map_sg api.  With the latter, the system
> already allocates a domain per device and there's no way to control it. This was
> presumably done to help isolation between drivers.  If there are multiple drivers
> in the user level, do we not want the same isoation to apply to them?
>    

In the case of kvm, we don't want isolation between devices, because 
that doesn't happen on real hardware.  So if the guest programs devices 
to dma to each other, we want that to succeed.

> Also, domains are not a very scarce resource - my little core i5 has 256,
> and the intel architecture goes to 64K.
>    

But there is a 0.2% of mapped memory per domain cost for the page 
tables.  For the kvm use case, that could be significant since a guest 
may have large amounts of memory and large numbers of assigned devices.

> And then there's the fact that it is possible to have multiple disjoint iommus on a system,
> so it may not even be possible to bring 2 devices under one domain.
>    

That's indeed a deficiency.

> Given all that, I am inclined to leave it alone until someone has a real problem.
> Note that not sharing iommu domains doesn't mean you can't share device memory,
> just that you have to do multiple mappings
>    

I think we do have a real problem (though a mild one).

The only issue I see with deferring the solution is that the API becomes 
gnarly; both the kernel and userspace will have to support both APIs 
forever.  Perhaps we can implement the new API but defer the actual 
sharing until later, don't know how much work this saves.  Or Alex/Chris 
can pitch in and help.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

