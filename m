Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0H0RIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:08:12 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12876 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0H0RII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:08:08 -0400
Date: Fri, 27 Aug 2010 19:07:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: Fix checkpatch errors in lm90 driver
Message-ID: <20100827190744.4f36c485@hyperion.delvare>
In-Reply-To: <20100827164833.GB22316@ericsson.com>
References: <1282838076-7175-1-git-send-email-guenter.roeck@ericsson.com>
	<20100827134523.6bcc70aa@hyperion.delvare>
	<20100827134926.GA21827@ericsson.com>
	<20100827172403.4c22bbce@hyperion.delvare>
	<20100827164833.GB22316@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 09:48:33 -0700, Guenter Roeck wrote:
> On Fri, Aug 27, 2010 at 11:24:03AM -0400, Jean Delvare wrote:
> Hi Jean,
> 
> > Hi Guenter,
> > 
> > On Fri, 27 Aug 2010 06:49:26 -0700, Guenter Roeck wrote:
> > > Next question: lm90_update_device() currently does not return any errors.
> > > In recent drivers, we pass i2c read errors up to userland. Before I introduce
> > > the max6696 changes, does it make sense to add error checking/return
> > > into the driver, similar to what I have done in the smm665 and jc42 drivers ?
> > 
> > So far, most hwmon driver authors decided to ignore such errors, or
> > limited their handling to logging the issue, mainly because the caching
> > mechanism makes handling of such errors tough. Now I admit that the
> > approach you took in the jc42 driver is interesting. I never considered
> > having a single error value being returned by the update function the
> > way you did.
> > 
> > This has the obvious drawback that transient I/O errors cause _all_
> > sensor values to be unavailable, which is discussable, especially for a
> > device with many features. It's hard to justify that all values of a
> > full-featured hardware monitoring chip could be unavailable because,
> > for example, one of the temperature sensors is unreliable. So this
> > approach is fine for your small jc42 driver, but I don't think it can be
> > generalized.
>
> On the plus side, though, a transient failure only causes a single read
> operation to fail, since I don't update the timestamp nor the valid flag
> in the error case. As a result, the next read will again try to update
> all values. So it isn't really that bad. Only real drawback of my approach
> is that a transient read failure on one sensor register will likely be
> reported while trying to read data for another sensor.

Good point, I had missed this implementation detail. But this cuts both
ways: if there are too many transient errors (like the W83L785TS-S had)
the update function may keep failing forever, even though each value
could have been updated at some point in time.

> Of course, you are right that a permanent error on a single register will
> cause all sensor read operations to fail, which isn't really desirable.
> I have no idea if that can happen in the real world, though. Seems to be
> unlikely that a failing sensor would cause an I2C operation failure.
> But who knows - maybe it does happen with some chips.

In all honesty, I can't remember any such device. In general, failing
sensors are reported through data flags, not low-level errors. The only
two drivers I know which needed special error handling are w83l785ts
and thinkpad_acpi - the latter isn't I2C-based so there's no register
caching needed.

> > In the general case, I think I am fine with pretty much anything which
> > doesn't plain ignore error codes (as many drivers still do...) and
> > doesn't block all readings on transient errors. This can mean returning
> > 0 on error, or returning the previous last known value (definitely
> > acceptable for transient errors, but not so for long-standing ones),
> 
> Basic reason for returning errors in the first place was that I was asked
> to do so in review feedback for one of my drivers - specifically, that I
> should not drop errors. So we would need some clear(er) guidelines
> for new drivers if we want to go along that path.

I don't remember that discussion, but I think the only thing we really
want to avoid is negative errno values being returned to user-space
silently as negative (or large positive) temperature or voltage values.
As long as this doesn't happen, I think we are on the safe side.

> > with or without logging. Or if you really want to pass error codes down
> > to user-space, I think you have to rework the update() function and the
> > per-device data structure altogether, to be able to store error codes
> > in the data structure.
>
> Seems to be a bit excessive, and it doesn't seem to be worth the effort
> and added complexity.

I tend to agree. Which is why nobody did it so far (or maybe once in one
rare driver, can't remember.)

But at least this is the "best" way to handle errors, in that it
doesn't introduce a policy at driver level. Errors are reported exactly
as if no register value caching was done.

> > A different (and complementary) approach is to repeat the failing
> > command and see if it helps. The w83l785ts driver does exactly this. If
> > we want to generalize this, it would probably make sense to implement
> > it at the the i2c-core level (i.e. add a "retries" i2c_client
> > attribute.)
> > 
> Still doesn't solve the permanent error case, though. Question remains, then,
> if it is likely that a single i2c register would return a permanent error
> while others still work.

It could in specific cases. Think of a new device which is a
stripped-down version of one we already support. One can forcibly bind
the driver to the new device, but maybe the device will return I/O
errors on non-existent features. Obviously this is a transient
situation though, as proper support for the new device would have to be
added at some point anyway.

For a device we properly support, no, I can't imagine a permanent error
other than global.

> > I admit I have been ignoring the issue mainly so far, because it's not
> > a big problem in practice (except on one board with the w83l785ts
> > driver, thus the extra code in that driver), so adding complex or
> > invasive code to deal with it isn't too appealing.
>
> I'll take that as a hint and won't make any changes to lm90 driver error 
> handling.

If you have other, more important things on your to-do list, then
that's the right thing to do ;)

-- 
Jean Delvare
