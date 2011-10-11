Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1JKTKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:10:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33966 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879Ab1JKTKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:10:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RESEND PATCH 2/2] PM/runtime: handle ->runtime_suspend failure correctly
Date: Tue, 11 Oct 2011 21:12:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1318131626-9373-1-git-send-email-tom.leiming@gmail.com> <201110102340.57242.rjw@sisk.pl> <CACVXFVNSq2cLin4VQjFHWz+oH96Zwfq_jJ7vR2PurU+3vb6RpQ@mail.gmail.com>
In-Reply-To: <CACVXFVNSq2cLin4VQjFHWz+oH96Zwfq_jJ7vR2PurU+3vb6RpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112112.35595.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 11, 2011, Ming Lei wrote:
> Hi
> 
> 2011/10/11 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Sunday, October 09, 2011, tom.leiming@gmail.com wrote:
> >> From: Ming Lei <ming.lei@canonical.com>
> >>
> >> If ->runtime_suspend returns -EAGAIN or -EBUSY, the device should
> >> still be in ACTIVE state, so it is not needed to send idle notification
> >> to its parent; if ->runtime_suspend returns other fatal failure, it
> >> doesn't make sense to send idle notification to its parent.
> >>
> >> So skip these when failure is returned from ->runtime_suspend, also add
> >> comments for this handling in rpm_suspend.
> >>
> >> This patch also updates comments for rpm_suspend:
> >>
> >> - 'Cancel a pending idle notification' should be put before, also
> >> should be changed as 'Cancel a pending idle notification or
> >> autosuspend/suspend'
> >
> > That should be a different patch I think?
> 
> OK, I will split it into two.
> 
> >
> >> - idle notification for suspend failure has been removed, so update
> >> comments for it
> >>
> >> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> >> ---
> >> v1: some minor change on Alan's suggestion
> >> ---
> >>  drivers/base/power/runtime.c |   34 +++++++++++++++++++---------------
> >>  1 files changed, 19 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> >> index 441b5a3..e3c6a8f 100644
> >> --- a/drivers/base/power/runtime.c
> >> +++ b/drivers/base/power/runtime.c
> >> @@ -284,14 +284,17 @@ static int rpm_callback(int (*cb)(struct device *), struct device *dev)
> >>   * @dev: Device to suspend.
> >>   * @rpmflags: Flag bits.
> >>   *
> >> - * Check if the device's runtime PM status allows it to be suspended.  If
> >> - * another suspend has been started earlier, either return immediately or wait
> >> - * for it to finish, depending on the RPM_NOWAIT and RPM_ASYNC flags.  Cancel a
> >> - * pending idle notification.  If the RPM_ASYNC flag is set then queue a
> >> - * suspend request; otherwise run the ->runtime_suspend() callback directly.
> >> - * If a deferred resume was requested while the callback was running then carry
> >> - * it out; otherwise send an idle notification for the device (if the suspend
> >> - * failed) or for its parent (if the suspend succeeded).
> >> + * Check if the device's runtime PM status allows it to be suspended. Cancel
> >> + * a pending idle notification or autosuspend/suspend. If another suspend has
> >> + * been started earlier, either return immediately or wait for it to finish,
> >> + * depending on the RPM_NOWAIT and RPM_ASYNC flags. If the RPM_ASYNC flag is
> >> + * set then queue a suspend request; otherwise run the ->runtime_suspend()
> >> + * callback directly. If ->runtime_suspend returns failure, just cancel
> >> + * pending request and wake up waited tasks, then return immediatelly.
> >> + * After ->runtime_suspend succeeded, if a deferred resume was requested
> >> + * while the callback was running then carry it out; otherwise send an idle
> >> + * notification for its parent (if both ignore_children and irq_safe
> >> + * are not set).
> >>   *
> >>   * This function must be called under dev->power.lock with interrupts disabled.
> >>   */
> >> @@ -410,15 +413,16 @@ static int rpm_suspend(struct device *dev, int rpmflags)
> >>                       dev->power.runtime_error = 0;
> >>               else
> >>                       pm_runtime_cancel_pending(dev);
> >> -     } else {
> >> +             wake_up_all(&dev->power.wait_queue);
> >> +             goto out;
> >> +     }
> >>   no_callback:
> >
> > I don't think the change above is correct.  The code below
> > no_callback only should be executed if retval is zero.
> 
> The 'goto out' above no_callback will bypass this, won't it?

Yes, it will, sorry.  It seems I was confused by the removal of
"} else {".

OK, so this is technically correct.

Please resubmit with the unrelated comment changes splitted out.

Thanks,
Rafael
