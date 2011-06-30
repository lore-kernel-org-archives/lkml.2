Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1F3WdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:33:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54483 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1F3WdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:33:20 -0400
MIME-Version: 1.0
In-Reply-To: <1309405895.3205.57.camel@localhost.localdomain>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
 <BANLkTinSsqBqX7=jzwbw_=RfXeQz29h_+A@mail.gmail.com> <1309390941.3205.22.camel@localhost.localdomain>
 <BANLkTineYVKw9MMQUqRGJ6Q_yEfgmsgJxg@mail.gmail.com> <1309405895.3205.57.camel@localhost.localdomain>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Thu, 30 Jun 2011 18:32:59 -0400
Message-ID: <BANLkTims9aa3Ct+C1x6kNDeOi2juUNbzkA@mail.gmail.com>
Subject: Re: [PATCH v7 00/16] EVM
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, resent in plain text, sorry about the HTML

On Wed, Jun 29, 2011 at 23:51, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Wed, 2011-06-29 at 21:57 -0400, Kyle Moffett wrote:
>> On Wed, Jun 29, 2011 at 19:42, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> > On Wed, 2011-06-29 at 16:53 -0400, Kyle Moffett wrote:
>> >> Hmm, I'm not sure that this design actually provides the protection that
>> >> you claim it does.
>> >>
>> >> Specifically, you don't actually protect the on-disk data-structures that
>> >> are far more vulnerable to malicious modification than the actual *values*
>> >> of the extended attributes themselves.
>> >
>> > True, EVM only protects the file metadata. The patch description says,
>> >
>> >        While this patchset does authenticate the security xattrs, and
>> >        cryptographically binds them to the inode, coming extensions
>> >        will bind other directory and inode metadata for more complete
>> >        protection.
>> >
>> > It should have said, "bind other directory, inode data and inode
>> > metadata."
>> >
>> > In particular, IMA-appraisal stores the file data's hash as the
>> > security.ima xattr, which is EVM protected. Other methods, such as
>> > digital signatures, could be used instead of the file's hash, to
>> > additionally provide authenticity.
>>
>> The problem is that your *design* assumes that the filesystem itself is
>> valid, but your stated threat model assumes that the attacker has offline
>> access to the filesystem, an explicit contradiction.
>>
>> There have been numerous cases in the past where a corrupt or invalid
>> filesystem causes kernel panics or even exploitable overflows or memory
>> corruption; see the history of the "fsfuzzer" tool for more information.
>>
>> Furthermore, if the attacker can intentionally cause data extent or inode
>> extended attribute aliasing (shared space-on-disk) between different
>> files then your entire security model falls flat.
>>
>> So if you assume the attacker has raw access to the underlying filesystem
>> then you MUST authenticate *all* of the low-level filesystem data,
>> including the "implicit" metadata of allocation tables, extents, etc.
>>
>> Cheers,
>> Kyle Moffett
>
> Assuming someone does modify the underlying filesystem, how does that
> break the security model?  The purpose of EVM/IMA-appraisal is not to
> prevent files offline from being modified, but to detect if/when it
> occurs and to enforce file integrity.

The problem is that you are assuming that a large chunk of filesystem
code is capable of properly and securely handling untrusted and malicious
content.  Historically filesystem drivers are NOT capable of handling
such things, as evidenced by the large number of bugs that tools such as
fsfuzzer tend to trigger.  If you want to use IMA as-designed then you
need to perform a relatively extensive audit of filesystem and fsck code.

Furthermore, even when the filesystem does not have any security issues
itself, you are assuming that intentionally malicious data-aliasing
between "trusted" and "untrusted" files can have no potential security
implications.  You should look at the prevalence of simple stupid "/tmp"
symlink attacks for more counter-examples there.

In addition, IMA relies on the underlying attribute and data caching
properties of the VFS, which won't hold true for intentionally malicious
corrupted filesystems.  It effectively assumes that writing data or
metadata for one file will not invalidate the cached data or metadata for
another which is blatantly false when filesystem extents overlap each
other.

Overall, the IMA architecture assumes that if it loads and validates the
file data or metadata that it cannot be changed except through a kernel
access to that particular inode.  For a corrupted filesystem that is
absolutely untrue.

Cheers,
Kyle Moffett
