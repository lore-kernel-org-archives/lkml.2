Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab2KPEIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 23:08:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58241 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2KPEIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 23:08:49 -0500
Date: Fri, 16 Nov 2012 04:08:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, arnd@arndb.de
Subject: Re: [RFC PATCH v1 30/31] ARC: switch to generic kernel_execve() and
 sys_execve()
Message-ID: <20121116040847.GA22671@ZenIV.linux.org.uk>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
 <1352281674-2186-31-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352281674-2186-31-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 10:47:53AM +0100, Vineet Gupta wrote:
> +; When we land here, pt_regs have already been updated in-place correctly
> +; A pointer to them is also passed by kernel_execve, we just need to make sure
> +; that SP is set to point to them.
> +ARC_ENTRY ret_from_kernel_execve
> +	; Force SP to "normal" pt_regs just populated.
> +	b.d   ret_from_system_call
> +	mov   sp, r0

won't that splatter crap into regs->r0?  IOW, why not branch to
ret_from_exception here?

> +ARC_EXIT ret_from_kernel_execve

Another thing: why not fold that branch to ret_from_exception into the end of
ret_from_kernel_thread() (instead of calling sys_exit()), select
GENERIC_KERNEL_EXECVE and lose __ARCH_WANT_KERNEL_EXECVE.

Actually, now that I look at your ret_from_kernel_thread...  How the hell
will it cope with kernel_thread() payload trying to return?  AFAICS, this
j.d [r1] will lose the return address, won't it?  And while we are at it,
I would suggest passing callback and its argument via callee-saved registers -
makes for simpler life in ret_from_kernel_thread(), since switch_to() itself
will take care of loading those...
