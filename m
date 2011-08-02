Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab1HBGb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 02:31:56 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55398 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1HBGbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 02:31:50 -0400
Date: Tue, 2 Aug 2011 08:31:44 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Nicolas Palix <Nicolas.Palix@inria.fr>, linux-kernel@vger.kernel.org,
        Gilles Muller <Gilles.Muller@lip6.fr>
Subject: Re: Compat-wireless release for 2011-08-01 is (NOT) baked
In-Reply-To: <CAB=NE6WyTKPx+0yt5P1ponajKUd70eqFJQLwH8s1_2hfPkoBTA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1108020823200.26651@ask.diku.dk>
References: <20110801190401.100CA40ED1@repository3.orbit-lab.org>
 <4E370ECF.80509@gnu.org> <CAB=NE6WyTKPx+0yt5P1ponajKUd70eqFJQLwH8s1_2hfPkoBTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-1257558526-1312266704=:26651"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-1257558526-1312266704=:26651
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 1 Aug 2011, Luis R. Rodriguez wrote:

> On Mon, Aug 1, 2011 at 1:38 PM, Pavel Roskin <proski@gnu.org> wrote:
> > On 08/01/2011 03:04 PM, Compat-wireless cronjob account wrote:
> >>
> >>  From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
> >>  + d7c6e83...c39a889 akpm-end   ->  origin/akpm-end  (forced update)
> >>    55f9c40..3da3f87  akpm-start ->  origin/akpm-start
> >>  + cf684c9...346346f master     ->  origin/master  (forced update)
> >>    55f9c40..3da3f87  stable     ->  origin/stable
> >>  * [new tag]         next-20110801 ->  next-20110801
> >> /usr/bin/sha1sum: *.tar.bz2: No such file or directory
> >
> 
> Right, this failed to build the compat-wireless daily tarball based on
> linux-next.git due to a failed hunk:
> 
> Applying backport patch: patches/01-netdev.patch
> patching file drivers/net/usb/rndis_host.c
> patching file drivers/net/usb/usbnet.c
> patching file drivers/net/wireless/rndis_wlan.c
> patching file net/mac80211/iface.c
> Hunk #1 FAILED at 698.
> Hunk #2 succeeded at 846 (offset 1 line).
> Hunk #3 succeeded at 885 (offset 1 line).
> Hunk #4 succeeded at 1136 (offset 1 line).
> Hunk #5 succeeded at 1146 (offset 1 line).
> 1 out of 5 hunks FAILED -- saving rejects to file net/mac80211/iface.c.rej
> patching file drivers/net/b44.c
> patching file net/wireless/wext-core.c
> patching file drivers/net/wireless/ipw2x00/ipw2100.c
> patching file drivers/net/wireless/ipw2x00/ipw2200.c
> patching file drivers/net/wireless/iwmc3200wifi/netdev.c
> patching file drivers/net/wireless/libertas/main.c
> patching file drivers/net/wireless/libertas/mesh.c
> patching file drivers/net/wireless/libertas/defs.h
> patching file drivers/net/wireless/mac80211_hwsim.c
> patching file drivers/net/wireless/mwifiex/main.c
> patching file drivers/net/wireless/orinoco/main.c
> patching file net/bluetooth/bnep/netdev.c
> Hunk #2 FAILED at 235.
> 1 out of 2 hunks FAILED -- saving rejects to file
> net/bluetooth/bnep/netdev.c.rej
> patching file drivers/net/atl1e/atl1e_main.c
> patching file drivers/net/atl1c/atl1c_main.c
> patching file drivers/net/atlx/atl1.c
> patching file drivers/net/atlx/atl2.c
> Patching patches/01-netdev.patch failed, update it
> 
> Whenever we have a failed hunk we run into this. I think we can do
> better, we could break down 01-netdev.patch into one a coccinelle
> spatch for example and then the rest to be handled separately, this
> may help speed with making us lazier and making the backup even more
> automatic.
> 
> For example:
> 
> mcgrof@tux ~/linux-next (git::master)$ cat netdev-attach.cocci
> @@
> expression ptr, ops;
> @@
> ...
> -ptr->netdev_ops = ops;
> +netdev_attach_ops(ptr, ops);
> ...

The outer dots are not needed.  Even incorrect, because they imply that 
there is only one occurrence of this code in the current function.

> mcgrof@tux ~/linux-next (git::master)$ spatch -sp_file
> netdev-attach.cocci -in_place drivers/net/usb/rndis_host.c
> init_defs_builtins: /usr/share/coccinelle/standard.h
> HANDLING: drivers/net/usb/rndis_host.c
> diff =
> --- drivers/net/usb/rndis_host.c        2011-04-25 11:44:25.713248001 -0700
> +++ /tmp/cocci-output-14779-d7a728-rndis_host.c 2011-08-01
> 16:30:48.342283464 -0700
> @@ -355,7 +355,7 @@ generic_rndis_bind(struct usbnet *dev, s
>         dev->rx_urb_size &= ~(dev->maxpacket - 1);
>         u.init->max_transfer_size = cpu_to_le32(dev->rx_urb_size);
> 
> -       net->netdev_ops = &rndis_netdev_ops;
> +       netdev_attach_ops(net, &rndis_netdev_ops);
> 
>         retval = rndis_command(dev, u.header, CONTROL_BUFFER_SIZE);
>         if (unlikely(retval < 0)) {
> 
> Question then is -- are we willing to require spatch for building the
> tarballs? I'm OK with this, anyone else?

The problem with Coccinelle is that there can be false positives and false 
negatives, ie th rule applies where it should not and doesn't apply where 
it should.  But there are probably cases like this one where one knows 
that it should always be done this way.  It would be nice, though if there 
could be some kind of guarantee that the right thing has happened.  
Perhaps there could be a way to generate from a semantic patch some checks 
that it has applied everywhere possible.  Or perhaps the semantic patch 
could be only used as a last resort, if the normal application fails.  In 
that way there would be less to check by hand.

julia
---511516320-1257558526-1312266704=:26651--
