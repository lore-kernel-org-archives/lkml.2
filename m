Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1HRFve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 01:51:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56288 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1HRFvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 01:51:32 -0400
Subject: RE: [PATCH 2/8] Staging: hv: vmbus: Invoke vmbus_on_msg_dpc()
 directly
From: Sasha Levin <levinsasha928@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
In-Reply-To: <6E21E5352C11B742B20C142EB499E04808194C66@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1313446210-10611-1-git-send-email-kys@microsoft.com>
	 <1313446327-10650-1-git-send-email-kys@microsoft.com>
	 <1313446327-10650-2-git-send-email-kys@microsoft.com>
	 <1313585267.15004.3.camel@lappy>
	 <6E21E5352C11B742B20C142EB499E04808194C66@TK5EX14MBXC126.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 18 Aug 2011 08:50:20 +0300
Message-ID: <1313646620.22532.16.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 18:43 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Sasha Levin [mailto:levinsasha928@gmail.com]
> > Sent: Wednesday, August 17, 2011 8:48 AM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > Subject: Re: [PATCH 2/8] Staging: hv: vmbus: Invoke vmbus_on_msg_dpc()
> > directly
> > 
> > On Mon, 2011-08-15 at 15:12 -0700, K. Y. Srinivasan wrote:
> > > The message processing function needs to execute on the same CPU where
> > > the interrupt was taken. tasklets cannot gurantee this; so, invoke the
> > > function directly.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > 
> > tasklets are guaranteed to run on the same CPU as the function that
> > scheduled them.
> > 
> > Unless I'm missing something?
> 
> I too was under this impression until I stumbled upon this comment in
> include/Linux/interrupt.h where I see that there is no guarantee that
> tasklet would run on the same CPU that it was scheduled on
> (look at the first listed property):
> 
> /* Tasklets --- multithreaded analogue of BHs.
> 
>    Main feature differing them of generic softirqs: tasklet
>    is running only on one CPU simultaneously.
> 
>    Main feature differing them of BHs: different tasklets
>    may be run simultaneously on different CPUs.
> 
>    Properties:
>    * If tasklet_schedule() is called, then tasklet is guaranteed
>      to be executed on some cpu at least once after this.
> .
> .
> */
> 
> Given this comment here, I felt that safest thing to do would be to just
> not use the tasklet in this scenario.

Hm..

Looking at __tasklet_schedule() it should be guaranteed to run on the
same CPU, but as you said - the comment above is actually saying the
opposite.

The relevant documentation in the 'Linux Device Drivers' book also
states that it is guaranteed, so maybe we can get a confirmation from
Greg that this is still true and update the comment instead?

Not using bottom halves and just calling the dpc handler would mean that
you block interrupts for much longer than you need to.

-- 

Sasha.

