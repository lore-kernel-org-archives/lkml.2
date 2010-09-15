Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0IOOaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:30:25 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58091 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab0IOOaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:30:24 -0400
Date: Wed, 15 Sep 2010 07:29:27 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 7/7] hwmon: (lm90) Add support for max6695 and
 max6696
Message-ID: <20100915142927.GB9707@ericsson.com>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
 <1284038750-8833-8-git-send-email-guenter.roeck@ericsson.com>
 <20100915132029.4c708c7d@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100915132029.4c708c7d@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, Sep 15, 2010 at 07:20:29AM -0400, Jean Delvare wrote:
> Hi Guenter,
> 
> Sorry for the slow review, I am in the process of reinstalling my
> workstation entirely, and this keeps be busy.
> 
No problem. I appreciate your time.

> On Thu, 9 Sep 2010 06:25:50 -0700, Guenter Roeck wrote:
[...]
> > +MAX6695 and MAX6696:
> > +  * Better local resolution
> > +  * Selectable address
> 
> MAX6696 only?
> 
yes

[...]
> >  enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
> > -     w83l771, max6659 };
> > +     w83l771, max6659, max6695 };
> 
> How much time before we mix max6659 and max6695? ;) It might make sense
> to decide to go with max6696 for the latter, to work around this
> potential issue.
> 
ok with me. 

> >
> >  /*
> >   * The LM90 registers
> > @@ -135,9 +140,10 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
> >  #define LM90_REG_R_TCRIT_HYST                0x21
> >  #define LM90_REG_W_TCRIT_HYST                0x21
> >
> > -/* MAX6646/6647/6649/6657/6658/6659 registers */
> > +/* MAX6646/6647/6649/6657/6658/6659/6695/6696 registers */
> >
> >  #define MAX6657_REG_R_LOCAL_TEMPL    0x11
> > +#define MAX6695_REG_R_STATUS2                0x12
> >  #define MAX6659_REG_R_REMOTE_EMERG   0x16
> >  #define MAX6659_REG_W_REMOTE_EMERG   0x16
> >  #define MAX6659_REG_R_LOCAL_EMERG    0x17
> > @@ -152,6 +158,8 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
> >  #define      LM90_HAVE_LOCAL_EXT     0x04    /* extended local temperature   */
> >  #define      LM90_HAVE_REM_LIMIT_EXT 0x08    /* extended remote limit        */
> >  #define      LM90_HAVE_EMERGENCY     0x10    /* 3rd upper (emergency) limit  */
> > +#define      LM90_HAVE_EMERGENCY_ALARM 0x20  /* emergency alarm              */
> > +#define      LM90_HAVE_TEMP3         0x40    /* 3rd temperature sensor       */
> 
> Use one space after #define.
> 
Did that already after the comment in the earlier patch of the series.

> >
> >  /*
> >   * Functions declaration
> > @@ -164,6 +172,10 @@ static void lm90_init_client(struct i2c_client *client);
> >  static void lm90_alert(struct i2c_client *client, unsigned int flag);
> >  static int lm90_remove(struct i2c_client *client);
> >  static struct lm90_data *lm90_update_device(struct device *dev);
> > +static int lm90_read_reg(struct i2c_client *client, u8 reg, u8 *value);
> > +static inline void lm90_select_remote_channel(struct i2c_client *client,
> > +                                           struct lm90_data *data,
> > +                                           int channel);
> 
> Would it be possible to simply place these functions at the right
> location so that forward declarations are not needed? Ideally I would
> like to get rid of all these forward declarations.
> 
I moved lm90_select_remote_channel() so the lm90_read_reg() declaration
is no longer needed.

Code structure is such that sensor show/set functions come first, followed by
"real" code. Unfortunately, that implies that local functions called from
those functions have to be forward declarated.

We can move that around to avoid forward declarations, but I would prefer
to do that in a separate patch if we decide to go that way.

[...]
> > +/*
> > + * Additional attributes for devices with 3 temperature sensors
> > + */
> > +static SENSOR_DEVICE_ATTR_2(temp3_input, S_IRUGO, show_temp11, NULL, 0, 5);
> > +static SENSOR_DEVICE_ATTR_2(temp3_min, S_IWUSR | S_IRUGO, show_temp11,
> > +     set_temp11, 3, 6);
> > +static SENSOR_DEVICE_ATTR_2(temp3_max, S_IWUSR | S_IRUGO, show_temp11,
> > +     set_temp11, 4, 7);
> > +static SENSOR_DEVICE_ATTR(temp3_crit, S_IWUSR | S_IRUGO, show_temp8,
> > +     set_temp8, 6);
> > +static SENSOR_DEVICE_ATTR(temp3_crit_hyst, S_IRUGO, show_temphyst, NULL, 4);
> 
> 4, really? Remote 2 critical limit is 6.
> 
I am impressed. Good catch.

> (That's what we get for using bare numbers instead of defining proper
> symbols, sigh.)
> 
> Also it seems that the hysteresis register applies to both critical and
> emergency limits, so it would probably make sense to create (read-only)
> temp[1-3]_emergency_hyst attributes.
> 
Makes sense. That will be in patch #6 (previously patch #5), though,
with additional code here, and yet another attribute in the ABI.

[...]
> 
> Please document the fact that the following function must be called
> with data->update_lock held.
> 
Done.

[...]

> 
> Code looks overall pretty clean. Great job!
> 
Thanks!

Guenter
