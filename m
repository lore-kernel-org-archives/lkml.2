Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab1EaRkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:40:52 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:42146 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab1EaRkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:40:51 -0400
Date: Tue, 31 May 2011 23:10:43 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        anderson@redhat.com
Subject: Re: [RFC Patch 4/6] PANIC_MCE: Introduce a new panic flag for fatal
 MCE, capture related information
Message-ID: <20110531174043.GA2000@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
 <20110526171521.GD17988@in.ibm.com>
 <m1fwo09g15.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fwo09g15.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:04:06AM -0700, Eric W. Biederman wrote:
> "K.Prasad" <prasad@linux.vnet.ibm.com> writes:
> 
> > PANIC_MCE: Introduce a new panic flag for fatal MCE, capture related information
> >
> > Fatal machine check exceptions (caused due to hardware memory errors) will now
> > result in a 'slim' coredump that captures vital information about the MCE. This
> > patch introduces a new panic flag, and new parameters to *panic functions
> > that can capture more information pertaining to the cause of crash.
> >
> > Enable a new elf-notes section to store additional information about the crash.
> > For MCE, enable a new notes section that captures relevant register status
> > (struct mce) to be later read during coredump analysis.
> 
> There may be a reason to pass everything struct mce through 5 layers of
> code but right now it looks like it just makes everything uglier to no
> real purpose.

We could have stopped with just a blank elf-note of type NT_MCE
indicating an MCE triggered panic, but dumping 'struct mce' in it will
help gather more useful information about the error - especially the
memory address that experienced unrecoverable error (stored in
mce->addr).

The patch 6/6 for the 'crash' tool enabled decoding of 'struct
mce' to show this information (although the sample log in patch 0/6)
didn't show these benefits because 'mce-inject' tool used to soft-inject
these errors doesn't populate all registers with valid contents.

The idea was that when mce->addr contains physical address is shown
while decoding coredump, the corresponding memory DIMM could be identified
for replacement/isolation.

Given that 'struct mce' isn't placed in a user-space visible file its
duplicate copies have to be maintained in 'crash' (like it is done in
'mcelog' tool), and that's one disadvantage.

If you think that this complicates the patch, I'll start with a much
'slimmer' version (!) of the slimdump and the improvements may be
contemplated iteratively.

Thanks,
K.Prasad
