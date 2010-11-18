Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab0KRDyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 22:54:35 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43128 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460Ab0KRDyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 22:54:35 -0500
X-Sasl-enc: hAuwJXSJ9V6xWuvsUclhx9Xh7DGiv4sAL3DDYvtxaqgz 1290052473
Subject: Re: autofs4 hang in 2.6.37-rc1
From: Ian Kent <raven@themaw.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Avi Kivity <avi@redhat.com>, autofs@linux.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <201011150954.34289.arnd@arndb.de>
References: <4CDFDC2B.6040205@redhat.com> <4CE00194.3070601@redhat.com>
	 <1289785533.3248.18.camel@localhost>  <201011150954.34289.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 11:54:27 +0800
Message-ID: <1290052468.2465.7.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 09:54 +0100, Arnd Bergmann wrote:
> On Monday 15 November 2010 02:45:33 Ian Kent wrote:
> 
> > You can't hold an exclusive mutex during an autofs expire because the
> > daemon will start by calling the ioctl to check for a dentry to expire
> > then call back to the daemon to perform the umount and wait for a status
> > return (also an ioctl).
> 
> Ok, I see. So it's my fault for not realizing that there are long blocking
> ioctls. I was under the assumption that all of these ioctl commands were
> simple non-blocking commands.
> 
> > >From memory the expire is the only ioctl that is sensitive to this
> > deadlock.
> > 
> > So, either the mutex must be released while waiting for the status
> > return or get rid of the autofs4_ioctl_mutex altogether.
> 
> Right. As I said with the original patch, I don't think the mutex
> is really needed, but using it seemed to be the safer alternative.
> It was in the sense that it guaranteed the breakage to be obvious
> rather than silent...
> 
> Ian, if you can prove that the lock is not needed, I think we shold
> just remove it.

I've looked through the old ioctl interface code and that looks fine.

But the important thing to notice is that the new ioctl interface (in
fs/autofs4/dev-ioctl.c) used the unlocked_ioctl method since it was
merged in 2.6.28 and that calls back into the core ioctl code for its
major functionality. So the core function of the ioctl interface has
been used without the BKL for quite a while now and has been heavily
exercised in subsequent testing since the new ioctl interface has been
in place.

I can't see any reason for keeping the autofs4_ioctl_mutex.

Ian


