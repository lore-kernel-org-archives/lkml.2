Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0DZXvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:51:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0DZXvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:51:20 -0400
Message-ID: <a96459c7f3573eef81dd6d6c4e3dedd8.squirrel@www.zytor.com>
In-Reply-To: <20100426162517.4ad308ff@virtuousgeek.org>
References: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com>
    <20100426162517.4ad308ff@virtuousgeek.org>
Date: Mon, 26 Apr 2010 16:49:55 -0700
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below   
 BIOS_END
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Andy Isaacson" <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       "Yinghai" <yinghai.lu@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, guenter.roeck@ericsson.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas Renninger" <trenn@suse.de>, yaneti@declera.com
User-Agent: SquirrelMail/1.4.20-1.fc11
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (terminus.zytor.com [127.0.0.1]); Mon, 26 Apr 2010 16:50:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, sounds like we're talking about a few different things here:
>   1) devices which sit in e820 reserved space (whether at < 1M or > 1M)
>   2) devices which sit in e820 ram or other space below 1M
>   3) how to hand out space from the 0-1M region
>
> Bjorn's patch fixes (3) so that regular PCI devices don't get space
> there, which makes sense.
>
> Some devices may be in the special region, but were pointed there by
> the BIOS.  Generally this should be ok, so drivers requesting this
> space should be allowed to get at it, but we should avoid putting
> anything else there.
>
> And below it sounds like you're talking about (1).  If so, then yes I
> guess we need a solution there, which will allow drivers to bind to
> these "reserved" devices, even though the BIOS has marked them as off
> limits, at least as far as e820 goes.
>
> So perhaps both (1) and (2) could be put into a new, special IO
> resource space, or could use a new flag, since "busy" doesn't really
> reflect what's going on there very well, as Bjorn pointed out.
>
> Jesse

Properly done, these aren't separate cases at all.

The E820 interface as specified doesn't reserve the address space below 1
MB, because it is legacy space -- which is another way of saying "everyone
already knows to reserve it."  The Right Thing[TM] to do is simply to
modify the data output by E820 to reserve all non-memory space below 1 MB;
this can (and should) be done in platform-specific initialization code to
allow overrides.

Once that is done, both your (2) and (3) cases are nothing but special
subcases of (1).  That's what I would like to see as the right solution,
but it is clearly too late to do that in .34.

Bjorn's solution is very attractive for .34 since it is so simple, but
it's not a complete solution.

        -hpa
