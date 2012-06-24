Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2FXS2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 14:28:15 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29139 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2FXS2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 14:28:14 -0400
Date: Sun, 24 Jun 2012 20:28:12 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "devendra.aaru" <devendra.aaru@gmail.com>
cc: Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mgag200: Fix a memory leak in mgag200fb_create()
In-Reply-To: <CAHdPZaMCDO2GAyxR_WYxqpwC1Ym307uj3CXFG7r0LybMLH7Pig@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1206242025290.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206220012470.7671@swampdragon.chaosbits.net> <CAHdPZaMCDO2GAyxR_WYxqpwC1Ym307uj3CXFG7r0LybMLH7Pig@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-889122848-1340562492=:30361"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-889122848-1340562492=:30361
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 22 Jun 2012, devendra.aaru wrote:

> On Fri, Jun 22, 2012 at 3:43 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> > First we allocate memory for 'sysram' with vmalloc() and subsequently
> > we allocate for 'info' with framebuffer_alloc(). If the second
> > allocation fails we return -ENOMEM, but neglect to vfree() the memory
> > we previously allocated for 'sysram', thus leaking it.
> >
> Hi Jesper,
> 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/gpu/drm/mgag200/mgag200_fb.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/mgag200/mgag200_fb.c b/drivers/gpu/drm/mgag200/mgag200_fb.c
> > index 880d336..3c837e5 100644
> > --- a/drivers/gpu/drm/mgag200/mgag200_fb.c
> > +++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
> > @@ -156,8 +156,10 @@ static int mgag200fb_create(struct mga_fbdev *mfbdev,
> >                return -ENOMEM;
> >
> >        info = framebuffer_alloc(0, device);
> > -       if (info == NULL)
> > +       if (info == NULL) {
> > +               vfree(sysram);
> >                return -ENOMEM;
> > +       }
> >
> >        info->par = mfbdev;
> >
> This looks ok. but what about the error path?
> there are more leaks at error paths. mgag200_framebuffer_init failcase
> and the functions below like,
> fb_alloc_cmap,
> alloc_apertures,
> ?
> 
I didn't do a complete review. I just happened to notice this one and 
wanted to submit a patch.

If I can find the time I may look more closely for other problems, but no 
promises, so for now I'd suggest just merging this patch and then future 
patches from me, you or someone else, can be added on top of that at a 
later time.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-889122848-1340562492=:30361--
