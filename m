Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1F3B6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:58:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60468 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab1F3B6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <1309390941.3205.22.camel@localhost.localdomain>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
 <BANLkTinSsqBqX7=jzwbw_=RfXeQz29h_+A@mail.gmail.com> <1309390941.3205.22.camel@localhost.localdomain>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 29 Jun 2011 21:57:41 -0400
Message-ID: <BANLkTineYVKw9MMQUqRGJ6Q_yEfgmsgJxg@mail.gmail.com>
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

On Wed, Jun 29, 2011 at 19:42, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Wed, 2011-06-29 at 16:53 -0400, Kyle Moffett wrote:
>> On Wed, Jun 29, 2011 at 15:50, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> > Discretionary Access Control(DAC) and Mandatory Access Control(MAC) can
>> > protect the integrity of a running system from unauthorized changes. When
>> > these protections are not running, such as when booting a malicious OS,
>> > mounting the disk under a different operating system, or physically moving
>> > the disk to another system, an "offline" attack is free to read and write
>> > file data/metadata.
>> >
>> > Extended Verification Module(EVM) detects offline tampering of the security
>> > extended attributes (e.g. security.selinux, security.SMACK64, security.ima),
>> > which is the basis for LSM permission decisions and, with the IMA-appraisal
>> > patchset, integrity appraisal decisions. This patchset provides the framework
>> > and an initial method to detect offline tampering of the security extended
>> > attributes.  The initial method maintains an HMAC-sha1 across a set of
>> > security extended attributes, storing the HMAC as the extended attribute
>> > 'security.evm'. To verify the integrity of an extended attribute, EVM exports
>> > evm_verifyxattr(), which re-calculates the HMAC and compares it with the
>> > version stored in 'security.evm'.  Other methods of validating the integrity
>> > of a file's metadata will be posted separately (eg. EVM-digital-signatures).
>>
>> Hmm, I'm not sure that this design actually provides the protection that
>> you claim it does.
>>
>> Specifically, you don't actually protect the on-disk data-structures that
>> are far more vulnerable to malicious modification than the actual *values*
>> of the extended attributes themselves.
>
> True, EVM only protects the file metadata. The patch description says,
>
>        While this patchset does authenticate the security xattrs, and
>        cryptographically binds them to the inode, coming extensions
>        will bind other directory and inode metadata for more complete
>        protection.
>
> It should have said, "bind other directory, inode data and inode
> metadata."
>
> In particular, IMA-appraisal stores the file data's hash as the
> security.ima xattr, which is EVM protected. Other methods, such as
> digital signatures, could be used instead of the file's hash, to
> additionally provide authenticity.

The problem is that your *design* assumes that the filesystem itself is
valid, but your stated threat model assumes that the attacker has offline
access to the filesystem, an explicit contradiction.

There have been numerous cases in the past where a corrupt or invalid
filesystem causes kernel panics or even exploitable overflows or memory
corruption; see the history of the "fsfuzzer" tool for more information.

Furthermore, if the attacker can intentionally cause data extent or inode
extended attribute aliasing (shared space-on-disk) between different
files then your entire security model falls flat.

So if you assume the attacker has raw access to the underlying filesystem
then you MUST authenticate *all* of the low-level filesystem data,
including the "implicit" metadata of allocation tables, extents, etc.

Cheers,
Kyle Moffett
