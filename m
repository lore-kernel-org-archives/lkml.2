Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1KCN3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:29:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1KCN3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:29:19 -0400
Date: Thu, 3 Nov 2011 15:30:16 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] virtio-pci: flexible configuration layout
Message-ID: <20111103133015.GL18296@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
 <20111101114542.GA13434@redhat.com>
 <1320150813.3847.24.camel@lappy>
 <20111101124223.GA14060@redhat.com>
 <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
 <1320279543.31237.14.camel@lappy>
 <20111103103314.GA18296@redhat.com>
 <1320318591.29407.17.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320318591.29407.17.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2. Move device specific features into the device specific region.
> Currently the features field is a mix between virtio-pci and device
> specific features.

A single feature field with bits partitioned to transport
specific and device specific fields is a generic virtio
thing. So there's relatively little to be gained from
moving the device bits out.

> I did more similar things in the spec suggestion I've sent,

What lacked there is the motivation.

I am aware of several issues that need to be addressed,
as they block extending virtio going forward:
- There's no place to put more transport registers.
  For MSIX I hacked around that with moving device config when a feature
  bit is set, but in hindsight this setup is fragile
  and is panful to extend any further.
  Splitting out device and transport helps.
- PIO space is limited. We are wasting it on non data path
  configuration. There might also be a wish to have largish data
  in configuration space, like a 1024 byte ID field.
- PIO is faster than MMIO on x86 KVM so we need to keep
  using it for data path on that architecture
- Support architectures which have host/guest at different
  endian-ness.

I addressed the first 3 and added capability infrastructure
which we can use in the future to support the last one
(by nature of using little endian format for capabilities).

> could you
> look at the second part for more ideas please?

I saw the per-queue features - but I don't see how it will work really
or what is the issue they solve.
Any more ideas I missed?

> -- 
> 
> Sasha.
