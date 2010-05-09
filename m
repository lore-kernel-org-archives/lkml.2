Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0EIDVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 23:21:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48340 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0EIDVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 23:21:14 -0400
Subject: Re: Fix [e]glibc build process
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrey Volkov <avolkov@varma-el.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>, David Gibson <dwg@au1.ibm.com>,
       linuxppc-dev list <Linuxppc-dev@ozlabs.org>
In-Reply-To: <4BE5C203.6060509@varma-el.com>
References: <4BE5C203.6060509@varma-el.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sat, 08 May 2010 22:21:09 -0500
Message-Id: <1273375269.5312.4.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 23:56 +0400, Andrey Volkov wrote:
> This patch fix [e]glibc build process destruction (more precisely _assembler_
> is die when try to compile getcontext.S since stdint.h coldn't be assembled)
> intruduced by patch:
> 
> commit: 162d92dfb79a0b5fc03380b8819fa5f870ebf1e
> Date: Mon, 8 Feb 2010 11:51:05 +0000 (11:51 +0000)
> from: Dave Kleikamp
> 
> Signed-off-by: Andrey Volkov <avolkov@varma-el.com>
> 
> ---
> 
>  arch/powerpc/include/asm/ptrace.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
> index 9e2d84c..025912b 100644
> --- a/arch/powerpc/include/asm/ptrace.h
> +++ b/arch/powerpc/include/asm/ptrace.h
> @@ -27,8 +27,10 @@
>  #ifdef __KERNEL__
>  #include <linux/types.h>
>  #else
> +#ifndef __ASSEMBLY__
>  #include <stdint.h>
>  #endif
> +#endif
> 
>  #ifndef __ASSEMBLY__

Assembly code won't need to pull in linux/types.h either, so this would
be simpler:

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
index 9e2d84c..0ed710e 100644
--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -24,14 +24,14 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#ifndef __ASSEMBLY__
+
 #ifdef __KERNEL__
 #include <linux/types.h>
 #else
 #include <stdint.h>
 #endif
 
-#ifndef __ASSEMBLY__
-
 struct pt_regs {
 	unsigned long gpr[32];
 	unsigned long nip;

-- 
Dave Kleikamp
IBM Linux Technology Center

