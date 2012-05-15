Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2EOLr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:47:57 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:51014
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1758536Ab2EOLrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:47:55 -0400
Date: Tue, 15 May 2012 13:47:53 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] UBI: add lnum to struct ubi_work
In-Reply-To: <1337081204.2528.171.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1205151339020.18866@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205142046080.12448@eristoteles.iwoars.net>  <1337080498.2528.161.camel@sauron.fi.intel.com> <1337081204.2528.171.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For vol_id, its straightforward everywhere except: ubi_wl_init_scan()

where scheduling erase on the:

struct ubi_scan_leb *seb

appears to lack access to the volume id.  Should we add vol_id to
ubi_scan_leb, and in ubi_scan() run:

        ubi_rb_for_each_entry(rb1, sv, &si->volumes, rb) {
                ubi_rb_for_each_entry(rb2, seb, &sv->root, u.rb)
			seb->vol_id = sv->vol_id;

Or is there a simpler way?

Cheers,
Joel Reardon

On Tue, 15 May 2012, Artem Bityutskiy wrote:

> On Tue, 2012-05-15 at 14:14 +0300, Artem Bityutskiy wrote:
> > On Mon, 2012-05-14 at 20:47 +0200, Joel Reardon wrote:
> > > @@ -1086,13 +1090,14 @@ out_ro:
> > >   * @ubi: UBI device description object
> > >   * @pnum: physical eraseblock to return
> > >   * @torture: if this physical eraseblock has to be tortured
> > > + * @lnum: the last used logical eraseblock number for the PEB
> > >   *
> > >   * This function is called to return physical eraseblock @pnum to the pool of
> > >   * free physical eraseblocks. The @torture flag has to be set if an I/O error
> > >   * occurred to this @pnum and it has to be tested. This function returns zero
> > >   * in case of success, and a negative error code in case of failure.
> > >   */
> > > -int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture)
> > > +int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture, int lnum)
> >
> > Joel, am sorry for nitpicking again, but could you please put the "lnum"
> > argument between "ubi" and "lnum" instead? Just feels more natural.
> > Otherwise the patch is OK. Thanks!
>
> Err, but you also need volume ID, because there may be several volumes
> with the same lnum.
>
> --
> Best Regards,
> Artem Bityutskiy
>
