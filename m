Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0LQDb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:31:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44422 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab0LQDb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:31:27 -0500
Message-ID: <4D0AD976.3020504@zytor.com>
Date: Thu, 16 Dec 2010 19:31:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Vivek Goyal <vgoyal@redhat.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@redhat.com>,
        Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101207105053.GA2803@redhat.com> <4CFE89FE.1090901@kernel.org> <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org>
In-Reply-To: <4D09958D.2040907@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------030401060105050003030900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030401060105050003030900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/15/2010 08:29 PM, Yinghai Lu wrote:
> please check
> 
> [PATCH] x86, crashkernel, 32bit: only try to get range under 512M
> 
> Steanishlaw report kdump is 32bit is broken.
> 
> in misc.c for decompresser, it will do sanity checking to make sure heap
> heap under 512M.
> 
> So limit it in first kernel under 512M for 32bit system.
> 
> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/setup.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 

I'd like to apply a modified version of this patch (attached.)

Ack/nak, people?

	-hpa

--------------030401060105050003030900
Content-Type: text/x-patch;
 name="0001-x86-kexec-Limit-the-crashkernel-address-to-512-MiB.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-kexec-Limit-the-crashkernel-address-to-512-MiB.patc";
 filename*1="h"

>From 3f060a5da7498cd725ef41cb67f8ced362a81729 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@linux.intel.com>
Date: Thu, 16 Dec 2010 19:20:41 -0800
Subject: [PATCH] x86, kexec: Limit the crashkernel address to 512 MiB

We used to only map a maximum of 512 MiB of low memory for the kernel
initialization; this was enforced by the bzImage decompressor.  To
make sure we do not run afoul of this limitation, keep the crash
kernel below the 512 MiB mark.

This also adds a comfortable margin in case the user is running with a
nonstandard vmalloc= setting.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D09958D.2040907@kernel.org>
---
 arch/x86/kernel/setup.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 21c6746..7fb9abb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -501,7 +501,12 @@ static inline unsigned long long get_total_mem(void)
 	return total << PAGE_SHIFT;
 }
 
-#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
+/*
+ * Keep the crash kernel below this limit.  Not all bzImage kernels
+ * can be loaded above this address.
+ */
+#define CRASH_KERNEL_ADDR_MAX	(512 << 20)
+
 static void __init reserve_crashkernel(void)
 {
 	unsigned long long total_mem;
@@ -520,10 +525,10 @@ static void __init reserve_crashkernel(void)
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
 		/*
-		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
+		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
 		 */
 		crash_base = memblock_find_in_range(alignment,
-			       DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
+			       CRASH_KERNEL_ADDR_MAX, crash_size, alignment);
 
 		if (crash_base == MEMBLOCK_ERROR) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
-- 
1.7.2.3


--------------030401060105050003030900--
