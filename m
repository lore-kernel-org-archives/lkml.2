Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab0IGHop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 03:44:45 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:32953 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab0IGHoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 03:44:39 -0400
Date: Tue, 7 Sep 2010 09:43:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: Add support for max6695 and max6696 to lm90 
 driver
Message-ID: <20100907094355.418a94b1@hyperion.delvare>
In-Reply-To: <20100907020053.GB5332@ericsson.com>
References: <1283639675-31714-1-git-send-email-guenter.roeck@ericsson.com>
	<20100906181229.2e25db07@hyperion.delvare>
	<20100907020053.GB5332@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guten Morgen Guenter,

On Mon, 6 Sep 2010 19:00:53 -0700, Guenter Roeck wrote:
> On Mon, Sep 06, 2010 at 12:12:29PM -0400, Jean Delvare wrote:
> > On Sat, 4 Sep 2010 15:34:35 -0700, Guenter Roeck wrote:
> > > @@ -450,6 +505,8 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
> > >       int nr = attr->index;
> > >       long val;
> > >       int err;
> > > +     int offset = 1;
> > > +     u8 config;
> > >
> > >       err = strict_strtol(buf, 10, &val);
> > >       if (err < 0)
> > > @@ -462,19 +519,31 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
> > >       mutex_lock(&data->update_lock);
> > >       if (data->kind == adt7461)
> > >               data->temp11[nr] = temp_to_u16_adt7461(data, val);
> > > -     else if (data->kind == max6657 || data->kind == max6680)
> > > -             data->temp11[nr] = temp_to_s8(val) << 8;
> > >       else if (data->kind == max6646)
> > >               data->temp11[nr] = temp_to_u8(val) << 8;
> > > +     else if (!lm90_have_remote_limit_ext(data))
> > > +             data->temp11[nr] = temp_to_s8(val) << 8;
> > >       else
> > >               data->temp11[nr] = temp_to_s16(val);
> > >
> > > -     i2c_smbus_write_byte_data(client, reg[(nr - 1) * 2],
> > > +     if (data->kind == max6695 && nr >= 6) {
> > > +             /* select output channel 2 */
> > > +             lm90_read_reg(client, LM90_REG_R_CONFIG1, &config);
> > > +             i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
> > > +                                       config | 0x08);
> > > +             offset = 6;
> > > +     }
> > > +
> > > +     i2c_smbus_write_byte_data(client, reg[(nr - offset) * 2],
> > >                                 data->temp11[nr] >> 8);
> > 
> > This all gets a little tricky... Maybe it is time to rethink the whole
> > thing.
>
> You mean using the offset variable ? I would agree. No idea right now
> how to improve it, though. I'll think about it.

One option would be to switch to SENSOR_ATTR_2 and use the second
parameter as an index into the reg array, which in turn could become a
2-D array (or 1-D array of pair structs). I wasn't a big fan of
SENSOR_ATTR_2 originally because its attribute are small (u8) and
easily confused (index vs. nr) but it has its technical merits. Maybe
someday we'll unify SENSOR_ATTR and SENSOR_ATTR_2 into a single
structure with reasonably sized and named attributes. That will be a
lot of work though.

> > (...)
> > No alarms files for emergency limits?
>
> Actually, there should be. Status register bits are there. No idea why I missed those.
> Oh well, another ABI change. Is tempX_emergency_alarm ok ?

Of course it is.

> > (...)
> > Regardless of the last read register value?
>
> Unfortunately, yes. I thought the read would return man_id, but it doesn't.

It's not that bad. A constant, non-00, non-ff device ID, even
non-documented, has some value.

> > (...)
> > I'm not even sure what you are trying to protect yourself against.
> > Given the code flow, the MAX6657/58/59 have already been handled. Are
> > you aware of other Maxim chips, not handled by the lm90 driver,
> > behaving the same way?
>
> There is still max6680, tested afterwards. I wanted to make sure as good as I can
> that I don't detect max6680 as max6695.

Oh right. Same device ID, of course :(

> Of course, who knows what max6680 returns when reading registers 0x16 / 0x17.

I don't. But I can try obtaining the information for you, stay tuned.

> > (...)
> > As detection is weak, you may also want to check that bit 0 of status2
> > register is 0. Will slow things down a bit but... that's what you get
> > for poorly identifiable chips.
>
> Ok. Maybe I can read the additional registers only after max6657 was detected.

Yes, delaying register reads until they are really needed is good
practice.

> > (...)
> > BTW, we (you) may want to move all file removal code to a separate
> > function so that the code can be shared between lm90_probe and
> > lm90_remove.
>
> Makes sense. I'll check if it also makes sense to put that into a separate patch.

Yes, a separate patch would be good.

> (...)
> Thanks a lot for the review!

Welcome :)

-- 
Jean Delvare
