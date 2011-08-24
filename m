Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1HXPtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:49:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:39597 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab1HXPtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:49:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,275,1312182000"; 
   d="scan'208";a="10610479"
Date: Wed, 24 Aug 2011 16:53:57 +0100
From: Alan Cox <alan@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
Message-ID: <20110824165357.477f760d@bob.linux.org.uk>
In-Reply-To: <201108241320.47635.arnd@arndb.de>
References: <13141210141189@kroah.org>
	<73013289.R6WJLciOm2@wuerfel>
	<4E54C4ED.3060809@suse.cz>
	<201108241320.47635.arnd@arndb.de>
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

> It's not clear to me what state->mutex protects in the serial_core,
> but it has been around forever (used to be called state->sem) and is
> held in all uart functions, which is at least consistent. IIRC what
> Alan's plan for this was, uart_close should eventually get changed to
> use tty_port_close_start or even tty_port_close. Maybe the time for
> that has come now, lacking better alternatives?

That was certainly the plan.

> A lot of other drivers call tty_port_close_start() before taking
> port->mutex.

You don't need the port->mutex for tty_port_close_start() if I got it
right, the reason for taking it across the whole of tty_port_close is
so we would end up with a simple API which could be explained as

"open, close and hangup manage locking internally, you will never get
 the events overlapping in any callback. Initialize and shutdown
 callbacks will only be called once with each initialize of the first
 open matching a shutdown of the final close"

It has no meaningful performance impact so it seemed silly not to
provide a somewhat more accident-proof API.
