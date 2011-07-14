Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1GNPIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:08:19 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:34810 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1GNPIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:08:00 -0400
Subject: Re: [PATCH v7 00/16] EVM
From: David Safford <safford@watson.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Date: Thu, 14 Jul 2011 11:07:25 -0400
In-Reply-To: <BANLkTineYVKw9MMQUqRGJ6Q_yEfgmsgJxg@mail.gmail.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <BANLkTinSsqBqX7=jzwbw_=RfXeQz29h_+A@mail.gmail.com>
	 <1309390941.3205.22.camel@localhost.localdomain>
	 <BANLkTineYVKw9MMQUqRGJ6Q_yEfgmsgJxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1310656045.3845.243.camel@localhost>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 21:57 -0400, Kyle Moffett wrote:
> On Wed, Jun 29, 2011 at 19:42, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Wed, 2011-06-29 at 16:53 -0400, Kyle Moffett wrote:
> >> On Wed, Jun 29, 2011 at 15:50, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >> > Discretionary Access Control(DAC) and Mandatory Access Control(MAC) can
> >> > protect the integrity of a running system from unauthorized changes. When
> >> > these protections are not running, such as when booting a malicious OS,
> >> > mounting the disk under a different operating system, or physically moving
> >> > the disk to another system, an "offline" attack is free to read and write
> >> > file data/metadata.
> >> >
> >> > Extended Verification Module(EVM) detects offline tampering of the security
> >> > extended attributes (e.g. security.selinux, security.SMACK64, security.ima),
> >> > which is the basis for LSM permission decisions and, with the IMA-appraisal
> >> > patchset, integrity appraisal decisions. This patchset provides the framework
> >> > and an initial method to detect offline tampering of the security extended
> >> > attributes.  The initial method maintains an HMAC-sha1 across a set of
> >> > security extended attributes, storing the HMAC as the extended attribute
> >> > 'security.evm'. To verify the integrity of an extended attribute, EVM exports
> >> > evm_verifyxattr(), which re-calculates the HMAC and compares it with the
> >> > version stored in 'security.evm'.  Other methods of validating the integrity
> >> > of a file's metadata will be posted separately (eg. EVM-digital-signatures).
> >>
> >> Hmm, I'm not sure that this design actually provides the protection that
> >> you claim it does.
> >>
> >> Specifically, you don't actually protect the on-disk data-structures that
> >> are far more vulnerable to malicious modification than the actual *values*
> >> of the extended attributes themselves.
> >
> > True, EVM only protects the file metadata. The patch description says,
> >
> >        While this patchset does authenticate the security xattrs, and
> >        cryptographically binds them to the inode, coming extensions
> >        will bind other directory and inode metadata for more complete
> >        protection.
> >
> > It should have said, "bind other directory, inode data and inode
> > metadata."
> >
> > In particular, IMA-appraisal stores the file data's hash as the
> > security.ima xattr, which is EVM protected. Other methods, such as
> > digital signatures, could be used instead of the file's hash, to
> > additionally provide authenticity.
> 
> The problem is that your *design* assumes that the filesystem itself is
> valid, but your stated threat model assumes that the attacker has offline
> access to the filesystem, an explicit contradiction.

Agreed we did not describe our model clearly. But as stated in the prior
post, EVM's part of the defense in depth is to protect security xattrs
(not the data) from attack, and EVM itself is immune to these attacks,
since the attacker cannot forge an acceptable verifier.

> There have been numerous cases in the past where a corrupt or invalid
> filesystem causes kernel panics or even exploitable overflows or memory
> corruption; see the history of the "fsfuzzer" tool for more information.

Seems to me code bugs in the kernel should be fixed, given the universal 
practice of automounting of removable media, and loopback mounting 
images, regardless of EVM.

> Furthermore, if the attacker can intentionally cause data extent or inode
> extended attribute aliasing (shared space-on-disk) between different
> files then your entire security model falls flat.
 
As discussed in the prior post, your attacks do succeed on 
IMA-Appraisal-HASH as a known tradeoff, but I don't see how they
can succeed on IMA-Appraisal-DigitalSignature or EVM or IMA attestation.
Even if the attacker has complete control of the xattr data, he 
does not have the key needed to forge an HMAC acceptable to EVM.

> So if you assume the attacker has raw access to the underlying filesystem
> then you MUST authenticate *all* of the low-level filesystem data,
> including the "implicit" metadata of allocation tables, extents, etc.

I still don't see how this affects EVM or IMA attestation...

As you suggested earlier, you could protect all of the fs metadata
at the dm level, as a complement to filesystem level protections.
It would be interesting to see if such protections of all fs metadata
could be done efficiently within a filesystem itself, as Mimi suggested,
but I don't see the need.

thanks
dave


