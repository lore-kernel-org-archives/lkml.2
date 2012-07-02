Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2GBP5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:57:37 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:32675 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab2GBP5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:57:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1341244651!7540256!7
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>, Devendra Naga <devendra.aaru@gmail.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 2 Jul 2012 10:57:22 -0500
Subject: RE: [PATCH 1/2] staging/comedi/drivers: release allocated I/O
 region if alloc_private fails
Thread-Topic: [PATCH 1/2] staging/comedi/drivers: release allocated I/O
 region if alloc_private fails
Thread-Index: Ac1YLmYHAd7ecvEDQiCozJiqi2/bUQAO18pA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698F2EECE@AUSP01VMBX24.collaborationhost.net>
References: <1341149798-12695-1-git-send-email-devendra.aaru@gmail.com>
 <4FF15E92.3040503@mev.co.uk>
In-Reply-To: <4FF15E92.3040503@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 02, 2012 1:41 AM, Ian Abbott wrote:
> No.  The I/O region will be deallocated in fl512_detach() because 
> dev->iobase has been set non-zero.  fl512_detach() will be called by the 
> comedi core if fl512_attach() returns an error.  This is an unusual 
> aspect of the comedi drivers.

I have been wondering if that aspect should be "fixed".

It's more typical for kernel drivers to clean up after themselves if
the probe/attach/init/etc. fails. And the release/detach/exit/etc.
is only called if the driver has successfully loaded.

With the comedi drivers, the "detach" is always called if the "attach"
failed. And, of course the "detach" is called when the device is removed.

Because of this the "detach" routines need to do all the checks to
see what needs to be cleaned up. Not a big deal but it does create
some confusion as this patch shows.

Ian, what's your opinion on this? Do you think we should refactor all
the driver "attach" routines so they clean up on failure and fix the
core so the "detach" is only called after a successful "attach"?

This would be a pretty big patch since it affects every driver as well
as the core. 

We could break it up by introducing a temporary flag in the comedi_driver
struct that indicates if the driver has been "fixed". The core could then
work as-is for non-updated drivers. Once all the drivers have been updated
we then fix the core and remove the flag from all the drivers.

Regards,
Hartley
