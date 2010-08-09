Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0HIJdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:33:25 -0400
Received: from web27001.mail.ukl.yahoo.com ([217.146.177.1]:21401 "HELO
	web27001.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755912Ab0HIJdX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:33:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=XCJ3cxRQYHNH6saz2uiIzSix1bsUYVhthft43OLLM+cSEbDcsPhH+veHuiMWVYJXzcsOjaWSo1EeBcLK2ssGjrnz+IJub/bUbwo2OZsBAOSikQUg09Wk6R41zjcr/9A25WgbY8OsDZjFizP+VfepcHww9VbzZKA/q20B5u8qLi0=;
Message-ID: <66994.33108.qm@web27001.mail.ukl.yahoo.com>
X-YMail-OSG: HCQX2IkVM1l3edg78vDFUb9xRsk.gv0lNUoE46fmDxPdTwi
 qgjCH36Aq9l_EfkDztLlfhksRO4ov9hPI9ERFMrRwsuphrOTUmXUoTdLsByL
 NMlgWBJB4CoXMCFjZF4nIdqXlN8q9o747sdUzK.6Ttb4PrVru0jmtGTEnONA
 tYkYUiowQ.xrtkAYRQ7Nz4RhC2_BHKyhn6VMoNBYP0J7OfsvbYIbcDyyUajF
 MC8CrzLf2OXOz5QkNBx_wjgrPa2dxl5Y21d4x7KL2MSvHUdXQdOtDeJwnrXb
 DbLD0of3f0qAHUZQdBbmQ747zlntq.2du12qopk0-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Mon, 9 Aug 2010 09:33:21 +0000 (GMT)
From: bifferos <bifferos@yahoo.co.uk>
Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what c_ident is
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de,
        hpa@linux.intel.com, Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <20100803192557.GA13595@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The quick fix for this is:

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 490dac6..06a2dac 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -497,6 +497,9 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
               if (!cpu_devs[i])
                       break;

+               if (!cpu_devs[i]->c_ident[0])
+                       continue;
+
               if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
                   (cpu_devs[i]->c_ident[1] &&
                    !strcmp(v, cpu_devs[i]->c_ident[1]))) {


however, Peter's requirement to remove c_ident renders my patch 
somewhat less useful back on RDC.  /proc/cpuinfo then lists the 
vendor as 'RDC' (an improvement over not applying the patch) and 
the model name as '486' (also an improvement), but for some 
reason the variants in my case statement then no longer make it 
through to /proc/info.  I don't think this is a big deal, and I
still think the patch is worth applying with this change.

regards,
Mark


--- On Tue, 3/8/10, Ingo Molnar <mingo@elte.hu> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what c_ident is
> To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org, florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de, hpa@linux.intel.com
> Cc: linux-tip-commits@vger.kernel.org
> Date: Tuesday, 3 August, 2010, 20:25
> 
> * tip-bot for H. Peter Anvin <hpa@linux.intel.com>
> wrote:
> 
> > Commit-ID: 
> c0366f5f5c1615c4f70b1bd646149ba9233830b9
> > Gitweb:     http://git.kernel.org/tip/c0366f5f5c1615c4f70b1bd646149ba9233830b9
> > Author:     H. Peter Anvin <hpa@linux.intel.com>
> > AuthorDate: Tue, 3 Aug 2010 10:09:56 -0700
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Tue, 3 Aug 2010 10:09:56 -0700
> > 
> > x86, cpu: RDC doesn't have CPUID, which is what
> c_ident is
> > 
> > c_ident is supposed to be a CPUID identifier, and RDC
> doesn't have
> > that.
> 
> -tip testing found that these RDC patches cause a boot
> crash if a 
> X86_RDC321X=y kernel is booted on a regular PC:
> 
> [    0.015999] Pid: 0, comm: swapper Not tainted
> 2.6.35-tip+ #23896 A8N-E/System Product Name 
>    
> [    0.015999] EIP: 0060:[<c1267d14>]
> EFLAGS: 00010282 CPU: 0         
>                
>            
> [    0.015999] EIP is at strcmp+0xf/0x22 
>                
>                
>                
>         
> [    0.015999] EAX: c1a81541 EBX: 00000004 ECX:
> 0000000f EDX: 00000000         
>                
>   
> [    0.015999] ESI: c1a81571 EDI: 00000000 EBP:
> c19ccf78 ESP: c19ccf70         
>                
>   
> [    0.015999]  DS: 007b ES: 007b FS: 00d8
> GS: 00e0 SS: 0068           
>                
>           
> [    0.015999] Process swapper (pid: 0,
> ti=c19cc000 task=c1a07e60 task.ti=c19cc000)   
>            
> [    0.015999] Stack:       
>                
>                
>                
>                
>      
> [    0.015999]  c1a81530 c1a81570 c19ccf8c
> c16d9b7f c1ac8538 c1a81530 c1a81570 c19ccfac   
>        
> [    0.015999] <0> c16d9dcb c104dc9f
> c1a15210 c1a81548 c1ac8538 00099800 c19ce000 c19ccfb4 
>       
> [    0.015999] <0> c1a89a4f c19ccfc0
> c1a89d2d c1a96147 c19ccfe0 c1a84953 431d9715 00000006 
>       
> [    0.015999] Call Trace:     
>                
>                
>                
>                
>   
> [    0.015999]  [<c16d9b7f>] ?
> get_cpu_vendor+0x22/0x8f         
>                
>              
>    
> [    0.015999]  [<c16d9dcb>] ?
> identify_cpu+0xc5/0x2e0         
>                
>                
>   
> [    0.015999]  [<c104dc9f>] ?
> sub_preempt_count+0x9/0x39         
>                
>            
>    
> [    0.015999]  [<c1a89a4f>] ?
> identify_boot_cpu+0xd/0x23         
>                
>            
>    
> [    0.015999]  [<c1a89d2d>] ?
> check_bugs+0xb/0xaf           
>                
>                
>     
> [    0.015999]  [<c1a96147>] ?
> cpuset_init+0x65/0x77         
>                
>                
>     
> [    0.015999]  [<c1a84953>] ?
> start_kernel+0x37e/0x392         
>                
>              
>    
> [    0.015999]  [<c1a840c9>] ?
> i386_start_kernel+0xc9/0xd0       
>                
>                 
> [    0.015999] Code: c0 83 c9 ff f2 ae 4f 89 d1
> 49 78 06 ac aa 84 c0 75 f7 31 c0 aa 89 d8 5b 5e 5 
> [    0.015999] EIP: [<c1267d14>]
> strcmp+0xf/0x22 SS:ESP 0068:c19ccf70     
>                
>        
> 
> mercury:~> cat /proc/cpuinfo 
> processor    : 0
> vendor_id    : AuthenticAMD
> cpu family    : 15
> model        : 35
> model name    : AMD Athlon(tm) 64 X2 Dual
> Core Processor 3800+
> stepping    : 2
> cpu MHz        : 2010.301
> cache size    : 512 KB
> physical id    : 0
> siblings    : 2
> core id        : 0
> cpu cores    : 2
> fpu        : yes
> fpu_exception    : yes
> cpuid level    : 1
> wp        : yes
> flags        : fpu vme de pse
> tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36
> clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm
> 3dnowext 3dnow rep_good pni lahf_lm cmp_legacy
> bogomips    : 4021.85
> TLB size    : 1024 4K pages
> clflush size    : 64
> cache_alignment    : 64
> address sizes    : 40 bits physical, 48 bits
> virtual
> power management: ts fid vid ttp
> 
> config attached.
> 
> Thanks,
> 
>     Ingo
> 


      
