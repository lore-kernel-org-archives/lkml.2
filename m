Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1FOCHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 22:07:01 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:43069 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab1FOCG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 22:06:59 -0400
Date: Wed, 15 Jun 2011 07:36:16 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        anderson@redhat.com
Subject: Re: [RFC Patch 4/6] PANIC_MCE: Introduce a new panic flag for fatal
 MCE, capture related information
Message-ID: <20110615020616.GA2070@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
 <20110526171521.GD17988@in.ibm.com>
 <m1fwo09g15.fsf@fess.ebiederm.org>
 <20110531174043.GA2000@in.ibm.com>
 <20110608171632.GA11077@in.ibm.com>
 <m162obt5pi.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m162obt5pi.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 08:44:25AM -0700, Eric W. Biederman wrote:
> "K.Prasad" <prasad@linux.vnet.ibm.com> writes:
> 
> > On Tue, May 31, 2011 at 11:10:43PM +0530, K.Prasad wrote:
> >> On Fri, May 27, 2011 at 11:04:06AM -0700, Eric W. Biederman wrote:
> >> > "K.Prasad" <prasad@linux.vnet.ibm.com> writes:
> >> > 
[snipped]
> > So our fears arise due to the premise that reading a faulty memory
> > location leads to undesirable consequences (whether MCE is disabled
> > or not) and would like to modify the OS to avoid such an operation.
> >
> > While the ugliness of the patch (which I believe is due to
> > non-separation of generic and arch-specific code) is something that can
> > be addressed, I hope that the reasons for the patch are seen to be
> > valid.
> 
> Yes.  The objection really is to not exporting the information you need
> to solve this in userspace and then fixing the one userspace tool that
> uses this to work correctly.
> 
> > Here's an attempt to make the slimdump patch more generic that can be
> > used by any hardware generated crash to prevent a coredump from being
> > captured (compile tested only).
> >
> > I'll post a more formal version of the patch upon hearing further
> > comments.
> 
> But this is not the way.  The kernel does not generate the core dump
> it just gives the information needed for userspace to generate the core
> dump.
> 
> Giving a little more information to userspace and letting the program
> that reads vmcore have the policy on what do is the preferred way to do
> this.
> 
> You are asking for yet another way to filter crashdumps which is
> entirely reasonable.  Patching out the ability in the kernel for the
> rest of us to have our own policies of what to dump is unreasonable.
>

I think I get the drift of your idea. So adding a new elf-note to
indicate the cause of crash is fine...and continue to allow the kernel
to provide a way to read old kernel memory irrespective of the crash.

Instead, make the user-space tool (makedumpfile?) more intelligent to
recognise the cause of crash as fatal MCE or any other hardware-error
induced crash (using the new elf-note as a clue) and abstain from
reading the contents of the old memory to create a full coredump. A
different user with a different need might want to try out something
adventurous (by reading the full coredump) but let not the kernel
prevent it, which sounds fine. I'll get some patches ready to this
effect.

However, there's another part of the problem - wherein pages with
uncorrectable memory errors which are detected during scrubbing, marked
as 'hardware poisoned' (with PG_hwpoison flag) in order to be quarantined,
may be read during creation of coredump initiated through usual kernel
panics (software bug or otherwise).

This will result in a fatal MCE for the kdump kernel and will cause a
reboot of the system without any coredump (and possibly without any
message in /var/log/messages). We're contemplating ways to avoid such a
situation and the panic+crash_kexec+vmcore/makedumpfile code may
require suitable changes to address this issue.

Let us know your views on this.

Thanks,
K.Prasad

