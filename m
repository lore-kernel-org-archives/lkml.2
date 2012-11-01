Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab2KAJjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:39:55 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:35515 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933039Ab2KAJjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:39:51 -0400
X-Greylist: delayed 1259 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2012 05:39:51 EDT
Date: Thu, 1 Nov 2012 10:18:42 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Shan Wei <shanwei88@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] net: xfrm: use this_cpu_ptr per-cpu helper
Message-ID: <20121101091842.GA2719@secunet.com>
References: <509109F9.3030904@gmail.com>
 <0000013ab7e4a640-60bd5b38-a1fc-4730-b918-4109211ffea0-000000@email.amazonses.com>
 <50923956.5090206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50923956.5090206@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 01 Nov 2012 09:18:42.0604 (UTC) FILETIME=[E300AEC0:01CDB811]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 04:56:54PM +0800, Shan Wei wrote:
> Christoph Lameter said, at 2012/11/1 1:35:
> > It would be better to use
> > 
> > 	this_cpu_read(tfms)
> > 
> > since that would also make it atomic vs interrupts. The above code (both
> > original and modified) could determine a pointer to a per cpu structure
> > and then take an interrupt which would move the task. On return we would
> > be accessing the per cpu variable of another processor.
> 
> this_cpu_read
> |-----_this_cpu_generic_read
> 
> #define _this_cpu_generic_read(pcp)                                     \
> ({      typeof(pcp) ret__;                                              \
>         preempt_disable();                                              \
>         ret__ = *this_cpu_ptr(&(pcp));                                  \
>         preempt_enable();                                               \
>         ret__;                                                          \
> })
> 
> 
> this_cpu_read operations locate per-cpu variable with preemption safe， not
> disable interrupts. why is it atomic vs interrupts?
> 
> I have no idea whether we need to disable preemption for this code?
> At least, xfrm code run well with per_cpu_ptr which don't disable preemption.

We compare the name of the newly allocated crypto transform against the
existing ones. The name is the same on every percpu transform and it
does not change after the transform is allocated. So we don't care
if we get migrated or not, we can just take the transform from an
arbitrary cpu to read the name from it.
