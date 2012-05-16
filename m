Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab2EPM7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:59:32 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41439 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933417Ab2EPM7a convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 16 May 2012 08:59:30 -0400
Message-Id: <4FB3C0ED020000780008418E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 16 May 2012 13:59:57 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <matt.fleming@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
References: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
 <20120515124707.GB25248@srcf.ucam.org>
 <4FB273EB0200007800083D32@nat28.tlf.novell.com>
 <20120515132006.GA26196@srcf.ucam.org>
 <4FB3B734020000780008415D@nat28.tlf.novell.com>
 <20120516123912.GA20990@srcf.ucam.org>
In-Reply-To: <20120516123912.GA20990@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.05.12 at 14:39, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, May 16, 2012 at 01:18:28PM +0100, Jan Beulich wrote:
> 
>> Okay, looks like calling efi_ioremap() at this point is possible.
>> But why is efi_enter_virtual_mode() being called as late as is
>> the case currently for x86 anyway?
> 
> Assuming that things are as they are for a good reason is not 
> necessarily true in the EFI code...

Okay...

>> And then again the current logic in efi_enter_virtual_mode()
>> looks flawed (it assumes two contiguous pieces of direct
>> mappings, and while on systems with dis-contiguous physical
>> memory this currently appears to be true, it's not correct - the
>> holes could have MMIO assignments in them - and hence
>> shouldn't be relied upon), and I wouldn't want to copy this
>> elsewhere.
> 
> Could you elaborate on that a little?

There are systems where RAM on individual nodes is always
starting at e.g. a 1Tb boundary. Obviously there can (at
least theoretically) be anything in between, and hence
assuming that __va() is usable here is simply wrong, as likely
no mapping was created at all for the hole space (or if there
is one, it would conflict with the one to be established here
in the EfiMemoryMappedIO case).

>> Plus the use of set_virtual_address_map is bogus in the first
>> place, as it makes it impossible for a kexec-ed kernel to also
>> use EFI services (as it would have to call the function a
>> second and possibly third time, yet it is not permitted to be
>> called more than once). Imo all calls have to happen in
>> physical mode.
> 
> Platforms don't correctly deal with the case where you make physical 
> calls after ExitBootServices(). We tried running in physical mode. It 
> simply doesn't work.

Interesting, especially as we're using physical mode exclusively so
far in Xen. That's a platform issue though, and working around
it by (silently!) sacrificing other functionality is questionable imo.
It should at best be an option (default off), so that on systems
where physical mode works, kexec can work too.

>> So I'm afraid if the patch as I provided it isn't acceptable, and
>> if the call to efi_enter_virtual_mode() can't be moved ahead
>> of the one to timekeeping_init(), this winds down to the whole
>> logic needing a re-write.
> 
> I have zero objection to this being cleaned up, but I don't know of any 
> obvious reason why we can't do enter_virtual_mode() earlier.

I shall give that a try then. It would imply that we don't need
phys_efi_get_time() then anymore. I don't have a 32-bit EFI box
though to test that things don't break there...

Jan

