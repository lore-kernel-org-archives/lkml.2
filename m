Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1IMOBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:01:20 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39355 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899Ab1IMOBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:01:19 -0400
Subject: Re: [PATCH v2 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
In-Reply-To: <20110913132931.GA5203@srcf.ucam.org>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
	 <1315838094-2307-11-git-send-email-matt@console-pimps.org>
	 <20110913132931.GA5203@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 15:01:16 +0100
Message-ID: <1315922476.3466.60.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 14:29 +0100, Matthew Garrett wrote:
> On Mon, Sep 12, 2011 at 03:34:54PM +0100, Matt Fleming wrote:
> 
> > +	status = efi_call_phys5(sys_table->boottime->locate_handle,
> > +				EFI_LOCATE_BY_PROTOCOL, proto,
> > +				NULL, &size, gop_handle);
> > +	if (status != EFI_SUCCESS)
> > +		goto free_handle;
> > +
> > +	nr_gops = size / sizeof(void *);
> > +	for (i = 0; i < nr_gops; i++) {
> > +		void *h = gop_handle[i];
> > +
> > +		status = efi_call_phys3(sys_table->boottime->handle_protocol,
> > +					h, proto, &gop);
> > +		if (status != EFI_SUCCESS)
> > +			continue;
> > +
> > +		status = efi_call_phys4(gop->query_mode, gop, gop->mode->mode,
> > +					&size, &info);
> > +		if (status == EFI_SUCCESS)
> > +			break;
> > +	}
> 
> Apple do something funky here, which is to provide a GOP that's not 
> backed by real hardware but which muxes writes out to multiple outputs 
> in order to handle the multiple display case without screwing up aspect 
> ratio. That's fine, except that the stride reported for the fake one is 
> just the horizontal width of the logical display. That results in things 
> failing badly. The real one also implements PCIIO. My workaround so far 
> has been to look for a GOP that handles PCIIO and use it if found, and 
> otherwise just fall back to the first GOP.

Ah right, thanks for that. I actually implement that strategy when
searching for a UGA (checking for PCIIO) but without falling back to the
first one if no PCIIO protocol is found. Your proposed scheme seems much
more robust so I'll respin this patch.

-- 
Matt Fleming, Intel Open Source Technology Center

