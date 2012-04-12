Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965982Ab2DLUQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:16:13 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63954 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965873Ab2DLUQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:16:12 -0400
Date: Thu, 12 Apr 2012 22:15:33 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com
Subject: Re: [PATCH V4 1/3] x86: introduce CONFIG_X86_DEV_DMA_OPS
Message-ID: <20120412201533.GA26533@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4F87186B.9010303@zytor.com>
References: <4F87186B.9010303@zytor.com>
  <cover.1331622735.git.rubini@gnudd.com>
 <5965c5b1f828732b3599131fb21070aba6f1a386.1331622735.git.rubini@gnudd.com>
 <20120314065614.GB27480@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Anvin:
> I looked over it, and at least this bit seems okay to me.
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Thanks.

> I have to express some concern about where this device may be going,
> though.

Well, this CONFIG_X86_DEV_DMA_OPS in particular should not be
concerning, as it's just separating out an x86-64 ifdef so it can be
used and activated by 32-bit systems as well.

As for "this device", it's an I/O Hub that can be used as main chipset
on Atom computers, mainly aimed at the automotive sector. It is a
typical ARM SoC with the usual set of internal peripherals, mounted on
a bridge between PCIe and AMBA, so the PCIe host can access the SoC
peripherals -- and SoC peripherals can DMA to PCIe memory.  Actually,
some SoC devices work well using the existing amba drivers, with
minimal changes that I plan to clean up and submit soon.

The strange DMA requirements here depend on the size limits of the
respective windows: SoC devices can only access a 512MB window of the
host memory, so we need to take care of this with special options.

The current approach is using swiotlb and it works pretty well, though
with a limit of 4MB of swiotlb area.  I've been considering use of the
DMA zone to this aim: internally I have some half-working thing that
resuses the ISA DMA zone for our own aims, raising the DMA limit to
512MB.

Do you think the approach may make sense? I use this basic
thing in Kconfig, to rely on GFP_DMA for the rest:

  config MAX_DMA_PADDR
          int
          default 536870912 if MAX_DMA_PADDR_512M
          default 16777216

  config MAX_DMA_PADDR_512M
          bool

(actually, we'd benefit from being able to use hex in defaults)

Is this worth exploring, to possibly submit a patch in this direction?

thanks
/alessandro
