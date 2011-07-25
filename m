Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1GYCoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 22:44:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47242 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab1GYCop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 22:44:45 -0400
Date: Mon, 25 Jul 2011 03:44:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdevtmpfs oops since yesterdays vfs merge
Message-ID: <20110725024444.GP24703@ZenIV.linux.org.uk>
References: <20110724231701.GA1707@redhat.com>
 <20110724232812.GN24703@ZenIV.linux.org.uk>
 <20110724234029.GA4881@redhat.com>
 <20110724235154.GO24703@ZenIV.linux.org.uk>
 <20110725015324.GA7603@redhat.com>
 <20110725015612.GB7603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725015612.GB7603@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 09:56:12PM -0400, Dave Jones wrote:

> [    7.760774] dracut: luksOpen /dev/sda2 luks-b5a1fb36-5672-4191-a260-e3f389eb0bb6
> [   14.787158] nodename: dm-0
> [   15.082391] nodename: dm-0
> 
> 
> when it triggers the bug_on(), it's that second nodename that is garbage.

Interesting...  The next experiment would be to stick BUG_ON(!req.dev)
into devtmpfs_create_node() right after the assigment to that field.

We couldn't be hit by the lack of barriers here, could we?  Store to
req.dev happens before spin_unlock(&req_lock), so by the time when
that request is seen by loop in devtmpfsd() and passed to handle() it
should be seen - we have grabbed req_lock, found a pointer to req, dropped
req_lock and called handle().  Should've been enough...

Might be interesting to print &req from devtmpfs_create_node(), both on
entry and on exit, and print req right before the call of handle()...

Incidentally, that disassembly shows one really ugly thing - offset of
->devt in struct device is 0x3c0.  IOW, each of those suckers eats a
kilobyte... ;-/
