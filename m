Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab0KPTYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:24:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:59772 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab0KPTYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:24:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,207,1288594800"; 
   d="scan'208";a="574406179"
Subject: Re: [REGRESSION] [BISECT] ACPI+Inspiron 1545 = crash at
 xrstor_state()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jody Bruchon <jody@nctritech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
In-Reply-To: <20101116144213.GA3715@a1.tnic>
References: <20101116144213.GA3715@a1.tnic>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 16 Nov 2010 11:24:18 -0800
Message-Id: <1289935458.2683.28.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 06:42 -0800, Borislav Petkov wrote:
> On Tue, Nov 16, 2010 at 04:56:06AM -0500, Jody Bruchon wrote:
> >  I previously reported an early boot crash on an Inspiron 1545 laptop;
> > see previous posts for more details.  I used the parameters "debug
> > vga=6 earlyprintk=vga" to catch these errors since they happen so
> > early in boot that the normal console has not yet initialized.
> > 
> > A picture of the crash dump from 2.6.37-rc2 is available here (2.6.36
> > crash is identical except for the reported kernel version):
> > http://c02ware.com/bugs/dump_c7ff0d9c92435e836e13aaa8d0e56d4000424bcc.jpg
> > 
> > I have experienced similar problems on a small number of other systems
> > also.  After confirming that the problem was introduced going from
> > 2.6.35 to 2.6.36, I have successfully bisected the kernel, and
> > narrowed down and tested to verify the commit which introduced the
> > problem.  Reverting this commit fixes 2.6.36 but 2.6.37-rc2 has the
> > exact same crash even if I revert it.  I don't know what to do from
> > here, but someone with more knowledge can surely guide me.  I will
> > only have the unit to test with for another day or two.  I have
> > attached a suitable .config for reference as well.  The commit info is
> > below.
> 
> I don't think this patch is at fault. Your oops photo above shows that
> the machine oopses at the first xrstor call in xstate_enable_boot_cpu():
> 
>  1c3:   0f 06                   clts
>  1c5:   83 c8 ff                or     $0xffffffff,%eax
>  1c8:   89 c2                   mov    %eax,%edx
>  1ca:   0f ae 2f                xrstor (%edi)			<---------
>  1cd:   8b 3d 54 00 00 00       mov    0x54,%edi
>  1d3:   0f ae 27                xsave  (%edi)
> 
> Adding more people to Cc.

hmm, that kernel .config has CONFIG_X86_L1_CACHE_SHIFT=5 and hence
xrstor faulted as it didn't find a 64byte aligned buffer.

Can you set the cpu type to GENERIC_CPU instead of MPENTIUMII? That
should avoid this issue.

I will see how can I fix this issue.

thanks,
suresh

