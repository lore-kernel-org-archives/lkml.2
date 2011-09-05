Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab1IEIj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 04:39:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12862 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1IEIjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 04:39:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=yAJ2L9h2baQOgFwsrXRIe4lJV5DfGaLhUyJbuMqIJk/Mr4T5UlAOPuDgedTYONAaJ
	lelgSH8rZHOORZqEj/1RA==
MIME-Version: 1.0
In-Reply-To: <874o0rqxbq.fsf@emc.com.tw>
References: <1315189007-2179-1-git-send-email-jj_ding@emc.com.tw>
 <1315189007-2179-8-git-send-email-jj_ding@emc.com.tw> <CAGS+omCTDb-y7Gut=KgU5wz70R9=75gkmruYpOOS5JUECOK_UA@mail.gmail.com>
 <874o0rqxbq.fsf@emc.com.tw>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 5 Sep 2011 16:39:28 +0800
X-Google-Sender-Auth: -jaDWQ_FUFmsbNBiLIxgsdOicyU
Message-ID: <CAGS+omBeU1XczFgp23c+cPKAHn5EqOp1AbxYXuJQ55TKYGO7Fw@mail.gmail.com>
Subject: Re: [PATCH v5 7/8] Input: elantech - add v3 hardware support
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JJ,

On Mon, Sep 5, 2011 at 3:10 PM, JJ Ding <jj_ding@emc.com.tw> wrote:
> Hi Daniel,
>
> On Mon, 5 Sep 2011 12:35:28 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
>> Hi JJ,
>>
>> On Mon, Sep 5, 2011 at 10:16 AM, JJ Ding <jj_ding@emc.com.tw> wrote:
>> > diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
>> > index 2ae7c49..c4ceefd 100644
>> > --- a/drivers/input/mouse/elantech.c
>> > +++ b/drivers/input/mouse/elantech.c
>> > @@ -108,6 +108,16 @@ static int elantech_read_reg(struct psmouse *psmouse, unsigned char reg,
>> >                        rc = -1;
>> >                }
>> >                break;
>> > +
>> > +       case 3:
>> > +               if (elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
>> > +                   elantech_ps2_command(psmouse, NULL, ETP_REGISTER_READWRITE) ||
>> > +                   elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
>> > +                   elantech_ps2_command(psmouse, NULL, reg) ||
>> > +                   elantech_ps2_command(psmouse, param, PSMOUSE_CMD_GETINFO)) {
>> > +                       rc = -1;
>> > +               }
>> > +               break;
>> >        }
>> >
>> >        if (rc)
>> > @@ -154,6 +164,18 @@ static int elantech_write_reg(struct psmouse *psmouse, unsigned char reg,
>> >                        rc = -1;
>> >                }
>> >                break;
>> > +
>> > +       case 3:
>> > +               if (elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
>> > +                   elantech_ps2_command(psmouse, NULL, ETP_REGISTER_READWRITE) ||
>> > +                   elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
>> > +                   elantech_ps2_command(psmouse, NULL, reg) ||
>> > +                   elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
>> > +                   elantech_ps2_command(psmouse, NULL, val) ||
>> > +                   elantech_ps2_command(psmouse, NULL, PSMOUSE_CMD_SETSCALE11)) {
>> > +                       rc = -1;
>> > +               }
>> > +               break;
>> >        }
>> >
>> >        if (rc)
>> > @@ -350,6 +372,84 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
>> >        input_sync(dev);
>> >  }
>> >
>> > +/*
>> > + * Interpret complete data packets and report absolute mode input events for
>> > + * hardware version 3. (12 byte packets for two fingers)
>> > + */
>> > +static void elantech_report_absolute_v3(struct psmouse *psmouse,
>> > +                                       int packet_type)
>> > +{
>> > +       struct input_dev *dev = psmouse->dev;
>> > +       struct elantech_data *etd = psmouse->private;
>> > +       unsigned char *packet = psmouse->packet;
>> > +       unsigned int fingers = 0, x1 = 0, y1 = 0, x2 = 0, y2 = 0;
>> > +       unsigned int width = 0, pres = 0;
>> > +
>> > +       /* byte 0: n1  n0   .   .   .   .   R   L */
>> > +       fingers = (packet[0] & 0xc0) >> 6;
>> > +
>> > +       switch (fingers) {
>> > +       case 3:
>> > +       case 1:
>> > +               /*
>> > +                * byte 1:  .   .   .   .  x11 x10 x9  x8
>> > +                * byte 2: x7  x6  x5  x4  x4  x2  x1  x0
>> > +                */
>> > +               x1 = ((packet[1] & 0x0f) << 8) | packet[2];
>> > +               /*
>> > +                * byte 4:  .   .   .   .  y11 y10 y9  y8
>> > +                * byte 5: y7  y6  y5  y4  y3  y2  y1  y0
>> > +                */
>> > +               y1 = etd->y_max - (((packet[4] & 0x0f) << 8) | packet[5]);
>> > +               break;
>> > +
>> > +       case 2:
>> > +               if (packet_type == PACKET_V3_HEAD) {
>> > +                       /*
>> > +                        * byte 1:   .    .    .    .  ax11 ax10 ax9  ax8
>> > +                        * byte 2: ax7  ax6  ax5  ax4  ax3  ax2  ax1  ax0
>> > +                        */
>> > +                       etd->prev_x = ((packet[1] & 0x0f) << 8) | packet[2];
>> > +                       /*
>> > +                        * byte 4:   .    .    .    .  ay11 ay10 ay9  ay8
>> > +                        * byte 5: ay7  ay6  ay5  ay4  ay3  ay2  ay1  ay0
>> > +                        */
>> > +                       etd->prev_y = etd->y_max -
>> > +                               (((packet[4] & 0x0f) << 8) | packet[5]);
>> > +                       /*
>> > +                        * wait for next packet
>> > +                        */
>> > +                       return;
>> > +               }
>> > +
>> > +               /* packet_type == PACKET_V3_TAIL */
>> > +               x1 = etd->prev_x;
>> > +               y1 = etd->prev_y;
>> > +               x2 = ((packet[1] & 0x0f) << 8) | packet[2];
>> > +               y2 = etd->y_max - (((packet[4] & 0x0f) << 8) | packet[5]);
>> > +               break;
>> > +       }
>> > +
>> > +       pres = (packet[1] & 0xf0) | ((packet[4] & 0xf0) >> 4);
>> > +       width = ((packet[0] & 0x30) >> 2) | ((packet[3] & 0x30) >> 4);
>> > +
>> > +       input_report_key(dev, BTN_TOUCH, fingers != 0);
>> > +       if (fingers != 0) {
>> > +               input_report_abs(dev, ABS_X, x1);
>> > +               input_report_abs(dev, ABS_Y, y1);
>> > +       }
>> > +       elantech_report_semi_mt_data(dev, fingers, x1, y1, x2, y2);
>>
>> Originally, v3 was using semi-mt, which reported corner coordinates of
>> a box containing at least two of the N touches on the touchpad.  I
>> thought this was due to hardware limitation.
>>
>> If the hardware really can report true positions for (up to) 3
>> contacts, then using pure MT-B is a good approach.  This driver still
>> seems to mix semi-mt and MT-B together a bit.
>>
>> Can you report all three contacts in their own slots, 0, 1 and 2,
>> instead of just reoprting two of them with 0,1?
>>
>> Also, when reporting the 'legacy single touch' coordinate (ABS_X,
>> ABS_Y), please use:
>> input_mt_report_pointer_emulation(), instead of always reporting the
>> last (x1,y1).  Otherwise the single touch point will bounce back and
>> forth between 1st and 3rd touch.
>
> v3 can only track the true positions of two fingers. With 3 finger
> touch, it reports the lowest value of x and the biggest value of y,
> among the three fingers. v3 changed the protocol so it could report
> 2-finger touch data w/o reduced resolution and improved the hardware to
> truly track 2 fingers independently, otherwise it's pretty much the same
> as v2.


If I read this code correctly, it looks like in the 3-finger case,
(x1,y1) as reported in the (ABS_X, ABS_Y), and in the call to
elantech_report_semi_mt_data() will bounce back and forth between the
1st finger and 3rd finger ("lowest value of x and the biggest value of
y").  Won't this be very confusing for userspace (i.e.
xf86-input=synaptics)?

In fact, I'm not sure how "lowest value of x and the biggest value of
y" can be reported to userspace in a useful way at the same time as
two absolute finger positions.

Perhaps just report up to 2 MT-B slots, for the first two fingers, and
only report "3 fingers on the pad" with BTN_TOOL_TRIPLETAP  (see the
recent "synaptics image sensor" patchset for a similar
implementation):
https://patchwork.kernel.org/patch/1076142/

Thanks,
-Dan

>
>> > +       input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
>> > +       input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
>> > +       input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
>>
>> Use input_mt_report_pointer_emulation() with use_count = true.   This
>> will also report ABS_PRESURE (but not ABS_TOOL_WIDTH, unfortunately).
>>
>> > +       input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
>> > +       input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
>> > +       input_report_abs(dev, ABS_PRESSURE, pres);
>> > +       input_report_abs(dev, ABS_TOOL_WIDTH, width);
>> > +
>> > +       input_sync(dev);
>> > +}
>> > +
>> >  static int elantech_packet_check_v1(struct psmouse *psmouse)
>> >  {
>> >        struct elantech_data *etd = psmouse->private;
>> > @@ -403,11 +503,37 @@ static int elantech_packet_check_v2(struct psmouse *psmouse)
>> >  }
>> >
>> >  /*
>> > + * We check the constant bits to determine what packet type we get,
>> > + * so packet checking is mandatory for v3 hardware.
>> > + */
>> > +static int elantech_packet_check_v3(struct psmouse *psmouse)
>> > +{
>> > +       const u8 debounce_packet[] = { 0xc4, 0xff, 0xff, 0x02, 0xff, 0xff };
>> > +       unsigned char *packet = psmouse->packet;
>> > +
>> > +       /*
>> > +        * check debounce first, it has the same signature in byte 0
>> > +        * and byte 3 as PACKET_V3_HEAD.
>> > +        */
>> > +       if (!memcmp(packet, debounce_packet, sizeof(debounce_packet)))
>> > +               return PACKET_DEBOUNCE;
>> > +
>> > +       if ((packet[0] & 0x0c) == 0x04 && (packet[3] & 0xcf) == 0x02)
>> > +               return PACKET_V3_HEAD;
>> > +
>> > +       if ((packet[0] & 0x0c) == 0x0c && (packet[3] & 0xce) == 0x0c)
>> > +               return PACKET_V3_TAIL;
>> > +
>> > +       return PACKET_UNKNOWN;
>> > +}
>> > +
>> > +/*
>> >  * Process byte stream from mouse and handle complete packets
>> >  */
>> >  static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
>> >  {
>> >        struct elantech_data *etd = psmouse->private;
>> > +       int packet_type;
>> >
>> >        if (psmouse->pktcnt < psmouse->pktsize)
>> >                return PSMOUSE_GOOD_DATA;
>> > @@ -429,6 +555,18 @@ static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
>> >
>> >                elantech_report_absolute_v2(psmouse);
>> >                break;
>> > +
>> > +       case 3:
>> > +               packet_type = elantech_packet_check_v3(psmouse);
>> > +               /* ignore debounce */
>> > +               if (packet_type == PACKET_DEBOUNCE)
>> > +                       return PSMOUSE_FULL_PACKET;
>> > +
>> > +               if (packet_type == PACKET_UNKNOWN)
>> > +                       return PSMOUSE_BAD_DATA;
>> > +
>> > +               elantech_report_absolute_v3(psmouse, packet_type);
>> > +               break;
>> >        }
>> >
>> >        return PSMOUSE_FULL_PACKET;
>> > @@ -463,8 +601,15 @@ static int elantech_set_absolute_mode(struct psmouse *psmouse)
>> >                    elantech_write_reg(psmouse, 0x11, etd->reg_11) ||
>> >                    elantech_write_reg(psmouse, 0x21, etd->reg_21)) {
>> >                        rc = -1;
>> > -                       break;
>> >                }
>> > +               break;
>> > +
>> > +       case 3:
>> > +               etd->reg_10 = 0x0b;
>> > +               if (elantech_write_reg(psmouse, 0x10, etd->reg_10))
>> > +                       rc = -1;
>> > +
>> > +               break;
>> >        }
>> >
>> >        if (rc == 0) {
>> > @@ -498,11 +643,12 @@ static int elantech_set_absolute_mode(struct psmouse *psmouse)
>> >        return rc;
>> >  }
>> >
>> > -static void set_range(struct psmouse *psmouse, unsigned int *x_min,
>> > +static int set_range(struct psmouse *psmouse, unsigned int *x_min,
>> >                     unsigned int *y_min, unsigned int *x_max,
>> >                     unsigned int *y_max)
>> >  {
>> >        struct elantech_data *etd = psmouse->private;
>> > +       unsigned char param[3];
>> >        int i;
>> >
>> >        switch (etd->hw_version) {
>> > @@ -530,19 +676,30 @@ static void set_range(struct psmouse *psmouse, unsigned int *x_min,
>> >                        *y_max = (etd->capabilities[2] - i) * 64;
>> >                }
>> >                break;
>> > +
>> > +       case 3:
>> > +               if (synaptics_send_cmd(psmouse, ETP_FW_ID_QUERY, param))
>> > +                       return -1;
>> > +
>> > +               *x_max = (0x0f & param[0]) << 8 | param[1];
>> > +               *y_max = (0xf0 & param[0]) << 4 | param[2];
>> > +               break;
>> >        }
>> > +
>> > +       return 0;
>> >  }
>> >
>> >  /*
>> >  * Set the appropriate event bits for the input subsystem
>> >  */
>> > -static void elantech_set_input_params(struct psmouse *psmouse)
>> > +static int elantech_set_input_params(struct psmouse *psmouse)
>> >  {
>> >        struct input_dev *dev = psmouse->dev;
>> >        struct elantech_data *etd = psmouse->private;
>> >        unsigned int x_min = 0, y_min = 0, x_max = 0, y_max = 0;
>> >
>> > -       set_range(psmouse, &x_min, &y_min, &x_max, &y_max);
>> > +       if (set_range(psmouse, &x_min, &y_min, &x_max, &y_max))
>> > +               return -1;
>> >
>> >        __set_bit(EV_KEY, dev->evbit);
>> >        __set_bit(EV_ABS, dev->evbit);
>> > @@ -570,6 +727,9 @@ static void elantech_set_input_params(struct psmouse *psmouse)
>> >
>> >        case 2:
>> >                __set_bit(BTN_TOOL_QUADTAP, dev->keybit);
>> > +               __set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
>> > +               /* fall through */
>> > +       case 3:
>> >                input_set_abs_params(dev, ABS_X, x_min, x_max, 0, 0);
>> >                input_set_abs_params(dev, ABS_Y, y_min, y_max, 0, 0);
>> >                if (etd->reports_pressure) {
>> > @@ -578,7 +738,6 @@ static void elantech_set_input_params(struct psmouse *psmouse)
>> >                        input_set_abs_params(dev, ABS_TOOL_WIDTH, ETP_WMIN_V2,
>> >                                             ETP_WMAX_V2, 0, 0);
>> >                }
>> > -               __set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
>> >                input_mt_init_slots(dev, 2);
>>
>> Should this be 3?
>>
>> >                input_set_abs_params(dev, ABS_MT_POSITION_X, x_min, x_max, 0, 0);
>> >                input_set_abs_params(dev, ABS_MT_POSITION_Y, y_min, y_max, 0, 0);
>> > @@ -586,6 +745,8 @@ static void elantech_set_input_params(struct psmouse *psmouse)
>> >        }
>> >
>> >        etd->y_max = y_max;
>> > +
>> > +       return 0;
>> >  }
>> >
>> >  struct elantech_attr_data {
>> > @@ -727,7 +888,8 @@ int elantech_detect(struct psmouse *psmouse, bool set_properties)
>> >         * Report this in case there are Elantech models that use a different
>> >         * set of magic numbers
>> >         */
>> > -       if (param[0] != 0x3c || param[1] != 0x03 || param[2] != 0xc8) {
>> > +       if (param[0] != 0x3c || param[1] != 0x03 ||
>> > +           (param[2] != 0xc8 && param[2] != 0x00)) {
>> >                pr_debug("unexpected magic knock result 0x%02x, 0x%02x, 0x%02x.\n",
>> >                         param[0], param[1], param[2]);
>> >                return -1;
>> > @@ -793,16 +955,16 @@ static int elantech_reconnect(struct psmouse *psmouse)
>> >  /*
>> >  * determine hardware version and set some properties according to it.
>> >  */
>> > -static void elantech_set_properties(struct elantech_data *etd)
>> > +static int elantech_set_properties(struct elantech_data *etd)
>> >  {
>> > -       /*
>> > -        * Assume every version greater than 0x020030 is new EeePC style
>> > -        * hardware with 6 byte packets, except 0x020600
>> > -        */
>> >        if (etd->fw_version < 0x020030 || etd->fw_version == 0x020600)
>> >                etd->hw_version = 1;
>> > -       else
>> > +       else if (etd->fw_version < 0x150600)
>> >                etd->hw_version = 2;
>> > +       else if ((etd->fw_version & 0x0f0000) >> 16 == 5)
>> > +               etd->hw_version = 3;
>> > +       else
>> > +               return -1;
>> >
>> >        /*
>> >         * Turn on packet checking by default.
>> > @@ -817,13 +979,15 @@ static void elantech_set_properties(struct elantech_data *etd)
>> >        etd->jumpy_cursor =
>> >                (etd->fw_version == 0x020022 || etd->fw_version == 0x020600);
>> >
>> > -       if (etd->hw_version == 2) {
>> > +       if (etd->hw_version > 1) {
>> >                /* For now show extra debug information */
>> >                etd->debug = 1;
>> >
>> >                if (etd->fw_version >= 0x020800)
>> >                        etd->reports_pressure = true;
>> >        }
>> > +
>> > +       return 0;
>> >  }
>> >
>> >  /*
>> > @@ -850,9 +1014,12 @@ int elantech_init(struct psmouse *psmouse)
>> >                pr_err("failed to query firmware version.\n");
>> >                goto init_fail;
>> >        }
>> > -
>> >        etd->fw_version = (param[0] << 16) | (param[1] << 8) | param[2];
>> > -       elantech_set_properties(etd);
>> > +
>> > +       if (elantech_set_properties(etd)) {
>> > +               pr_err("unknown hardware version, aborting...\n");
>> > +               goto init_fail;
>> > +       }
>> >        pr_info("assuming hardware version %d "
>> >                "(with firmware version 0x%02x%02x%02x)\n",
>> >                etd->hw_version, param[0], param[1], param[2]);
>> > @@ -871,7 +1038,10 @@ int elantech_init(struct psmouse *psmouse)
>> >                goto init_fail;
>> >        }
>> >
>> > -       elantech_set_input_params(psmouse);
>> > +       if (elantech_set_input_params(psmouse)) {
>> > +               pr_err("failed to query touchpad range.\n");
>> > +               goto init_fail;
>> > +       }
>> >
>> >        error = sysfs_create_group(&psmouse->ps2dev.serio->dev.kobj,
>> >                                   &elantech_attr_group);
>> > @@ -883,7 +1053,7 @@ int elantech_init(struct psmouse *psmouse)
>> >        psmouse->protocol_handler = elantech_process_byte;
>> >        psmouse->disconnect = elantech_disconnect;
>> >        psmouse->reconnect = elantech_reconnect;
>> > -       psmouse->pktsize = etd->hw_version == 2 ? 6 : 4;
>> > +       psmouse->pktsize = etd->hw_version > 1 ? 6 : 4;
>> >
>> >        return 0;
>> >
>> > diff --git a/drivers/input/mouse/elantech.h b/drivers/input/mouse/elantech.h
>> > index d9e6144..236c33c 100644
>> > --- a/drivers/input/mouse/elantech.h
>> > +++ b/drivers/input/mouse/elantech.h
>> > @@ -16,6 +16,7 @@
>> >  /*
>> >  * Command values for Synaptics style queries
>> >  */
>> > +#define ETP_FW_ID_QUERY                        0x00
>> >  #define ETP_FW_VERSION_QUERY           0x01
>> >  #define ETP_CAPABILITIES_QUERY         0x02
>> >
>> > @@ -24,6 +25,7 @@
>> >  */
>> >  #define ETP_REGISTER_READ              0x10
>> >  #define ETP_REGISTER_WRITE             0x11
>> > +#define ETP_REGISTER_READWRITE         0x00
>> >
>> >  /*
>> >  * Hardware version 2 custom PS/2 command value
>> > @@ -79,6 +81,14 @@
>> >  #define ETP_WMIN_V2                    0
>> >  #define ETP_WMAX_V2                    15
>> >
>> > +/*
>> > + * v3 hardware has 2 kinds of packet types.
>> > + */
>> > +#define PACKET_UNKNOWN                 0x01
>> > +#define PACKET_DEBOUNCE                        0x02
>> > +#define PACKET_V3_HEAD                 0x03
>> > +#define PACKET_V3_TAIL                 0x04
>> > +
>> >  struct elantech_data {
>> >        unsigned char reg_10;
>> >        unsigned char reg_11;
>> > @@ -98,6 +108,8 @@ struct elantech_data {
>> >        unsigned int fw_version;
>> >        unsigned int single_finger_reports;
>> >        unsigned int y_max;
>> > +       unsigned int prev_x;
>> > +       unsigned int prev_y;
>> >        unsigned char parity[256];
>> >  };
>> >
>> > --
>> > 1.7.4.1
>> >
>>
>
