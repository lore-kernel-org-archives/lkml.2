Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab1JDP7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:59:55 -0400
Received: from kanga.kvack.org ([205.233.56.17]:45845 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab1JDP7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:59:54 -0400
Date: Tue, 4 Oct 2011 11:59:53 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jon Mason <mason@myri.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using "performance" settings
Message-ID: <20111004155953.GG19130@kvack.org>
References: <1317653420-21404-3-git-send-email-mason@myri.com> <20111003215547.GA3107@myri.com> <20111004144215.GE19130@kvack.org> <1317743522.29415.225.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317743522.29415.225.camel@pasglop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 05:52:02PM +0200, Benjamin Herrenschmidt wrote:
> Hi Ben !

Hey Ben as well!

> I beg to disagree :) See below.
> 
> >  Here's why: I am actually implementing a PCIe nic on an FPGA at 
> > present, and have just been in the process of tuning how memory read 
> > requests are issued and processed.  It is perfectly valid for a PCIe 
> > endpoint to issue a read request for an entire 4KB block (assuming it 
> > respects the no 4KB boundary crossings rule), even when the MPS setting 
> > is only 64 or 128 bytes.
> 
> But not if the Max Read Request Size of the endpoint is clamped which
> afaik is the whole point of the exercise.

Yes, that is true.  However, from a performance point of view, clamping 
the maximum read size has a large, negative effect.  Going from 32 dword 
reads to full packet sized reads in my project meant the difference of 
50MB/s vs 110MB/s on gige with 1500 byte packets.

> Hence the clamping of MRRS which is done by Jon's patch, the patch
> referenced here by me additionally prevents drivers who blindly try to
> set it back to 4096 to also be appropriately limited.

I have checked, and the large read requests are supported by all the systems 
I have access to (mix of 2-5 year old hardware).

> Note that in practice (though I haven't put that logic in Linux bare
> metal yet), pHyp has an additional refinement which is to "know" what
> the real max read response of the host bridge is and only clamp the MRRS
> if the MPS of the device is lower than that. In practice, that means
> that we don't clamp on most high speed adapters as our bridges never
> reply with more than 512 bytes in a TLP, but this will require passing
> some platforms specific information down which we don't have at hand
> just yet.

My concern, which I forgot to put in the original message is that allowing 
a bridge to have a large MPS than the endpoints will result in things 
failing when a large write occurs.  Aiui, we don't restrict the size of 
memcpy_toio() type functions, and there are PCIe devices which do not 
perform DMA.  Clamping MPS on the bridge is a requirement of correctness.

> This is really the only way to avoid bogging everybody down to 128 bytes
> if you have one hotplug leg on a switch or one slow device. For example
> on some of our machines, if we don't apply that technique, the PCI-X ->
> USB leg of the main switch will cause everything to go down to 128
> bytes, including the on-board SAS controllers. (The chipset has 6 host
> bridges or so but all the on-board stuff is behind a switch on one of
> them).

The difference in overhead between 128 and 256 byte TLPs isn't that great.  
64 bytes is pretty bad, I'd agree.  That said, I'd be interested in seeing 
how things measure up when you have the PCIe link busy in both directions.

		-ben
