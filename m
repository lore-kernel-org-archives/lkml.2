Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab2IDWNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:13:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40430 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab2IDWNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:13:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
	<1346774117-2277-8-git-send-email-mjg@redhat.com>
	<87txvdzgur.fsf@xmission.com> <20120904202205.GA28903@srcf.ucam.org>
	<87r4qhwkx9.fsf@xmission.com> <20120904212717.GA30899@srcf.ucam.org>
Date: Tue, 04 Sep 2012 15:12:52 -0700
In-Reply-To: <20120904212717.GA30899@srcf.ucam.org> (Matthew Garrett's message
	of "Tue, 4 Sep 2012 22:27:17 +0100")
Message-ID: <87fw6xtp23.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX194So+1D2oA24omsm+ZXIk+BWqXZUG52TI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg59@srcf.ucam.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Tue, Sep 04, 2012 at 02:13:54PM -0700, Eric W. Biederman wrote:
>> Matthew Garrett <mjg59@srcf.ucam.org> writes:
>> > And 
>> > secondly, there are already several non-EFI platforms that want to enact 
>> > a policy preventing root from being able to arbitrarily replace the 
>> > kernel. Given that people are doing this in the wild, it makes sense to 
>> > move towards offering that policy in the mainline kernel.
>> 
>> Either this code makes sense without an appeal to EFI or this code makes
>> no sense.
>
> The driving force behind this code right now is that our choices are 
> either (1) do something like this, or (2) disable kexec entirely.

Actually there is an interesting question here. Why does even EFI secure
boot justify this?  If I install my own key in EFI I should be able to
boot a kernel that does anything I want it to.   My machine doing what I
want it to is the point of trusted boot is it not?

> Like I 
> said, long term we'd want to provide appropriate technical mechanisms to 
> make kexec usable in a world where people want to be able to trust their 
> kernel, and we have people working on that. But that being our 
> motivation for the implementation doesn't mean that other parties won't 
> have uses for it, and I'd like to find a solution that satisfies them as 
> well.

I expect you want to make that that medium term.  Enterprise distros
don't ship without kexec-on-panic.  Too often long term seems to be
something that no one ever gets around to in kernel development.

>> It is fine for jumping through the EFI trusted boot hoops to be your
>> motivation, but EFI policy should not be the justification for kernel
>> implementation details.
>
> Sure it is. The kernel exists to provide the functionality that people 
> require, and UEFI imposes that requirement on the people. It's like 
> saying gcc policy shouldn't be the justification for kernel 
> implementation details. We don't control the gcc developers, but we have 
> to consume what they provide us with.

This isn't efi specific code.  We need to be able to think about what
is happening with a local analysis so we can see if it is correct.

This is slightly violated already as pointed out elsewhere,
as CAP_SECURE_BOOT means we did not boot securely.

>> So please rework this to come from an angle that makes sense all by
>> itself.
>
> I'm afraid I have no idea what you're asking for here. Some vendors want 
> to be able to ensure that kexec is only used to load trusted code. Right 
> now there's no mechanism for ensuring that, so why not at least provide 
> a mechanism for them to turn it off at runtime?

There is a mechanism to turn it off at runtime CAP_SYS_BOOT.

In general booting anything else besides what you are running is equally
bad.

What I am asking for is a mechanism that makes sense without having to
think about EFI.  Without having to think about the silly hoops people
are going through because of the impending launch of windows 8.

As Alan says a capability doesn't seem horrible.  But if we use a
capability it needs to be a well named capability, and the semantics
of the capability need to make inherent sense.

I have the basic question, why can't I trust the root who has all
capabilities?  What makes the root user more trusted than the linux
kernel.  Especially when typically the root user is the owner of
the machine.

There is a element here where it seems implementing the policy you
are proposing will start encouraging people to start hoarding kernel
bugs instead of reporting them.  So implementing this policy might
make the kernel in net less secure.  How is that prevented?

Ultimately the question is.

This is Unix.  In Unix we give root rope and let him hang himself
or shoot himself in the foot (not that we encourage it).

Why are we now implementing a security model where we don't trust root?

What is gained from a security model where root is untrusted?

Eric
