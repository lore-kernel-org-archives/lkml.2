Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab0FGGoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 02:44:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55394 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab0FGGoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 02:44:16 -0400
Date: Mon, 7 Jun 2010 07:44:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jari Ruusu <jariruusu@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.35-rc2 module reference counting broken
Message-ID: <20100607064412.GK31073@ZenIV.linux.org.uk>
References: <4C0C819E.EA5D6A18@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0C819E.EA5D6A18@users.sourceforge.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 08:20:30AM +0300, Jari Ruusu wrote:
> Someone broke block device module reference counting. Problem occours when a
> modular block device is mounted and unmounted. Not when it is directly read.
> 2.6.34 kernel works OK, but 2.6.35-rc2 kernel seems to increase usage count
> by one for each mount + umount pair.

Very interesting...  Looks like mount() bumps refcount by 2.  umount() after
that drops refcount by 1, so it's not leaking superblocks.

Which probably means that open_bdev_exclusive() is fscked.  Interesting...
FWIW, quick look through the history seems to point to this:
commit 6b4517a7913a09d3259bb1d21c9cb300f12294bd
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Apr 7 18:53:59 2010 +0900

    block: implement bd_claiming and claiming block

I'm far too sleepy right now, but I'd start with reviewing what that
thing is doing to module refcounting...
