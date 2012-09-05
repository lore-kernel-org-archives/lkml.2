Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2IECya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 22:54:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:53228 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2IECy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 22:54:29 -0400
Message-ID: <1346813643.2257.24.camel@pasglop>
Subject: Re: [PATCH v2] powerpc: fix personality handling in
 ppc64_personality()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Sep 2012 12:54:03 +1000
In-Reply-To: <alpine.LNX.2.00.1208020907490.14910@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012201520.14910@pobox.suse.cz>
	 <m27gtitfv4.fsf@igel.home>
	 <alpine.LNX.2.00.1208020907490.14910@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 09:10 +0200, Jiri Kosina wrote:
> Directly comparing current->personality against PER_LINUX32 doesn't work
> in cases when any of the personality flags stored in the top three bytes
> are used.
> 
> Directly forcefully setting personality to PER_LINUX32 or PER_LINUX
> discards any flags stored in the top three bytes
> 
> Use personality() macro to compare only PER_MASK bytes and make sure that
> we are setting only the bits that should be set, instead of
> overwriting the whole value.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
> 
> changed since v1: fix the bit ops to reflect the fact that PER_LINUX is 
> actually 0

Had already merged v1 (oops.. didn't spot the issue with PER_LINUX being
0). Can you send an incremental fixup ?

Cheers,
Ben.

>  arch/powerpc/kernel/syscalls.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
> index f2496f2..dc1558e 100644
> --- a/arch/powerpc/kernel/syscalls.c
> +++ b/arch/powerpc/kernel/syscalls.c
> @@ -107,11 +107,11 @@ long ppc64_personality(unsigned long personality)
>  	long ret;
>  
>  	if (personality(current->personality) == PER_LINUX32
> -	    && personality == PER_LINUX)
> -		personality = PER_LINUX32;
> +	    && personality(personality) == PER_LINUX)
> +		personality |= PER_LINUX32;
>  	ret = sys_personality(personality);
> -	if (ret == PER_LINUX32)
> -		ret = PER_LINUX;
> +	if (personality(ret) == PER_LINUX32)
> +		ret &= ~PER_LINUX32;
>  	return ret;
>  }
>  #endif
> -- 
> 1.7.3.1
> 


