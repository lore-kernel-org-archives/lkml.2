Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab0K3MRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 07:17:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab0K3MRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 07:17:41 -0500
Subject: Re: linux-next: Tree for November 22 (kvm)
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Avi Kivity <avi@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CF3EC1E.7050707@redhat.com>
References: <20101122134911.b7e106f9.sfr@canb.auug.org.au>
	 <20101122132627.bd4e88ef.randy.dunlap@oracle.com>
	 <20101129083324.6870d7da.randy.dunlap@oracle.com>
	 <4CF3D637.6060204@redhat.com> <4CF3E733.8090809@redhat.com>
	 <4CF3E870.4040308@oracle.com>  <4CF3EC1E.7050707@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 30 Nov 2010 10:17:28 -0200
Message-ID: <1291119448.17261.4.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 08:08 -1000, Zachary Amsden wrote:
> On 11/29/2010 07:52 AM, Randy Dunlap wrote:
> > On 11/29/10 09:47, Zachary Amsden wrote:
> >    
> >> On 11/29/2010 06:35 AM, Avi Kivity wrote:
> >>      
> >>> On 11/29/2010 06:33 PM, Randy Dunlap wrote:
> >>>        
> >>>> On Mon, 22 Nov 2010 13:26:27 -0800 Randy Dunlap wrote:
> >>>>
> >>>>          
> >>>>>   On Mon, 22 Nov 2010 13:49:11 +1100 Stephen Rothwell wrote:
> >>>>>
> >>>>>            
> >>>>>>   Hi all,
> >>>>>>
> >>>>>>   Changes since 20101119:
> >>>>>>              
> >>>>>
> >>>>>   kvm.c:(.init.text+0x11f49): undefined reference to
> >>>>>            
> >>>> `kvm_register_clock'
> >>>>          
> >>>>>   when CONFIG_KVM_CLOCK is not enabled.
> >>>>>            
> >>>>
> >>>> BUild error still present in linux-next-2010-NOV-29.
> >>>>
> >>>>          
> >>> Glauber, Zach?
> >>>
> >>>        
> >> I can only speculate this reference is being called from smpboot without
> >> CONFIG guarding?
> >>      
> > Sorry, looks like I dropped the first line of the error messages:
> >
> > arch/x86/built-in.o: In function `kvm_smp_prepare_boot_cpu':
> > kvm.c:(.init.text+0xad38): undefined reference to `kvm_register_clock'
> >
> > from arch/x86/kernel/kvm.c:
> >
> > #ifdef CONFIG_SMP
> > static void __init kvm_smp_prepare_boot_cpu(void)
> > {
> > 	WARN_ON(kvm_register_clock("primary cpu clock"));
> > 	kvm_guest_cpu_init();
> > 	native_smp_prepare_boot_cpu();
> > }
> >
> > so it looks like you are correct...
> >    
> 
> Looks like this is the appropriate fix:
> 
> #ifdef CONFIG_SMP
> static void __init kvm_smp_prepare_boot_cpu(void)
> {
> #ifdef CONFIG_KVM_CLOCK
> 	WARN_ON(kvm_register_clock("primary cpu clock"));
> #endif
> 	kvm_guest_cpu_init();
> 	native_smp_prepare_boot_cpu();
> }
> 
> 
> The SMP code is still buggy as well, wrt printk timing, in that it 
> doesn't get called early enough, correct?  Has anyone thought of a good 
> solution to that problem?
> 
> Basically the problem is CPU-1 will get CPU-0's per-cpu areas copied 
> over, and these are not valid for CPU-1.  If the clocksource is used on 
> CPU-1 before kvm clock gets setup, it can go backwards, wreaking havoc, 
> causing panic, etc.
> 
> What is the best test to guard against this?  Perhaps we should keep the 
> CPU number in the per-cpu data and test against it?
Can we identify precisely when it happens? If we can, we can try to
force a hypervisor exit or re-register right after the data is copied
over. This will force the per-cpu structure to get updated with good
values.



