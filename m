Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1KXU5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 15:57:09 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40595 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794Ab1KXU5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 15:57:07 -0500
Subject: Re: [PATCH v5 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>,
        Peter Jones <pjones@redhat.com>
In-Reply-To: <4ECE5803.3060203@gmail.com>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
	 <1318848017-12301-11-git-send-email-matt@console-pimps.org>
	 <4E9C8AAC.7080803@gmail.com>
	 <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4ECC4207.3010607@gmail.com>
	 <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4ECE5803.3060203@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 20:56:56 +0000
Message-ID: <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 15:43 +0100, Maarten Lankhorst wrote:
> Hey Matt,
> 
> On 11/23/2011 08:27 PM, Matt Fleming wrote:
> 
> > On Wed, 2011-11-23 at 01:44 +0100, Maarten Lankhorst wrote:
> >> When I tested this with v3.2-rc2 it didn't boot, it hung before it
> >> initialized the kernel.
> >> Without initrd it works fine, though.
> > Bah, so this change actually makes booting worse? You said before that
> > you almost made it to userspace but this seems to hang much earlier now.
> > Is that correct?
> >
> > ... back to the drawing board.
> I was looking at why grub2 could boot, seems to be it reads in chunks of
> 256 kilobytes. I seem to be able to get it to boot with chunks of 4 mb
> as well, but didn't test beyond that.
> 
> So the fix is to simply read the file in parts, otherwise efi hangs..
> As a nice side effect, short reads are also handled, but the efi
> firmware seems to choke over huge reads and dies.

Urrggghh.....

Thanks a lot for diagnosing this, Maarten! The copy of grub that I have
(fedora's version) looks like it uses the disk_io protocol to read from
disks, I wonder if there's a reason for this. I Cc'd Peter Jones in case
he's seen anything like this before.

Aha, read_file() in the elilo source contains this helpful comment,

	/*                                                                      
         * We load by chunks rather than a single big read because              
         * early versions of EFI had troubles loading files                     
         * from floppies in a single big request.  Breaking                     
         * the read down into chunks of 4KB fixed that                          
         * problem. While this problem has been fixed, we still prefer          
         * this method because it tells us whether or not we're making          
         * forward progress.                                                    
         */

(but reading the code it's clear it uses a chunk size of 16KB, not 4KB)

So, it looks like it's not just reading from floppies that hits this bug
in the firmware.

Maarten, could you send a patch against the 'x86/efi-stub' branch at
git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/linux.git that
splits the read up into 16KB chunks and explains,

	- why we need to do the reading in chunks
	- why we chose the 16KB chunk size (because elilo said so)

That way, the bug fix will be properly documented and attributed to you.

-- 
Matt Fleming, Intel Open Source Technology Center

