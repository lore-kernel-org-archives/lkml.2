Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab1FQOLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:11:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64176 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1FQOLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:11:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [AX25] inconsistent lock state
Date: Fri, 17 Jun 2011 16:11:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: f6bvp <f6bvp@free.fr>, linux-kernel@vger.kernel.org,
        Linux Netdev List <netdev@vger.kernel.org>, linux-hams@vger.kernel.org
References: <4B2CD772.1030106@upmc.fr> <201106171536.15660.arnd@arndb.de> <20110617135147.GA3470@linux-mips.org>
In-Reply-To: <20110617135147.GA3470@linux-mips.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171611.10655.arnd@arndb.de>
X-Provags-ID: V02:K0:NWeMWz0GEM1ctT1CtwmoPdoB9RtXUP68ur6tUm26ebv
 JN+yoYXLSGg3g4z7yRsaPrO/AfmOo4W90MZVIJlBLXMAyHv4Y2
 +eEB7FtYizRzdkmKPJrl9Cv6MVFrvjWQUyyoUAKBF7EwCAsqu2
 GWww/1FmXu+YEb1vrGeja5KbR1XtlaolvNBGaHmN2iXpbYjM+e
 nol/bYSDR5Wn3fLd1NV0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 June 2011 15:51:48 Ralf Baechle wrote:
> On Fri, Jun 17, 2011 at 03:36:15PM +0200, Arnd Bergmann wrote:
> 
> (Removed Jarek from cc; his email bounces.)
> 
> > The message hints that disc_data_lock is aquired with softirqs disabled,
> > but does not itself disable softirqs, which can in rare circumstances
> > lead to a deadlock.
> > 
> > Does this fix it?
> 
> If so, drivers/net/hamradio.c, function sp_get() would probably need the
> equivalent fix.  Same for drivers/net/ppp_async.c:ap_get() and sp_get() in
> drivers/net/ppp_synctty.c.

It seems that ppp_synctty.c is ok, it uses write_lock_irq() already,
sixpack.c looks like it has the same bug as mkiss. I also realized
after sending out the patch that only the write_lock needs to be
changed to write_lock_bh, while read_lock can leave softirqs enabled
because it can be called recursively.

	Arnd
