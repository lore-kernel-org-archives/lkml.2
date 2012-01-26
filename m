Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2AZOoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:44:55 -0500
Received: from shutemov.name ([176.9.204.213]:40896 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab2AZOoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:44:54 -0500
Date: Thu, 26 Jan 2012 16:45:33 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Renninger <trenn@suse.de>,
        Bruno Friedmann <bruno@ioda-net.ch>, Len Brown <len.brown@intel.com>
Subject: Re: [67/90] intel idle: Make idle driver more robust
Message-ID: <20120126144533.GA1731@shutemov.name>
References: <20120123234211.GA19504@kroah.com>
 <20120123234028.628058547@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20120123234028.628058547@clark.kroah.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 03:39:53PM -0800, Greg KH wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Thomas Renninger <trenn@suse.de>
> 
> commit 5c2a9f06a9cd7194f884cdc88144866235dec07d upstream.
> 
> kvm -cpu host passes the original cpuid info to the guest.
> 
> Latest kvm version seem to return true for mwait_leaf cpuid
> function on recent Intel CPUs. But it does not return mwait
> C-states (mwait_substates), instead zero is returned.
> 
> While real CPUs seem to always return non-zero values, the intel
> idle driver should not get active in kvm (mwait_substates == 0)
> case and bail out.
> Otherwise a Null pointer exception will happen later when the
> cpuidle subsystem tries to get active:
> [0.984807] BUG: unable to handle kernel NULL pointer dereference at (null)
> [0.984807] IP: [<(null)>] (null)
> ...
> [0.984807][<ffffffff8143cf34>] ? cpuidle_idle_call+0xb4/0x340
> [0.984807][<ffffffff8159e7bc>] ? __atomic_notifier_call_chain+0x4c/0x70
> [0.984807][<ffffffff81001198>] ? cpu_idle+0x78/0xd0
> 
> Reference:
> https://bugzilla.novell.com/show_bug.cgi?id=726296
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: Bruno Friedmann <bruno@ioda-net.ch>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/idle/intel_idle.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -321,7 +321,8 @@ static int intel_idle_probe(void)
>  	cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, &mwait_substates);
>  
>  	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
> -		!(ecx & CPUID5_ECX_INTERRUPT_BREAK))
> +	    !(ecx & CPUID5_ECX_INTERRUPT_BREAK) ||
> +	    !mwait_substates)
>  			return -ENODEV;

It breaks build for me.

>From 4b26a35ab3bf4094efb31911587b676158f675b5 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Thu, 26 Jan 2012 16:24:50 +0200
Subject: [PATCH] intel_idle: fix build issue
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

  CC      drivers/idle/intel_idle.o
/home/space/kas/git/public/linux-3.0-mid/drivers/idle/intel_idle.c: In function ‘intel_idle_probe’:
/home/space/kas/git/public/linux-3.0-mid/drivers/idle/intel_idle.c:508:7: error: ‘mwait_substates’ undeclared (first use in this function)
/home/space/kas/git/public/linux-3.0-mid/drivers/idle/intel_idle.c:508:7: note: each undeclared identifier is reported only once for each function it appears in
make[3]: *** [drivers/idle/intel_idle.o] Error 1

Variable 'substates' hasn't renamed to 'mwait_substates' in 3.0.
See c423628 intel_idle: delete substates DEBUG modparam

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/idle/intel_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 15d72ca..a1aecc3 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -505,7 +505,7 @@ static int intel_idle_probe(void)
 
 	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
 	    !(ecx & CPUID5_ECX_INTERRUPT_BREAK) ||
-	    !mwait_substates)
+	    !substates)
 			return -ENODEV;
 
 	if (substates == 0)	/* can over-ride via modparam */
-- 
 Kirill A. Shutemov
