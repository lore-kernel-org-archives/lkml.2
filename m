Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1KISNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:13:06 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60216 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1KISNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:13:04 -0500
Date: Wed, 9 Nov 2011 10:12:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: worker thread - filp_close() problem
Message-ID: <20111109181257.GA26633@core.coreip.homeip.net>
References: <CAME+iuf1xWb=oJkaP9Dm0G2Tbrx_TUGD+DJ58mNfROeovE3+sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAME+iuf1xWb=oJkaP9Dm0G2Tbrx_TUGD+DJ58mNfROeovE3+sQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 08:52:12PM +0900, Murali K. Vemuri wrote:
> Hi there,
> 
> I have a device driver where in I have to do like this:
> 
> (I am using Kernel 2.6.32, and unfortunately cannot upgrade).
> 
> 1. Register for an interrupt.
> 2. When I receive the interrupt, I do some processing, and schedule a
> worker for further processing after 25 msec.
> (The device data sheet says I have to give a minimum of 20 m sec).
> 3. The worker thread has to do some processing and then program
> another device connected to the serial port.
> 
> Problem:
> 1. as long as I don't call the program_serial_dev() from
> my_dev_task(), everything is fine.
> 2. When I call the program_serial_dev(), I am, getting the error
> (console freezes as well):
> ------------[ cut here ]------------
> WARNING: at kernel/workqueue.c:485 flush_cpu_workqueue+0x34/0x88()
> [<c003f92c>] (unwind_backtrace+0x0/0xd8) from [<c006404c>]
> (warn_slowpath_common+0x48/0x60)

It looks like we end up trying to flush a workqueue from within a work
item, which deadlocks.

Since you are using threaded IRQ just stick msleep(25) there and call
program_serial_dev() from it.

... But from the looks of things the programming should not be done in
kernel but rather from userspace...

-- 
Dmitry
