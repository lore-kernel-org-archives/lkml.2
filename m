Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1GNPIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:08:01 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:34806 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1GNPH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:07:58 -0400
Subject: Re: [PATCH v7 00/16] EVM
From: David Safford <safford@watson.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Date: Thu, 14 Jul 2011 11:07:08 -0400
In-Reply-To: <BANLkTinSsqBqX7=jzwbw_=RfXeQz29h_+A@mail.gmail.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <BANLkTinSsqBqX7=jzwbw_=RfXeQz29h_+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1310656028.3845.242.camel@localhost>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 16:53 -0400, Kyle Moffett wrote:
> On Wed, Jun 29, 2011 at 15:50, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > Discretionary Access Control(DAC) and Mandatory Access Control(MAC) can
> > protect the integrity of a running system from unauthorized changes. When
> > these protections are not running, such as when booting a malicious OS,
> > mounting the disk under a different operating system, or physically moving
> > the disk to another system, an "offline" attack is free to read and write
> > file data/metadata.
> >
> > Extended Verification Module(EVM) detects offline tampering of the security
> > extended attributes (e.g. security.selinux, security.SMACK64, security.ima),
> > which is the basis for LSM permission decisions and, with the IMA-appraisal
> > patchset, integrity appraisal decisions. This patchset provides the framework
> > and an initial method to detect offline tampering of the security extended
> > attributes.  The initial method maintains an HMAC-sha1 across a set of
> > security extended attributes, storing the HMAC as the extended attribute
> > 'security.evm'. To verify the integrity of an extended attribute, EVM exports
> > evm_verifyxattr(), which re-calculates the HMAC and compares it with the
> > version stored in 'security.evm'.  Other methods of validating the integrity
> > of a file's metadata will be posted separately (eg. EVM-digital-signatures).
> 
> Hmm, I'm not sure that this design actually provides the protection that
> you claim it does.

My apologies for not responding sooner - I was on vacation when this
thread was discussed, and I wanted to take the time to make sure I
understood all of the ramifications of the attacks you raised.

Having studied the potential attacks based on fs metadata manipulation,
I believe that EVM (this particular patch set) is explicitly immune to the 
attacks, and does provide exactly what it claims - protection of a file's 
sensitive xattrs against offline attack.

EVM stores an HMAC or a Digital Signature across the designated set of
sensitive xattrs. The corresponding secret or private key is not known
to the attacker, and the attacker cannot therefore forge a valid
HMAC/signature. On xattr read, EVM verifies the value, so attacker 
supplied data, even in the presence of offline or fs metadata
based attack, will not be accepted by EVM. On authorized update
of a protected xattr, EVM explicitly verifies the current xattr
data to make sure it has not been tampered in the meanwhile, and
updates the verifier only if the data has not been tampered. Without
the corresponding key, even if the attacker can tamper the xattrs,
he cannot do so in a way that EVM will accept.

You did correctly point out a vulnerability of one of the other integrity
modules (IMA-Appraisal-HASH) to these attacks, but this is a known tradeoff
with that particular module, which can be avoided/detected with other
modules (IMA-Appraisal-DigitalSignature, and IMA measurement/attestation.)

For unchanging files, IMA-Appraisal-DigitalSignature verifies the file's
data against a digital signature (typically from the Distro), and treats
the file as immutable, so even if an attacker changes the data through
an fs-metadata attack, the change will succeed while the inode
is cached, but it will not persist - it will be detected whenever
the inode is next reloaded from disk. Without the corresponding private
key, neither the attacker nor the kernel can update the verifying
signature.

For changing files, IMA-Appraisal-HASH does allow the file's hash
to be updated, and this does open the described attack, as it 
cannot distinguish a good change in the file's hash from a malicious
one induced by the fs-metadata attack outlined. (And IMA-Appraisal-HASH
is certainly effective for other non-offline attacks.)

However any such change, once persistent, will be detected by the base 
IMA measurement and attestation. Regardless of how a file is changed,
any persistent file change will be detected by IMA attestation, 
because it's measurement chain is rooted in hardware, and it cannot
be forged by software.

So the overall integrity architecture provides defense in depth;
MAC (selinux, apparmor, smack...) will try to confine the damage
from a data exploited program, IMA-Appraisal will try to detect
and block damage locally, EVM will protect xattrs from damage,
and IMA attestation is the final remote catcher of anything that 
makes it through all of these layers.

> Specifically, you don't actually protect the on-disk data-structures that
> are far more vulnerable to malicious modification than the actual *values*
> of the extended attributes themselves.
>
> For example, compare the number of actual practical exploits of image
> buffer-overflow vulnerabilities involving user-generated content versus
> the number of Man-in-the-middle exploits of trusted content, I guarantee
> you there are a lot more of the former in the wild.
 
Yes, but most data driven attacks of vulnerable software do try to become 
persistent, at which point they become detectable. Even the Morris worm
wrote out one file.

> It's also worth mentioning that one of the reasons we have traditionally
> prevented user mounts of many filesystems is because the filesystem
> drivers tended to be buggy and susceptible to panic or buffer overflow.

Every system I have used (fedora, ubuntu, android...) by default
allows automatic mounting of removable media, and fs images. That seems to 
me to be a problem if there is exploitable fs code.

> To give you a trivial example of how this could be subverted, you could
> modify the block mapping table of an unprotected file to reference some
> blocks used in a "protected" file.  Then boot up the system and "verify"
> the protected file, and then write new data to the unprotected file and
> generate some memory pressure to force the protected data to be reloaded
> from disk.

As discussed earlier, this example is an attack on IMA-Appraisal-HASH, not 
IMA-Appraisal-DigitalSignature (which treats such files as immutable), or 
on EVM at all, and even then it will be detected by IMA attestation.
 
> Another good example of how this breaks down in practice would be the
> various incompatibilities in different VFAT filesystem behavior with
> NUL filenames.  I don't remember what the change was on Linux, but in
> practice on several operating systems you can "mkdir" a new directory
> entry and several more could suddenly appear (because the NUL entry is
> now populated).

I haven't looked in detail at this, but I believe the IMA-Appraisal-directory
extension will handle this, and it does not affect EVM itself.

> If you want to use HMAC verification of disk contents then you should not
> be performing the HMAC of some partial logical view of them, but instead
> protect the *disk contents* themselves!!!
>
> Perhaps modifying dm-crypt to support HMAC-based authentication modes
> would be one approach.  You could probably even code it to store the HMAC
> metadata in a separate partition to allow for read-only access by your
> bootloader, etc.
 
There are big tradeoffs doing integrity at the disk vs filesystem level.
For example, if we do integrity checking only at the dm level, then
we cannot have policy based verification of digitally signed files. This
is a very important use case for some customers. 

thanks,
dave



