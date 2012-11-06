Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab2KFNQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:16:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48333 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2KFNQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:16:44 -0500
Date: Tue, 6 Nov 2012 13:16:34 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Shea Levy <shea@shealevy.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121106131634.GA1818@srcf.ucam.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <20121031150201.GA12394@srcf.ucam.org>
 <alpine.LNX.2.00.1211061350100.24253@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211061350100.24253@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 01:51:15PM +0100, Jiri Kosina wrote:
> On Wed, 31 Oct 2012, Matthew Garrett wrote:
> > shim generates a public and private key. 
> 
> It seems to me that this brings quite a huge delay into the boot process 
> both for "regular" and resume cases (as shim has no way to know what is 
> going to happen next). Mostly because obtaining enough entropy is 
> generally very difficult when we have just shim running, right?

pseudorandom keys should be sufficient here. It's intended to deal with 
the case of an automated attack rather than a deliberate effort to break 
into a given user's system.

> > It hands the kernel the private key in a boot parameter and stores the 
> > public key in a boot variable. On suspend, the kernel signs the suspend 
> > image with that private key and discards it. On the next boot, shim 
> > generates a new key pair and hands the new private key to the kernel 
> > along with the old public key. The kernel verifies the suspend image 
> > before resuming it. The only way to subvert this would be to be able to 
> > access kernel memory directly, which means the attacker has already won.
> 
> I like this protocol, but after some off-line discussions, I still have 
> doubts about it. Namely: how do we make sure that there is noone tampering 
> with the variable?

The variable has the same level of security as MOK, so that would be a 
more attractive target.

> - consider securely booted win8 (no Linux installed on that machine, so 
>   the variable for storing public key doesn't exist yet), possibly being 
>   taken over by a malicious user
> - he/she creates this secure variable from within the win8 and stores 
>   his/her own public key into it

You can't create a non-RT variable from the OS.

> - he/she supplies a signed shim (as provided by some Linux distro vendor), 
>   signed kernel (as provided by some Linux distro vendor) and specially 
>   crafted resume image, signed by his/her own private key

shim detects that the key has the RT bit set and deletes it.

> - he/she reboots the machine in a way that shim+distro kernel+hacker's S4 
>   image is used to resume

And so this step can't happen.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
