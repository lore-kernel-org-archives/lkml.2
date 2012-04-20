Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2DTKep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:34:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55158 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2DTKen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:34:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120420103110.GD3467@shadowen.org>
References: <1334852525-14950-1-git-send-email-apw@canonical.com>
	<CAPM=9tzC5M-K-irN=Dw3Ai+2ExUj_vSCVYUj-qpmccHLAeaifA@mail.gmail.com>
	<20120420103110.GD3467@shadowen.org>
Date: Fri, 20 Apr 2012 11:34:43 +0100
Message-ID: <CAPM=9txRi3=0=211S7RO=OqJwVPkFfQTtMC=DAhxZUUAW3voww@mail.gmail.com>
Subject: Re: [PATCH 0/1] [RFC] DRM locking issues during early open
From: Dave Airlie <airlied@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bryce Harrington <bryce@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I may be reading things wrong but the initialisation does indeed hold
> drm_global_mutex, but and back when this first occured we would have
> been using kernel_lock() which was at least partially reentrant right?

Yup if we slept with the BKL held we'd have allowed others to get past it,

but also I introduced the global mutex in pci a while back

commit b64c115eb22516ecd187c74ad6de3f1693f1dc7b
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 14 20:14:38 2010 +1000

    drm: fix race between driver loading and userspace open.

    Not 100% sure this is due to BKL removal, its most likely a combination
    of that + userspace timing changes in udev/plymouth. The drm adds the sysfs
    device before the driver has completed internal loading, this causes udev
    to make the node and plymouth to open it before we've completed loading.

    The proper solution is to delay the sysfs manipulation until later
in loading
    however this causes knock on issues with sysfs connector nodes, so
we can use
    the global mutex to serialise loading and userspace opens.

    Reported-by: Toni Spets (hifi on #radeon)
    Signed-off-by: Dave Airlie <airlied@redhat.com>

by a while I mean nearly 1.5 yrs ago, with the intent of fixing it this way.

Dave.
