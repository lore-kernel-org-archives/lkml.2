Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155Ab1ENXeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 19:34:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51950 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1ENXeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 19:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=OYbcDb1VHDWIqOis1DP2T6jlIu7hH9Qu2RKmJg/mA3yLbRzG/zd+l11g5iXEipCyn9
         AB1+jqDCCIwIKOn2w+aXSYOT3qTuvGkudpSx+ocKrAy24TGHN9vVOALARXWQ6Ul5IVhU
         H35GnXWynxb1pfJ4XfbHFWsqduB+t/oJPlT4Q=
Date: Sat, 14 May 2011 16:33:59 -0700
From: mark gross <markgross@thegnar.org>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Cc: markgross@thegnar.org, linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] pm loss development
Message-ID: <20110514233359.GA19916@gvim.org>
Reply-To: markgross@thegnar.org
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
 <20110514162423.GA8292@gvim.org>
 <BANLkTikaH24rnMxKUOJq8TtgXvzoD3=zYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikaH24rnMxKUOJq8TtgXvzoD3=zYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 10:30:31PM +0200, Raffaele Recalcati wrote:
> On Sat, May 14, 2011 at 6:24 PM, mark gross <markgross@thegnar.org> wrote:
> > On Thu, May 12, 2011 at 07:11:01PM +0200, Raffaele Recalcati wrote:
> >> What happen normally in runtime pm implementation is that every devices
> >> are switched off and are enabled only when needed.
> >> In our case instead we have a completely functional embedded system and,
> >> when an asyncrhonous event appear, we have only some tens milliseconds
> >> before the actual power failure takes place.
> >
> > Very interesting!  I've been worried about a similar failure on battery
> > driven devices that can experience significant voltage droops when
> > battery gets old, or low, and we turn on the flashlight led, vibrator
> > and make the screen bright while a high volume ring tone gets played.
> >
> > I think 10ms is a bit unrealistic.  I think its more like 300uSec before
> > you hit brown out.
> 
> In our circuit it is the real timing, but I can understand your situation.
> Are you sure about 300usec?

not 100%,  I'll ask the HW guys what the RC bulk circuit half life is
for the device.  This along with the estimate of the burst power load
will define the time constraint for responding to the event.

Note: an LCD will easily pull 600mW to a full watt, and a loud audio
system can pull a watt, and a 3G modem can have some scary big transient
spikes in current.  The LED flash light can pull a watt, and I think the
vibrator is up around 500mW.  And um, well, my CPU has a power dynamic
range of ~200mW to ~2watts in C0. So, on a bad day a load spike on the
battery could be over 4 watts with all these going off at the same time.

Some of these events are pretty bursty (vibrator, ring tone at high
volume, 3G modem spike, P-states, camera flash)  If you are unlucky you
get a brown out as the vbat drops < 3.3 (or whatever)

> 
> >> This patchset add a support in order to switch off not vital part of the system,
> >> in order to allow the board to survive longer.
> >> This allow the possibility to save important data.
> >>
> >> The implementation has been written by Davide Ciminaghi.
> >> My work instead was about analyzing different previuos implementation,
> >> a first completely custom one, a second using runtime pm, arriving
> >> finally to that one.
> >>
> >> I have tested PM loss in our DaVinci dm365 basi board and I write here below a
> >> piece of code showing a possible usage.
> >>
> >> -------------------
> >>
> >> static int powerfail_status;
> >>
> >> static irqreturn_t basi_powerfail_stop(int irq, void *dev_id);
> >>
> >> static irqreturn_t basi_powerfail_quick_check_start(int irq, void *dev_id)
> >> {
> >>         basi_mask_irq_gpio0(IRQ_DM365_GPIO0_2);
> >>         basi_unmask_irq_gpio0(IRQ_DM365_GPIO0_0);
> >>
> >>         /* PowerFail situation - START: power is going away */
> >>         return IRQ_WAKE_THREAD;
> >> }
> >>
> >> static irqreturn_t basi_powerfail_start(int irq, void *dev_id)
> >> {
> >>         if (powerfail_status)
> >>                 return IRQ_HANDLED;
> >>         powerfail_status = 1;
> >>         pm_loss_power_changed(SYS_PWR_FAILING);
> >>         return IRQ_HANDLED;
> >> }
> >>
> >>
> >> static irqreturn_t basi_powerfail_quick_check_stop(int irq, void *dev_id)
> >> {
> >>         basi_mask_irq_gpio0(IRQ_DM365_GPIO0_0);
> >>         basi_unmask_irq_gpio0(IRQ_DM365_GPIO0_2);
> >>
> >>         /* PowerFail situation - STOP: power is coming back */
> >>         return IRQ_WAKE_THREAD;
> >> }
> >>
> >> static irqreturn_t basi_powerfail_stop(int irq, void *dev_id)
> >> {
> >>         if (!powerfail_status)
> >>                 return IRQ_HANDLED;
> >>         powerfail_status = 0;
> >>         pm_loss_power_changed(SYS_PWR_GOOD);
> >>         return IRQ_HANDLED;
> >> }
> >>
> >> enum basi_pwrfail_prio {
> >>         BASI_PWR_FAIL_PRIO_0,
> >>         BASI_PWR_FAIL_MIN_PRIO = BASI_PWR_FAIL_PRIO_0,
> >>         BASI_PWR_FAIL_PRIO_1,
> >>         BASI_PWR_FAIL_PRIO_2,
> >>         BASI_PWR_FAIL_PRIO_3,
> >>         BASI_PWR_FAIL_MAX_PRIO = BASI_PWR_FAIL_PRIO_3,
> >> };
> >>
> >> struct pm_loss_default_policy_item basi_pm_loss_policy_items[] = {
> >>         {
> >>                 .bus_name = "mmc",
> >>                 .bus_priority = BASI_PWR_FAIL_PRIO_1,
> >>         },
> >>         {
> >>                 .bus_name = "platform",
> >>                 .bus_priority = BASI_PWR_FAIL_PRIO_2,
> >>         },
> >> };
> >>
> >> #define BASI_POLICY_NAME "basi-default"
> >>
> >> struct pm_loss_default_policy_table basi_pm_loss_policy_table = {
> >>         .name = BASI_POLICY_NAME,
> >>         .items = basi_pm_loss_policy_items,
> >>         .nitems = ARRAY_SIZE(basi_pm_loss_policy_items),
> >> };
> >>
> >> static void basi_powerfail_configure(void)
> >> {
> >>         int stat;
> >>         struct pm_loss_policy *p;
> >>         stat = request_threaded_irq(IRQ_DM365_GPIO0_2,
> > Is this some comparator device that tugs on this gpio when the voltage
> > drops or goes to 0?  Is threaded irq fast enough?
> 
> yes, there is a comparator.
> I need more data about timing, I'll try to add this info in some days.

yeah, even if you don't have as fast of a response time need as I think
I have, you do need to consider what if the system is busy at the time
this interrupt comes in.  Could you be blocked and fail to save your
emmc from corruption?

> 
> > Could we consider something that includes a hot path ISR based
> > notification call back to do stuff like blink off devices that don't
> > need to save state;  backlights, vibrators, flashlight LEDs, audio
> > output drivers <-- I'm not sure about audio HW, and then a slower path
> > for other things that can be put into lower power states?
> >
> > the all-clear notification that power is good again should be on a
> > slower path I would assume.
> 
> First I get data, afterwards we can see if your need can be seen as an
> extension or something else.
>

This is an interesting problem though. ;)  It brings a hard real time
requirement to the normal linux kernel from the physics of battery
performance. 

--mark
