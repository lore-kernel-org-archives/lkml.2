Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab0FHFW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 01:22:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab0FHFW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 01:22:56 -0400
Date: Tue, 8 Jun 2010 15:22:52 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH, RFC] tty: stop abusing file->f_u.fu_list
Message-ID: <20100608052252.GO26335@laptop>
References: <20100604064307.737085373@suse.de>
 <20100604072618.227745945@suse.de>
 <20100604183934.GA2309@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604183934.GA2309@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 02:39:34PM -0400, Christoph Hellwig wrote:
> The ttry code currently abuses the file anchor for the per-sb file list
> to track instances of a given tty.  But there's no good reason for
> that, we can just install a proxy object in file->private that gets
> added to the list and points to the tty and keep the list away from
> VFS internals.

Well this code looks like the error handling is broken and it's pretty
convoluted to fix (eg. tty_release requires tty from filp but is called
to clean up code from before tty file private structure is allocated).

So I really prefer to put my original patch first. I really don't see
how it makes the tty code more of a special case. In both cases, it
must know that the vfs does not require the file's presence on the
s_files list so it can be reused for tty code. After my patch, it no
longer knows any details about how the vfs does locking for the list.

Possibly a lighter way to do what you want is to have the vfs not use
fu_list for device inodes and define drivers to be allowed to use it for
their own purpose. But that is easily possible after my patch.

