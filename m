Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab1DRFtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 01:49:04 -0400
Received: from cobra.newdream.net ([66.33.216.30]:45779 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1DRFs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 01:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=TlACZbTvT46VOhMmq14QBjAvw
	yM1M6m3kAapLPEurkz02Vlxtqv7jVJD5kMn7xFNAw8IjdNnvwMDbKirE7IRAASMy
	fjk+7uix89e5VSWEevTlSBQjaBrDfTnP7uZKR8wA6a6ZyPrSl0pVskOMbbwiNJ1S
	y6BLzOXjrakqzI8mEw=
Date: Sun, 17 Apr 2011 22:52:40 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Jim Schutt <jaschut@sandia.gov>
cc: Maciej Rutecki <maciej.rutecki@gmail.com>, dchinner@redhat.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [Regression,bisected] 2.6.39-rc3 ceph client write hangs
In-Reply-To: <201104172017.15090.maciej.rutecki@gmail.com>
Message-ID: <Pine.LNX.4.64.1104172249540.18433@cobra.newdream.net>
References: <4DA879CA.8060305@sandia.gov> <201104172017.15090.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-31607930-1303105960=:18433"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-31607930-1303105960=:18433
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

This was a simple s/igrab/ihold/ fix.  See

283a85dc6e670083adb1e5437bd93d163f4f801a

in the for-linus branch of ceph-client.git.  I'll push to Linus in the=20
next few days.

Thanks!
sage




On Sun, 17 Apr 2011, Maciej Rutecki wrote:

> I created a Bugzilla entry at=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D33452
> for your bug report, please add your address to the CC list in there, tha=
nks!
>=20
> On pi=FF=FFtek, 15 kwietnia 2011 o 19:00:58 Jim Schutt wrote:
> > Hi,
> >=20
> > This command is hanging on 2.6.39-rc3, where /mnt/ceph is
> > a ceph file system:
> >    dd conv=3Dfdatasync if=3D/dev/zero of=3D/mnt/ceph/zero.`hostname -s`=
 bs=3D4k
> > count=3D4k
> >=20
> > It works on 2.6.38.  As of commit e38f5b745075 in Linus'
> > tree it still doesn't work.
> >=20
> > I bisected this to:
> >=20
> > 250df6ed274d767da844a5d9f05720b804240197 is the first bad commit
> > commit 250df6ed274d767da844a5d9f05720b804240197
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Tue Mar 22 22:23:36 2011 +1100
> >=20
> >      fs: protect inode->i_state with inode->i_lock
> >=20
> > In the early stages of the bisection, bad commits would show this
> > in dmesg:
> >=20
> > [  137.004963] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
> > [  137.056431] ceph: loaded (mds proto 32)
> > [  137.063213] libceph: client4283 fsid
> > 950217ad-499e-eab1-03f7-f6d245f42751 [  137.063826] libceph: mon0
> > 172.17.40.34:6789 session established [  219.658002] INFO: rcu_sched_st=
ate
> > detected stall on CPU 0 (t=3D60000 jiffies)
> >=20
> > For the last couple of bad commits during the bisection, the
> > client box would just hang and I'd have to power-cycle it.
> >=20
> > When I reboot/remount after a hang, the file I was trying
> > to write is there, with size and date both zero:
> >=20
> > # ls -l --time-style=3D+%s /mnt/ceph/zero.an1024
> > -rw-r--r-- 1 jaschut jaschut 0 0 /mnt/ceph/zero.an1024
> >=20
> > strace suggests it's the write that hangs:
> >=20
> > close(3)                                =3D 0
> > close(0)                                =3D 0
> > open("/dev/zero", O_RDONLY)             =3D 0
> > lseek(0, 0, SEEK_CUR)                   =3D 0
> > close(1)                                =3D 0
> > open("/mnt/ceph/zero.an1024", O_WRONLY|O_CREAT|O_TRUNC, 0666) =3D 1
> > rt_sigaction(SIGUSR1, NULL, {SIG_DFL, [], 0}, 8) =3D 0
> > rt_sigaction(SIGINT, NULL, {SIG_DFL, [], 0}, 8) =3D 0
> > rt_sigaction(SIGUSR1, {0x401a20, [INT USR1], SA_RESTORER, 0x7f3a97f292d=
0},
> > NULL, 8) =3D 0 rt_sigaction(SIGINT, {0x401a10, [INT USR1],
> > SA_RESTORER|SA_NODEFER|SA_RESETHAND, 0x7f3a97f292d0}, NULL, 8) =3D 0
> > clock_gettime(CLOCK_MONOTONIC, {216, 671807533}) =3D 0
> > read(0,
> > "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
> > 4096) =3D 4096 write(1,
> > "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
> > 4096
> >=20
> > Let me know if I can do anything else to help sort this out.
> >=20
> > -- Jim
> >=20
> > (Please Cc: me as I am not subscribed to lkml.)
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
>=20
> --=20
> Maciej Rutecki
> http://www.maciek.unixy.pl
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
--557981400-31607930-1303105960=:18433--
