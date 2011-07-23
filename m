Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab1GWELs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 00:11:48 -0400
Received: from smtp-out.google.com ([74.125.121.67]:27476 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1GWELl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 00:11:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=VH13jY/WX4cPt2StxU5GApHzsLdYohhlFyxlJeUUd3pWxCuvZCsiu4sdn+GLf5+iM
	mJraPzgNE1lKm01AQQxcw==
MIME-Version: 1.0
In-Reply-To: <4E2A1D9A.2090704@canonical.com>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
 <1311169146-20066-10-git-send-email-djkurtz@chromium.org> <4E2A1D9A.2090704@canonical.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Sat, 23 Jul 2011 12:11:18 +0800
X-Google-Sender-Auth: QODpR3sqChI4ljQTqAdLWKkiAI0
Message-ID: <CAGS+omABdrRjZ0nsajAB3WRj2WASUYKMfAaPeaOWuhUfLUFMeQ@mail.gmail.com>
Subject: Re: [PATCH 9/9 v2] Input: synaptics - process finger (<=5) transitions
To: Chase Douglas <chase.douglas@canonical.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

Thanks for all of your reviews!

On Sat, Jul 23, 2011 at 9:02 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
>
> On 07/20/2011 06:39 AM, djkurtz@chromium.org wrote:
> > From: Daniel Kurtz <djkurtz@chromium.org>
> >
> > Synaptics image sensor touchpads track up to 5 fingers, but only report 2.
> > They use a special "TYPE=2" (AGM-CONTACT) packet type that reports
> > the number of tracked fingers and which finger is reported in the SGM
> > and AGM packets.
> >
> > With this new packet type, it is possible to tell userspace when 4 or 5
> > fingers are touching.
>
> Maybe I'm blind, but I don't see where the QUADTAP and QUINTAP values
> are set in the events. I see where the bits are set during
> initialization, but not during use.

It's subtle.
The firmware actually report 4/5 in the AGM-CONTACT packet, which the
agm packet parser sets directly in mt_state->count.
This is then reported to userspace when synaptics_report_mt() calls
input_mt_report_finger_count(dev, mt_state->count), which now supports
QUINTTAP (see patch #8).

-Daniel

>
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > ---
> >  drivers/input/mouse/synaptics.c |   44 ++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 43 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> > index 893e567..2a1e05f 100644
> > --- a/drivers/input/mouse/synaptics.c
> > +++ b/drivers/input/mouse/synaptics.c
> > @@ -729,6 +729,10 @@ static void synaptics_image_sensor_1f(struct synaptics_data *priv,
> >               synaptics_mt_state_set(mt_state, 0, -1, -1);
> >               priv->mt_state_lost = true;
> >               break;
> > +     case 4:
> > +     case 5:
> > +             /* mt_state was updated by AGM-CONTACT packet */
> > +             break;
> >       }
> >  }
> >
> > @@ -775,6 +779,10 @@ static void synaptics_image_sensor_2f(struct synaptics_data *priv,
> >               synaptics_mt_state_set(mt_state, 0, -1, -1);
> >               priv->mt_state_lost = true;
> >               break;
> > +     case 4:
> > +     case 5:
> > +             /* mt_state was updated by AGM-CONTACT packet */
> > +             break;
> >       }
> >  }
> >
> > @@ -803,6 +811,22 @@ static void synaptics_image_sensor_3f(struct synaptics_data *priv,
> >               break;
> >       case 2:
> >               /*
> > +              * If the AGM previously contained slot 3 or higher, then the
> > +              * newly touching finger is in the lowest available slot.
> > +              *
> > +              * If SGM was previously 1 or higher, then the new SGM is
> > +              * now slot 0 (with a new finger), otherwise, the new finger
> > +              * is now in a hidden slot between 0 and AGM's slot.
> > +              *
> > +              * In all such cases, the SGM now contains slot 0, and the AGM
> > +              * continues to contain the same slot as before.
> > +              */
> > +             if (old->agm >= 3) {
> > +                     synaptics_mt_state_set(mt_state, 3, 0, old->agm);
> > +                     break;
> > +             }
> > +
> > +             /*
> >                * After some 3->1 and all 3->2 transitions, we lose track
> >                * of which slot is reported by sgm and agm.
> >                *
> > @@ -836,9 +860,22 @@ static void synaptics_image_sensor_3f(struct synaptics_data *priv,
> >                * received AGM-CONTACT packet.
> >                */
> >               break;
> > +
> > +     case 4:
> > +     case 5:
> > +             /* mt_state was updated by AGM-CONTACT packet */
> > +             break;
> >       }
> >  }
> >
> > +/* Handle case where mt_state->count = 4, or = 5 */
> > +static void synaptics_image_sensor_45f(struct synaptics_data *priv,
> > +                                    struct synaptics_mt_state *mt_state)
> > +{
> > +     /* mt_state was updated correctly by AGM-CONTACT packet */
> > +     priv->mt_state_lost = false;
> > +}
> > +
> >  static void synaptics_image_sensor_process(struct psmouse *psmouse,
> >                                          struct synaptics_hw_state *sgm)
> >  {
> > @@ -858,8 +895,10 @@ static void synaptics_image_sensor_process(struct psmouse *psmouse,
> >               synaptics_image_sensor_1f(priv, &mt_state);
> >       else if (sgm->w == 0)
> >               synaptics_image_sensor_2f(priv, &mt_state);
> > -     else if (sgm->w == 1)
> > +     else if (sgm->w == 1 && mt_state.count <= 3)
> >               synaptics_image_sensor_3f(priv, &mt_state);
> > +     else
> > +             synaptics_image_sensor_45f(priv, &mt_state);
> >
> >       /* Send resulting input events to user space */
> >       synaptics_report_mt(psmouse, &mt_state, sgm);
> > @@ -1078,6 +1117,9 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
> >               input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
> >               /* Image sensors can sometimes report per-contact width */
> >               input_set_abs_params(dev, ABS_MT_TOUCH_MAJOR, 4, 15, 0, 0);
> > +             /* Image sensors can signal 4 and 5 finger clicks */
> > +             __set_bit(BTN_TOOL_QUADTAP, dev->keybit);
> > +             __set_bit(BTN_TOOL_QUINTTAP, dev->keybit);
> >       } else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
> >               /* Non-image sensors with AGM use semi-mt */
> >               __set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
>
