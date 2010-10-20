Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0JTN1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:27:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35269 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0JTN1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:27:22 -0400
Date: Wed, 20 Oct 2010 14:27:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 19/35] fs: icache remove redundant i_sb_list umount
 locking
Message-ID: <20101020132721.GZ19804@ZenIV.linux.org.uk>
References: <20101019034216.319085068@kernel.dk>
 <20101019034657.476923711@kernel.dk>
 <20101020124631.GA24394@ZenIV.linux.org.uk>
 <20101020130345.GA6663@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020130345.GA6663@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 12:03:45AM +1100, Nick Piggin wrote:

> Where can fsnotify_destroy_mark run concurrently at umount time, can you
> explain? I haven't spotted it yet.

When you destroy the group mark belongs to.  Which is not tied to any
specific fs...

Basically, these marks are associated with pairs (inode, group) and
can be kicked out by either side.  They pin inodes once set up, without
pinning the superblock down.  Main selling point of idiotify, inherited
by fsnotify.  That's why we need to go through that list on umount in
the first place - we need to evict that crap, or it'll keep inodes busy.

OTOH, removal of group also needs to kill the subset of marks - ones
belonging to that group...  grep for fsnotify_put_group() and look
for the chain through fsnotify_destroy_group() and on to
fsnotify_destroy_mark() and fsnotify_destroy_inode_mark().
