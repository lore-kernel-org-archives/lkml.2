Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab0JHOGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:06:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48825 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab0JHOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:06:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HGNjDQC+0xpR5JJfbjmQFdk9PIoaVNnHC232IR3JcYaONw3nLoUTQstwU2dXmqTOuL
         v/whVvBoLxZv2PmOkdFy6JArUEt8QJZTriWJHO+oEFl+C0wx5QNtb2oy3OJEiYynGef7
         ziFMiOc+uBPppdymFgcBmNNdDs1hmQr5PO6K0=
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101008134821.GA15157@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
	 <1286515292-15882-16-git-send-email-david@fromorbit.com>
	 <20101008095658.GA19804@ZenIV.linux.org.uk>
	 <20101008100346.GA27737@infradead.org>
	 <1286533219.2959.128.camel@edumazet-laptop>
	 <20101008134821.GA15157@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 16:06:12 +0200
Message-ID: <1286546772.2959.372.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 08 octobre 2010 à 09:48 -0400, Christoph Hellwig a écrit :
> On Fri, Oct 08, 2010 at 12:20:19PM +0200, Eric Dumazet wrote:
> > If iunique() was scalable, sockets could use it, so that we can have
> > hard guarantee two sockets on machine dont have same inum.
> > 
> > A reasonable compromise here is to use a simple and scalable allocator,
> > and take the risk two sockets have same inum.
> > 
> > While it might break some applications playing fstats() games, on
> > sockets, current schem is vastly faster.
> > 
> > I worked with machines with millions of opened socket concurrently,
> > iunique() was not an option, and application didnt care of possible inum
> > clash.
> 
> The current version of iuniqueue is indeed rather suboptimal.  As is
> the pure counter approach.  I think the right way to deal with it
> is to use an idr allocator.  This means the filesystem needs to
> explicitly free the inode number when the inode is gone, but that
> just makes the usage more clear.  Together with the lazy assignment
> scheme for synthetic filesystems that should give us both speed and
> correctness.
> 

On 32bit arches, inum for sockets/pipes could be pretty fast

unsigned u32 rnd_val __read_mostly; /* seeded at boot time */

unsigned u32 get_inum(struct inode *ino, size_t size)
{
	return rnd_val ^ ((long)ino + random32() % size);
}

(Ie , use fact that an inode is a kernel object, with a given address
and a given size, two inodes cannot overlap)


I have no idea how scalable is an idr allocator, but it probably uses
one big lock.

Maybe finally generate 64bit inum on 64bit arches...



