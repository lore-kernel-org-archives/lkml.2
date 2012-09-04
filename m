Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2IDXZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:25:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54875 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2IDXZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:25:06 -0400
Date: Wed, 5 Sep 2012 00:25:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
Message-ID: <20120904232503.GA1077@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-8-git-send-email-mjg@redhat.com>
 <87txvdzgur.fsf@xmission.com>
 <20120904202205.GA28903@srcf.ucam.org>
 <87r4qhwkx9.fsf@xmission.com>
 <20120904212717.GA30899@srcf.ucam.org>
 <87fw6xtp23.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw6xtp23.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:12:52PM -0700, Eric W. Biederman wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> > The driving force behind this code right now is that our choices are 
> > either (1) do something like this, or (2) disable kexec entirely.
> 
> Actually there is an interesting question here. Why does even EFI secure
> boot justify this?  If I install my own key in EFI I should be able to
> boot a kernel that does anything I want it to.   My machine doing what I
> want it to is the point of trusted boot is it not?

The full implementation should trust keys that are trusted by the 
platform, so it'd boot any kexec image you cared to sign. Or simply 
patch this code out and rebuild and self-sign, or disable the code that 
turns off the capability when in secure boot mode. I've no objection to 
putting that behind an #ifdef.

> > Like I 
> > said, long term we'd want to provide appropriate technical mechanisms to 
> > make kexec usable in a world where people want to be able to trust their 
> > kernel, and we have people working on that. But that being our 
> > motivation for the implementation doesn't mean that other parties won't 
> > have uses for it, and I'd like to find a solution that satisfies them as 
> > well.
> 
> I expect you want to make that that medium term.  Enterprise distros
> don't ship without kexec-on-panic.  Too often long term seems to be
> something that no one ever gets around to in kernel development.

I can't comment on the release schedule of unnanounced products or 
features that we may wish to be implemented in them.

> > Sure it is. The kernel exists to provide the functionality that people 
> > require, and UEFI imposes that requirement on the people. It's like 
> > saying gcc policy shouldn't be the justification for kernel 
> > implementation details. We don't control the gcc developers, but we have 
> > to consume what they provide us with.
> 
> This isn't efi specific code.  We need to be able to think about what
> is happening with a local analysis so we can see if it is correct.
> 
> This is slightly violated already as pointed out elsewhere,
> as CAP_SECURE_BOOT means we did not boot securely.

If your problem is the naming, we'll change the name. Really not a 
problem.

> > I'm afraid I have no idea what you're asking for here. Some vendors want 
> > to be able to ensure that kexec is only used to load trusted code. Right 
> > now there's no mechanism for ensuring that, so why not at least provide 
> > a mechanism for them to turn it off at runtime?
> 
> There is a mechanism to turn it off at runtime CAP_SYS_BOOT.

Which also prevents anyone from rebooting the system, which is really 
not what we're aiming for here. The firmware can enforce the booting of 
trusted code, the aim is to ensure that the kernel has equivalent 
functionality.

> What I am asking for is a mechanism that makes sense without having to
> think about EFI.  Without having to think about the silly hoops people
> are going through because of the impending launch of windows 8.

Again, I'm not clear on what you're talking about here. There's nothing 
UEFI specific about this patch. Anyone who has firmware-level trust can 
drop this capability in order to make it harder for someone to 
circumvent that trust by replacing the running kernel at runtime.

> I have the basic question, why can't I trust the root who has all
> capabilities?  What makes the root user more trusted than the linux
> kernel.  Especially when typically the root user is the owner of
> the machine.

Because historically we've found that root is also often someone who has 
determined a mechanism for running arbitrary code on your machine, 
rather than someone you trust. Root and the kernel aren't equivalent, 
otherwise root would just be able to turn off memory protection in their 
userspace processes. This patchset merely strengthens that existing 
dividing line.

> There is a element here where it seems implementing the policy you
> are proposing will start encouraging people to start hoarding kernel
> bugs instead of reporting them.  So implementing this policy might
> make the kernel in net less secure.  How is that prevented?

It's not. The metric I'm concerned with says a kernel where root can 
load arbitrary code into the kernel is less secure than one where root 
can't do that. Implementing this functionality may result in some 
unfixed flaws that permit root to load arbitrary code. Not implementing 
this functionality *guarantees* that root can load arbitrary code. So, 
by the metric I'm concerned with, security improves. But security isn't 
a bright line subject, and other people may disagree. I can't force 
anyone to implement a given policy.

> Ultimately the question is.
> 
> This is Unix.  In Unix we give root rope and let him hang himself
> or shoot himself in the foot (not that we encourage it).
> 
> Why are we now implementing a security model where we don't trust root?
> 
> What is gained from a security model where root is untrusted?

Root is already untrusted to a degree. We want to provide a mechanism 
that permits the user to indicate that they want to make that more 
explicit.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
