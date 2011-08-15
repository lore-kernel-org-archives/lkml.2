Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab1HOKoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:44:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50166 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1HOKox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:44:53 -0400
Date: Mon, 15 Aug 2011 06:47:34 -0400
From: Jeff Layton <jlayton@samba.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS
Message-ID: <20110815064734.403b630f@corrin.poochiereds.net>
In-Reply-To: <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 11:18:38 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:

> 
> Adding some more CIFS people to Cc.
> 
> 
> On Mon, 15 Aug 2011, Justin Piszcz wrote:
> 
> > Hi,
> > 
> > Is this normal/is there a limitation on CIFS mounts? I do not have the full
> > crash output, I would need to take a picture of the screen, but its completely
> > reproducible, crashes every time..  thoughts?
> > 
> > Aug 14 05:16:41 box kernel: [518217.158195] df              D 0000000000000000
> > 0  5465  11246 0x00000004
> > Aug 14 05:16:41 box kernel: [518217.158200]  ffff88061f19c090 0000000000000082
> > 0000000000000002 ffff880600000000
> > Aug 14 05:16:41 box kernel: [518217.158206]  ffff8806275accf0 0000000000004000
> > ffff88058513ffd8 ffff88058513ffd8
> > Aug 14 05:16:41 box kernel: [518217.158211]  ffff88058513fdf8 ffff880627076240
> > 000000000000002f 0000000000000000
> > Aug 14 05:16:41 box kernel: [518217.158217] Call Trace:
> > Aug 14 05:16:41 box kernel: [518217.158226]  [<ffffffff810ca086>] ?
> > do_lookup+0x46/0x310
> > Aug 14 05:16:41 box kernel: [518217.158231]  [<ffffffff810c7e9d>] ?
> > acl_permission_check+0x4d/0xb0
> > Aug 14 05:16:41 box kernel: [518217.158239]  [<ffffffff815b2448>] ?
> > __mutex_lock_slowpath+0xc8/0x140
> > Aug 14 05:16:41 box kernel: [518217.158243]  [<ffffffff815b1fea>] ?
> > mutex_lock+0x1a/0x40
> > Aug 14 05:16:41 box kernel: [518217.158250]  [<ffffffff811ec969>] ?
> > cifs_reconnect_tcon+0x1a9/0x320
> > Aug 14 05:16:41 box kernel: [518217.158254]  [<ffffffff811ecba3>] ?
> > smb_init+0x33/0x90
> > Aug 14 05:16:41 box kernel: [518217.158258]  [<ffffffff811f30e0>] ?
> > CIFSSMBQFSInfo+0x60/0x210
> > Aug 14 05:16:41 box kernel: [518217.158262]  [<ffffffff811eb86e>] ?
> > cifs_statfs+0xce/0x170
> > Aug 14 05:16:41 box kernel: [518217.158268]  [<ffffffff810e5797>] ?
> > statfs_by_dentry+0x67/0x100
> > Aug 14 05:16:41 box kernel: [518217.158272]  [<ffffffff810e5845>] ?
> > vfs_statfs+0x15/0x90
> > Aug 14 05:16:41 box kernel: [518217.158275]  [<ffffffff810e58f0>] ?
> > user_statfs+0x30/0x50
> > Aug 14 05:16:41 box kernel: [518217.158279]  [<ffffffff810e5972>] ?
> > sys_statfs+0x12/0x30
> > Aug 14 05:16:41 box kernel: [518217.158284]  [<ffffffff815b3b7b>] ?
> > system_call_fastpath+0x16/0x1b
> > 
> > Then it hangs up, on my machine it actually panics and in both cases all I/O
> > stops and the machine is unusable.  This is from simply mounting a CIFS share.
> > The share sizes are 18T and 28T, is there a limitation on the size that would
> > cause the kernel to crash like that?
> > 
> > mount.cifs //l1/drve /mnt_pnt -o user=myusername,pass=mypassword, then
> > df -h or ls /mnt_pnt instant kernel panic. :(
> > 
> > Remote host is Windows 7 64-bit.
> > 

There was at least one known oops at mount time with 3.0:

    https://bugzilla.redhat.com/show_bug.cgi?id=727927

...but I can't tell whether you hit that w/o seeing the oops messasge.

It should be fixed in mainline and the patches for that and another
mount time problem will be in the next set of stable kernels. You may
want to pull these two commits into your kernel and try again:

80975d21aae2136ccae1ce914a1602dc1d8b0795
f9e8c45002cacad536b338dfa9e910e341a49c31

Cheers,
-- 
Jeff Layton <jlayton@samba.org>
