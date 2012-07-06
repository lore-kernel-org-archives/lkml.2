Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2GFJsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:48:39 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55073 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2GFJsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:48:36 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 3/7] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <20120703075535.GA13291@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050629.4560.85284.stgit@abhimanyu.in.ibm.com> <20120703075535.GA13291@amt.cnet>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Fri, 06 Jul 2012 15:17:53 +0530
Message-ID: <87hatlxlti.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
x-cbid: 12070609-8256-0000-0000-0000033568B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue, 3 Jul 2012 04:55:35 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Jun 04, 2012 at 10:37:24AM +0530, Nikunj A. Dadhania wrote:
> > flush_tlb_others_ipi depends on lot of statics in tlb.c.  Replicated
> > the flush_tlb_others_ipi as kvm_flush_tlb_others to further adapt to
> > paravirtualization.
> > 
> > Use the vcpu state information inside the kvm_flush_tlb_others to
> > avoid sending ipi to pre-empted vcpus.
> > 
> > * Do not send ipi's to offline vcpus and set flush_on_enter flag
> > * For online vcpus: Wait for them to clear the flag
> > 
> > The approach was discussed here: https://lkml.org/lkml/2012/2/20/157
> > 
> > Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> > 
> > --
> > Pseudo Algo:
> > 
> >    Write()
> >    ======
> > 
> > 	   guest_exit()
> > 		   flush_on_enter[i]=0;
> > 		   running[i] = 0;
> > 
> > 	   guest_enter()
> > 		   running[i] = 1;
> > 		   smp_mb();
> > 		   if(flush_on_enter[i]) {
> > 			   tlb_flush()
> > 			   flush_on_enter[i]=0;
> > 		   }
> > 
> > 
> >    Read()
> >    ======
> > 
> > 	   GUEST                                                KVM-HV
> > 
> >    f->flushcpumask = cpumask - me;
> > 
> > again:
> >    for_each_cpu(i, f->flushmask) {
> > 
> > 	   if (!running[i]) {
> > 						   case 1:
> > 
> > 						   running[n]=1
> > 
> > 						   (cpuN does not see
> > 						   flush_on_enter set,
> > 						   guest later finds it
> > 						   running and sends ipi,
> > 						   we are fine here, need
> > 						   to clear the flag on
> > 						   guest_exit)
> > 
> > 		  flush_on_enter[i] = 1;
> > 						   case2:
> > 
> > 						   running[n]=1
> > 						   (cpuN - will see flush
> > 						   on enter and an IPI as
> > 						   well - addressed in patch-4)
> > 
> > 		  if (!running[i])
> > 		     cpu_clear(f->flushmask);      All is well, vm_enter
> > 						   will do the fixup
> > 	   }
> > 						   case 3:
> > 						   running[n] = 0;
> > 
> > 						   (cpuN went to sleep,
> > 						   we saw it as awake,
> > 						   ipi sent, but wait
> > 						   will break without
> > 						   zero_mask and goto
> > 						   again will take care)
> > 
> >    }
> >    send_ipi(f->flushmask)
> > 
> >    wait_a_while_for_zero_mask();
> > 
> >    if (!zero_mask)
> > 	   goto again;
> 
> Can you please measure increased vmentry/vmexit overhead? x86/vmexit.c 
> of git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git should 
> help.
> 

Please find below the results (debug patch attached for enabling
registration of kvm_vcu_state)

I have taken results for 1 and 4 vcpus. Used the following command for
starting the tests:

/usr/libexec/qemu-kvm -smp $i -device testdev,chardev=testlog -chardev
file,id=testlog,path=vmexit.out -serial stdio -kernel ./x86/vmexit.flat

Machine : IBM xSeries with Intel(R) Xeon(R) X7560 2.27GHz CPU 
          with 32 core, 32 online cpus and 4*64GB RAM.

x  base - unpatched host kernel 
+  wo_vs - patched host kernel, vcpu_state not registered
*  w_vs.txt - patched host kernel and vcpu_state registered

1 vcpu results:
---------------
    cpuid
    =====
           N        Avg       Stddev
    x     10     2135.1      17.8975
    +     10       2188      18.3666
    *     10     2448.9      43.9910
    
    vmcall
    ======
           N        Avg       Stddev
    x     10     2025.5      38.1641
    +     10     2047.5      24.8205
    *     10     2306.2      40.3066
    
    mov_from_cr8
    ============
           N        Avg       Stddev
    x     10         12       0.0000
    +     10         12       0.0000
    *     10         12       0.0000
    
    mov_to_cr8
    ==========
           N        Avg       Stddev
    x     10       19.4       0.5164
    +     10       19.1       0.3162
    *     10       19.2       0.4216
    
    inl_from_pmtimer
    ================
           N        Avg       Stddev
    x     10    18093.2     462.0543
    +     10    16579.7    1448.8892
    *     10    18577.7     266.2676
    
    ple-round-robin
    ===============
           N        Avg       Stddev
    x     10       16.1       0.3162
    +     10       16.2       0.4216
    *     10       15.3       0.4830

4 vcpus result
--------------
    cpuid
    =====
           N        Avg       Stddev
    x     10     2135.8      10.0642
    +     10       2165       6.4118
    *     10     2423.7      12.5526
    
    vmcall
    ======
           N        Avg       Stddev
    x     10     2028.3      19.6641
    +     10     2024.7       7.2273
    *     10     2276.1      13.8680
    
    mov_from_cr8
    ============
           N        Avg       Stddev
    x     10         12       0.0000
    +     10         12       0.0000
    *     10         12       0.0000
    
    mov_to_cr8
    ==========
           N        Avg       Stddev
    x     10         19       0.0000
    +     10         19       0.0000
    *     10         19       0.0000
    
    inl_from_pmtimer
    ================
           N        Avg       Stddev
    x     10    25574.2    1693.5374
    +     10    25190.7    2219.9223
    *     10      23044    1230.8737
    
    ipi
    ===
           N        Avg       Stddev
    x     20   31996.75    7290.1777
    +     20   33683.25    9795.1601
    *     20    34563.5    8338.7826
    
    ple-round-robin
    ===============
           N        Avg       Stddev
    x     10     6281.7    1543.8601
    +     10     6149.8    1207.7928
    *     10     6433.3    2304.5377

Thanks
Nikunj


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=enable_vcpu_state.diff


Enable and register vcpu_state information to the host
    
Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

diff --git a/x86/vmexit.c b/x86/vmexit.c
index ad8ab55..a9823c9 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -3,6 +3,7 @@
 #include "smp.h"
 #include "processor.h"
 #include "atomic.h"
+#include "vm.h"
 
 static unsigned int inl(unsigned short port)
 {
@@ -173,10 +174,45 @@ static void enable_nx(void *junk)
 		wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX_MASK);
 }
 
+#define KVM_MSR_ENABLED                 1
+#define KVM_FEATURE_VCPU_STATE          7
+#define MSR_KVM_VCPU_STATE              0x4b564d04
+
+struct kvm_vcpu_state {
+        int state;
+        int flush_on_enter;
+        int pad[14];
+};
+
+struct kvm_vcpu_state test[4];
+
+static inline void my_wrmsr(unsigned int msr,
+			  unsigned low, unsigned high)
+{
+  asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high) : "memory");
+}
+#define wrmsrl(msr, val) my_wrmsr(msr, (u32)((u64)(val)), ((u64)(val))>>32)
+
+static void enable_vcpu_state(void *junk)
+{
+	struct kvm_vcpu_state *vs;
+	int me = smp_id();
+
+	if (cpuid(0x80000001).d & (1 << KVM_FEATURE_VCPU_STATE)) {
+		vs = &test[me];
+		memset(vs, 0, sizeof(struct kvm_vcpu_state));
+		
+		wrmsrl(MSR_KVM_VCPU_STATE, ((unsigned long)(vs) | KVM_MSR_ENABLED));
+		printf("%d: Done vcpu state %p\n", me, virt_to_phys((void*)vs));
+	}
+}
+
 bool test_wanted(struct test *test, char *wanted[], int nwanted)
 {
 	int i;
 
+	return true;
+
 	if (!nwanted)
 		return true;
 
@@ -192,11 +228,16 @@ int main(int ac, char **av)
 	int i;
 
 	smp_init();
+	setup_vm();
+
 	nr_cpus = cpu_count();
 
 	for (i = cpu_count(); i > 0; i--)
 		on_cpu(i-1, enable_nx, 0);
 
+	for (i = cpu_count(); i > 0; i--)
+		on_cpu(i-1, enable_vcpu_state, 0);
+
 	for (i = 0; i < ARRAY_SIZE(tests); ++i)
 		if (test_wanted(&tests[i], av + 1, ac - 1))
 			do_test(&tests[i]);

--=-=-=--

