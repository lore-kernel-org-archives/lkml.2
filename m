Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab1FARXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759044Ab1FARXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:23:44 -0400
Date: Wed, 1 Jun 2011 13:23:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Anderson <anderson@redhat.com>
Cc: prasad@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC Patch 4/6] PANIC_MCE: Introduce a new panic flag for fatal
 MCE, capture related information
Message-ID: <20110601172326.GA17449@redhat.com>
References: <20110531174043.GA2000@in.ibm.com>
 <718105787.11709.1306948696436.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <718105787.11709.1306948696436.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 01:18:16PM -0400, Dave Anderson wrote:
> 
> 
> ----- Original Message -----
> > On Fri, May 27, 2011 at 11:04:06AM -0700, Eric W. Biederman wrote:
> > > "K.Prasad" <prasad@linux.vnet.ibm.com> writes:
> > >
> > > > PANIC_MCE: Introduce a new panic flag for fatal MCE, capture
> > > > related information
> > > >
> > > > Fatal machine check exceptions (caused due to hardware memory errors) will now
> > > > result in a 'slim' coredump that captures vital information about the MCE. This
> > > > patch introduces a new panic flag, and new parameters to *panic functions
> > > > that can capture more information pertaining to the cause of
> > > > crash.
> > > >
> > > > Enable a new elf-notes section to store additional information about the crash.
> > > > For MCE, enable a new notes section that captures relevant register status
> > > > (struct mce) to be later read during coredump analysis.
> > >
> > > There may be a reason to pass everything struct mce through 5 layers of
> > > code but right now it looks like it just makes everything uglier to no
> > > real purpose.
> > 
> > We could have stopped with just a blank elf-note of type NT_MCE
> > indicating an MCE triggered panic, but dumping 'struct mce' in it will
> > help gather more useful information about the error - especially the
> > memory address that experienced unrecoverable error (stored in mce->addr).
> > 
> > The patch 6/6 for the 'crash' tool enabled decoding of 'struct
> > mce' to show this information (although the sample log in patch 0/6)
> > didn't show these benefits because 'mce-inject' tool used to soft-inject
> > these errors doesn't populate all registers with valid contents.
> > 
> > The idea was that when mce->addr contains physical address is shown
> > while decoding coredump, the corresponding memory DIMM could be identified
> > for replacement/isolation.
> > 
> > Given that 'struct mce' isn't placed in a user-space visible file its
> > duplicate copies have to be maintained in 'crash' (like it is done in
> > 'mcelog' tool), and that's one disadvantage.
> 
> FWIW, unlike mcelog, it really doesn't have to be maintained in the crash
> utility.  It's just another kernel data structure whose contents can be
> determined dynamically during runtime:
> 

That's what I was wondering. Why can't we simple extract the contents
of this structure from /proc/vmcore and save it, instead of trying to
export it by appending additional elf notes to vmcore.

Thanks
Vivek

>   crash> struct mce
>   struct mce {
>       __u64 status;
>       __u64 misc;
>       __u64 addr;
>       __u64 mcgstatus;
>       __u64 ip;
>       __u64 tsc;
>       __u64 time;
>       __u8 cpuvendor;
>       __u8 inject_flags;
>       __u16 pad;
>       __u32 cpuid;
>       __u8 cs;
>       __u8 bank;
>       __u8 cpu;
>       __u8 finished;
>       __u32 extcpu;
>       __u32 socketid;
>       __u32 apicid;
>       __u64 mcgcap;
>   }
>   SIZE: 88
>   crash> 
> 
> Dave
>  
> > If you think that this complicates the patch, I'll start with a much
> > 'slimmer' version (!) of the slimdump and the improvements may be
> > contemplated iteratively.
> > 
> > Thanks,
> > K.Prasad
