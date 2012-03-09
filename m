Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2CIOYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:24:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab2CIOYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:24:30 -0500
Date: Fri, 9 Mar 2012 09:24:22 -0500
From: Don Zickus <dzickus@redhat.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86,nmi: Fix page faults by nmiaction if kmemcheck is
 enabled
Message-ID: <20120309142422.GD24378@redhat.com>
References: <1331240549-13120-1-git-send-email-dzickus@redhat.com>
 <1331287938.13274.38.camel@ThinkPad-T420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331287938.13274.38.camel@ThinkPad-T420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 05:12:18AM -0500, Li Zhong wrote:
> On Thu, 2012-03-08 at 16:02 -0500, Don Zickus wrote:
> 
> Thank you, Don. 
> 
> As flags is moved into the macro, it may cause following compile error, 
> drivers/watchdog/hpwdt.c: In function 'hpwdt_init_nmi_decoding':
> drivers/watchdog/hpwdt.c:737: error: initializer element is not constant
> drivers/watchdog/hpwdt.c:737: error: (near initialization for
> 'hpwdt_pretimeout_na.flags')

Crap, I thought I had them all compiled.  Thanks for the heads up.
Actually I think this could is just misusing the flag to begin with.  Let
me figure out what is going on.

Thanks,
Don

> 
> So following fix might be needed: 
> 
> diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
> index 3c166d3..e1161ea 100644
> --- a/drivers/watchdog/hpwdt.c
> +++ b/drivers/watchdog/hpwdt.c
> @@ -734,9 +734,12 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
>  	 * die notify list to handle a critical NMI. The default is to
>  	 * be last so other users of the NMI signal can function.
>  	 */
> -	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
> -					(priority) ? NMI_FLAG_FIRST : 0,
> -					"hpwdt");
> +	if (priority)
> +		retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
> +					NMI_FLAG_FIRST, "hpwdt");
> +	else
> +		retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
> +					0, "hpwdt");
>  	if (retval != 0) {
>  		dev_warn(&dev->dev,
>  			"Unable to register a die notifier (err=%d).\n",
> 
> 
