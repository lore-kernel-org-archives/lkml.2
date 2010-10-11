Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0JKRa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:30:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35532 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab0JKRa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:30:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BpL5chh+xIpsFcBvZ4gwVYdxROORjPC5UdPDIJ/rbMIRgFooJRPsY0dViZkwr00rkV
         M19sbvBBwSwWshLEemaaM2wcmQIr1KoVmEy9+tZqxg2VHMx7kwnciu/mFr7Z1UjVwk66
         U5CRAM+94SeH1DIJEYc1UhVbAI18fZySN5GGg=
Date: Mon, 11 Oct 2010 10:30:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, xorg-devel@lists.x.org,
        Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: Re: [PATCH 3/3] Input: synaptics - remove touches over button click
 area
Message-ID: <20101011173015.GB27304@core.coreip.homeip.net>
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
 <1286549880-32580-2-git-send-email-chase.douglas@canonical.com>
 <1286549880-32580-3-git-send-email-chase.douglas@canonical.com>
 <1286549880-32580-4-git-send-email-chase.douglas@canonical.com>
 <AANLkTi=QA5zgn=u39RyordViWw1CgpK9gy8kE_MdrpN3@mail.gmail.com>
 <s5h7hho3bau.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5h7hho3bau.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 07:10:33PM +0200, Takashi Iwai wrote:
> At Mon, 11 Oct 2010 11:24:04 -0500,
> Chris Bagwell wrote:
> > 
> > On Fri, Oct 8, 2010 at 9:58 AM, Chase Douglas
> > <chase.douglas@canonical.com> wrote:
> > > Now that we have proper multitouch support, we can handle integrated
> > > buttons better. If we know the top of the buttons on the touchpad, we
> > > can ignore any touches that occur within the touchpad area while a
> > > button is clicked. It may be possible to get the button area by querying
> > > the device, but for now allow the user to manually set it.
> > >
> > > A note on why this works: the Synaptics touchpads have pseudo touch
> > > tracking. When two touches are on the touchpad, an MT touch packet with
> > > just the X, Y, and pressure values is sent before a normal Synaptics
> > > touch packet. When one touch is obviously in motion and the other is
> > > stationary, the touchpad controller sends the touch in motion in the
> > > normal packet and the stationary touch in the MT packet. Single touch
> > > emulation is provided by the normal packet, so an action like clicking
> > > a button and dragging with another finger still works as expected.
> > >
> > > Tested on a Dell Mini 1012 with synaptics_multitouch=1 and
> > > synaptics_button_thresh=4100.
> > >
> > > Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> > > ---
> > >  drivers/input/mouse/synaptics.c |   16 +++++++++++++++-
> > >  1 files changed, 15 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> > > index 7289d88..e67778d 100644
> > > --- a/drivers/input/mouse/synaptics.c
> > > +++ b/drivers/input/mouse/synaptics.c
> > > @@ -49,6 +49,12 @@ module_param(synaptics_multitouch, bool, 0644);
> > >  MODULE_PARM_DESC(synaptics_multitouch,
> > >                 "Enable multitouch mode on Synaptics devices");
> > >
> > > +static int synaptics_button_thresh = YMIN_NOMINAL + YMAX_NOMINAL;
> > > +module_param(synaptics_button_thresh, int, 0644);
> > > +MODULE_PARM_DESC(synaptics_button_thres,
> > > +                "Y coordinate threshold of integrated buttons on Synaptics "
> > > +                "devices");
> > > +
> > >  /*****************************************************************************
> > >  *     Stuff we need even when we do not want native Synaptics support
> > >  ****************************************************************************/
> > > @@ -463,6 +469,10 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
> > >        }
> > >  }
> > >
> > > +#define TOUCH_OVER_BUTTON(hw) (((hw).left || (hw).middle || (hw).right) && \
> > > +                              (YMAX_NOMINAL + YMIN_NOMINAL - (hw).y > \
> > > +                               synaptics_button_thresh))
> > > +
> > >  /*
> > >  *  called for each full received packet from the touchpad
> > >  */
> > > @@ -477,7 +487,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
> > >        synaptics_parse_hw_state(psmouse->packet, priv, &hw);
> > >
> > >        if (SYN_MULTITOUCH(priv, &hw)) {
> > > -               if (hw.z > 0) {
> > > +               if (hw.z > 0 && !TOUCH_OVER_BUTTON(hw)) {
> > >                        input_report_abs(dev, ABS_MT_POSITION_X, hw.x);
> > >                        input_report_abs(dev, ABS_MT_POSITION_Y,
> > >                                         YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
> > > @@ -509,6 +519,10 @@ static void synaptics_process_packet(struct psmouse *psmouse)
> > >                return;
> > >        }
> > >
> > > +       /* If touch occurs over depressed button, ignore it */
> > > +       if (TOUCH_OVER_BUTTON(hw))
> > > +               hw.z = 0;
> > > +
> > >        if (hw.z > 0) {
> > >                priv->num_fingers++;
> > >                finger_width = 5;
> > > --
> > > 1.7.1
> > >
> > >
> > 
> > I'm convinced now that clickpad style touchpads can't work without
> > multi-touch and something like logic in xf86-input-multitouch.
> 
> Actually Clickpad works without multi-touch patch.  With my patches to
> synaptics, it worked in some level.  There are many restrictions (e.g.
> pushing the button first then drag), though.
> 

I am OK with devices not working perfectly with default/existing
drivers, but we should allow enough functionality (movement, primary
- left - click and so on) so that user can go through install and/or
upgrade of  userpsace component.

This also mean that we need to have userspace component available before
changing the behavior that will cause adverse effect for older setups.
Of course if we could avoid degrading older setups that would be even
better.

-- 
Dmitry
