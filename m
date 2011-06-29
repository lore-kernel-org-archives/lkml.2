Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1F2Lip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:38:45 -0400
Received: from bar.sig21.net ([80.81.252.164]:36327 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1F2Lin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:38:43 -0400
Date: Wed, 29 Jun 2011 13:38:34 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: missing compat-ioctl for CDROM_DRIVE_STATUS + FDGETPRM
Message-ID: <20110629113834.GA4227@sig21.net>
References: <20110617090424.GA19345@sig21.net>
 <201106171502.39445.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106171502.39445.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.648,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 03:02:39PM +0200, Arnd Bergmann wrote:
> On Friday 17 June 2011 11:04:24 Johannes Stezenbach wrote:
> > running even a simple "qemu-img create -f qcow2 some.img 1G" causes
> > the following in dmesg on a Linux host with linux-2.6.39.1 x86_64 kernel
> > and 32bit userspace:
> > 
> > ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(00005326){t:'S';sz:0} arg(7fffffff) on some.img
> > ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(801c0204){t:02;sz:28} arg(fff77350) on some.img
> > 
> > (The same happens when starting a qemu or kvm vm.)
> > 
> > ioctl 00005326 seems to be CDROM_DRIVE_STATUS,
> > ioctl 801c0204 is FDGETPRM.  Both are used in
> > qemu/block/raw-posix.c in cdrom_probe_device()
> > and floppy_probe_device() respectively.
> > 
> > FWIW, I'm using qemu/kvm from Debian unstable
> > (qemu-0.14.0+dfsg-5.1, qemu-kvm-0.14.1+dfsg-1)
> 
> Both are handled by the kernel for block devices, but not for regular
> files. The messages may be annoying but they are harmless. We could
> silence them either by checking if the file is actually a block device in
> qemu-img, or by adding a nop handler to the kernel for regular files.

Sorry for very slow reply.  I think qemu's use of these ioctls
to probe if the device is a cdrom or floppy is valid, so instead
of adding a stat() call to check for block device in qemu, I think
it is better to silence the warning in the kernel.

Do I get it right that just adding two IGNORE_IOCTL() to
the ioctl_pointer array in linux/fs/compat_ioctl.c is sufficient,
like in commit 3f001711?
I.e. these ioctls are handled for block devices earlier
in compat_sys_ioctl()?


Thanks,
Johannes
