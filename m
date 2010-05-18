Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0ERQwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:52:25 -0400
Received: from smtp125.mail.ukl.yahoo.com ([77.238.184.56]:25084 "HELO
	smtp125.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754124Ab0ERQwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:52:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=xrDCPv+ZVzcPIWp6aMjaTHCCFEbuN8sZCfS/rSXFJQyeKN5cMj7rL7vLSCIAdil5AjWTnEkROuOMPAg3e6l2fC1mUG5OsxJnBAOuN9/Ew6sTskgK1J8HG/KIH5Q1qzZuwJ3R2hW9iKqcTSAGp3UrTyFF1MqBdWAvJG4Rk1Ar8Nk=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: PhvRauIVM1mFnWUcLsFwiXgt.JpaqsKpi8tnvC0930CqI6tAknTsbr8Gajw81EFetbJ3CMRTmQXX7140ONxmzpSv2vZEIuhnTosu1VeKkqmCh0vHEJmyTpW7ldNIEv7aUJkjvjyctHLFS7K_3f5asRFznbD7vxlhpRW0ctC9AScUxiHijtGKkNPHrOklxxVESF.jOjp7ipjL8mDdtP412fooNHJ28nJcrxdPQBuwfLo7m2gUt5aXr6foqiIzSF3UNm7twdMhNpQWVKmWKeklWeoQn8toJrEv
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BF2C5C1.2020807@yahoo.es>
Date: Tue, 18 May 2010 18:52:17 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: konrad.wilk@oracle.com, Ian.Campbell@eu.citrix.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org,
       linux@arm.linux.org.uk
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions visible
 in the header file.
References: <4BE9A989.5020808@yahoo.es>	<20100511193918.GA4166@phenom.dumpdata.com>	<4BEB884B.7030402@yahoo.es> <20100518123010G.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100518123010G.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/18/2010 05:28 AM, FUJITA Tomonori wrote:
>> The whole series work fine on the Wii 32-bit PowerPC platform (used to implement the MEM2 DMA facility needed by its EHCI controller).
>>
>> Tested-by: Albert Herranz <albert_herranz@yahoo.es>
> 
> I know that you decrease the swiotlb size from 64MB (default) to 1MB,
> however, pre-allocating 1MB is too wasteful to Wii?
> 

Every single KB counts on the Wii. It has just 24MB of MEM1 and 64MB of MEM2 (discontiguous memory ranges).
I'm using 1MB for the SWIOTLB for now, but of course that can be further tweaked down.

> Wii's EHCI controller connects to storage devices? If not, what you
> need is the facility to do bouncing with dynamically allocated memory
> such as the network stack, the block layer and
> arm/arm/common/dmabounce.c
> 

The two external USB ports in the Wii are part of an embedded EHCI controller (with its two OHCI companion controllers). You can connect whatever USB device you want to them.

I posted (in the past) a patch series [1] in which I made the dmabounce code in the ARM architecture tree available to other architectures, and used that to implement the needed bouncing infrastructure.
But I was told then by Russell to use swiotlb instead [2].

Either if dmabounce or swiotlb is used, what's needed in the end is a way to allocate coherent buffers from a specific part of memory (MEM2) and to bounce buffers to/from MEM2 as needed.
This is currently solved by using struct dma_map_ops + swiotlb as a bounce buffer implementation, placing the swiotlb area in MEM2.
Coherent memory is allocated from a dedicated pool of MEM2 (currently using the generic per-device dma coherent allocator).

Cheers,
Albert

[1] http://marc.info/?l=linux-usb&m=126736610418835
[2] http://marc.info/?l=linux-usb&m=126736687519788
