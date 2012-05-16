Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab2EPMjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:39:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34726 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab2EPMja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:39:30 -0400
Date: Wed, 16 May 2012 13:39:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, matt.fleming@linux.intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
Message-ID: <20120516123912.GA20990@srcf.ucam.org>
References: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
 <20120515124707.GB25248@srcf.ucam.org>
 <4FB273EB0200007800083D32@nat28.tlf.novell.com>
 <20120515132006.GA26196@srcf.ucam.org>
 <4FB3B734020000780008415D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB3B734020000780008415D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 01:18:28PM +0100, Jan Beulich wrote:

> Okay, looks like calling efi_ioremap() at this point is possible.
> But why is efi_enter_virtual_mode() being called as late as is
> the case currently for x86 anyway?

Assuming that things are as they are for a good reason is not 
necessarily true in the EFI code...

> And then again the current logic in efi_enter_virtual_mode()
> looks flawed (it assumes two contiguous pieces of direct
> mappings, and while on systems with dis-contiguous physical
> memory this currently appears to be true, it's not correct - the
> holes could have MMIO assignments in them - and hence
> shouldn't be relied upon), and I wouldn't want to copy this
> elsewhere.

Could you elaborate on that a little?

> Plus the use of set_virtual_address_map is bogus in the first
> place, as it makes it impossible for a kexec-ed kernel to also
> use EFI services (as it would have to call the function a
> second and possibly third time, yet it is not permitted to be
> called more than once). Imo all calls have to happen in
> physical mode.

Platforms don't correctly deal with the case where you make physical 
calls after ExitBootServices(). We tried running in physical mode. It 
simply doesn't work.

> So I'm afraid if the patch as I provided it isn't acceptable, and
> if the call to efi_enter_virtual_mode() can't be moved ahead
> of the one to timekeeping_init(), this winds down to the whole
> logic needing a re-write.

I have zero objection to this being cleaned up, but I don't know of any 
obvious reason why we can't do enter_virtual_mode() earlier.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
