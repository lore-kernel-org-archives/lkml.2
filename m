Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab1JDQow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:44:52 -0400
Received: from kanga.kvack.org ([205.233.56.17]:52009 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932919Ab1JDQob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:44:31 -0400
Date: Tue, 4 Oct 2011 12:44:30 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jon Mason <mason@myri.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using "performance" settings
Message-ID: <20111004164430.GH19130@kvack.org>
References: <1317653420-21404-3-git-send-email-mason@myri.com> <20111003215547.GA3107@myri.com> <20111004144215.GE19130@kvack.org> <1317743522.29415.225.camel@pasglop> <20111004155953.GG19130@kvack.org> <1317745197.29415.244.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317745197.29415.244.camel@pasglop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 06:19:57PM +0200, Benjamin Herrenschmidt wrote:
> On Tue, 2011-10-04 at 11:59 -0400, Benjamin LaHaise wrote:
...
> > My concern, which I forgot to put in the original message is that allowing 
> > a bridge to have a large MPS than the endpoints will result in things 
> > failing when a large write occurs.  Aiui, we don't restrict the size of 
> > memcpy_toio() type functions, and there are PCIe devices which do not 
> > perform DMA.  Clamping MPS on the bridge is a requirement of correctness.
> 
> Yes, this is a problem if your bridge can generate large writes. Ours
> can't so this is safe. Our bridges can't write combine beyond 128 bytes.

> Originally, I had that whole logic implemented in arch specific code,
> but when Jon started fiddling with MPS/MRRS in generic code, I suggested
> to have the generic code have the option of doing what I want. Maybe we
> should remove it completely as a user-visible option and leave it back
> to platform code only. In any case, it isn't the default.

Ah, I see now.  Yes, if that can be put into arch specific code, it makes 
far more sense since things will work correctly assuming the bridge also 
limits read completions with data to 128 bytes?

> Our performance guys say that between 128 and 512 or 2048 which is what
> we face in some cases here, it's worth it. I haven't yet had a chance to
> verify by myself.

Just to give you an idea of the problems with generating small read 
read requests: the on-the-wire cost of sending a 1500 byte ethernet packet 
with 128 byte read requests is the difference between 1x 12-16 byte TLP 
on the transmit link of the endpoint vs 12x 12-16 byte TLPs (the overhead 
for a TLP is at least 8 bytes of header and CRC iirc, maybe more for the 
DLLP flag bytes) or going from 20-24 bytes per tx packet to 256-288 bytes 
of read requests.  This won't matter much for devices with lots of excess 
bandwidth, but for PCIe 1x devices (ie common gige chipsets) that really 
hurts.  It also means that only 2 or 3 packets can have read requests 
outstanding with the default limit of 32 tags, but hopefully the device 
supports extended tags.

		-ben
