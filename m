Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0KJGdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 01:33:19 -0500
Received: from adelie.canonical.com ([91.189.90.139]:33013 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab0KJGdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 01:33:18 -0500
Date: Wed, 10 Nov 2010 01:33:12 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@canonical.com>
X-X-Sender: nico@xanadu.home
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 29/49] vcs: add poll/fasync support
In-Reply-To: <AANLkTinfLT0WYDHek8+QjYKfGC0rtJ3ZFhoZj2fD8-Ri@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1011100119140.13911@xanadu.home>
References: <20101022175112.GC13489@kroah.com> <1287771688-14805-29-git-send-email-gregkh@suse.de> <AANLkTinVp4C9bRW6=EMHwh1UyeadFbOXKe1aDsxknJf8@mail.gmail.com> <alpine.LFD.2.00.1011092013290.13911@xanadu.home>
 <AANLkTinfLT0WYDHek8+QjYKfGC0rtJ3ZFhoZj2fD8-Ri@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811582-801402965-1289370794=:13911"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811582-801402965-1289370794=:13911
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 10 Nov 2010, Kay Sievers wrote:

> On Wed, Nov 10, 2010 at 02:26, Nicolas Pitre
> <nicolas.pitre@canonical.com> wrote:
> > On Wed, 10 Nov 2010, Kay Sievers wrote:
> >
> >> On Fri, Oct 22, 2010 at 20:21, Greg Kroah-Hartman <gregkh@suse.de> wro=
te:
> >> > From: Nicolas Pitre <nico@fluxnic.net>
> >> >
> >> > The /dev/vcs* devices are used, amongst other things, by accessibili=
ty
> >> > applications such as BRLTTY to display the screen content onto refre=
shable
> >> > braille displays. =C2=A0Currently this is performed by constantly re=
ading from
> >> > /dev/vcsa0 whether or not the screen content has changed. =C2=A0Give=
n the
> >> > default braille refresh rate of 25 times per second, this easily qua=
lifies
> >> > as the biggest source of wake-up events preventing laptops from ente=
ring
> >> > deeper power saving states.
> >> >
> >> > To avoid this periodic polling, let's add support for select()/poll(=
) and
> >> > SIGIO with the /dev/vcs* devices. =C2=A0The implemented semantic is =
to report
> >> > data availability whenever the corresponding vt has seen some update=
 after
> >> > the last read() operation. =C2=A0The application still has to lseek(=
) back
> >> > as usual in order to read() the new data.
> >>
> >> Shouldn't it raise POLLPRI/POLLERR then, when it's not about new data
> >> to read? We do this for several files in the kernel where we just want
> >> to wakup someone, but the pretty well-defined semantics of poll()
> >> don't apply.
> >
> > Hmmm... =C2=A0Maybe POLLPRI, but POLLERR makes no sense.
>=20
> I have no opinion about that, but it's what others do:
>   http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D31b07093c44a7a442394d44423e21d783f5523b8
>   http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D4508a7a734b111b8b7e39986237d84acb1168dd0
>=20
> The POLLIN should definitely go, it's POSIX defined. What we do here
> is more like an error that wakes up than a stream data to read. :)

OK.  What about this then?
----- >8
Subject: [PATCH] vcs: make proper usage of the poll flags

Kay Sievers pointed out that usage of POLLIN is well defined by POSIX,
and the current usage here doesn't follow that definition.  So let's
duplicate the same semantics as implemented by sysfs_poll() instead.

Signed-off-by: Nicolas Pitre <nicolas.pitre@canonical.com>
---
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 273ab44..a93856e 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -553,12 +553,12 @@ static unsigned int
 vcs_poll(struct file *file, poll_table *wait)
 {
 =09struct vcs_poll_data *poll =3D vcs_poll_data_get(file);
-=09int ret =3D 0;
+=09int ret =3D DEFAULT_POLLMASK|POLLERR|POLLPRI;
=20
 =09if (poll) {
 =09=09poll_wait(file, &poll->waitq, wait);
-=09=09if (!poll->seen_last_update)
-=09=09=09ret =3D POLLIN | POLLRDNORM;
+=09=09if (poll->seen_last_update)
+=09=09=09ret =3D DEFAULT_POLLMASK;=20
 =09}
 =09return ret;
 }
---1463811582-801402965-1289370794=:13911--
