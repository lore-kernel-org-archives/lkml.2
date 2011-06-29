Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab1F2Uxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:53:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54284 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1F2Uxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:53:45 -0400
MIME-Version: 1.0
In-Reply-To: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 29 Jun 2011 16:53:24 -0400
Message-ID: <BANLkTinSsqBqX7=jzwbw_=RfXeQz29h_+A@mail.gmail.com>
Subject: Re: [PATCH v7 00/16] EVM
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 15:50, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Discretionary Access Control(DAC) and Mandatory Access Control(MAC) can
> protect the integrity of a running system from unauthorized changes. When
> these protections are not running, such as when booting a malicious OS,
> mounting the disk under a different operating system, or physically moving
> the disk to another system, an "offline" attack is free to read and write
> file data/metadata.
>
> Extended Verification Module(EVM) detects offline tampering of the security
> extended attributes (e.g. security.selinux, security.SMACK64, security.ima),
> which is the basis for LSM permission decisions and, with the IMA-appraisal
> patchset, integrity appraisal decisions. This patchset provides the framework
> and an initial method to detect offline tampering of the security extended
> attributes.  The initial method maintains an HMAC-sha1 across a set of
> security extended attributes, storing the HMAC as the extended attribute
> 'security.evm'. To verify the integrity of an extended attribute, EVM exports
> evm_verifyxattr(), which re-calculates the HMAC and compares it with the
> version stored in 'security.evm'.  Other methods of validating the integrity
> of a file's metadata will be posted separately (eg. EVM-digital-signatures).

Hmm, I'm not sure that this design actually provides the protection that
you claim it does.

Specifically, you don't actually protect the on-disk data-structures that
are far more vulnerable to malicious modification than the actual *values*
of the extended attributes themselves.

For example, compare the number of actual practical exploits of image
buffer-overflow vulnerabilities involving user-generated content versus
the number of Man-in-the-middle exploits of trusted content, I guarantee
you there are a lot more of the former in the wild.

It's also worth mentioning that one of the reasons we have traditionally
prevented user mounts of many filesystems is because the filesystem
drivers tended to be buggy and susceptible to panic or buffer overflow.

To give you a trivial example of how this could be subverted, you could
modify the block mapping table of an unprotected file to reference some
blocks used in a "protected" file.  Then boot up the system and "verify"
the protected file, and then write new data to the unprotected file and
generate some memory pressure to force the protected data to be reloaded
from disk.

Another good example of how this breaks down in practice would be the
various incompatibilities in different VFAT filesystem behavior with
NUL filenames.  I don't remember what the change was on Linux, but in
practice on several operating systems you can "mkdir" a new directory
entry and several more could suddenly appear (because the NUL entry is
now populated).

If you want to use HMAC verification of disk contents then you should not
be performing the HMAC of some partial logical view of them, but instead
protect the *disk contents* themselves!!!

Perhaps modifying dm-crypt to support HMAC-based authentication modes
would be one approach.  You could probably even code it to store the HMAC
metadata in a separate partition to allow for read-only access by your
bootloader, etc.

Cheers,
Kyle Moffett
