Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491Ab2FGJaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:30:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33096 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab2FGJaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:30:03 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206061022020.1788-100000@iolanthe.rowland.org>
References: <CACVXFVPjQmvmXnYNm4sSjJXq83qe-Xg8=YjRppSNMpUQYLokjQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1206061022020.1788-100000@iolanthe.rowland.org>
Date: Thu, 7 Jun 2012 17:30:00 +0800
Message-ID: <CACVXFVOU4VyGicyn01w6ScMPenZip2kPco7dpzT+Qf5Xmgc8FQ@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 10:44 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

>> > On the whole, it might be easier just to hold the device lock during
>> > the shutdown call.
>>
>> Yes, it is easier, but it is not efficient because there are very less
>> drivers which implemented .shutdown callback. Suppose there are some
>> drivers which have no .shutdown but are holding device lock,  extra
>> time will be consumed in the lock acquiring, which may slow down 'power
>> down'.
>
> The main reasons for holding the device lock are probe and remove
> callbacks.  In your patch, synchronize_srcu has to wait for those too.
> So there won't be much extra time.

There are differences between holding dev->lock(parent->lock) and
using synchronize_srcu:

	- synchronize_srcu just wait for the ongoing probe/release
	to complete

	- holding dev->lock and parent->lock before shutdown means
	every dev->lock and parent->lock is to be acquired, so any
	drivers holding dev lock during device_shutdown will slow down
	'power down' or 'reset'.

	- if the device has not .shutdown implemented, it is not
	necessary to acquire the lock and parent->lock, either of
	which may has been held in other places already.

But after thinking about the problem further, the patch isn't good enough:

	- even probe/remove is disallowed during shutdown, device_add/
	device_del can be completed and only probe and release things
	are bypassed, so .shutdown may see a deleted device from view of
	driver model. For example, pci_device_shutdown need to access
	its devres which may have been deleted by device_del already.

	- violate driver model's implicit rule: once device_release_driver
	(in device_del path) is completed, other callbacks for the device(driver)
	won't be seen or called by others

So take the simply approach of holding lock to fix the races.


Thanks,
--
Ming Lei
