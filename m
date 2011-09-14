Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1INM45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 08:56:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab1INM44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 08:56:56 -0400
Date: Wed, 14 Sep 2011 08:56:40 -0400
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org
Subject: Re: [V4][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110914125640.GT5795@redhat.com>
References: <1315947509-6429-1-git-send-email-dzickus@redhat.com>
 <1315947509-6429-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315947509-6429-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 04:58:27PM -0400, Don Zickus wrote:
> 
> V3:
>   - redesigned the algorithm to utilize Avi's idea of detecting a back-to-back
>     NMI with %rip.

Hi Robert,

I realized I added an optimization for executing the nmi handlers to help
minimize the impact on the virt folks and realize it might break your IBS
stuff.

> -static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
> +static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
>  {
>  	struct nmi_desc *desc = nmi_to_desc(type);
>  	struct nmiaction *next_a, *a, **ap = &desc->head;
> @@ -87,6 +87,16 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
>  
>  		handled += a->handler(type, regs);
>  
> +		/*
> + 		 * Optimization: only loop once if this is not a 
> + 		 * back-to-back NMI.  The idea is nothing is dropped
> + 		 * on the first NMI, only on the second of a back-to-back
> + 		 * NMI.  No need to waste cycles going through all the
> + 		 * handlers.
> + 		 */
> +		if (!b2b && handled)
> +			break;
> +
>  		a = next_a;
>  	}
>  	rcu_read_unlock();

The optimization is to run through the handlers until one of them claims
the NMI but only for the first NMI.  Whereas on the second half of a
back-to-back NMI, run through all the handlers regardless of how many
claim they handled it.

Does your IBS stuff need to always run through two handlers?

Cheers,
Don
