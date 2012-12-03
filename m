Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2LCRnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:43:50 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:36514 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab2LCRnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:43:49 -0500
Date: Mon, 3 Dec 2012 12:43:42 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: Roland Eggner <edvx1@systemanalysen.net>, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
Message-ID: <20121203174342.GB20260@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dimitrios Apostolou <jimis@gmx.net>,
	Roland Eggner <edvx1@systemanalysen.net>,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>
References: <1353855815.22969.20.camel@soupermouf>
 <1354452243.22969.48.camel@soupermouf>
 <20121202225051.GA13685@mobil.systemanalysen.net>
 <alpine.LFD.2.02.1212030120090.1646@soupermouf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1212030120090.1646@soupermouf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 01:56:27AM +0200, Dimitrios Apostolou wrote:
> 
> Please take a look at [2], it's what is called in that case. Via
> this call all slabs that have registered a shrinker, get actually
> shrinked. Other fs do, but I can't find whether ext4 actually
> registers a shrinker for its slabs.

The ext4 inode cache gets shrunk via the VFS layer, in
prune_icache_sb() in fs/inode.c.  This is true for all file systems'
inode caches.

If you are under heavy memory pressure, or if you run echo 3 >
/proc/sys/vm/drop_caches, and the inodes aren't getting dropped, then
it's because the inodes are getting pinned for some reason --- i.e.,
they are referenced via some entry in the dentry cache, perhaps there
are files open, or processes are cd'ed into a directory, etc.

So an example of what happens with the ext4_inode_cache before and
after running "echo 3 > /proc/sys/vm/drop_caches":

ext4_inode_cache  183379 183379   1872   17    8 : tunables    0    0    0 : slabdata  10787  10787      0

ext4_inode_cache    1595   6120   1872   17    8 : tunables    0    0    0 : slabdata    360    360      0

(What's left is due to all of the executable files, shared libraries,
current directories, and open files for all my processes running on my
system --- which for context is Xfce plus Chrome, emacs, mutt, and a
bunch of terminal windows plus the usual assortment of system daemons.)

If you are seeing a large number of inodes still in the ext4 inode
cache after using drop_caches, then I'd look to see whether you have
something like SELinux or auditing enabled which is pinning a bunch of
dentries or inodes, or whether your backup program (or some other
program running on your system) is keeping lots of directories or
inodes open for some reason.

Hope this helps,

					- Ted
