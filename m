Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2G3I0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:26:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47445 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2G3I0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:26:13 -0400
Date: Mon, 30 Jul 2012 09:26:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [Bisected] commit 71574865 (vfs: do_last(): common slow lookup)
 breaks CUPS printing
Message-ID: <20120730082611.GE6481@ZenIV.linux.org.uk>
References: <20120728104316.GA248@x4>
 <20120730065046.GC6481@ZenIV.linux.org.uk>
 <20120730071023.GA273@x4>
 <20120730075611.GD6481@ZenIV.linux.org.uk>
 <20120730080536.GA268@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730080536.GA268@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 10:05:36AM +0200, Markus Trippelsdorf wrote:
> On 2012.07.30 at 08:56 +0100, Al Viro wrote:
> > On Mon, Jul 30, 2012 at 09:10:23AM +0200, Markus Trippelsdorf wrote:
> > > 
> > > Looks like you're right. The first warning happens during startup. The last one
> > > when I print a test page (which now succeeds).  
> > > Thanks Al.
> > 
> > > WTF: open("/dev/input/mice", 34946)
> > > WTF: open("/dev/usblp0", 32898)
> > > WTF: open("/dev/usb/lp0", 32898)
> > 
> > Ahhh...  OK, yes - it's the case we had missed (and where the manpage
> > needs correction, BTW).  O_EXCL for *devices* has additional semantics;
> > it's not "fail if exists", it's "fail if already opened by somebody".
> > No need to pester CUPS folks (except that I really hope that this
> > open of /dev/input/mice does *not* come from them)...
> 
> I've omitted some WTF's from my former reply, because they happend after
> I've sent it.

> Jul 30 09:07:19 x4 kernel: WTF: open("/var/spool/cups/a00018", 32897)
> Jul 30 09:30:40 x4 kernel: WTF: open("/var/cache/cups/job.cache.O", 32897)

> /var/spool/cups/a00018 & /var/cache/cups/job.cache.O are not devices AFAICS.

Yecch...  AFAICS, there's a couple of places in CUPS likely to do that -
cupsGetFile() and cupsdRemoveFile(); this seems to be the former.  In the best
case there's enough locking to make that a piece of harmless cargo-cult
programming.  In the worst...
