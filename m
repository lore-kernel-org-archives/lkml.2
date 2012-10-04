Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946559Ab2JDV3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:29:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45241 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946507Ab2JDV3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:29:31 -0400
MIME-Version: 1.0
In-Reply-To: <20121004164630.GB2244@phenom.dumpdata.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
	<1348991844-12285-5-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
	<20121003165105.GA30214@jshin-Toonie>
	<CAE9FiQW7vcwSUen_TD8tZQd6aDU2-on5_T4Bjr6aqN1bxM_5Cg@mail.gmail.com>
	<20121004164630.GB2244@phenom.dumpdata.com>
Date: Thu, 4 Oct 2012 14:29:30 -0700
X-Google-Sender-Auth: gdeaGQUbAHhCBFNWU8I3L5XVwf4
Message-ID: <CAE9FiQUBohwjOzOm26yJME=JzZ7eH55hM+Q=Kc4Pz+ocaw90Jg@mail.gmail.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jacob Shin <jacob.shin@amd.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 9:46 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> then kdump may have problem get big range again.
>
> Is there a git commit that explains what the 'big range' problem is?

commit 7f8595bfacef279f06c82ec98d420ef54f2537e0
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Thu Dec 16 19:20:41 2010 -0800

    x86, kexec: Limit the crashkernel address appropriately

    Keep the crash kernel address below 512 MiB for 32 bits and 896 MiB
    for 64 bits.  For 32 bits, this retains compatibility with earlier
    kernel releases, and makes it work even if the vmalloc= setting is
    adjusted.

    For 64 bits, we should be able to increase this substantially once a
    hard-coded limit in kexec-tools is fixed.

    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Cc: Vivek Goyal <vgoyal@redhat.com>
    Cc: Stanislaw Gruszka <sgruszka@redhat.com>
    Cc: Yinghai Lu <yinghai@kernel.org>
    LKML-Reference: <20101217195035.GE14502@redhat.com>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 21c6746..c9089a1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -501,7 +501,18 @@ static inline unsigned long long get_total_mem(void)
        return total << PAGE_SHIFT;
 }

-#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
+/*
+ * Keep the crash kernel below this limit.  On 32 bits earlier kernels
+ * would limit the kernel to the low 512 MiB due to mapping restrictions.
+ * On 64 bits, kexec-tools currently limits us to 896 MiB; increase this
+ * limit once kexec-tools are fixed.
+ */
+#ifdef CONFIG_X86_32
+# define CRASH_KERNEL_ADDR_MAX (512 << 20)
+#else
+# define CRASH_KERNEL_ADDR_MAX (896 << 20)
+#endif
+
 static void __init reserve_crashkernel(void)
 {
        unsigned long long total_mem;
@@ -520,10 +531,10 @@ static void __init reserve_crashkernel(void)
                const unsigned long long alignment = 16<<20;    /* 16M */

                /*
-                *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
+                *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
                 */
                crash_base = memblock_find_in_range(alignment,
-                              DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
+                              CRASH_KERNEL_ADDR_MAX, crash_size, alignment);

                if (crash_base == MEMBLOCK_ERROR) {
                        pr_info("crashkernel reservation failed - No
suitable area found.\n");
