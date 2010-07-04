Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab0GDNW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 09:22:57 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56743 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757524Ab0GDNW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 09:22:56 -0400
Subject: Re: [PATCH] VIDEO: ivtvfb, remove unneeded NULL test
From: Andy Walls <awalls@md.metrocast.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Ian Armstrong <ian@iarmst.demon.co.uk>,
       ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <4C30372D.9050304@suse.cz>
References: <1277206910-27228-1-git-send-email-jslaby@suse.cz>
	 <1278216707.2644.32.camel@localhost>  <4C30372D.9050304@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Jul 2010 09:22:25 -0400
Message-ID: <1278249745.2280.46.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166
 definitions=2010-07-02_03:2010-02-06,2010-07-02,2010-07-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1007040050
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-04 at 09:24 +0200, Jiri Slaby wrote:
> On 07/04/2010 06:11 AM, Andy Walls wrote:
> > You missed an identical instance of the useless test 10 lines prior in
> > ivtvfb_callback_init(). :)
> 
> Ah, thank you for pointing out. Find my comment below.
> 
> > --- a/drivers/media/video/ivtv/ivtvfb.c
> > +++ b/drivers/media/video/ivtv/ivtvfb.c
> > @@ -1201,9 +1201,14 @@ static int ivtvfb_init_card(struct ivtv *itv)
> >  static int __init ivtvfb_callback_init(struct device *dev, void *p)
> >  {
> >         struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
> > -       struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
> > +       struct ivtv *itv;
> >  
> > -       if (itv && (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
> > +       if (v4l2_dev == NULL)
> > +               return 0;
> > +
> > +       itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
> > +
> > +       if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
> >                 if (ivtvfb_init_card(itv) == 0) {
> >                         IVTVFB_INFO("Framebuffer registered on %s\n",
> >                                         itv->v4l2_dev.name);
> > @@ -1216,10 +1221,16 @@ static int __init ivtvfb_callback_init(struct device *de
> >  static int ivtvfb_callback_cleanup(struct device *dev, void *p)
> >  {
> >         struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
> > -       struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
> > -       struct osd_info *oi = itv->osd_info;
> > +       struct ivtv *itv;
> > +       struct osd_info *oi;
> > +
> > +       if (v4l2_dev == NULL)
> > +               return 0;
> 
> >From my POV I NACK this. Given that it never triggered and drvdata are
> set in v4l2_device_register called from ivtv_probe I can't see how
> v4l2_dev be NULL. Could you elaborate?

I hemmed and hawed over that too.  I didn't do a very thorough analysis
of the restrictions on unloading modules, but here was my line of
reasoning:

1. I assumed the check was there because presumably someone has run into
an Ooops there before, prior to the conversion to the v4l2_device
infrastrucutre.

I have reasearched that with git log this morning, and found that
assumption was false.  The itv NULL check is a hold-over from when the
ivtvfb and ivtv were apparently more tightly coupled.  The itv pointer
was originally read from an array in ivtv that could have entries set to
NULL.  That array is long gone.



2. Note that the ivtvfb driver is not automatically loaded nor unloaded
by the kernel ivtv driver.  Something from userspace will reqeust the
load and unload of the module.

There are windows of time where a struct device * will exist for a card
in the ivtv driver, but a struct v4l2_device * may not: the end of
ivtv_remove() and the beginning of ivtv_probe().

I was contemplating a case where user space requested unloading both the
ivtvfb and the ivtv driver.  Given all the I2C devices these cards can
have, I thought v4l2_device_unregister() at the end of ivtv_remove()
could present a window of time large enough to worry about a race.
v4l2_device_unregister() sets the struct device  drvdata pointer to
NULL, and then begins unregistering the i2c clients.  I haven't profiled
the process to know how long it typically takes, though.

I also don't know if kernel mechanisms will absolutely prevent
initiating the unload of ivtv.ko before the unload of ivtvfb.ko is
completely finished.  Will they?

$ modinfo ivtvfb | grep -E '(depend)|(alias)'
depends:        ivtv

$ modinfo ivtv | grep -E '(depend)|(alias)'
alias:          pci:v00004444d00000016sv*sd*bc*sc*i*
alias:          pci:v00004444d00000803sv*sd*bc*sc*i*
depends:        cx2341x,videodev,tveeprom,v4l2-common,i2c-core,i2c-algo-bit

Regards,
Andy

