Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0JKVU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:20:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab0JKVUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:20:25 -0400
Date: Mon, 11 Oct 2010 17:20:06 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
Message-ID: <20101011212006.GB23882@redhat.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
 <1286606987-19879-5-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286606987-19879-5-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 02:49:46PM +0800, Huang Ying wrote:
> In general, unknown NMI is used by hardware and firmware to notify
> fatal hardware errors to OS. So the Linux should treat unknown NMI as
> hardware error and go panic upon unknown NMI for better error
> containment.
> 
> But there are some broken hardware, which will generate unknown NMI
> not for hardware error. To support these machines, a white list
> mechanism is provided to treat unknown NMI as hardware error only on
> some known working system.
> 
> These systems are identified via the presentation of APEI HEST or
> some PCI ID of the host bridge. The PCI ID of host bridge instead of
> DMI ID is used, so that the checking can be done based on the platform
> type instead of motherboard. This should be simpler and sufficient.
> 
> The method to identify the platforms is designed by Andi Kleen.

I don't have any major problems with the other patches in the patch
series.  In fact I would like to get them committed somewhere, so we can
continue building on them.

> @@ -366,6 +368,15 @@ unknown_nmi_error(unsigned char reason,
>  	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
>  			NOTIFY_STOP)
>  		return;
> +	/*
> +	 * On some platforms, hardware errors may be notified via
> +	 * unknown NMI
> +	 */
> +	if (unknown_nmi_as_hwerr)
> +		panic(
> +		"NMI for hardware error without error record: Not continuing\n"
> +		"Please check BIOS/BMC log for further information.");
> +
>  #ifdef CONFIG_MCA
>  	/*
>  	 * Might actually be able to figure out what the guilty party

The only quirk I have left is the above piece, which is basically a
philosophy difference with Robert and myself.  Where we believe it should
be on the die_chain and Andi and yourself would like to see it explicitly
called out.

If we move to a new notifier chain, like we discussed in another thread,
would you guys be willing to move this into that new notifier chain or is
your argument still going to stand?

Cheers,
Don
