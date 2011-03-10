Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1CJRum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:50:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46597 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1CJRui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:50:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        Takao Indoh <tindoh@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Len Brown <lenb@kernel.org>, linux-doc@vger.kernel.org,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1299766243-494-1-git-send-email-amwang@redhat.com>
	<20110310143923.GB29464@redhat.com>
Date: Thu, 10 Mar 2011 09:50:28 -0800
In-Reply-To: <20110310143923.GB29464@redhat.com> (Vivek Goyal's message of
	"Thu, 10 Mar 2011 09:39:23 -0500")
Message-ID: <m1oc5ig90b.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+XjpojrpPcM+/zUpTtSTiLZ/Y7TGW3aKU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [Patch] acpi: introduce "acpi_addr=" parameter for kdump
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Mar 10, 2011 at 10:10:43PM +0800, Amerigo Wang wrote:
>> From: Takao Indoh <tindoh@redhat.com>
>> 
>> There is a problem with putting the first kernel in EFI virtual mode,
>> it is that when the second kernel comes up it tries to initialize the
>> EFI again and once we have put EFI in virtual mode we can not really
>> do that.
>> 
>> Actually, EFI is not necessary for kdump, we can boot the second kernel
>> with "noefi" parameter, but the boot will mostly fail because 2nd kernel
>> cannot find RSDP.
>> 
>> In this situation, we introduced "acpi_addr=" kernel parameter,
>> so that kexec-tools can pass the "noefi acpi_addr=X" to the second kernel
>> to make kdump works.
>> 
>
> Little more background on this. So we now seem to have this general
> general problem of how to make kexec/kdump work with EFI.
>
> I have very limited knowledge of EFI and based on some information
> gleaned, it looks we seem to have two alternatives to make kdump work.
>
> - Don't transition to virtual mode in first kernel and work with
>   physical mode of EFI. Maintain a separate set of page tables for
>   mapping EFI and use those to make EFI calls.
>
> - Transition EFI in virtual mode in first kernel. Boot second kernel with
>   "noefi" and pass in whatever details are required on kernel command line.
>   One such details is ACPI pointer.
>
> Matthew Garret mentioned that other OSes tend to transition EFI in
> virtual mode (MacOS X seems to be the exception) and if we decide to stick
> to physical mode all the time then we can expect a host of BIOS bug report
> as vendors are unlikely to test that path.
>
> Keeping in that mind, using noefi for second kernel make sense. But
> I think it is not good for pure kexec case. Takao Indoh san mentioned
> that he seems to be running into VGA initialization issues and it
> seems there is a need to pass SMBIOS address also.
>
> So I think if it work, for kdump case probably using noefi is fine. I
> wanted to bring up the case of kexec and wondering how to make it 
> work with virtual mode of EFI or what is our strategy to handle it.
>
> Eric and others, any thoughts on this in general?

If we want to handle EFI in a long term supportable manner and stop
making short term hacks here is my suggestion.

Move all EFI calls that the kernel does (on x86) into a special section
of the bzImage that the bootloader can run.  This works very well for
the x86 BIOS and it should also work very well for EFI.  Among other
things by having a special 32bit and a special 64bit section this solves
the what flavor of EFI problem are we running on problem.

Never perform any EFI calls once the kernel is initialized, last I
looked all of the EFI calls that were interesting to perform at runtime
were a subset of what ACPI can do, and ACPI is a easier to deal with
long term.

Kexec and kdump can easily pass the gather data from the first kernel to
the second kernel like we do for the normal bios paramsters today.

As a fly in the ointment that leaves the question of how do we set EFI
variables.  It is needed functionality when we are installing, and
occasionally nice to have.  But it is a very rare slow path.  I would
isolate the EFI after the kernel has booted to exactly to that one case.
Either with a special driver or a some flavor of virtualization from
userspace like we used to do for video card initialization.

The current design of EFI in the x86 kernel is crap.  We seem to have
advanced past the early adopter hack anything together to make it work
stage.  So let's stop adding hacks and write something that won't give
us a long term support problems.

Eric
