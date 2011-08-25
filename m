Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1HYQxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:53:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab1HYQxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:53:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=VUdTKvuXN1/vvj5kRM3+sF6lCDxw5qI36GAKgDs8OqyzE5K9hSOoeYXN3x4uJPGR2
	Pmye4u4M/GwxKH5RUvT4Q==
MIME-Version: 1.0
In-Reply-To: <CAOtrxKNwPd_fucOVwKS_bTBKh8P3tiNgOadpCh7fXNE6hJjpFw@mail.gmail.com>
References: <20110819175316.GA999@ime.usp.br> <CAOtrxKNVckzkxM=ahV13kV=7-Jtj=WWkx_So4pCdVX3e8mdjPw@mail.gmail.com>
 <CA+55aFyyJNnL54o=xRH7CubFLDaQwcF31sqd7tfBcfR8XfnX5g@mail.gmail.com>
 <CAOtrxKN3sugEcNPb0MkihAJ6P+idAUfGnJBoBq_kwxsDiHdR+A@mail.gmail.com>
 <CAOtrxKMgdSWXRacAy8AVp8q1Zst2NKhvwbUDrhp1pMN5fme9ew@mail.gmail.com>
 <CAErSpo79Wu7fvm=bCpSN=ydfb9u64r=_WVoV3qBmjqb76CKjXg@mail.gmail.com> <CAOtrxKNwPd_fucOVwKS_bTBKh8P3tiNgOadpCh7fXNE6hJjpFw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Aug 2011 10:53:15 -0600
Message-ID: <CAErSpo4xkh9r66h6bFEoqa0LihEQPFUGAw5atXWRJQb0pQU=Vw@mail.gmail.com>
Subject: Re: [Bug 41622] [REGRESSION][BISECTED] Notebook crashes upon
 detecting the PCI subsystem with kernels >= 2.6.24-rc7
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Thomas Meyer <thomas@m3y3r.de>, Gary Hade <garyhade@us.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        bugme-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 8:49 AM, Rogério Brito <rbrito@ime.usp.br> wrote:
> 2011/8/24 Bjorn Helgaas <bhelgaas@google.com>:
>> I'd still like to see a dmesg log with no arguments (remove the
>> "acpi=off pnpbios=off noapic nolapic" arguments).  Your machine is new
>> enough that we'll use PCI _CRS by default, and I'd like to make sure
>> we're doing the right thing.
>
> OK. I put them there one by one, but let me report what I get with
> those disabled, but *with* that small patch applied:
>
> * "acpi=off pnpbios=off noapic": it works well, no problems with
> dropping the nolapic.
> * "acpi=off noapic": it works well, with no problems dropping
> "pnpbios=off, aside from the "[Firmware Bug]: powernow-k8: No PSB or
> ACPI _PSS objects" message.
> * "acpi=off": does not work well---it books OK, but some accesses to
> disk get very long and I get the following in the dmesg log:
> ...
> * without any boot options: without "acpi=off", the machine just hangs
> at (hand copied, but photographed, if you want it):
>
> (...)
> CPU: Mobile AMD Sempron (tm) Processor 3400+ stepping 02
> ACPI: Core revision 20110623
>
> And nothing else happens.

This is a serious problem, and while we probably need to fix both this
and the PCI bridge issue, this is the first thing you hit, so I'd like
to look at it first.  Users should never have to use "acpi=off" except
for debugging purposes.

I opened a separate bug report for it:
https://bugzilla.kernel.org/show_bug.cgi?id=41722

Would you build your kernel with "CONFIG_ACPI_DEBUG=y" and boot with
the kernel options "ignore loglevel acpi.debug_layer=0xffffffff
acpi.debug_level=0xffffffff" and see if we can learn anything?  If
that's too much output, try acpi.debug_layer=0x59f instead.

>> I don't really like that change because in __pci_bus_size_bridges(),
>> it's not obvious why sizing transparent bridges should be a problem.
>> If growing transparent bridge windows makes us run out of space, let's
>> put the smarts ("this bridge is transparent, we can take advantage of
>> subtractive decode so we may not need to grow the positive decode
>> windows") at the point where we grow, not at the point where we size.
>> If we do have enough space, growing the positive decode windows is
>> better because they're faster than subtractive decode.
>
> I'm afraid that I have understood almost nothing of what you just said
> :-), but I will try to read some of the code.

That's all right; that was intended for the PCI people who might care
about how this is implemented.

Bjorn
