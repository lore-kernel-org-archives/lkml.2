Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab2JXWNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:13:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50348 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819Ab2JXWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:13:31 -0400
Date: Wed, 24 Oct 2012 15:13:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: zhanglong <longzhax@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yanmin_zhang@linux.intel.com, Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH v2] drivers-core: move the calling to device_pm_remove
 behind the calling to bus_remove_device
Message-ID: <20121024221327.GA23353@kroah.com>
References: <507D7D08.7010903@intel.com>
 <1871387.QctMb7gSFB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1871387.QctMb7gSFB@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 09:46:19PM +0200, Rafael J. Wysocki wrote:
> On Tuesday 16 of October 2012 23:28:08 zhanglong wrote:
> > We hit an hang issue when removing a mmc device on Medfield Android phone by sysfs interface.
> > 
> > device_pm_remove will call pm_runtime_remove which would disable
> > runtime PM of the device. After that pm_runtime_get* or
> > pm_runtime_put* will be ignored. So if we disable the runtime PM
> > before device really be removed, drivers' _remove callback may
> > access HW even pm_runtime_get* fails. That is bad.
> > 
> > Consider below call sequence when removing a device:
> > device_del => device_pm_remove
> >              => class_intf->remove_dev(dev, class_intf)  => pm_runtime_get_sync/put_sync
> >              => bus_remove_device => device_release_driver => pm_runtime_get_sync/put_sync
> > 
> > remove_dev might call pm_runtime_get_sync/put_sync.
> > Then, generic device_release_driver also calls pm_runtime_get_sync/put_sync.
> > Since device_del => device_pm_remove firstly, later _get_sync wouldn't really wake up the device. 
> > 
> > I git log -p to find the patch which moves the calling to device_pm_remove ahead.
> > It's below patch:
> > 
> > commit  775b64d2b6ca37697de925f70799c710aab5849a
> > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > Date:   Sat Jan 12 20:40:46 2008 +0100
> > 
> >      PM: Acquire device locks on suspend
> > 
> >      This patch reorganizes the way suspend and resume notifications are
> >      sent to drivers.  The major changes are that now the PM core acquires
> >      every device semaphore before calling the methods, and calls to
> >      device_add() during suspends will fail, while calls to device_del()
> >      during suspends will block.
> > 
> >      It also provides a way to safely remove a suspended device with the
> >      help of the PM core, by using the device_pm_schedule_removal() callback
> >      introduced specifically for this purpose, and updates two drivers (msr
> >      and cpuid) that need to use it. 
> > 
> > 
> > As device_pm_schedule_removal is deleted by another patch, we need also revert other parts of the patch,
> > i.e. move the calling of device_pm_remove after the calling to bus_remove_device.
> > 
> > Signed-off-by: LongX Zhang <longx.zhang@intel.com>
> 
> Greg, do you see any potential problems with this patch?

No, no objection from me:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
