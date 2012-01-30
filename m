Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2A3SNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:13:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54216 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2A3SNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:13:18 -0500
Date: Mon, 30 Jan 2012 10:13:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
Message-ID: <20120130181313.GI3355@google.com>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org>
 <20120130171558.GB3355@google.com>
 <alpine.DEB.2.00.1201301121330.28693@router.home>
 <20120130174256.GF3355@google.com>
 <alpine.DEB.2.00.1201301145570.28693@router.home>
 <20120130175434.GG3355@google.com>
 <alpine.DEB.2.00.1201301156530.28693@router.home>
 <20120130180224.GH3355@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130180224.GH3355@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 10:02:24AM -0800, Tejun Heo wrote:
> I thought it didn't.  I rememer thinking about this and determining
> that NULL can't be allocated for dynamic addresses.  Maybe I'm
> imagining things.  Anyways, if it can return NULL for valid
> allocation, it is a bug and should be fixed.

So, the default translation is

#define __addr_to_pcpu_ptr(addr)					\
	(void __percpu *)((unsigned long)(addr) -			\
	(unsigned long)pcpu_base_addr +					\
	(unsigned long)__per_cpu_start)

It basically offsets the virtual address of the first unit against the
start of static percpu section, so if the linked percpu data address
is higher than the base address of the initial chunk, I *think*
overwrap is possible.  I don't think this can happen on x86 regardless
of first chunk allocation mode tho but there may be configurations
where __per_cpu_start is higher than pcpu_base_addr (IIRC some archs
locate vmalloc area lower than kernel image, dunno whether the used
address range actually is enough for causing overflow tho).

Anyways, yeah, it seems we should improve this part too.

Thanks.

-- 
tejun
