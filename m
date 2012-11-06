Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2KFMv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:51:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2KFMvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:51:25 -0500
Date: Tue, 6 Nov 2012 13:51:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Shea Levy <shea@shealevy.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <20121031150201.GA12394@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.1211061350100.24253@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz> <20121031150201.GA12394@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Matthew Garrett wrote:

> > Reading stored memory image (potentially tampered before reboot) from disk 
> > is basically DMA-ing arbitrary data over the whole RAM. I am currently not 
> > able to imagine a scenario how this could be made "secure" (without 
> > storing private keys to sign the hibernation image on the machine itself 
> > which, well, doesn't sound secure either).
> 
> shim generates a public and private key. 

It seems to me that this brings quite a huge delay into the boot process 
both for "regular" and resume cases (as shim has no way to know what is 
going to happen next). Mostly because obtaining enough entropy is 
generally very difficult when we have just shim running, right?

> It hands the kernel the private key in a boot parameter and stores the 
> public key in a boot variable. On suspend, the kernel signs the suspend 
> image with that private key and discards it. On the next boot, shim 
> generates a new key pair and hands the new private key to the kernel 
> along with the old public key. The kernel verifies the suspend image 
> before resuming it. The only way to subvert this would be to be able to 
> access kernel memory directly, which means the attacker has already won.

I like this protocol, but after some off-line discussions, I still have 
doubts about it. Namely: how do we make sure that there is noone tampering 
with the variable?

Obvious step towards solving this is making the variable inaccessible 
after ExitBootServices() has been called (by not setting runtime access 
flag on it).

Now how about this scenario:

- consider securely booted win8 (no Linux installed on that machine, so 
  the variable for storing public key doesn't exist yet), possibly being 
  taken over by a malicious user
- he/she creates this secure variable from within the win8 and stores 
  his/her own public key into it
- he/she supplies a signed shim (as provided by some Linux distro vendor), 
  signed kernel (as provided by some Linux distro vendor) and specially 
  crafted resume image, signed by his/her own private key
- he/she reboots the machine in a way that shim+distro kernel+hacker's S4 
  image is used to resume
- distro kernel verifies the signature of the S4 image against the 
  attacker's public key stored in the variable; the signature is OK
- he/she has won, as he has managed to run an arbitrary kernel code 
  (stored in the S4 image) in a trusted mode

No?

Basically, once the machine is already populated with the "secure" version 
of Linux, this can't happen, as we will (as far as I understand) set the 
variable for storing the public key in a way that it can't be accessed 
from runtime environment. But how can we prevent it being *created* before 
the machine is ever touched by Linux?

Thanks,

-- 
Jiri Kosina
SUSE Labs
