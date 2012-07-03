Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2GCKSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:18:54 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:42309 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2GCKSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:18:53 -0400
Message-ID: <4FF2C705.9090005@mev.co.uk>
Date: Tue, 3 Jul 2012 11:18:45 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>, Devendra Naga <devendra.aaru@gmail.com>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] staging/comedi/drivers: release allocated I/O region
 if alloc_private fails
References: <1341149798-12695-1-git-send-email-devendra.aaru@gmail.com> <4FF15E92.3040503@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698F2EECE@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698F2EECE@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-02 16:57, H Hartley Sweeten wrote:
> On Monday, July 02, 2012 1:41 AM, Ian Abbott wrote:
>> No.  The I/O region will be deallocated in fl512_detach() because
>> dev->iobase has been set non-zero.  fl512_detach() will be called by the
>> comedi core if fl512_attach() returns an error.  This is an unusual
>> aspect of the comedi drivers.
>
> I have been wondering if that aspect should be "fixed".
>
> It's more typical for kernel drivers to clean up after themselves if
> the probe/attach/init/etc. fails. And the release/detach/exit/etc.
> is only called if the driver has successfully loaded.
>
> With the comedi drivers, the "detach" is always called if the "attach"
> failed. And, of course the "detach" is called when the device is removed.
>
> Because of this the "detach" routines need to do all the checks to
> see what needs to be cleaned up. Not a big deal but it does create
> some confusion as this patch shows.

At the very least, this behaviour should be documented with a comment at 
the appropriate place in comedidev.h.

I think Comedi's current clean-up model is based on the open/close model 
of TTY driver operations, where the 'close' tty_operation is called when 
the 'open' tty_operation fails (although typically these operations 
don't do much allocation or deallocation).

> Ian, what's your opinion on this? Do you think we should refactor all
> the driver "attach" routines so they clean up on failure and fix the
> core so the "detach" is only called after a successful "attach"?

It would be nicer, although the existing mechanism does have the slight 
advantage of using less code.

If this mechanism is adopted, drivers using the new mechanism should 
also be responsible for freeing their subdevices (which will need a new 
function comedi_free_subdevices()) and their comedi_device private data. 
  (They're already responsible for freeing comedi_subdevice private data 
in their 'detach' routines.)

> This would be a pretty big patch since it affects every driver as well
> as the core.
>
> We could break it up by introducing a temporary flag in the comedi_driver
> struct that indicates if the driver has been "fixed". The core could then
> work as-is for non-updated drivers. Once all the drivers have been updated
> we then fix the core and remove the flag from all the drivers.

That sounds like a reasonable plan.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
