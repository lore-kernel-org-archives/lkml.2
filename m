Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1HCUil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 16:38:41 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:42943 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1HCUih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 16:38:37 -0400
X-IronPort-AV: E=Sophos;i="4.67,312,1309752000"; 
   d="scan'208";a="157677268"
Subject: Re: [Xen-devel] [PATCH 0/3] xen-blkback: refactor vbd
 remove/disconnect.
From: Daniel Stodden <daniel.stodden@citrix.com>
To: Jan Beulich <jbeulich@novell.com>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "annie.li@oracle.com" <annie.li@oracle.com>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "KURT.HACKEL@oracle.com" <KURT.HACKEL@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4E396F090200007800073F59@nat28.tlf.novell.com>
References: <4E396F090200007800073F59@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 3 Aug 2011 13:38:32 -0700
Message-ID: <1312403912.2513.374.camel@agari.van.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 10:53 -0400, Jan Beulich wrote:
> >>> Joe Jin 08/03/11 4:10 AM >>> 
> >1. start guest with the latest kernel. 
> >2. attach new block device by xm block-attach in Dom0 
> >3. mount new disk in guest 
> >4. execute xm block-detach to detach the block device in dom0 until timeout 

Doesn't this fail immediately in userland right now? The disconnect
attempt (blkback switching to Closing) will be acknowledged with an
error, so you'd watch backend and frontend state simultaneously.

>From there on, there might be options. Could switch back to Connected
and call it a day, but that's currently nowhere exercised, so not sure
if it's fully stable.

But the behavior established in XCP is to bail out, but leave the
backend at Closing. That means from the backend perspective, the VBD
will unplug and get cleaned up at an unspecific later point in time. But
stay operational.

Note that the latter takes udev work, to finally clean up attached disk
images after completion.

> >5. try to unmount the disk in guest, umount hung. at here, any IOs to the 
> >device will hang. 

Yeah, not so good. That's what --force would imply.

> A bogus sequence of operations - an operator in Dom0 shouldn't remove
> a device that is still in use in a guest, except as an exceptionasl measure
> (and then other bad behavior is to be expected). What's the use case?

The administrative perspective is right, but it's a valid one. And even
if you're coordinating dom0 unplug with guest umount -- there needs a
way to handly buggy coordination.

We don't have guest usage indication in the frontend record, so backends
resort to try/error instead.

I think try/error is the way to deal with it. Transaction stuff
necessary to synch a front/back-coordinated disconnect seems over the
top, and we'd probably want compat behavior anyway.

Not sure what xm/xl can or wants to do about delayed detaches. If it
sounds undesirable, we probably want to consider patch to blkback to
abort shutdown-request and flip back to Connected. 

So a controller would try in sync, fail in sync, and rolls back. So it
won't have to deal with backend detach later. Sounds simpler. I don't
think there's really a particular reason XCP chose to behave the way it
does, except low hanging fruit.

Not convinced it doesn't need transactions either, because you could see
the tool/blkback interaction race blkback/blkfront driven by guest
umount. But it may yield a simpler UI.

Please correct me where my lack of OSS toolstack understanding
struck. :)

Daniel


