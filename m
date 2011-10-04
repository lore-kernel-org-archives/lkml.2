Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1JDQUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:20:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:42628 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab1JDQUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:20:15 -0400
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using
 "performance" settings
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jon Mason <mason@myri.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
In-Reply-To: <20111004155953.GG19130@kvack.org>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
	 <20111003215547.GA3107@myri.com> <20111004144215.GE19130@kvack.org>
	 <1317743522.29415.225.camel@pasglop>  <20111004155953.GG19130@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 18:19:57 +0200
Message-ID: <1317745197.29415.244.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 11:59 -0400, Benjamin LaHaise wrote:

> Yes, that is true.  However, from a performance point of view, clamping 
> the maximum read size has a large, negative effect.  Going from 32 dword 
> reads to full packet sized reads in my project meant the difference of 
> 50MB/s vs 110MB/s on gige with 1500 byte packets.

It depends how badly it's clamped and it's a tradeoff vs. clamping (or
not) the MPS. Ie. in our case it avoids clamping the MPS down to 128.

> > Hence the clamping of MRRS which is done by Jon's patch, the patch
> > referenced here by me additionally prevents drivers who blindly try to
> > set it back to 4096 to also be appropriately limited.
> 
> I have checked, and the large read requests are supported by all the systems 
> I have access to (mix of 2-5 year old hardware).

Yes, again, we only do that clamping on MRRS when the "performance" mode
is enabled explicitely. In any other case, we leave that alone and we
allow drivers to set it to 4K if they wish to do so.

> > Note that in practice (though I haven't put that logic in Linux bare
> > metal yet), pHyp has an additional refinement which is to "know" what
> > the real max read response of the host bridge is and only clamp the MRRS
> > if the MPS of the device is lower than that. In practice, that means
> > that we don't clamp on most high speed adapters as our bridges never
> > reply with more than 512 bytes in a TLP, but this will require passing
> > some platforms specific information down which we don't have at hand
> > just yet.
> 
> My concern, which I forgot to put in the original message is that allowing 
> a bridge to have a large MPS than the endpoints will result in things 
> failing when a large write occurs.  Aiui, we don't restrict the size of 
> memcpy_toio() type functions, and there are PCIe devices which do not 
> perform DMA.  Clamping MPS on the bridge is a requirement of correctness.

Yes, this is a problem if your bridge can generate large writes. Ours
can't so this is safe. Our bridges can't write combine beyond 128 bytes.

Originally, I had that whole logic implemented in arch specific code,
but when Jon started fiddling with MPS/MRRS in generic code, I suggested
to have the generic code have the option of doing what I want. Maybe we
should remove it completely as a user-visible option and leave it back
to platform code only. In any case, it isn't the default.

> > This is really the only way to avoid bogging everybody down to 128 bytes
> > if you have one hotplug leg on a switch or one slow device. For example
> > on some of our machines, if we don't apply that technique, the PCI-X ->
> > USB leg of the main switch will cause everything to go down to 128
> > bytes, including the on-board SAS controllers. (The chipset has 6 host
> > bridges or so but all the on-board stuff is behind a switch on one of
> > them).
> 
> The difference in overhead between 128 and 256 byte TLPs isn't that great.

Our performance guys say that between 128 and 512 or 2048 which is what
we face in some cases here, it's worth it. I haven't yet had a chance to
verify by myself.

> 64 bytes is pretty bad, I'd agree.  That said, I'd be interested in seeing 
> how things measure up when you have the PCIe link busy in both directions.

When I get the HW support for some of those new platforms in a more
final shape and a bit more time (ie after I'm back from travelling :-) I
should be able to do better measurements with some 10GE adapters for
example, or with our RAID controllers.

Cheers,
Ben.


