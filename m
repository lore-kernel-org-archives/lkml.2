Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab0FDSIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 14:08:16 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:52171 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0FDSIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 14:08:13 -0400
Subject: Re: [PATCH 04/14] evm: re-release
From: David Safford <safford@watson.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1275664804.21231.61.camel@moss-pluto.epoch.ncsc.mil>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1271886594-3719-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1275661730.21231.32.camel@moss-pluto.epoch.ncsc.mil>
	 <1275663212.3205.12.camel@localhost.localdomain>
	 <1275664804.21231.61.camel@moss-pluto.epoch.ncsc.mil>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Jun 2010 14:08:09 -0400
Message-ID: <1275674889.2644.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 11:20 -0400, Stephen Smalley wrote:
> On Fri, 2010-06-04 at 10:53 -0400, Mimi Zohar wrote:
> > On Fri, 2010-06-04 at 10:28 -0400, Stephen Smalley wrote:
> > > On Wed, 2010-04-21 at 17:49 -0400, Mimi Zohar wrote:
> > > > EVM depends on the Kernel Key Retention System to provide it with the
> > > > kernel master key for the HMAC operation.  The kernel master key is
> > > > securely loaded onto the root's keyring, typically by 'loadkernkey',
> > > > which either uses the TPM sealed secret key, if available, or a
> > > > password requested from the console.  To signal EVM, that the key has
> > > > been loaded onto the keyring, 'echo 1 > <securityfs>/evm'. This is
> > > > normally done in the initrd, which has already been measured as part
> > > > of the trusted boot. (Refer to http://linux-ima.sourceforge.net/#EVM.)
> > > 
> > > I don't remember this dependency on the kernel key system in prior
> > > incarnations of EVM.  Can you explain the rationale for using it, and
> > > the implications?
> > 
> > This changed very early on, so that people without a TPM could 'play'
> > with it.
> 
> The last time EVM was posted to lsm list (2005, AFAICS) prior to this
> year's round, David Safford said:
> "Since the kernel master key is unsealed by the hardware TPM only as a
> result of a valid trusted boot, and the key is never visible outside the
> kernel, the EVM HMAC attribute cannot be forged in an offline attack."
> 
> So that seemed to be an important property to you at the time.  I
> understand providing alternatives for TPM-less systems, but that doesn't
> necessarily mean changing the properties on systems with TPMs.
> 
In it's earliest form we did have an extension to the tpm device driver
to do the unseal, keeping the resultant key entirely in the kernel.
When IMA and EVM were compiled in, and all initialization was done 
within the initrd (which was measured by grub), we thought that doing
the unseal while in the initrd init script which was still single
threaded, was safe enough. (EVM does zero out the key on the ring
after it copies it, so that it is not visible after the boot).
One of our thoughts was to have a common interface for loading the
key, independent of whether it came from a passphrase or TPM.

If you think this is undesirable for TPM based systems, we could
certainly add a securityfs file to evm, through which the init script
could load the encrypted blob. Then evm could have the TPM unseal it
without the key ever being visible outside kernel memory. Alternately
we could simply redefine the contents of the ring evm_key to be the 
encrypted blob, and add a line to evm's initialization to unseal the
blob, if there is a tpm. 

dave
