Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab1AUJ2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:28:50 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:40121 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab1AUJ2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:28:49 -0500
X-Greylist: delayed 1786 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jan 2011 04:28:48 EST
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Fwd: Re: BUG: double mutex_unlock in drivers/media/video/tlg2300/pd-video.c
Date: Fri, 21 Jan 2011 12:15:51 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_H7UONZKQu5o1qy5"
Message-Id: <201101211215.51322.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_H7UONZKQu5o1qy5
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit



--Boundary-00=_H7UONZKQu5o1qy5
Content-Type: message/rfc822;
  name="forwarded message"
Content-Transfer-Encoding: 7bit
Content-Description: Alexander Strakh <strakh@ispras.ru>: Re: BUG: double mutex_unlock in drivers/media/video/tlg2300/pd-video.c
Content-Disposition: inline

From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Huang Shijie <shijie8@gmail.com>
Subject: Re: BUG: double mutex_unlock in drivers/media/video/tlg2300/pd-video.c
Date: Wed, 15 Dec 2010 17:19:32 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
References: <201012131859.15152.strakh@ispras.ru> <AANLkTi=4CZ2LD8cj_cjnb5yyyML+M6T=57EjT_hD4TBn@mail.gmail.com>
In-Reply-To: <AANLkTi=4CZ2LD8cj_cjnb5yyyML+M6T=57EjT_hD4TBn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201012151719.33086.strakh@ispras.ru>

Hello,

> Hi Strakh:
>=20
> Thanks for your patch.
>=20
> But I prefer to remove the mutex_unlock() in the pd_vidioc_s_fmt(),
> since the pd_vidioc_s_fmt() is also called in restore_v4l2_context().
>=20
> would you please change the patch?
> I will ack it.
>=20
> Best Regards
> Huang Shijie
>=20
> 2010/12/13 Alexander Strakh <strakh@ispras.ru>:
> >        KERNEL_VERSION: 2.6.36
> >        SUBJECT: double mutex_lock in
> > drivers/media/video/tlg2300/pd-video.c in function vidioc_s_fmt
> >        SUBSCRIBE:
> >        First mutex_unlock in function pd_vidioc_s_fmt in line 767:
> >=20
> >  764        ret |=3D send_set_req(pd, VIDEO_ROSOLU_SEL,
> >  765                                vid_resol, &cmd_status);
> >  766        if (ret || cmd_status) {
> >  767                mutex_unlock(&pd->lock);
> >  768                return -EBUSY;
> >  769        }
> >=20
> >        Second mutex_unlock in function vidioc_s_fmt in line 806:
> >=20
> >  805        pd_vidioc_s_fmt(pd, &f->fmt.pix);
> >  806        mutex_unlock(&pd->lock);
> >=20
> > Found by Linux Device Drivers Verification Project
> >=20
> > =D0=A1hecks the return code of pd_vidioc_s_fm before mutex_unlocking.
> >=20
> > Signed-off-by: Alexander Strakh <strakh@ispras.ru>
> >=20
> > ---
> > diff --git a/drivers/media/video/tlg2300/pd-video.c
> > b/drivers/media/video/tlg2300/pd-video.c
> > index a1ffe18..fe6bd2b 100644
> > --- a/drivers/media/video/tlg2300/pd-video.c
> > +++ b/drivers/media/video/tlg2300/pd-video.c
> > @@ -802,8 +802,8 @@ static int vidioc_s_fmt(struct file *file, void *fh,
> > struct v4l2_format *f)
> >                return -EINVAL;
> >        }
> >=20
> > -       pd_vidioc_s_fmt(pd, &f->fmt.pix);
> > -       mutex_unlock(&pd->lock);
> > +       if(!pd_vidioc_s_fmt(pd, &f->fmt.pix))
> > +               mutex_unlock(&pd->lock);
> >        return 0;
> >  }

 Removing mutex_unlock from pd_vidioc_s_fmt().

=2D--
diff --git a/drivers/media/video/tlg2300/pd-video.c=20
b/drivers/media/video/tlg2300/pd-video.c
index a1ffe18..6eb4538 100644
=2D-- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -763,10 +763,8 @@ static int pd_vidioc_s_fmt(struct poseidon *pd, struct=
=20
v4l2_pix_format *pix)
 	}
 	ret |=3D send_set_req(pd, VIDEO_ROSOLU_SEL,
 				vid_resol, &cmd_status);
=2D	if (ret || cmd_status) {
=2D		mutex_unlock(&pd->lock);
+	if (ret || cmd_status)
 		return -EBUSY;
=2D	}
=20
 	pix_def->pixelformat =3D pix->pixelformat; /* save it */
 	pix->height =3D (context->tvnormid & V4L2_STD_525_60) ?  480 : 576;


--Boundary-00=_H7UONZKQu5o1qy5--
