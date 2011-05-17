Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab1EQX6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:58:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:1417 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab1EQX6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:58:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,228,1304319600"; 
   d="scan'208";a="437911002"
Date: Wed, 18 May 2011 00:44:20 +0100
From: Alan Cox <alan@linux.intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: NULL pointer deref in tty port / uart
Message-ID: <20110518004420.2b8f5da9@bob.linux.org.uk>
In-Reply-To: <20110517231229.GB1776@nowhere>
References: <20110517231229.GB1776@nowhere>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	echo 1 > /dev/ttyS4 # which blocks
> 
> And on another console:
> 
> 	cat /dev/ttyS4 # which blocks
> 
> Then Ctrl + C the echo in the first console. This produces the
> following trace:

First cat is in tty_port_block_til_ready, second cat joins it there. ^C
causes one to close, which wakes the second which goes around the loop
again, tries to raise the carrier and explodes, it seems because
someone trashed memory it is using.

Not quite sure why at this point

On the first exit of the open path port->count is 1 which is as we want
it. Close takes it down to zero which triggers the port shutdown path
which is as we want. We clean up port->tty and shut down the port.
Seeing the second pending open we wake it which is when it goes kaboom

Nothing obvious strikes me from reading the code.
