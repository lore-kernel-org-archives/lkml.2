Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab2CLQR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:17:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab2CLQR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:17:56 -0400
Date: Mon, 12 Mar 2012 12:17:43 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 5/7] x86/jump labels: Use etiher 5 byte or 2 byte jumps
Message-ID: <20120312161743.GB2607@redhat.com>
References: <20120308221730.807074710@goodmis.org>
 <20120308222202.525768259@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308222202.525768259@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 05:17:35PM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Have the jump labels add a "jmp" in the assembly instead
> of a default nop. This will cause the assembler to put in
> either a 2 byte or 5 byte jmp depending on where the target
> lable is.
> 
> Then at compile time, the update_jump_label code will replace
> the jmps with either 2 or 5 byte nops.
> 
> On boot up, the code can be examined to see if the jump label
> uses either a 2 or 5 byte nop and replace it.
> 
> By allowing the jump labels to be 2 bytes, it speeds up the
> nops, not only 2 byte nops are faster than 5 byte nops, but also
> because it saves on cache foot print.
> 
>    text    data     bss     dec     hex filename
> 13403667 3666856 2998272 20068795 13239bb ../nobackup/mxtest/vmlinux-old
> 13398536 3666856 2998272 20063664 13225b0 ../nobackup/mxtest/vmlinux-new
> 
> Converting the current v3.2 trace points saved 5,131 bytes.
> As more places use jump labels, this will have a bigger savings.
> 

Hi Steven,

Strange. I'm not seeing the text size savings with this patch, relative
to the 'old' jump label compiled code. Is your comparison against jump
labels disabled?

Here's the size without your patch 'CONFIG_JUMP_LABEL' set:

   text    data     bss     dec     hex filename
10809465        1023976 1159168 12992609         c64061 vmlinux

And with your patches and 'CONFIG_JUMP_LABEL' set:

   text    data     bss     dec     hex filename
10812613        1023976 1163264 12999853         c65cad vmlinux

So an increase in text of 3148. Which is not completely explained by the
increase in arch/x86/kernel/jump_label.o:

without your patch 'CONFIG_JUMP_LABEL' set:

   text    data     bss     dec     hex filename
    229       0       0     229      e5 arch/x86/kernel/jump_label.o


with your patch 'CONFIG_JUMP_LABEL' set:

   text    data     bss     dec     hex filename
    943       0       8     951     3b7 arch/x86/kernel/jump_label.o

So jump_label.o is 714 bytes larger, which is not enough to explain the
3148 byte increase.

I'm using gcc (GCC) 4.6.2 20111027 (Red Hat 4.6.2-1).

Can you please double check the savings.

Thanks,

-Jason
