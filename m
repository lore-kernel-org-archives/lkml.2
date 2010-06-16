Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab0FPUdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:33:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab0FPUdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:33:31 -0400
Date: Wed, 16 Jun 2010 13:32:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Wilck <martin.wilck@ts.fujitsu.com>,
       Thomas Jarosch <thomas.jarosch@intra2net.com>, stable@kernel.org
Subject: Re: [PATCH] IPMI: Set schedule_timeout_wait value back to one
Message-Id: <20100616133220.65b200a0.akpm@linux-foundation.org>
In-Reply-To: <20100616135144.GA7548@minyard.local>
References: <20100616135144.GA7548@minyard.local>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 08:51:44 -0500
Corey Minyard <minyard@acm.org> wrote:

> From: Martin Wilck <martin.wilck@ts.fujitsu.com>
> 
> Some systems were seeing CPU usage go up dramatically with the recent
> changes to try to reduce timer usage in the IPMI driver.  This was
> traced down to schedule_timeout_interruptible(1) being changed to
> schedule_timeout_interruptbile(0).  Revert that change.
> 
> Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
> 
> Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
> +++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
> @@ -1018,7 +1018,7 @@ static int ipmi_thread(void *data)
>  		else if (smi_result == SI_SM_IDLE)
>  			schedule_timeout_interruptible(100);
>  		else
> -			schedule_timeout_interruptible(0);
> +			schedule_timeout_interruptible(1);
>  	}
>  	return 0;
>  }

This fixes a regression introduced by ae74e823cb7d ("ipmi: add
parameter to limit CPU usage in kipmid"), yes?  I noted that in the
changelog.

I also noted that it addresses
https://bugzilla.kernel.org/show_bug.cgi?id=16147 and I added the
vital(!) cc:stable@kernel.org, as we busted 2.6.34.

This is a pretty important -stable fix I think - several people have
hit it and the effects are ugly.


