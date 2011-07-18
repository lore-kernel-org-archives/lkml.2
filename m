Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1GRB5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 21:57:14 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51385 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949Ab1GRB5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 21:57:13 -0400
X-Sasl-enc: Ahj4doifhm3Au3QRVtUqY0YGN9uYaq+Z3K9FM72u/AJa 1310954231
Subject: Re: [autofs] autofs does not resolve names ?
From: Ian Kent <raven@themaw.net>
To: JA =?ISO-8859-1?Q?Magall=F3n?= <jamagallon@ono.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
In-Reply-To: <20110717013746.5c5e477a@werewolf.home>
References: <20110716030141.3e6916e3@werewolf.home>
	 <1310783458.3171.2.camel@perseus.themaw.net>
	 <20110717013746.5c5e477a@werewolf.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 09:57:08 +0800
Message-ID: <1310954228.3164.5.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-17 at 01:37 +0200, JA Magallón wrote:
> On Sat, 16 Jul 2011 10:30:58 +0800, Ian Kent <raven@themaw.net> wrote:
> 
> (CC LKML for info and completeness...)
> 
> > On Sat, 2011-07-16 at 03:01 +0200, JA Magallón wrote:
> > > Hi all...
> > > 
> > > Since the update to autofs-5.0.6, I have a curious problem. Probably it is not autofs
> > > to blame, but I ask here to see if someone can give me some light...
> > 
> > Have you applied autofs-5.0.6-fix-ipv6-name-for-lookup-fix.patch?
> > Which fixes a stupid mistake on my part.
> > 
> 
> Love you ! That did the trick, everything works again.
> 
> Are you planning to release a 5.0.7 with the fix ?

That will go into 5.0.7 but it probably won't be released for a while.
Patches, such as this, are available on
http://www.kernel.org/pub/linux/daemons/autofs/v5 as soon as they are
committed to the autofs repository.

> 
> > > 
> > > Setup:
> > > /etc/autofs/auto.master:
> > > 
> > > /home   ldap://danae-nfs.cps.unizar.es/automountMapName=auto_home,o=diis --timeout=60,tcp,nobrowse
> > > 
> > > (user homes map from LDAP, shared homes at a server)
> > > 
> > > The name is resolved:
> > > 
> > > annwn:/etc/autofs# host danae-nfs
> > > danae-nfs.cps.unizar.es has address 155.210.152.202
> > > annwn:/etc/autofs# ping danae-nfs
> > > PING danae-nfs.cps.unizar.es (155.210.152.202) 56(84) bytes of data.
> > > 64 bytes from danae-nfs.cps.unizar.es (155.210.152.202): icmp_req=1 ttl=255 time=0.339 ms
> > > ...
> > > 
> > > But when I access home (ssh the box):
> > > 
> > > Jul 15 01:39:31 annwn automount[7774]: Starting automounter version 5.0.6, master map auto.master
> > > Jul 15 01:39:31 annwn automount[7774]: using kernel protocol version 5.02
> > > Jul 15 01:39:31 annwn automount[7774]: lookup_nss_read_master: reading master files auto.master
> > > ...
> > > Jul 15 01:39:31 annwn automount[7774]: mount_mount: mount(nfs): root=/home name=magallon what=danae-nfs:/export/home/usuarios/giga/magallon, fstype=nfs, options=tcp,quota
> > > Jul 15 01:39:31 annwn automount[7774]: mount_mount: mount(nfs): nfs options="tcp,quota", nobind=0, nosymlink=0, ro=0
> > > Jul 15 01:39:31 annwn automount[7774]: get_nfs_info: called with host danae-nfs(69.65.19.116) proto udp version 0x30
> > > Jul 15 01:39:37 annwn automount[7774]: get_nfs_info: called with host danae-nfs(69.65.19.116) proto tcp version 0x30
> > > 
> > > Where the hell does it get that IP address for my server ????
> > > 
> > > Diggin a bit more:
> > > 
> > > annwn:/var/log# host 69.65.19.116
> > > 116.19.65.69.in-addr.arpa domain name pointer nx-deleted-host-1.no-ip.com
> > > 
> > > because I have at /etc/resolv.conf:
> > > 
> > > search cps.unizar.es unizar.es no-ip.org
> > > 
> > > Why did it not resolved first with the first domain ?
> > > 
> > > If I delete the no-ip.org domain, I get:
> > > 
> > > Jul 15 01:47:18 annwn automount[8068]: mount_mount: mount(nfs): root=/home name=magallon what=danae-nfs:/export/home/usuarios/giga/magallon, fstype=nfs, options=tcp,quota
> > > Jul 15 01:47:18 annwn automount[8068]: mount_mount: mount(nfs): nfs options="tcp,quota", nobind=0, nosymlink=0, ro=0
> > > Jul 15 01:47:20 annwn automount[8068]: add_host_addrs: hostname lookup failed: Name or service not known
> > > Jul 15 01:47:20 annwn automount[8068]: mount(nfs): no hosts available
> > > Jul 15 01:47:20 annwn automount[8068]: dev_ioctl_send_fail: token = 28
> > > Jul 15 01:47:20 annwn automount[8068]: failed to mount /home/magallon
> > > 
> > > automount does not add the search domains and resolve ? what am I doing wrong ?
> > > is it a bug ? uuhhh ?
> > > 
> > > TIA
> > > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


