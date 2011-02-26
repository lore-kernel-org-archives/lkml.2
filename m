Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1BZPUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 10:20:47 -0500
Received: from imr4.ericy.com ([198.24.6.8]:51450 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1BZPUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 10:20:46 -0500
Date: Sat, 26 Feb 2011 07:19:11 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] hwmon: PMBus device driver
Message-ID: <20110226151911.GA16108@ericsson.com>
References: <1297969217-9564-1-git-send-email-guenter.roeck@ericsson.com>
 <1297969217-9564-2-git-send-email-guenter.roeck@ericsson.com>
 <4D680FAE.80600@cam.ac.uk>
 <20110226024552.GA14032@ericsson.com>
 <4D68D8CB.1050108@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D68D8CB.1050108@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,
On Sat, Feb 26, 2011 at 05:41:15AM -0500, Jonathan Cameron wrote:
> On 02/26/11 02:45, Guenter Roeck wrote:
> > On Fri, Feb 25, 2011 at 03:23:10PM -0500, Jonathan Cameron wrote:
> >> On 02/17/11 19:00, Guenter Roeck wrote:
> >>> This driver adds support for hardware monitoring features of various PMBus
> >>> devices.
> >>
> >> Hi Guenter, I'm afraid this isn't the most thorough review ever, but there
> >> are a few questions I'd like answered inline. These devices are pretty ugly.
> >>
> > Hi Jonathan,
> >
> > given the complexity of the driver I am very happy you found the time!
> >
> >> I'm also a little unhappy with how often you clear faults without it being
> >> obvious why.  Please have another look at this and add clarifying comments...
> >>
> > Mostly that was to make me feel safer. I removed some; hope it is better now.
> >
> >> I've suggested use of some macros inline. Not sure whether it's actualy a good
> >> idea though. What do you think?
> >>
> > I actually had more function macros in the code, but I am getting a bit away
> > from it after I noticed that it often just obfuscates the code. Only reason
> > for not removing the remaining the function macros is that I didn't find
> > a clean way to replace them with actual code or functions.
> Fair enough. They would have been really ugly macros.  Just feels like there ought
> to be a cleaner way of handling those big chunks of very predicable code!  Maybe
> some sort of array of structs with all the relevant info in them?

Sounds like a good idea. Let me think about it; maybe I can come up with something.

[ ... ]
> >>>
> >>> +config PMBUS
> >>> +     tristate "PMBus support"
> >
> > Side note: that should really be a boolean. Will be fixed in next version.
> >
> Why?  Can't the pmbus core stuff be a module?

You are absolutely right. I forgot that this is used to compile the core module.
Sorry for the noise.

> >>
> > You are right, though that would require context information which is currently
> > not exported from pmbus_core.c. Specifically, pmbus.c would need to know about
> > struct pmbus_data which is private to pmbus_core.c. I would prefer to keep it that way.
> >
> > Maybe I could add an API call into pmbus_core.c to retrieve a pointer to pmbus_driver_info.
> > Do you think that would make sense ? I am a bit at odds with myself if the list or an
> > API function (or something else ?) would be better.
> >
> Are I'd missed the issue with the struct definition being private.
> 
> API call is probably the cleanest option.  The list just seems to be be adding complexity
> for no actual gain.
> 
The API got rid of the list and reduced the code size by about 25 lines.
Definitely a winner.

> >>> +bool pmbus_check_word_register(struct i2c_client *client, int page, int reg)
> >>> +{
> >>> +     int rv, status;
> >>> +     struct pmbus_data *data = i2c_get_clientdata(client);
> >>> +
> >>> +     pmbus_write_byte(client, page, PMBUS_CLEAR_FAULTS);
> >> If there have been faults, do we not want to have handled them?
> >> That is, should there be any circumstance under which we would want
> >> to clear one here?x
> >
> > That is one place where it is really needed. Status codes are sticky, so if
> > "PB_CML_FAULT_INVALID_COMMAND" was set for whatever reason, it would be reported
> > below even if the following access is ok.
> They wouldn't you ideally pick that up and report it when it first occurs rather
> than clearing it here?  i.e. Clear whenever it occurs not at the top of a later
> function that wants to check the same error code...

Makes sense, only I'll have to clean up the status when loading the driver, before
starting to do any register checks. I'll see what I can do.

> >
> >>> +     rv = pmbus_read_word_data(client, page, reg);
> >>
> >> I think this is idenical to the check code in the previous function.
> >> Worth pulling out to a utility function used by both?
> >
> > Yes, excellent idea.
> >
> >>> +     if (rv >= 0 && !(data->flags & PMBUS_SKIP_STATUS_CHECK)) {
> >>> +             status = pmbus_read_byte_data(client, page, PMBUS_STATUS_BYTE);
> >>> +             if (status < 0 || (status & PB_STATUS_CML)) {
> >>> +                     int status2 = pmbus_read_byte_data(client, page,
> >>> +                                                        PMBUS_STATUS_CML);
> >>> +                     if (status2 < 0
> >>> +                         || (status2 & PB_CML_FAULT_INVALID_COMMAND)) {
> >>> +                             dev_dbg(&client->dev,
> >>> +                                     "page %d reg 0x%x status 0x%x-0x%x\n",
> >>> +                                     page, reg, status, status2);
> >>> +                             rv = -EINVAL;
> >>> +                     }
> >>> +             }
> >>> +     }
> >>> +     pmbus_write_byte(client, page, PMBUS_CLEAR_FAULTS);
> >
> > This one isn't strictly needed, though, so I removed it.
> >
> Good
> 
Except per discussion above, I'll see if I can remove the one at the top of the function.

> ....
> >>> +
> >>> +/*
> >>> + * Return boolean calculated from converted data.
> >>> + * <index> defines a status register index and mask, and optionally
> >>> + * two sensor indexes.
> >>> + * The upper half-word references the two sensors,
> >>> + * the lower half word references status register and mask.
> >>> + * The function returns true if (status[reg] & mask) is true and,
> >>> + * if specified, if v1 >= v2.
> >>> + * To determine if an object exceeds upper limits, specify <v, limit>.
> >>> + * To determine if an object exceeds lower limits, specify <limit, v>.
> >>> + */
> >>> +static int pmbus_get_boolean(struct pmbus_data *data, int index, int *val)
> >>> +{
> >>> +     u8 s1 = (index >> 24) & 0xff;
> >>> +     u8 s2 = (index >> 16) & 0xff;
> >>> +     u8 reg = (index >> 8) & 0xff;
> >>> +     u8 mask = index & 0xff;
> >>> +     int status;
> >>> +     u8 regval;
> >>> +
> >>> +     status = data->status[reg];
> >>> +     if (status < 0)
> >>> +             return status;
> >>> +
> >>> +     regval = status & mask;
> >>
> >> This test could do with a simple explanatory comment (which is another
> >> way of saying I'm not quite clear why this makes sense!)
> >
> > You mean the following test ? If both s1 and s2 are 0, the function
> > returns the result of (status & mask). This is for all booleans
> > which are created with pmbus_add_boolean_reg().
> >
> > Otherwise, the result is determined by comparison as described above.
> >
> > I'll add additional comments to describe this in more detail.
> Cool. My issue was I couldn't tell what s1 and s2 actually are.

I added more description at the top of the function. Hope it is a bit clearer
in the next version.

Thanks,

Guenter

