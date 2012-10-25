Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935892Ab2JYQXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:23:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab2JYQXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:23:18 -0400
Date: Thu, 25 Oct 2012 11:39:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [RFC] Kdump with UEFI secure boot (Re: [PATCH v2] kdump: pass
 acpi_rsdp= to 2nd kernel for efi booting)
Message-ID: <20121025153937.GE9377@redhat.com>
References: <1350588121.30243.7.camel@rhapsody>
 <20121018193831.GD18147@redhat.com>
 <874nlrv2ni.fsf@xmission.com>
 <20121019020630.GA27052@redhat.com>
 <877gqnnnf0.fsf@xmission.com>
 <20121019143112.GB27052@redhat.com>
 <871ugqb4gj.fsf@xmission.com>
 <20121023131854.GA16496@redhat.com>
 <20121023145920.GD16496@redhat.com>
 <20121023154123.GA30730@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023154123.GA30730@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 04:41:24PM +0100, Matthew Garrett wrote:
> On Tue, Oct 23, 2012 at 10:59:20AM -0400, Vivek Goyal wrote:
> 
> > But what about creation of a new program which can call kexec_load()
> > and execute an unsigned kernel. Doesn't look like that will be
> > prevented using IMA.
> 
> Right. Trusting userspace would require a new system call that passes in 
> a signature of the userspace binary, and the kernel would then have to 
> verify the ELF object in memory in order to ensure that it 
> matches the signature.

[ CC lkml and IMA/EVM developers ]

Not sure how much of this is feasible. There is initialized data which
can change. That means we shall have to exclude initialized data from
digest. And then initialized data can be changed by attacker.

I think in the context of kexec, purgatory (which is actually a
relocatable executable), is embedded in kexec binary as "const char
purgatory[]". I am assuming that it will show up as initialized data
in /sbin/kexec. And if we do not include initialized data in digest
calculation, then one can overwrite purgatory with its own executable
code and kexec will load it into the kernel and let it run at priviliged
level.

So looks like even above will not be foolproof. (Assuming we can do
this. I thought we lost all the elf headers after loading elf 
binary and now we don't know which mmpaed areas need to be included
in digest and which should not be).
 
> Verifying that the copy on the filesystem is 
> unmodified isn't adequate - an attacker could simply have paused the 
> process and injected code.

This is an interesting point. So even if we verify the signature of
/sbin/kexec, parent can change the code (using ptrace() interface?).
And we are again prone to attack. So this will work if we are doing
integrity/authenticity checks on all root processes and not just
one /sbin/kexec.

> Realistically, the only solution here is for 
> the kernel to verify that the kernel it's about to boot is signed and 
> for it not to take any untrusted executable code from userspace.

Hmm.., given above, looks like implementing a new system call to pass
in full kernel and initramfs (along with some command line or other
parameters), becomes interesting.

Thanks
Vivek
