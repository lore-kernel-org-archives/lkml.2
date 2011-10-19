Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab1JSPVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:21:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44146 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782Ab1JSPVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:21:40 -0400
Date: Wed, 19 Oct 2011 16:21:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arvid Brodin <arvid.brodin@enea.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Memory leak in isp1760-hcd.c
Message-ID: <20111019152132.GH29653@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arvid,

I get the following kmemleak report coming from the ISP1760 driver:

unreferenced object 0xef42d000 (size 28):                                       
  comm "khubd", pid 189, jiffies 4294937550 (age 1421.040s)                     
  hex dump (first 28 bytes):                                                    
    00 01 10 00 00 02 20 00 08 d0 42 ef 08 d0 42 ef  ...... ...B...B.           
    00 00 00 00 00 00 00 00 ff ff ff ff              ............               
  backtrace:                                                                    
    [<c0080fe1>] create_object+0xa1/0x1ac                                       
    [<c007eac5>] kmem_cache_alloc+0x8d/0xdc                                     
    [<c01a9617>] isp1760_urb_enqueue+0x2ab/0x2f8                                
    [<c019bbbd>] usb_hcd_submit_urb+0x75/0x574                                  
    [<c019d8f1>] usb_start_wait_urb+0x29/0x80                                   
    [<c019daad>] usb_control_msg+0x89/0xac                                      
    [<c0197f43>] hub_port_init+0x4fb/0x9c8                                      
    [<c0199c75>] hub_thread+0x5a1/0xd74                                         
    [<c0035acd>] kthread+0x69/0x6c                                              
    [<c000dc6d>] kernel_thread_exit+0x1/0x8                                     

After some investigation, it looks like schedule_ptds() is called from
isp1760_irq() and removes the qh from the controlqhs queue but
ep->hcpriv still points to the qh and therefore it is not freed.

Shortly after this, the isp1760_endpoint_disable() function sets
ep->hcpriv to NULL and calls schedule_ptds() but since the corresponding
qh is no longer in the queue, it is simply forgotten and reported by
kmemleak.

Is there a race condition between isp1760_endpoint_disable and
isp1760_irq?

Thanks.

-- 
Catalin
