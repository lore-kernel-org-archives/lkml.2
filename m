Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1AEXDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:03:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342Ab1AEXDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:03:02 -0500
Date: Wed, 5 Jan 2011 15:02:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mahatma@eu.by
Cc: Dzianis Kahanovich <mahatma@bspu.unibel.by>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix miscompiling with GCC 4.5 -finline-functions
Message-Id: <20110105150226.f4e2f31e.akpm@linux-foundation.org>
In-Reply-To: <4D2339F7.3090502@bspu.unibel.by>
References: <4D2339F7.3090502@bspu.unibel.by>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Jan 2011 17:17:11 +0200
Dzianis Kahanovich <mahatma@bspu.unibel.by> wrote:

> Fixing broken automatic inlining for GCC 4.5+  (breaks build with
> -finline-functions or -O3 on x86_*).
> 

Please always quote the compiler output when addressing build errors
and warnings.

> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -569,7 +569,7 @@ static inline void ept_sync_individual_a
>  	}
>  }
> 
> -static unsigned long vmcs_readl(unsigned long field)
> +static noinline unsigned long vmcs_readl(unsigned long field)
>  {
>  	unsigned long value = 0;
> 
> --- a/drivers/media/radio/radio-aimslab.c
> +++ b/drivers/media/radio/radio-aimslab.c
> @@ -71,7 +71,7 @@ static struct rtrack rtrack_card;
> 
>  /* local things */
> 
> -static void sleep_delay(long n)
> +static noinline void sleep_delay(long n)
>  {
>  	/* Sleep nicely for 'n' uS */
>  	int d = n / msecs_to_jiffies(1000);

A golden rule is that when a programmer reads some code, he should be
able to understand why it's there.  There is no way on this little
earth that a programmer will be able to look at this code and say
"ah-hah, that must be a workaround for gcc-4.5 -finline-functions!".

We fix that problem this way:

--- a/arch/x86/kvm/vmx.c~fix-miscompiling-with-gcc-45-finline-functions-fix
+++ a/arch/x86/kvm/vmx.c
@@ -569,6 +569,7 @@ static inline void ept_sync_individual_a
 	}
 }
 
+/* noinline works around gcc-4.5+ build error with -finline-functions */
 static noinline unsigned long vmcs_readl(unsigned long field)
 {
 	unsigned long value = 0;
--- a/drivers/media/radio/radio-aimslab.c~fix-miscompiling-with-gcc-45-finline-functions-fix
+++ a/drivers/media/radio/radio-aimslab.c
@@ -71,6 +71,7 @@ static struct rtrack rtrack_card;
 
 /* local things */
 
+/* noinline works around gcc-4.5+ build error with -finline-functions */
 static noinline void sleep_delay(long n)
 {
 	/* Sleep nicely for 'n' uS */
_

