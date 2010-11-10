Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0KJTkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:40:40 -0500
Received: from imr3.ericy.com ([198.24.6.13]:48767 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab0KJTkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:40:39 -0500
Date: Wed, 10 Nov 2010 11:39:30 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (applesmc) Fix checkpatch errors
Message-ID: <20101110193930.GA31650@ericsson.com>
References: <1289415200-4928-1-git-send-email-guenter.roeck@ericsson.com>
 <4CDAE9D7.3060007@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CDAE9D7.3060007@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 01:52:07PM -0500, Henrik Rydberg wrote:
> On 11/10/2010 07:53 PM, Guenter Roeck wrote:
> 
> > Fix all checkpatch errors and most of the warnings.
> > 
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > ---
> >  drivers/hwmon/applesmc.c |   40 +++++++++++++++++++++-------------------
> >  1 files changed, 21 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> > index 1e49b30..365761b 100644
> > --- a/drivers/hwmon/applesmc.c
> > +++ b/drivers/hwmon/applesmc.c
> > @@ -174,9 +174,8 @@ static int __wait_status(u8 val)
> >  
> >  	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
> >  		udelay(us);
> > -		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val) {
> > +		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val)
> >  			return 0;
> > -		}
> >  	}
> >  
> >  	return -EIO;
> > @@ -431,7 +430,7 @@ static int applesmc_has_key(const char *key, bool *value)
> >  /*
> >   * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z).
> >   */
> > -static int applesmc_read_motion_sensor(int index, s16* value)
> > +static int applesmc_read_motion_sensor(int index, s16 *value)
> >  {
> >  	u8 buffer[2];
> >  	int ret;
> > @@ -779,14 +778,12 @@ static ssize_t applesmc_store_fan_speed(struct device *dev,
> >  					const char *sysfsbuf, size_t count)
> >  {
> >  	int ret;
> > -	u32 speed;
> > +	unsigned long speed;
> >  	char newkey[5];
> >  	u8 buffer[2];
> >  
> > -	speed = simple_strtoul(sysfsbuf, NULL, 10);
> > -
> > -	if (speed > 0x4000) /* Bigger than a 14-bit value */
> > -		return -EINVAL;
> > +	if (strict_strtoul(sysfsbuf, 10, &speed) < 0 || speed >= 0x4000)
> > +		return -EINVAL;		/* Bigger than a 14-bit value */
> 
> 
> Thanks for the bug fix, I forgot to include it.
> 
> >
> >  	sprintf(newkey, fan_speed_fmt[to_option(attr)], to_index(attr));
> >  
> > @@ -822,10 +819,11 @@ static ssize_t applesmc_store_fan_manual(struct device *dev,
> >  {
> >  	int ret;
> >  	u8 buffer[2];
> > -	u32 input;
> > +	unsigned long input;
> >  	u16 val;
> >  
> > -	input = simple_strtoul(sysfsbuf, NULL, 10);
> > +	if (strict_strtoul(sysfsbuf, 10, &input) < 0)
> > +		return -EINVAL;
> >  
> >  	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
> >  	val = (buffer[0] << 8 | buffer[1]);
> > @@ -977,7 +975,11 @@ static ssize_t applesmc_key_at_index_show(struct device *dev,
> >  static ssize_t applesmc_key_at_index_store(struct device *dev,
> >  	struct device_attribute *attr, const char *sysfsbuf, size_t count)
> >  {
> > -	key_at_index = simple_strtoul(sysfsbuf, NULL, 10);
> > +	unsigned long newkey;
> > +
> > +	if (strict_strtoul(sysfsbuf, 10, &newkey) < 0)
> > +		return -EINVAL;
> > +	key_at_index = newkey;
> 
> 
> Crash alert - key_at_index is not range checked, and the remake uses this value
> as an array index...
> 
Good that I made this change ;). I'll add the check and re-send.

This points to another problem, though. You allocate key_count entries,
ie cache[0]..cache[key_count-1]. Yet, the key searches are from 0..key_count,
ie span key_count+1 entries. Is that another problem ?

Seems to me you would either have to allocate key_count+1 entries, or terminate
the search at key_count - 1. Not sure which one would be correct. Let me know,
and I'll update the affected patch(es).

Thanks,
Guenter
