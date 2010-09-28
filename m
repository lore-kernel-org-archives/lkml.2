Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab0I1GfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:35:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58287 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0I1Ge6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K/ddSKnhxsk9I8ruGA6Swpkq3Db8I9YbqpDqMcDrNFVDBg9MTqr+kM/DTgAzcDoLF3
         YnFPRJYrQTvdV3GL4/IWVJprj48dT0MHW4lieFjHXlZdv4/IjjW5xr7Fch3dHd57tv58
         0HDmbR+3T+cfCgeHKz4iFu3ofH8cSTuDJ9fIc=
Date: Tue, 28 Sep 2010 08:34:49 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: "M. Warner Losh" <imp@bsdimp.com>
Cc: cl@linux.com, johnstul@us.ibm.com, giometti@linux.it, peterz@infradead.org,
        linux-api@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, tglx@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        khc@pm.waw.pl
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
Message-ID: <20100928063449.GA7224@riccoc20.at.omicron.at>
References: <alpine.DEB.2.00.1009231533040.7522@router.home>
 <1285278136.2587.154.camel@localhost.localdomain>
 <alpine.DEB.2.00.1009271038150.9258@router.home>
 <20100927.101423.702773873740300798.imp@bsdimp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927.101423.702773873740300798.imp@bsdimp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:14:23AM -0600, M. Warner Losh wrote:
> 
> This is a common error that I've seen repeated in this thread.  The
> only reason that it has historically been important is because when
> you are doing timestamping in software based on an interrupt, that
> stuff does matter.

Yes, thanks for your helpful explanation.

To further illustrate how small the effect of running the servo in
user space is, consider the following.

It is true that delays and jitter in the time to process the received
packet negatively affect the clock servo loop. However, the effect in
our case will be quite small.

John Eidson's book [1] presents a rigorous servo model that includes
an analysis of the delay from the time the samples (timestamps) are
taken until the corrective action is performed by the PTP software.

For PTP, the sample time is at the sender (the remote host, the master
clock). The master sends *two* packets, where the second one (the so
called follow-up packet) contains the hardware time stamp of the first
one. So, the computational delay includes the time spent by the sender
in its PTP stack preparing the second packet, the time the packet
spends in transit, and the time in the receiver's PTP stack and servo.

According to Eidson's analysis, a delay of up to 10 milliseconds would
be acceptable, even with a sample rate of 10 Hz. Therefore, saving a
few dozen microseconds by placing the servo (and PTP stack) into the
kernel is not worth the effort.

Richard


[1] title =     {Measurement, control, and communication using IEEE 1588},
    author =    {J. C. Eidson},
    year =      2006,
    publisher = {Springer-Verlag},
