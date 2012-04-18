Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2DRMzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 08:55:13 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:48716
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752179Ab2DRMzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:55:12 -0400
Date: Wed, 18 Apr 2012 14:55:05 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: mtdchar kernel oops
In-Reply-To: <20120416191718.GT6589@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1204181452410.8114@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1204151350450.13924@eristoteles.iwoars.net> <20120415153220.GR6589@ZenIV.linux.org.uk> <alpine.DEB.2.00.1204151951560.16000@eristoteles.iwoars.net> <20120415215355.GS6589@ZenIV.linux.org.uk> <alpine.DEB.2.00.1204161329200.21808@eristoteles.iwoars.net>
 <20120416191718.GT6589@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps Artem can shed some light on this, I'm working on a branch he's
prepared. But if its not happening at your end then perhaps something's up
on mine; the oops log is rather bizzare. I'll remake it from scratch and
see what happens.

Cheers,
Joel

On Mon, 16 Apr 2012, Al Viro wrote:

> On Mon, Apr 16, 2012 at 02:37:06PM +0200, Joel Reardon wrote:
> > The troubled asm pair corresponds to this line:
> > this_cpu_add(mnt->mnt_pcp->mnt_count, n) in  the inline mnt_add_count().
> > So I suppose that perhaps either mnt is bad, or mnt_pcp is bad.
> >
> > I'm using nandsim to simulate the mtd device. Steps are simple, load the
> > modules:
> > nand_ecc nand nand_ids mtd  mtd_blkdevs mtdblock mtdchar
> > nandsim first_id_byte=0x20 second_id_byte=0xa5 third_id_byte=0x00 fourth_id_byte=0x15 parts=0xa40 rptwear=1000
> >
> > then `ubiformat /dev/mtd0` does the oops.
>
> Not here:
>
> root@dizzy:~# modprobe nandsim first_id_byte=0x20 second_id_byte=0xa5 third_id_byte=0x00 fourth_id_byte=0x15 parts=0xa40 rptwear=1000
> ubiformat: mtd0 (nand), size 343932928 bytes (328.0 MiB), 2624 eraseblocks of 131072 bytes (128.0 KiB), min. I/O size 2048 bytes
> libscan: scanning eraseblock 2623 -- 100 % complete
> ubiformat: 2624 eraseblocks are supposedly empty
> ubiformat: formatting eraseblock 2623 -- 100 % complete
> root@dizzy:~# uname -a
> Linux dizzy 3.4.0-rc2+ #4 SMP Mon Apr 16 15:04:25 EDT 2012 x86_64 GNU/Linux
>
> and no oopsen in sight...
>
>
> > > Could you add printk into mtdchar_open(), dumping mnt and count values
> > > right after simple_pin_fs() call?
> > >
> >
> > It oopses before it returns from the simple_pin_fs call, so that won't be
> > possible...
>
> Wha...?  You mean, that happens on the _first_ simple_pin_fs() call?
> But that makes no damn sense whatsoever - we just do vfs_kern_mount(),
> get a vfsmount from it (and not an ERR_PTR(), at that), then store
> it into mnt and do mntget(mnt) followed by mntput(mnt).  If that really
> happens when simple_pin_fs() gets called with mnt == NULL and count == 0,
> we have much bigger problem on hands...
>
> Please, slap such printks before and after simple_pin_fs() in mtdchar_open()
> and before and after simple_release_fs() in mtdchar_close().  And verify that
> you have commit c65390f4dd49755863f6d772ec538ee4757c08d7 in your tree.
>
