Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab1JDPwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:52:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:34233 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab1JDPwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:52:17 -0400
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using
 "performance" settings
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jon Mason <mason@myri.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
In-Reply-To: <20111004144215.GE19130@kvack.org>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
	 <20111003215547.GA3107@myri.com>  <20111004144215.GE19130@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 17:52:02 +0200
Message-ID: <1317743522.29415.225.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 10:42 -0400, Benjamin LaHaise wrote:
> On Mon, Oct 03, 2011 at 04:55:48PM -0500, Jon Mason wrote:
> > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > 
> > When configuring the PCIe settings for "performance", we allow parents
> > to have a larger Max Payload Size than children and rely on children
> > Max Read Request Size to not be larger than their own MPS to avoid
> > having the host bridge generate responses they can't cope with.
> 
> I'm pretty sure that simply will not work, and is an incorrect understanding 
> of how PCIe bridges and devices interact with regards to transaction size 
> limits. 

Hi Ben !

I beg to disagree :) See below.

>  Here's why: I am actually implementing a PCIe nic on an FPGA at 
> present, and have just been in the process of tuning how memory read 
> requests are issued and processed.  It is perfectly valid for a PCIe 
> endpoint to issue a read request for an entire 4KB block (assuming it 
> respects the no 4KB boundary crossings rule), even when the MPS setting 
> is only 64 or 128 bytes.

But not if the Max Read Request Size of the endpoint is clamped which
afaik is the whole point of the exercise.

>   However, the root complex or PCIe bridge *must 
> not* exceed the Maximum Payload Size for any completions with data or 
> posted writes.  Multiple completions are okay and expected for read 
> requests.  If the MPS on the bridge is set to a larger value than 
> what all of the endpoints connected to it, the bridge or root complex will 
> happily send read completions exceeding the endpoint's MPS.  This can and 
> will lead to failure on the parts of endpoints.

Hence the clamping of MRRS which is done by Jon's patch, the patch
referenced here by me additionally prevents drivers who blindly try to
set it back to 4096 to also be appropriately limited.

Note that in practice (though I haven't put that logic in Linux bare
metal yet), pHyp has an additional refinement which is to "know" what
the real max read response of the host bridge is and only clamp the MRRS
if the MPS of the device is lower than that. In practice, that means
that we don't clamp on most high speed adapters as our bridges never
reply with more than 512 bytes in a TLP, but this will require passing
some platforms specific information down which we don't have at hand
just yet.

This is really the only way to avoid bogging everybody down to 128 bytes
if you have one hotplug leg on a switch or one slow device. For example
on some of our machines, if we don't apply that technique, the PCI-X ->
USB leg of the main switch will cause everything to go down to 128
bytes, including the on-board SAS controllers. (The chipset has 6 host
bridges or so but all the on-board stuff is behind a switch on one of
them).

Cheers,
Ben.


