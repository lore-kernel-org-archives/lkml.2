Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab2AJLAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 06:00:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34760 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab2AJLAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 06:00:09 -0500
Date: Tue, 10 Jan 2012 10:59:55 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "tiejun.chen" <tiejun.chen@windriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kmemleak/module: only scan the existed data section
Message-ID: <20120110105955.GK29581@arm.com>
References: <1325059891-20540-1-git-send-email-tiejun.chen@windriver.com>
 <CAHkRjk5fuubEQaq2CD1cGE=W+Lf6svE6fN8KyDrY6=i3-=b_RA@mail.gmail.com>
 <4F0BA99E.1090006@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0BA99E.1090006@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 02:59:42AM +0000, tiejun.chen wrote:
> Catalin Marinas wrote:
> > I would rather move this check to kmemleak.c. But why would it be
> > needed? Performance? A zero-size area shouldn't be scanned anyway.
> 
> When we call layout_sections() to calculate sh_entsize, often a zero-sized
> .data/.bss section would be ordered as a middle of all valid sections. For example,
> ------
> Symbol			Addr		size
> 
> .init.			0xf96d3000
> ......
> .data(or .bss) 		0xf96d3180	0
> ......			0xf96d4000		
> 
> If so kmemleak_scan_area(0xf96d3180,0,GFP_KERNEL) is fine as we expect since
> 0xf96d3180 is always within a valid address scopes summarized all section,
> 0xf96d3000 ~  0xf96d4000. But sometimes if that is arranged as a last section:
> -----
> Symbol			Addr		size
> 
> .init.			0xf96d3000
> ......
> .data(or .bss) 		0xf96d3180	0
> 
> 
> An then the following call trace is triggered
> ......
> kmemleak: Adding scan area to unknown object at 0xf96d3180
> Call Trace:
> [e9095de0] [c0008588] show_stack+0x68/0x1d8 (unreliable)
> [e9095e30] [c0690094] dump_stack+0x2c/0x44
> [e9095e40] [c015a190] kmemleak_scan_area+0x128/0x184
> [e9095e70] [c00a145c] load_module+0xa98/0x1c04
> [e9095f10] [c00a2650] sys_init_module+0x88/0x24c
> [e9095f40] [c0012f7c] ret_from_syscall+0x0/0x4
> --- Exception: c01 at 0xff63564
>     LR = 0x10003414

Ah, good find. As I said, I would check the size in the
kmemleak_scan_area() function and ignore if 0 (same as the ptr check).

Thanks.

-- 
Catalin
