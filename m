Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2HUOlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:41:23 -0400
Received: from mga06.intel.com ([134.134.136.21]:43525 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754898Ab2HUOlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:41:20 -0400
Subject: Re: [PATCH] x86: efi: Turn off efi_enabled after setup on mixed
 fw/kernel
From: Matt Fleming <matt.fleming@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mk@dee.su,
        Marko Kohtala <marko.kohtala@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, Peter Jones <pjones@redhat.com>
In-Reply-To: <CAOesGMiUOfg9aNjtsah-n_k-Uqbp4veppxgU=dDUOxBGyB5PxQ@mail.gmail.com>
References: <1345412920-10906-1-git-send-email-olof@lixom.net>
	 <50320DBD.5080507@canonical.com>
	 <CAOesGMiUOfg9aNjtsah-n_k-Uqbp4veppxgU=dDUOxBGyB5PxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Tue, 21 Aug 2012 15:39:00 +0100
Message-ID: <1345559940.3088.56.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 14:59 -0700, Olof Johansson wrote:
> > From a quick glance with some grepping, efi reboot and efifb will
> > also no longer work, is that intentional?
> 
> That's the very point of this patch, the EFI services won't work since
> there are no runtime services in this state, just boot time setup. If
> efi_enabled is left on, the reboot will panic.

But efifb should still work without EFI runtime services, no? I see this
in setup_arch(),

#ifdef CONFIG_VT                                                                
#if defined(CONFIG_VGA_CONSOLE)                                                 
        if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY)) 
                conswitchp = &vga_con;                                          
#elif defined(CONFIG_DUMMY_CONSOLE)                                             
        conswitchp = &dummy_con;                                                
#endif                                                                          
#endif                                   

but efi_enabled check looks bogus now that efi_enabled has come to mean
"EFI services available?". If we've been passed the dimensions of the
EFI framebuffer I'm unaware of a reason we can't use it.

