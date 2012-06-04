Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab2FDRNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:13:46 -0400
Received: from li158-162.members.linode.com ([173.230.148.162]:57619 "EHLO
	strelka.plastictigers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2FDRNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:13:45 -0400
Date: Mon, 4 Jun 2012 13:13:44 -0400
From: Marc Butler <marc@plastictigers.com>
To: Sagar Dharia <sdharia@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org, kheitke@codeaurora.org,
        gclemson@audience.com, broonie@opensource.wolfsonmicro.com,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rob@landley.net, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        ohad@wizery.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rusty@rustcorp.com.au, joerg.roedel@amd.com, trenn@suse.de,
        ak@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20120604171344.GA15837@plastictigers.com>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
 <20120601001617.GA16311@plastictigers.com>
 <74993ac9d11db0db7080c0864daef397.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74993ac9d11db0db7080c0864daef397.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 03:21:06AM -0700, Sagar Dharia wrote:
> > The enumeration slim_ch_proto is incorrect. It declares 2 transport
> > protocols which do not exist in the specification: SLIM_HARD_ISO;
> > SLIM_AUTO_ISO.
> 
> The enums are more SW representation (and not 1-1 mapping). Difference
> between HARD_ISO and AUTO_ISO with example:
> Let's say the root frequency is 24.576MHz. then all 4K family channels
> (sample rate multiple of 4K) can run isochronously, and all 11.025KHz
> channel can run with good efficiency.
> So if a client wants 11.025KHz and is does not want to do flow-control at
> this root frequency, then the client can specify AUTO_ISO to get the next
> available isochronous frequency.

I understand it is not a 1-to-1 mapping. However it *is* used as such:

 wbuf[2] = (u8)((segdist & 0xF00) >> 8) | (slc->prop.prot << 4);

which results in NEXT_DEFINE_CHANNEL messages with an invalid TP
field.

More importantly I think it makes it harder to understand the
framework. The concept of HARD_ISO and AUTO_ISO are extensions, and
should really look like such, say perhaps:

enum {
       SLIM_ISO,
       SLIM_PUSH,
       SLIM_PULL,
       SLIM_LOCKED,
       SLIM_ASYNC_SMPLX,
       SLIM_ASYNC_HALF_DUP,
       SLIM_EXT_SMPLX, 
       SLIM_EXT_HALF_DUP,
       SLIM_AUTO_ISO,
       SLIM_USER_DEF_1 = 14,
       SLIM_USER_DEF_2 = 15,
       /* extensions */
       SLIM_HARD_ISO,
       SLIM_AUTO_ISO
};       

> > b) Similarly to (a) the driver may be probed before the device has
> > been given a logical address (LA). This makes sense in the case of
> > driver that turns on the device (say via gpio) once the bus has
> > booted. However, the driver then needs to sit and poll
> > slim_get_logical_addr() until the logical address.
> This is not the case anymore.
> While taking care of the comments for RFC, I have introduced a completion
> that will be signalled when LA is given to the device. The driver can wait
> on that completion (wait_enum) instead of polling.

Yes, my mistake. The driver wouldn't have to poll if there was another
callback. So I don't see how the completion mechanism is superior: it
forces a synchronous interface to asynchronous events, or the driver
developer has to work around it.

-- 
If you wake up and you're not in pain, you know you're dead.
(Russian Proverb)

