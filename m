Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab0EUWHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:07:24 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:34404 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703Ab0EUWHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:07:20 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization
Thread-Topic: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization
Thread-Index: Acr5H/mIA2ovCiH5RJSF72cnsl7mOgAPKJIAAAs5tDA=
Date: Fri, 21 May 2010 22:07:17 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B8B5F2@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7266B8AE7C@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100521201228.GA6712@suse.de>
In-Reply-To: <20100521201228.GA6712@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@suse.de]
> > +/* Counter of IC channels initialized */
> > +atomic_t hv_utils_initcnt = ATOMIC_INIT(0);
> 
> This doesn't need to be an atomic variable, does it really?
> 
> Why not have a simple bool variable "vmbus_initialized" or something.
> It starts out as false, and then turns true when you are up and ready.
> Then provide a function that tests it:
> 	bool hv_vmbus_ready(void)
> 	{
> 		return vmbus_initialized
> 	}
> 	EXPORT_SYMBOL_GPL(hv_vmbus_ready);
> 
> 
> this turns into a simple function call, again, never needing to know
> about message types or any other mess.

This looks good. I will add the hv_vmbus_ready() function. It doesn't even 
have to be exported symbol, because it's only used in vmbus module to ensure 
all channels are ready before vmbus_init() returns. Other modules won't get a 
chance to see uninitialized channels after hv_vmbus is loaded.

Also, I'll cleanup the printk in hv_utils load/unload.

Regarding the atomic variable -- the channel offer processing function is 
triggered by interrupts from host -- should we be concerned about "counter++" 
racing with each other in two interrupts happening around the same time?

Thanks,

- Haiyang

