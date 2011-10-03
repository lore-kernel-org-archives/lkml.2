Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab1JCT0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:26:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35671 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1JCT0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:26:22 -0400
Date: Mon, 3 Oct 2011 15:24:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        David Daney <david.daney@cavium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Xen-devel] [PATCH RFC V2 2/5] stop_machine: make stop_machine
 safe and efficient to call early
Message-ID: <20111003192424.GB30091@phenom.oracle.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
 <58bc7c7142fe54cd6c17f2f18f4b11fd2f597d5a.1317506051.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58bc7c7142fe54cd6c17f2f18f4b11fd2f597d5a.1317506051.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4E8A0C04.00DB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 02:55:34PM -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Make stop_machine() safe to call early in boot, before SMP has been
> set up, by simply calling the callback function directly if there's
> only one CPU online.
> 
> [ Fixes from AKPM:
>    - add comment
>    - local_irq_flags, not save_flags
>    - also call hard_irq_disable() for systems which need it
> 
>   Tejun suggested using an explicit flag rather than just looking at
>   the online cpu count. ]
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/stop_machine.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index ba5070c..9c59d9e 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -41,6 +41,7 @@ struct cpu_stopper {
>  };
>  
>  static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
> +static bool stop_machine_initialized = false;

__read_mostly?

Thought it probably does not really matter that much in what section it
is put in.
