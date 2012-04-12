Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859Ab2DLVdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:33:24 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13966 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab2DLVdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:33:22 -0400
Date: Thu, 12 Apr 2012 23:33:20 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Gerd Hoffmann <kraxel@suse.de>, Alan Cox <alan@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: tty, hvc, xen: leak? dead code? everything is fine?
Message-ID: <alpine.LNX.2.00.1204122318480.7553@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Ok, so I'm staring at drivers/tty/hvc/hvc_xen.c::xen_hvm_console_init() - 
to be specific, this code (and yes, it's late and I'm tired, so I may be 
completely off, I admit that up front):

...
	info = vtermno_to_xencons(HVC_COOKIE);
	if (!info) {
		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | 
__GFP_ZERO);
		if (!info)
			return -ENOMEM;
	}

	/* already configured */
	if (info->intfw != NULL)
		return 0;
...

and either I'm completely overlooking something obvious or just being 
stupid (which is certainly possible) or there is a problem here;

If 'info->intfw' is something else than NULL here, then it seems like 
we'll leak the memory we allocated for 'info' when we return (in case 
info started out as NULL and we just allocated it with kzalloc()).

So it seems like we should 'kfree(info)' before the 'return 0' statement, 
but then again, we may not have entered the true branch of 'if (!info)' 
and just allocated 'info' - would it still be right to free it in that 
case?

Or *if* there's actually no way 'info->intfw' can actually be anything but 
NULL in this case, then this would just be dead code (but that doesn't 
seem to be the case).

At the very least, this looks fishy to me... Any feedback is welcome...


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

