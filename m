Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2BTLYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:24:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34979 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2BTLWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:22:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djkurtz@google.com designates 10.50.181.228 as permitted sender) smtp.mail=djkurtz@google.com; dkim=pass header.i=djkurtz@google.com
MIME-Version: 1.0
In-Reply-To: <20120215104837.GB4095@phenom.ffwll.local>
References: <1328817797-4026-1-git-send-email-bleung@chromium.org> <20120215104837.GB4095@phenom.ffwll.local>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 20 Feb 2012 19:22:00 +0800
X-Google-Sender-Auth: QIPgdkbd0ggtiVvjQEhXmAzZF9M
Message-ID: <CAGS+omD8e9dBen_kQkoY+vc4yP6HCAeoNRYhzK+OPw+99HDoFg@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Fix single msg gmbus_xfers writes
To: Benson Leung <bleung@chromium.org>, keithp@keithp.com, airlied@linux.ie,
        chris@chris-wilson.co.uk, djkurtz@chromium.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15, 2012 6:48 PM, "Daniel Vetter" <daniel@ffwll.ch> wrote:
>
> On Thu, Feb 09, 2012 at 12:03:17PM -0800, Benson Leung wrote:
> > gmbus_xfer with a single message (particularly a single message write) would
> > set Bus Cycle Select to 100b, the Gen Stop cycle, instead of 101b,
> > No Index, Stop cycle. This would not start single message i2c transactions.
> >
> > Also, gmbus_xfer done: will disable the interface without checking if
> > it is idle. In the case of writes, there will be no wait on status or delay
> > to ensure the write starts and completes before the interface is turned off.
> >
> > Fixed the former issue by using the same cycle selection as used in the
> > I2C_M_RD for the write case.
> > GMBUS_CYCLE_WAIT | (i + 1 == num ? GMBUS_CYCLE_STOP : 0)
> > Fixed the latter by waiting on GMBUS_ACTIVE to deassert before disable.
> >
> > Signed-off-by: Benson Leung <bleung@chromium.org>

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

>
> Can you clarify the commit message a bit and say that the first hunk is
> just for optics and the issue is only with the write path (because the
> read path is correct already). Silly me is just to easily confused ;-)
>
> Btw, I've reworked the gmbus -> gpio bit-banging fallback code a bit and
> if that passes review and all I'll reenable gmbus by default again. See
>
> http://cgit.freedesktop.org/~danvet/drm/log/?h=gmbus

If the write case is fixed by Benson's patch, is there any known use
case that still requires i2c bit banging on these pins?  It would be a
nice cleanup to remove it completely.

Also, I can think of at least two further potential performance
improvements that I was wondering if anybody has yet pursued:
  (1) Enabling the i915's gmbus interrupt.  This would eliminate the
need for the (relatively slow) wait_for polling loop.
  (2) Taking advantage of the i915's "INDEX" cycles to combine writing
a (1 or 2 byte) address & reading back an array of bytes into a single
transaction.

Best Regards,
-Daniel

>
> Yours, Daniel
>
> > ---
> >  drivers/gpu/drm/i915/intel_i2c.c |   13 +++++++++----
> >  1 files changed, 9 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> > index d30cccc..64bb9cd 100644
> > --- a/drivers/gpu/drm/i915/intel_i2c.c
> > +++ b/drivers/gpu/drm/i915/intel_i2c.c
> > @@ -249,7 +249,8 @@ gmbus_xfer(struct i2c_adapter *adapter,
> >
> >               if (msgs[i].flags & I2C_M_RD) {
> >                       I915_WRITE(GMBUS1 + reg_offset,
> > -                                GMBUS_CYCLE_WAIT | (i + 1 == num ? GMBUS_CYCLE_STOP : 0) |
> > +                                GMBUS_CYCLE_WAIT |
> > +                                (i + 1 == num ? GMBUS_CYCLE_STOP : 0) |
> >                                  (len << GMBUS_BYTE_COUNT_SHIFT) |
> >                                  (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
> >                                  GMBUS_SLAVE_READ | GMBUS_SW_RDY);
> > @@ -278,7 +279,8 @@ gmbus_xfer(struct i2c_adapter *adapter,
> >
> >                       I915_WRITE(GMBUS3 + reg_offset, val);
> >                       I915_WRITE(GMBUS1 + reg_offset,
> > -                                (i + 1 == num ? GMBUS_CYCLE_STOP : GMBUS_CYCLE_WAIT) |
> > +                                GMBUS_CYCLE_WAIT |
> > +                                (i + 1 == num ? GMBUS_CYCLE_STOP : 0) |
> >                                  (msgs[i].len << GMBUS_BYTE_COUNT_SHIFT) |
> >                                  (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
> >                                  GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
> > @@ -317,9 +319,12 @@ clear_err:
> >       I915_WRITE(GMBUS1 + reg_offset, 0);
> >
> >  done:
> > -     /* Mark the GMBUS interface as disabled. We will re-enable it at the
> > -      * start of the next xfer, till then let it sleep.
> > +     /* Mark the GMBUS interface as disabled after waiting for idle.
> > +      * We will re-enable it at the start of the next xfer,
> > +      * till then let it sleep.
> >        */
> > +     if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0, 10))
> > +             DRM_INFO("GMBUS timed out waiting for idle\n");
> >       I915_WRITE(GMBUS0 + reg_offset, 0);
> >       return i;
> >
> > --
> > 1.7.1
> >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
