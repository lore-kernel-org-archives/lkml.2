Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab0H0PYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:24:31 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:3275 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0H0PY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:24:28 -0400
Date: Fri, 27 Aug 2010 17:24:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: Fix checkpatch errors in lm90 driver
Message-ID: <20100827172403.4c22bbce@hyperion.delvare>
In-Reply-To: <20100827134926.GA21827@ericsson.com>
References: <1282838076-7175-1-git-send-email-guenter.roeck@ericsson.com>
	<20100827134523.6bcc70aa@hyperion.delvare>
	<20100827134926.GA21827@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Fri, 27 Aug 2010 06:49:26 -0700, Guenter Roeck wrote:
> Next question: lm90_update_device() currently does not return any errors.
> In recent drivers, we pass i2c read errors up to userland. Before I introduce
> the max6696 changes, does it make sense to add error checking/return
> into the driver, similar to what I have done in the smm665 and jc42 drivers ?

So far, most hwmon driver authors decided to ignore such errors, or
limited their handling to logging the issue, mainly because the caching
mechanism makes handling of such errors tough. Now I admit that the
approach you took in the jc42 driver is interesting. I never considered
having a single error value being returned by the update function the
way you did.

This has the obvious drawback that transient I/O errors cause _all_
sensor values to be unavailable, which is discussable, especially for a
device with many features. It's hard to justify that all values of a
full-featured hardware monitoring chip could be unavailable because,
for example, one of the temperature sensors is unreliable. So this
approach is fine for your small jc42 driver, but I don't think it can be
generalized.

In the general case, I think I am fine with pretty much anything which
doesn't plain ignore error codes (as many drivers still do...) and
doesn't block all readings on transient errors. This can mean returning
0 on error, or returning the previous last known value (definitely
acceptable for transient errors, but not so for long-standing ones),
with or without logging. Or if you really want to pass error codes down
to user-space, I think you have to rework the update() function and the
per-device data structure altogether, to be able to store error codes
in the data structure.

A different (and complementary) approach is to repeat the failing
command and see if it helps. The w83l785ts driver does exactly this. If
we want to generalize this, it would probably make sense to implement
it at the the i2c-core level (i.e. add a "retries" i2c_client
attribute.)

I admit I have been ignoring the issue mainly so far, because it's not
a big problem in practice (except on one board with the w83l785ts
driver, thus the extra code in that driver), so adding complex or
invasive code to deal with it isn't too appealing.

-- 
Jean Delvare
