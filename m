Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0JKRqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:46:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35622 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab0JKRql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <s5h7hho3bau.wl%tiwai@suse.de>
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
	<1286549880-32580-2-git-send-email-chase.douglas@canonical.com>
	<1286549880-32580-3-git-send-email-chase.douglas@canonical.com>
	<1286549880-32580-4-git-send-email-chase.douglas@canonical.com>
	<AANLkTi=QA5zgn=u39RyordViWw1CgpK9gy8kE_MdrpN3@mail.gmail.com>
	<s5h7hho3bau.wl%tiwai@suse.de>
Date: Mon, 11 Oct 2010 12:46:40 -0500
Message-ID: <AANLkTi=G3xYm5+Wqv0quGGUhDEd7x8r7WJhN-tb6G=TA@mail.gmail.com>
Subject: Re: [PATCH 3/3] Input: synaptics - remove touches over button click area
From: Chris Bagwell <chris@cnpbagwell.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chase Douglas <chase.douglas@canonical.com>, linux-input@vger.kernel.org,
        xorg-devel@lists.x.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 12:10 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 11 Oct 2010 11:24:04 -0500,
> Chris Bagwell wrote:
>>
>> On Fri, Oct 8, 2010 at 9:58 AM, Chase Douglas
>> <chase.douglas@canonical.com> wrote:
>> > Now that we have proper multitouch support, we can handle integrated
>> > buttons better. If we know the top of the buttons on the touchpad, we
>> > can ignore any touches that occur within the touchpad area while a
>> > button is clicked. It may be possible to get the button area by querying
>> > the device, but for now allow the user to manually set it.
>> >
>> > A note on why this works: the Synaptics touchpads have pseudo touch
>> > tracking. When two touches are on the touchpad, an MT touch packet with
>> > just the X, Y, and pressure values is sent before a normal Synaptics
>> > touch packet. When one touch is obviously in motion and the other is
>> > stationary, the touchpad controller sends the touch in motion in the
>> > normal packet and the stationary touch in the MT packet. Single touch
>> > emulation is provided by the normal packet, so an action like clicking
>> > a button and dragging with another finger still works as expected.
>> >
>> > Tested on a Dell Mini 1012 with synaptics_multitouch=1 and
>> > synaptics_button_thresh=4100.
>> >
>> > Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>> > ---
>> >  drivers/input/mouse/synaptics.c |   16 +++++++++++++++-
>> >  1 files changed, 15 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
>> > index 7289d88..e67778d 100644
>> > --- a/drivers/input/mouse/synaptics.c
>> > +++ b/drivers/input/mouse/synaptics.c
>> > @@ -49,6 +49,12 @@ module_param(synaptics_multitouch, bool, 0644);
>> >  MODULE_PARM_DESC(synaptics_multitouch,
>> >                 "Enable multitouch mode on Synaptics devices");
>> >
>> > +static int synaptics_button_thresh = YMIN_NOMINAL + YMAX_NOMINAL;
>> > +module_param(synaptics_button_thresh, int, 0644);
>> > +MODULE_PARM_DESC(synaptics_button_thres,
>> > +                "Y coordinate threshold of integrated buttons on Synaptics "
>> > +                "devices");
>> > +
>> >  /*****************************************************************************
>> >  *     Stuff we need even when we do not want native Synaptics support
>> >  ****************************************************************************/
>> > @@ -463,6 +469,10 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
>> >        }
>> >  }
>> >
>> > +#define TOUCH_OVER_BUTTON(hw) (((hw).left || (hw).middle || (hw).right) && \
>> > +                              (YMAX_NOMINAL + YMIN_NOMINAL - (hw).y > \
>> > +                               synaptics_button_thresh))
>> > +
>> >  /*
>> >  *  called for each full received packet from the touchpad
>> >  */
>> > @@ -477,7 +487,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>> >        synaptics_parse_hw_state(psmouse->packet, priv, &hw);
>> >
>> >        if (SYN_MULTITOUCH(priv, &hw)) {
>> > -               if (hw.z > 0) {
>> > +               if (hw.z > 0 && !TOUCH_OVER_BUTTON(hw)) {
>> >                        input_report_abs(dev, ABS_MT_POSITION_X, hw.x);
>> >                        input_report_abs(dev, ABS_MT_POSITION_Y,
>> >                                         YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
>> > @@ -509,6 +519,10 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>> >                return;
>> >        }
>> >
>> > +       /* If touch occurs over depressed button, ignore it */
>> > +       if (TOUCH_OVER_BUTTON(hw))
>> > +               hw.z = 0;
>> > +
>> >        if (hw.z > 0) {
>> >                priv->num_fingers++;
>> >                finger_width = 5;
>> > --
>> > 1.7.1
>> >
>> >
>>
>> I'm convinced now that clickpad style touchpads can't work without
>> multi-touch and something like logic in xf86-input-multitouch.
>
> Actually Clickpad works without multi-touch patch.  With my patches to
> synaptics, it worked in some level.  There are many restrictions (e.g.
> pushing the button first then drag), though.
>

True, but if I understand synaptic hardware MT behavior (sends
actively moving finger in higher resolution packet regardless of
original finger touch) then your patch will result in jumpy cursor on
X side and that side would need patches to attempt to guess invalid
data and discard.  I've worked on a few similar patches to various
xf86-input-* and generally they've failed to detect difference between
invalid packets vs. fast user movements.

The main point of my 3 options was to address jumpy cursor in
xf86-input-* that are not MT aware.  I think ABS_X/ABS_Y should only
allow its meaning to change at detectable time periods so user can
account for it and, specifically, that time period is best at
transition of BTN_TOOL_DOUBLETAP.

Assuming its easy enough to support exact rules for ABS_X/ABS_Y
changing meanings on kernel side (which I think it probably is pretty
easy), I think we should do it so that applications don't have to
become MT-aware as the official solution for jumpy cursors.

Chris
