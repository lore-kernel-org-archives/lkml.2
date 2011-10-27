Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1J0V71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 17:59:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44808 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1J0V70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 17:59:26 -0400
MIME-Version: 1.0
Date: Fri, 28 Oct 2011 00:59:25 +0300
Message-ID: <CAEbykaU_v6yYOVO3obyQDzacKrF5baOV6yXGZC010S1D=YKsbw@mail.gmail.com>
Subject: PROBLEM: lvm gets stuck during booting due to recent uevent change
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Milan Broz <mbroz@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit ebf4127cd677 "kobj_uevent: Ignore if some listeners
cannot handle message" in the current development tree lvm gets stuck
during booting and never recovers.

The machine has Ubuntu 11.10. Here is what happens:

An init script (/scripts/init-bottom/udev in initrd) issues command
"udevadm control --timeout=61 --exit".

At the same time udevd is executing "/sbin/lvm vgchange -a y" (from
/lib/udev/rules.d/85-lvm2.rules) that calls ioctl to resume a logical
volume. After that lvm gets stuck forever. Booting continues after the
61 second timeout.

Here is part of lvm backtrace from gdb (ioctl is called just before
dm_udev_wait from another function):

#0  0x00007f56d6d37797 in semop () from /lib/x86_64-linux-gnu/libc.so.6
#1  0x00007f56d720a75c in dm_udev_wait (cookie=223208589) at libdm-common.c:1279
#2  0x0000000000476d5f in _tree_action (dm=0xaa0680,
lv=0xffffffffffffff69, action=ACTIVATE) at activate/dev_manager.c:1479
#3  0x0000000000477a4e in dev_manager_activate (dm=0xaa0680,
lv=0xa9caf0) at activate/dev_manager.c:1505
#4  0x000000000042ebcc in _lv_activate_lv (lv=0xa9caf0) at
activate/activate.c:570
...
