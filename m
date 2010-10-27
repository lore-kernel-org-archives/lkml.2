Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab0J0VU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:20:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab0J0VUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:20:23 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=RC9uCRVjizEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=J1Y8HTJGAAAA:8 a=6LAenWPno1zOga4kw7EA:9 a=nmY5evJXL7rUakLWt0QA:7 a=sezUQDJ7mAAhkQoapop6-pzVTUsA:4 a=PUjeQqilurYA:10 a=4N9Db7Z2_RYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] jump_label: Fix unaligned traps on sparc.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
In-Reply-To: <20101023.110624.226758370.davem@davemloft.net>
References: <20101023.110624.226758370.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Oct 2010 17:20:20 -0400
Message-ID: <1288214420.18238.130.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-23 at 11:06 -0700, David Miller wrote:
> The vmlinux.lds.h knobs to emit the __jump_table section in the main
> kernel image takes care to align the section, but this doesn't help
> for the __jump_table section that gets emitted into modules.
> 
> Fix the resulting lack of section alignment by explicitly specifying
> it in the assembler.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks! I'll pull this in tonight with the other jump label patches.

Unfortunately, it turns out that gcc has a bug that can cause crashes
when jump label is used. We need to set it to broken until gcc has a fix
and we can detect if the compiler has the bug or not.

-- Steve


> 
> diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
> index 62e66d7..d95cf44 100644
> --- a/arch/sparc/include/asm/jump_label.h
> +++ b/arch/sparc/include/asm/jump_label.h
> @@ -14,6 +14,7 @@
>  			 "nop\n\t"				\
>  			 "nop\n\t"				\
>  			 ".pushsection __jump_table,  \"a\"\n\t"\
> +			 ".align 4\n\t"				\
>  			 ".word 1b, %l[" #label "], %c0\n\t"	\
>  			 ".popsection \n\t"			\
>  			 : :  "i" (key) :  : label);\


