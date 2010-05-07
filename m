Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0EGVSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:18:16 -0400
Received: from legolas.restena.lu ([158.64.1.34]:54614 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0EGVSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:18:15 -0400
Date: Fri, 7 May 2010 23:18:01 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: s2ram slow resume - radeon versus no_console_suspend?
Message-ID: <20100507231801.1794daa8@neptune.home>
In-Reply-To: <20100502155653.68fc3643@neptune.home>
References: <20100502155653.68fc3643@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 May 2010 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> On a IEI Kino 690S1 I'm having a hard time to get s2ram running.
> 
> When the system is able to suspend it takes an eternity (more than 3
> minutes to wake-up, the radeon apparently being responsible for quite
> a big share of that slowness.
> 
> 
> During resume early it looks like every PCI access needs about a second,
> and there are a few cases where during lots of seconds nothing seems to
> happen and the first event following is related to radeon.

This slowness only happens when I run the kernel with no_console_suspend
parameter (e.g. to debug some suspend/resume issue).
This probably means that in this case radeon's PCI config recorded during
suspend and restored during early resume is all but appropriate...

Currently drm/radeon does not suspend when no_console_suspend is provided,
even so when the kernel logging does not happen on tty0 & co.

e.g. I would expect that a kernel run with
  no_console_suspend console=ttyS0
would just skip suspending serial port ttyS0 and not also skip suspending
KMS framebuffer as it currently does.


In most framebuffer devices I see usage of acquire_console_sem() and
release_console_sem() but except for kernel/printk.c and drivers/serial/
code nothing is considering console_suspend_enabled.

Currently I'm not sure what code path prevents suspend of KMS (at least
for radeon) when no_console_suspend has been passed, this code path should
probably have a conditional just as serial to take no_console_suspend only
if it's running kernel's console itself.

Thanks,
Bruno
