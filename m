Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1FLPoe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 11:44:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53314 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab1FLPoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 11:44:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: prasad@linux.vnet.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck\, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        anderson@redhat.com
References: <20110526170722.GB23266@in.ibm.com>
	<20110526171521.GD17988@in.ibm.com> <m1fwo09g15.fsf@fess.ebiederm.org>
	<20110531174043.GA2000@in.ibm.com> <20110608171632.GA11077@in.ibm.com>
Date: Sun, 12 Jun 2011 08:44:25 -0700
In-Reply-To: <20110608171632.GA11077@in.ibm.com> (K. Prasad's message of "Wed,
	8 Jun 2011 22:46:32 +0530")
Message-ID: <m162obt5pi.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX199jUqiFULaTCxCg4r+Xm8tmFTHuZu4t1o=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;prasad@linux.vnet.ibm.com
X-Spam-Relay-Country: 
Subject: Re: [RFC Patch 4/6] PANIC_MCE: Introduce a new panic flag for fatal MCE, capture related information
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"K.Prasad" <prasad@linux.vnet.ibm.com> writes:

> On Tue, May 31, 2011 at 11:10:43PM +0530, K.Prasad wrote:
>> On Fri, May 27, 2011 at 11:04:06AM -0700, Eric W. Biederman wrote:
>> > "K.Prasad" <prasad@linux.vnet.ibm.com> writes:
>> > 
>> > > PANIC_MCE: Introduce a new panic flag for fatal MCE, capture related information
>> > >
>> > > Fatal machine check exceptions (caused due to hardware memory errors) will now
>> > > result in a 'slim' coredump that captures vital information about the MCE. This
>> > > patch introduces a new panic flag, and new parameters to *panic functions
>> > > that can capture more information pertaining to the cause of crash.
>> > >
>> > > Enable a new elf-notes section to store additional information about the crash.
>> > > For MCE, enable a new notes section that captures relevant register status
>> > > (struct mce) to be later read during coredump analysis.
>> > 
>> > There may be a reason to pass everything struct mce through 5 layers of
>> > code but right now it looks like it just makes everything uglier to no
>> > real purpose.
>> 
>> We could have stopped with just a blank elf-note of type NT_MCE
>> indicating an MCE triggered panic, but dumping 'struct mce' in it will
>> help gather more useful information about the error - especially the
>> memory address that experienced unrecoverable error (stored in
>> mce->addr).
>> 
>> The patch 6/6 for the 'crash' tool enabled decoding of 'struct
>> mce' to show this information (although the sample log in patch 0/6)
>> didn't show these benefits because 'mce-inject' tool used to soft-inject
>> these errors doesn't populate all registers with valid contents.
>> 
>> The idea was that when mce->addr contains physical address is shown
>> while decoding coredump, the corresponding memory DIMM could be identified
>> for replacement/isolation.
>> 
>> Given that 'struct mce' isn't placed in a user-space visible file its
>> duplicate copies have to be maintained in 'crash' (like it is done in
>> 'mcelog' tool), and that's one disadvantage.
>> 
>> If you think that this complicates the patch, I'll start with a much
>> 'slimmer' version (!) of the slimdump and the improvements may be
>> contemplated iteratively.
>
> While there are reports that kdump works fine (like in your case) in
> capturing the coredump for a crash resulting from fatal MCE,
> unfortunately we don't have means to recreate such a behaviour due to
> the inability to inject memory errors in hardware to study further.

Most modern memory controllers have the functionality of generating
memory writes with deliberately bad ecc data, and playing with a heat
gun or shorting to data wires together on dimms, to generate real ecc
errors isn't hard.  So with a day or so of effort you should be able to
test what happens when you get an MCE.

Furthermore there is the lkdtm module which let's you test other types
of crash dumps so you can verify that all sorts of code paths work.

> So our fears arise due to the premise that reading a faulty memory
> location leads to undesirable consequences (whether MCE is disabled
> or not) and would like to modify the OS to avoid such an operation.
>
> While the ugliness of the patch (which I believe is due to
> non-separation of generic and arch-specific code) is something that can
> be addressed, I hope that the reasons for the patch are seen to be
> valid.

Yes.  The objection really is to not exporting the information you need
to solve this in userspace and then fixing the one userspace tool that
uses this to work correctly.

> Here's an attempt to make the slimdump patch more generic that can be
> used by any hardware generated crash to prevent a coredump from being
> captured (compile tested only).
>
> I'll post a more formal version of the patch upon hearing further
> comments.

But this is not the way.  The kernel does not generate the core dump
it just gives the information needed for userspace to generate the core
dump.

Giving a little more information to userspace and letting the program
that reads vmcore have the policy on what do is the preferred way to do
this.

You are asking for yet another way to filter crashdumps which is
entirely reasonable.  Patching out the ability in the kernel for the
rest of us to have our own policies of what to dump is unreasonable.

Eric
