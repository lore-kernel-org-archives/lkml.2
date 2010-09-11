Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab0IKUIq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 16:08:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab0IKUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 16:08:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: BKL status?
Date: Sat, 11 Sep 2010 22:08:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3+; KDE/4.5.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jan Blunck <jblunck@suse.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
References: <20100824134931.GA30883@merkur.ravnborg.org> <20100907132725.GB5375@nowhere> <201009071710.40669.arnd@arndb.de>
In-Reply-To: <201009071710.40669.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009112208.06233.arnd@arndb.de>
X-Provags-ID: V02:K0:jtJoUEIxVsCyoGRhP9lqfMIoyasmsSAnb2Xzukn+YB8
 J5abuQIbUdIz9yg8/kWYkQCzb4XdPb6g8Rprlu2rcJBOkGwtri
 qWw5YP8AfzGRFArN33IaFPPMTaramifWx9cT9qPPiedkNHlEo3
 79NzD1VECIPNDMEojWL6DvN8eDdifML6dlcZiWE4OJm7L1a5ZE
 QrVOky4X7iqNRM2gZR+BQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 September 2010 17:10:40 Arnd Bergmann wrote:
> 
> > - individual drivers
> 
> We have two categories here. There are a large number of trivial
> drivers where we can prove that the BKL can get replaced with a
> private mutex, as my 'trivial' branch in g.k.o:bkl.git does.
> 
> Then there are some modules that are actually hard to do, most
> of them obsolete. Judging purely by the number of number of
> lock_kernel() calls, which is somewhat misleading, the main
> offenders are:
> 
> drivers/{media,staging,usb/gadget,char/raw}
> fs/{autofs,coda,hpfs,isofs,ncpfs,nfs,smbfs,udf,ufs}
> net/{appletalk,ipx,irda,ax25}
> 
> Out of these, we definitely need to fix v4l, isofs and nfs
> to have a chance of disabling the BKL in a distro kernel.
> But first things first, once fs/lockd is done, we are
> at the point where all remaining BKL users are in modules.

I have now taken care of most of the trivial ones in my git
tree and rebased the series.

The only bits that are left are those I didn't want to
touch for some reason:

arch/sparc: DaveM to look into it
drivers/media/video: Frederic has a series
drivers/gpu/drm/{i810,i830}: actually hard, can become BROKEN_ON_SMP
fs/lockd: Trond and Bruce will take care, disabled for now
fs/*/: interdependencies with the vfs series, can wait for one more release
net/{appletalk,ipx,irda,ax25}: no idea how to do it, need someone to
    actually care.

Many of the file systems should be fairly easy to do for someone who
knows more about VFS than me. However: autofs, coda, hpfs, ncpfs, smbfs
and ufs may end up not surviving the BKL removal unharmed and likely
get removed or marked BROKEN_ON_SMP unless someone puts some serious
work into them. isofs and udf look similar, but I suppose someone
will do it after all. Frederic has managed to do it for Reiserfs, so
I'm sure we will find a way to fix these.

	Arnd
