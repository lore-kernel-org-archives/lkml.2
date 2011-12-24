Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1LXRF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 12:05:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab1LXRFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 12:05:25 -0500
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=windows-1252
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20111224111359.GB3938@alea.gnuu.de>
Date: Sat, 24 Dec 2011 18:05:21 +0100
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C40CA3A1-2397-423B-96B3-CBEE4EA7EA30@suse.de>
References: <20111107194838.GA23558@alea.gnuu.de> <20111220202711.GD6830@alea.gnuu.de> <C3B4A5C9-0AE0-49C8-A349-879ADDA01804@suse.de> <20111224103108.GA19586@alea.gnuu.de> <20111224111359.GB3938@alea.gnuu.de>
To: =?iso-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24.12.2011, at 12:13, Jörg Sommer wrote:

> Jörg Sommer hat am Sat 24. Dec, 11:31 (+0100) geschrieben:
>> Alexander Graf hat am Fri 23. Dec, 14:50 (+0100) geschrieben:
>>> On 20.12.2011, at 21:27, Jörg Sommer wrote:
>>>> Jörg Sommer hat am Mon 07. Nov, 20:48 (+0100) geschrieben:
>>>>> CHK     include/linux/version.h
>>>>> HOSTCC  scripts/mod/modpost.o
>>>>> CHK     include/generated/utsrelease.h
>>>>> UPD     include/generated/utsrelease.h
>>>>> HOSTLD  scripts/mod/modpost
>>>>> GEN     include/generated/bounds.h
>>>>> CC      arch/powerpc/kernel/asm-offsets.s
>>>>> In file included from arch/powerpc/kernel/asm-offsets.c:59:0:
>>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h: In function ‘compute_tlbie_rb’:
>>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: error: ‘HPTE_V_SECONDARY’ undeclared (first use in this function)
>>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: note: each undeclared identifier is reported only once for each function it appears in
>>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:396:12: error: ‘HPTE_V_1TB_SEG’ undeclared (first use in this function)
>>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:401:10: error: ‘HPTE_V_LARGE’ undeclared (first use in this function)
>>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:415:2: warning: right shift count >= width of type [enabled by default]
>>>>> make[3]: *** [arch/powerpc/kernel/asm-offsets.s] Fehler 1
>>>>> make[2]: *** [prepare0] Fehler 2
>>>>> make[1]: *** [deb-pkg] Fehler 2
>>>>> make: *** [deb-pkg] Fehler 2
>>>> 
>>>> I'm so sorry to have to report a new bug in one of your patches. It was
>>>> covered by the one above. I've picked the commit for it from your git
>>>> repository and now, the kernel build fails with this error:
>>>> 
>>>> BOOTCC  arch/powerpc/boot/fdt_strerror.o
>>>> BOOTAR  arch/powerpc/boot/wrapper.a
>>>> WRAP    arch/powerpc/boot/zImage.pmac
>>>> WRAP    arch/powerpc/boot/zImage.coff
>>>> ERROR: "kvmppc_h_pr" [arch/powerpc/kvm/kvm.ko] undefined!
>>>> make[3]: *** [__modpost] Fehler 1
>>>> make[2]: *** [modules] Fehler 2
>>>> make[2]: *** Warte auf noch nicht beendete Prozesse...
>>>> WRAP    arch/powerpc/boot/zImage.miboot
>>>> make[1]: *** [deb-pkg] Fehler 2
>>>> make: *** [deb-pkg] Fehler 2
>>> 
>>> This is odd. kvmppc_h_pr shouldn't be accessed when not in book3s_64_pr mode:
>>> 
>>> #ifdef CONFIG_KVM_BOOK3S_64_PR
>>>                        if (kvmppc_h_pr(vcpu, cmd) == EMULATE_DONE) {
>>>                                r = RESUME_GUEST;
>>>                                break;
>>>                        }
>>> #endif
> 
> Is this the change you've thought of?
> 
> commit b8624f11e94dd9c2280cb01bf2ede31e4316477d
> Author: Jörg Sommer <joerg@alea.gnuu.de>
> Date:   Sat Dec 24 12:03:03 2011 +0100
> 
>    KVM: PPC: Use kvmppc_h_pr only if it's available
> 
>    The function kvmppc_h_pr() is only available when the config option
>    CONFIG_KVM_BOOK3S_64_PR is set, which is not the case for 32-bit PowerPCs
>    for example. Building the kernel for these systems failed, because the
>    symbol could not be resolved.
> 
>    ERROR: "kvmppc_h_pr" [arch/powerpc/kvm/kvm.ko] undefined!
> 
>    Signed-off-by: Jörg Sommer <joerg@alea.gnuu.de>
> 
> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index 4b0f01b..eddab24 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -677,10 +677,12 @@ program_interrupt:
> 			ulong cmd = kvmppc_get_gpr(vcpu, 3);
> 			int i;
> 
> +#ifdef CONFIG_KVM_BOOK3S_64_PR
> 			if (kvmppc_h_pr(vcpu, cmd) == EMULATE_DONE) {
> 				r = RESUME_GUEST;
> 				break;
> 			}
> +#endif
> 
> 			run->papr_hcall.nr = cmd;
> 			for (i = 0; i < 9; ++i) {


I was actually thinking of:

commit dfc209648daf8ba4197e71376b76c95fd26fd272
Author: Andreas Schwab <schwab@linux-m68k.org>
Date:   Tue Nov 8 07:17:39 2011 +0000

    KVM: PPC: protect use of kvmppc_h_pr
    
    kvmppc_h_pr is only available if CONFIG_KVM_BOOK3S_64_PR.
    
    Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
    Signed-off-by: Alexander Graf <agraf@suse.de>

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 72559b0..aaefe19 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -660,10 +660,12 @@ program_interrupt:
                        ulong cmd = kvmppc_get_gpr(vcpu, 3);
                        int i;
 
+#ifdef CONFIG_KVM_BOOK3S_64_PR
                        if (kvmppc_h_pr(vcpu, cmd) == EMULATE_DONE) {
                                r = RESUME_GUEST;
                                break;
                        }
+#endif
 
                        run->papr_hcall.nr = cmd;
                        for (i = 0; i < 9; ++i) {

But yes :). I guess we need to make sure this commit also lands in 3.2 :(.


Alex

