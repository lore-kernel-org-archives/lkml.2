Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0DVSMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 14:12:53 -0400
Received: from relay.ihostexchange.net ([66.46.182.52]:45610 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0DVSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 14:12:52 -0400
Message-ID: <4BD09175.9030703@VirtualLogix.com>
Date: Thu, 22 Apr 2010 20:12:05 +0200
From: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "usbip-devel@lists.sourceforge.net" 
	<usbip-devel@lists.sourceforge.net>
Subject: Re: [PATCH]: Fix deadlock in USBIP driver (staging), linux-2.6.34-rc5
References: <4BD07F2A.8080808@VirtualLogix.com> <20100422170207.GA18830@suse.de>
In-Reply-To: <20100422170207.GA18830@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
[...]
> Ok, but does the lock_kernel() call you just made actually prevent this
> from happening?  Isn't there some other lock you can use instead?
> 

Right. lock_kernel() is not needed (was copy/paste).
The deadlock is avoided by not calling wait_for_completion()
when the code is executed by the "eh" thread itself.

> Also, to have patches that we can apply, we need a "Signed-off-by:"
> line.  See the file, Documentation/SubmittingPatches for what this
> means.

Understood.

> Your email client wrapped the patch and made it unappliable :(
> 
> thanks,
> 
> greg k-h

Sorry about that. Please find below an hopefully better one.
Thanks,
	Eric.


Signed-off-by: Eric Lescouet <eric@lescouet.org>
-------------

diff -Nur linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c                   
--- linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c        2010-04-20 01:29:56.000000000 +0200                                       
+++ linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c    2010-04-22 19:19:52.997889126 +0200                                       
@@ -117,6 +117,9 @@
 {                                                                                                                                        
        struct usbip_task *eh = &ud->eh;                                                                                                  
                                                                                                                                          
+       if (eh->thread == current)                                                                                                        
+               return; /* do not wait for myself */                                                                                      
+                                                                                                                                         
        wait_for_completion(&eh->thread_done);                                                                                            
        usbip_dbg_eh("usbip_eh has finished\n");                                                                                          
 }                                                                                                                                        

