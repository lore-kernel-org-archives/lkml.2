Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab0ELFLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 01:11:08 -0400
Received: from mga12.intel.com ([143.182.124.36]:59260 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750729Ab0ELFLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 01:11:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,212,1272870000"; 
   d="scan'208";a="276089707"
Date: Tue, 11 May 2010 22:10:58 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Clemens Ladisch <clemens@ladisch.de>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Joe Perches <joe@perches.com>
Cc: linux-usb@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Use of start_frame in usbusx2yaudio.c
Message-ID: <20100512051058.GA32459@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are there any drivers in the kernel that set urb->start_frame on every
URB?

Could those drivers handle it if only the first URB they submitted to
the host controller was scheduled for that frame ID, and all the rest of
the URBs were scheduled ASAP?

I see there are three drivers that set start_frame (while not setting
URB_ISO_ASAP):
 - drivers/isdn/hisax/st5481_d.c
 - drivers/usb/core/devio.c
 - sound/usb/usx2y/usbusx2yaudio.c

I'm not really sure what usbusx2yaudio.c is doing.  I think when one URB
completes, it sets the next URB's start_frame to the previous URB's
start_frame plus the number of URBs (2 by default) times the number of
packets (4 by default).  Isn't this basically like setting URB_ISO_ASAP?
I really can't tell what fall back method is if this submission fails.

What is usbusx2yaudio.c attempting to do?  I've tried to get an overall
picture of what it expects the isochronous scheduling to look like, but
I'm finding the driver a bit hard to read.

I'm not too worried about the other two drivers.  The code in st5481_d.c
seems to fall back fine to URB_ISO_ASAP if the submission with the
start_frame set failed.  devio.c is usbfs, and I can't tell what
userspace drivers do. (It could be argued that if they needed such tight
control over isoc, they should have written a kernel driver.)

Sarah Sharp
