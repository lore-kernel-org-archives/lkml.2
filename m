Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab1ADUT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:19:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44018
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab1ADUT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:19:28 -0500
Date: Tue, 04 Jan 2011 12:19:58 -0800 (PST)
Message-Id: <20110104.121958.232738534.davem@davemloft.net>
To: alex.buell@munted.org.uk
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Using s3virge card in Sun Blade 2000
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294171877.17576.24.camel@lithium>
References: <1294156627.17576.21.camel@lithium>
	<20110104.092637.226761806.davem@davemloft.net>
	<1294171877.17576.24.camel@lithium>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Buell <alex.buell@munted.org.uk>
Date: Tue, 04 Jan 2011 20:11:17 +0000

> I'm already doing that. In the instances where it results in a crash and
> reboots are impossible, dropping into the OpenPROM results in a total
> system freeze, cannot type anything in, this means a big red switch
> time. Solaris didn't have this problem. Any ideas why Linux does this to
> the OpenPROM? 

First of all, the machine dies because those illegal I/O accesses
generate an unrecoverable asynchronous memory error, we cannot recover
from it so we have to panic the entire machine.

Secondly, the keyboard doesn't work because I never implemented the
monstrous amount of code necessary to allow USB keyboard to work with
OpenPROM after booting up.

You have to essentially reset the entire USB host controller, unload
all of the pending queued URBs in the host controller, put it into a
quiescent state, and then asynchronously process all USB keyboard
device events via USB host controller polling implemented via OpenPROM
backcalls into the kernel, and from there feed the characters to
OpenPROM so it can see the keypresses.  Upon return from OpenPROM you
have to reload all of the unloaded URBs back onto the USB host
controller queues so the kernel can use USB again.

I never considered this enormous amount of work worth doing, the
payback is just too small.
