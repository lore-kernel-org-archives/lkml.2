Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0ITKsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 06:48:00 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:17873 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab0ITKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 06:47:44 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L91KHQ-01-DFF-02
X-M-MSG: 
Date: Mon, 20 Sep 2010 12:44:15 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        "tdm.rhbz@gmail.com" <tdm.rhbz@gmail.com>
Subject: Re: [PATCH] oprofile, x86: allow backtrace for 32bit apps under
 64bit kernel
Message-ID: <20100920104415.GO13563@erda.amd.com>
References: <1284380117-6857-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1284380117-6857-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.09.10 08:15:17, Jiri Olsa wrote:
> hi,
> 
> adding support for backtrace of ia32 applications under 64bit kernels.
> 
> wbr,
> jirka
> 
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Tom Marshall <tdm.rhbz@gmail.com>
> ---
>  arch/x86/oprofile/backtrace.c |   42 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 42 insertions(+), 0 deletions(-)

Jirka,

see my comments below.

Please, provide a more meaningful commit message.

> 
> diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
> index 3855096..3e443ad 100644
> --- a/arch/x86/oprofile/backtrace.c
> +++ b/arch/x86/oprofile/backtrace.c
> @@ -73,6 +73,38 @@ static struct frame_head *dump_user_backtrace(struct frame_head *head)
>  	return bufhead[0].bp;
>  }
>  
> +#ifdef CONFIG_X86_64
> +struct frame_head_32 {
> +	__u32 ebp;
> +	__u32 ret;
> +} __attribute__((packed));

There exists already struct stack_frame_ia32.

Please, also change the code to reuse struct stack_frame for 64 bit
processes.

> +
> +static struct frame_head *
> +dump_user_backtrace_32(struct frame_head *head)
> +{
> +	struct frame_head_32 bufhead_32[2];
> +	unsigned long bp, ret;
> +
> +	/* Also check accessibility of one struct frame_head beyond */
> +	if (!access_ok(VERIFY_READ, head, sizeof(bufhead_32)))
> +		return NULL;
> +	if (__copy_from_user_inatomic(bufhead_32, head, sizeof(bufhead_32)))
> +		return NULL;
> +
> +	bp  = bufhead_32[0].ebp;
> +	ret = bufhead_32[0].ret;
> +
> +	oprofile_add_trace(ret);
> +
> +	/* frame pointers should strictly progress back up the stack
> +	* (towards higher addresses) */
> +	if (head >= (struct frame_head *) bp)

You are mixing up struct frame_head and struct frame_head_32 here.

> +		return NULL;
> +
> +	return (struct frame_head *) bp;
> +}
> +#endif
> +
>  void
>  x86_backtrace(struct pt_regs * const regs, unsigned int depth)
>  {
> @@ -86,6 +118,16 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
>  		return;
>  	}
>  
> +#ifdef CONFIG_X86_64

Rather use CONFIG_COMPAT here.

> +	if (current && test_thread_flag(TIF_IA32)) {
> +		/* User process is 32-bit */
> +		head = (struct frame_head *)(regs->bp & 0xffffffff);

Same is provided with compat_ptr().

> +		while (depth-- && head)
> +			head = dump_user_backtrace_32(head);
> +		return;
> +	}
> +#endif

Please avoid inline macros and make this an inline function (maybe
x86_backtrace_32) with a function stub for the !CONFIG_COMPAT case.

If possible, try to avoid duplicate code for 32 and 64 bit backtraces.

Thanks,

-Robert

> +
>  	while (depth-- && head)
>  		head = dump_user_backtrace(head);
>  }
> -- 
> 1.7.1
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

