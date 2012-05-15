Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab2EOL4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:56:36 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:46992
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1757851Ab2EOL4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:56:35 -0400
Date: Tue, 15 May 2012 13:56:34 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: determining if a block erasure failed
In-Reply-To: <1337082053.2528.182.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1205151349580.18866@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205150944550.17750@eristoteles.iwoars.net> <1337082053.2528.182.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah yes, if wl_wrk is freed in schedule_erase, theres no way to pass it
back that way.

The reason is that, if erasing a block of keys fails, then those keys may
remain on the flash device for eternity. While a rare occurance, it may be
nice to have ubifs perform GC on all main LEBs storing the data nodes that
can no longer be deleted through key erasure / reencrypt the valid data
nodes.

Cheers,
Joel Reardon
On Tue, 15 May 2012, Artem Bityutskiy wrote:

> On Tue, 2012-05-15 at 09:53 +0200, Joel Reardon wrote:
> > I want the caller of erase_worker() to be aware if the erase block became
> > bad. Here is the relevant code at the end of erase_worker():
> >
> > /* at this time, the erase has failed. err == -EIO */
> >         ubi_msg("mark PEB %d as bad", pnum);
> >         err = ubi_io_mark_bad(ubi, pnum);
> >         if (err)
> >                 goto out_ro;
> >
> > /* does other stuff, not touching err */
> >
> > /* err == 0 here, because of above goto */
> >         return err;
> >
> > out_ro:
> >         ubi_ro_mode(ubi);
> >         return err;
> >
> >
> > So, if this function should return zero when the erase block fails, then I
> > will add a "result" field to ubi_work that will store the result of the
> > work function. But I figured I'd check first if the return err that always
> > returns 0 is not an oversight and this function should return -EIO if it
> > fails.
>
> Why do you need the results?
>
> --
> Best Regards,
> Artem Bityutskiy
>
