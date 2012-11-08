Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2KHKSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:18:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57692 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2KHKSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:18:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121107145518.GB30662@srcf.ucam.org>
References: <87fw4nv1vj.fsf@xmission.com>
	<20121106035352.GA24698@srcf.ucam.org>
	<87hap3s3yl.fsf@xmission.com>
	<878vafqi5q.fsf@mid.deneb.enyo.de>
	<50992946.4060101@genband.com>
	<87625iwgao.fsf@mid.deneb.enyo.de>
	<7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com>
	<20121106224920.3b9d4a86@pyramind.ukuu.org.uk>
	<a35e035b-de9d-4253-9e7d-ae1f1c2e2f88@email.android.com>
	<CAMFK0gt7oAr4ArD8FmD8QE+i4g4rSTmQjbbLcjs02xwQeXGx-A@mail.gmail.com>
	<20121107145518.GB30662@srcf.ucam.org>
Date: Thu, 8 Nov 2012 10:18:04 +0000
Message-ID: <CAAMvbhEpmgE3badW0e7p4X4aeZwRd5Md3_5Q+g2s8r3p7dm5+w@mail.gmail.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Olivier Galibert <galibert@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Florian Weimer <fw@deneb.enyo.de>,
        Chris Friesen <chris.friesen@genband.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Josh Boyer <jwboyer@gmail.com>,
        LKML Mailing List <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The basis for any secure boot is a way to detect that the system has
been tampered with or not. "Tamper Evidence".
There are two main vectors for a system to be tampered with. Someone
local to the machine and remote users who can access the machine
across a network interface. (this includes the local user installing a
program from a remote source)
You have a fair chance of protecting via physical means (Locked rooms,
Background checks on users etc.) of preventing a user with malicious
intent to access the local machine.
The first thing a computer does when switched on is run its first code
instructions. Commonly referred to as the BIOS.
It would therefore be a requirement to ensure that the BIOS cannot be
tampered with via any other method apart from physically located at
the machine. Once you have a base computer code that cannot be
tampered with, you can trust it.
>From that point on, you can use digital signatures to build the chain of trust.
Normally digital signatures would examine the binary, ensure the
signature matches, and then run the code contained in it.
It is vital that the private key used to sign binaries cannot be found
on the local machine, otherwise an malicious user could use it to sign
malicious code, and therefore break the trust.
The binary files therefore must be signed on a separate computer, that
is trusted and protected from malicious users.
There is one known use case where the normal digital signature checks
will not work and this is the Hibernate file.
The files were digitally checked when loaded into a previously running machine.
The state of the machine was then saved to a file.
The problem is how to check the hibernate file has not been tampered
with in the interim.
As explained above, we cannot store a private key on the local
machine, so some other method for checking that the hibernate file has
not been tampered with is required.
I would suggest the fix for this problem is working out a way to check
the signature of binary files, while in RAM, or even on a running
machine. This is the format that the hibernate file is, it is
basically a RAM image.
When starting a hibernate image, the file would have to be scanned and
digital signature checked that all the executable code in the
hibernate image was sourced from correctly digitally signed binaries.

In fact, this last point, if done correctly, could replace virus
scanners. We would then have a system that rather than scan for
viruses, it instead scans for "tampering".

Remaining problems:
1) deciding who you trust, and from that, which digital
signatures/certificates you trust.
2) Handling compromised or expired signatures/certificates.

For 2, if the signatures are attached in each binary file, in order to
distribute a new set of signatures, you would have to re-distribute
all the binary files. Not a good idea due to download size. I would
therefore suggest that the signatures are distributed separately from
the binary files, so that you can change the signatures without having
to redistribute all the binary files.

Summary:
1) The BIOS code and the certificate it uses to check subsequently
loaded binaries should only be changeable by a user local to the
machine or not changeable at all without changing hardware.

For example, on some ARM based mobile phones, the BIOS and certificate
it uses are in a ROM, so not changeable at all. It then uses a multi
stage boot loader, with each stage providing for a different
certificate to be used to the next stage. This then permits the
certificates that are used to sign the Linux kernel to be changed
without having to change the certificate in the ROM. For Secure boot
for Linux, the BIOS and certificate should probably be controlled by
the user who controls the physical access to his machine. Then multi
stage boot loaders can be used to introduce a chain to trust to trust
other certificates, such as the debian or redhat or Microsoft ones, if
the user chooses to trust them.
With the user using their own BIOS certificate, it is very unlikely
for the remote malicious user to obtain the private key and thus
compromise the security of the system.

2) When "tamper" is detected, the system should revert to a stable
safe state. This probably means, prevent the system booting, and
present the local user with the evidence of tampering. Letting the
user choose the next step.

On 7 November 2012 14:55, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Nov 07, 2012 at 09:19:35AM +0100, Olivier Galibert wrote:
>> On Tue, Nov 6, 2012 at 11:47 PM, Matthew Garrett <mjg59@srcf.ucam.org>wrote:
>>
>> > Sure, and scripts run as root can wipe your files too. That's really not
>> > what this is all about.
>>
>> What it is about then? What is secure boot supposed to do for the owner of
>> the computer in a linux context?  I've not been able to understand it
>> through this discussion.
>
> It provides a chain of trust that allows you to ensure that a platform
> boots a trusted kernel. That's a pre-requisite for implementing any kind
> of fully trusted platform, but it's not sufficient in itself. One of
> those additional requirements is ensuring that the kernel *stays*
> trusted - in the past an attacker could just replace the kernel on disk
> and so there was little incentive to engage in more subtle attacks, but
> now that's impossible we need to care about them.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
