Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1IUNMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:12:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61775 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab1IUNMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:12:32 -0400
Date: Wed, 21 Sep 2011 09:15:58 -0400
From: Jeff Layton <jlayton@samba.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Suresh Jayaraman <sjayaraman@suse.com>, linux-kernel@vger.kernel.org,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: 3.1-rc4: CIFS VFS: Received no data, expecting 4
Message-ID: <20110921091558.75a24d7d@corrin.poochiereds.net>
In-Reply-To: <alpine.DEB.2.02.1109210756390.31360@p34.internal.lan>
References: <alpine.DEB.2.02.1109181258480.8689@p34.internal.lan>
	<4E79C958.7080702@suse.com>
	<20110921075730.74c3b512@corrin.poochiereds.net>
	<alpine.DEB.2.02.1109210756390.31360@p34.internal.lan>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011 07:56:57 -0400 (EDT)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> 
> 
> On Wed, 21 Sep 2011, Jeff Layton wrote:
> 
> > On Wed, 21 Sep 2011 16:54:08 +0530
> > Suresh Jayaraman <sjayaraman@suse.com> wrote:
> >
> >> Adding linux-cifs@vger.kernel.org to Cc.
> >>
> >> On 09/18/2011 10:29 PM, Justin Piszcz wrote:
> >>> Hello,
> >>>
> >>> What does this mean and why does it occur?
> >>
> >> This error seems to occur when we try to read from a socket and actually
> >> read no data. Not sure when this would occur.
> >>
> >
> > It would be nice to know what was returned by kernel_recvmsg here. Was
> > it "0" or an error code of some kind?
> 
> Hi,
> 
> It seemed to start like that:
> 
> Sep 18 12:02:52 p34 kernel: [   71.039405] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> Sep 18 12:02:52 p34 kernel: [   71.039970] NFSD: starting 90-second grace period
> Sep 18 12:17:06 p34 kernel: [  923.377483] CIFS VFS: Received no data, expecting 4
> Sep 18 12:17:23 p34 kernel: [  940.991731] [drm] nouveau 0000:04:00.0: Setting dpms mode 3 on tmds encoder (output 1)
> Sep 18 12:18:23 p34 kernel: [ 1000.699094] CIFS VFS: Received no data, expecting 4
> Sep 18 12:18:53 p34 kernel: [ 1030.668222] CIFS VFS: Received no data, expecting 4
> Sep 18 12:19:23 p34 kernel: [ 1060.637386] CIFS VFS: Received no data, expecting 4
> Sep 18 12:19:53 p34 kernel: [ 1090.606501] CIFS VFS: Received no data, expecting 4
> Sep 18 12:20:23 p34 kernel: [ 1120.575675] CIFS VFS: Received no data, expecting 4
> Sep 18 12:20:53 p34 kernel: [ 1150.544783] CIFS VFS: Received no data, expecting 4
> Sep 18 12:21:23 p34 kernel: [ 1180.513925] CIFS VFS: Received no data, expecting 4
> Sep 18 12:21:53 p34 kernel: [ 1210.483044] CIFS VFS: Received no data, expecting 4
> Sep 18 12:22:23 p34 kernel: [ 1240.452187] CIFS VFS: Received no data, expecting 4
> Sep 18 12:22:53 p34 kernel: [ 1270.421345] CIFS VFS: Received no data, expecting 4
> Sep 18 12:23:23 p34 kernel: [ 1300.390432] CIFS VFS: Received no data, expecting 4
> Sep 18 12:23:53 p34 kernel: [ 1330.359595] CIFS VFS: Received no data, expecting 4
> Sep 18 12:24:23 p34 kernel: [ 1360.328755] CIFS VFS: Received no data, expecting 4
> Sep 18 12:24:53 p34 kernel: [ 1390.283901] CIFS VFS: Received no data, expecting 4
> Sep 18 12:25:23 p34 kernel: [ 1420.249492] CIFS VFS: Received no data, expecting 4
> Sep 18 12:25:53 p34 kernel: [ 1450.218690] CIFS VFS: Received no data, expecting 4
> Sep 18 12:26:23 p34 kernel: [ 1480.187842] CIFS VFS: Received no data, expecting 4
> Sep 18 12:26:53 p34 kernel: [ 1510.156925] CIFS VFS: Received no data, expecting 4
> Sep 18 12:27:23 p34 kernel: [ 1540.126080] CIFS VFS: Received no data, expecting 4
> Sep 18 12:27:54 p34 kernel: [ 1570.095264] CIFS VFS: Received no data, expecting 4
> 

Given that this is happening every 30s, I'd suspect that the server is
disconnecting an idle socket and the client is continually reconnecting
it. That's probably causing it to return an error on the kernel_recvmsg
call.

I have a patch series queued for 3.2 that makes readpages asynchronous
and breaks the 16k barrier for reads. As part of that, it also turns
this into a debug message and tells you what the call returned.

http://git.samba.org/?p=jlayton/linux.git;a=shortlog;h=refs/heads/cifs-3.2

You may want to play with that...
-- 
Jeff Layton <jlayton@samba.org>
