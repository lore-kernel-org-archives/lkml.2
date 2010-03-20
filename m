Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0CTCxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 22:53:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37272 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600Ab0CTCxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 22:53:34 -0400
X-Sasl-enc: RweW1bUhsGWKty9LoOMfVR8gpThSKLcmc4YVc097BYds 1269053612
Date: Fri, 19 Mar 2010 23:53:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] Input: implement sysrq as an input handler
Message-ID: <20100320025329.GA2468@khazad-dum.debian.net>
References: <20100317061952.GA19789@core.coreip.homeip.net>
 <20100319000043.GC12017@khazad-dum.debian.net>
 <20100319000931.GA5671@core.coreip.homeip.net>
 <20100319160641.GC16743@khazad-dum.debian.net>
 <20100319180314.GB12143@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319180314.GB12143@core.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010, Dmitry Torokhov wrote:
> On Fri, Mar 19, 2010 at 01:06:41PM -0300, Henrique de Moraes Holschuh wrote:
> > On Thu, 18 Mar 2010, Dmitry Torokhov wrote:
> > > On Thu, Mar 18, 2010 at 09:00:43PM -0300, Henrique de Moraes Holschuh wrote:
> > > > Any chance of the user being able to avoid the SysRQ events getting to the
> > > > handle, e.g. by opening the input device in exclusive mode or something like
> > > > that?
> > > 
> > > Yes, it is a possible to suppress SysRq by grabbing an input device.
> > > This possibility exisst with the current implementation too though -
> > > after all legacy keyboard driver implemented as an input handler as
> > > well.
> > > 
> > > ... or am I answering a question different from the one you asked? ;)
> > 
> > No, that's exactly what I wanted to know.
> > 
> > What about SAK?  That thing *has* to be untrappable.
> 
> On what level untrapable? And what exactly is SAK? There is not a
> special key, at least not in general case, it is an action assigned to a
> key comboi.  Root can "trap" legacy keyboard SAK with loadkeys; it can
> also disable sysrq, unload modules and do other nasty things. But
> ordinary users can not trap it.

root isn't really a problem from a security PoV (well, maybe it is if the
operation isn't constrained by capabilities).  SAK can't protect you from
root.

_Normal_ userspace behaviour running a root process is a problem if it
blocks these handles, though, both for SAK and regular SysRQ.  I have lost
count of how many times SysRQ+SUB delivered me from filesystem corruption
and very annoying problems, both at home and at work.

We are sort of trusting userspace to not break the one way out from severly
hung systems while doing its normal day-to-day operations (as opposed to
deliberately disabling SysRQ or remapping SAK, etc).

> > Even for the SysRQ debug events, I'd feel better if we could have a class of
> > system input handlers that cannot be suppressed to use for these things.
> 
> That would require moving "these things", including their state
> machines, into input core otherwise it would not know what events can be
> trappable and which should be passed through. Or we should get rid of
> EVIOCGRAB.

Maybe we can add a flags field to input devices and input handlers, to be
able to have the core behave differently when needed, without moving
everything into the input core?  Would that work, or would it need too much
churn in the core?

> Given the fact that event devices are accessible only to root I think
> that current behavior is acceptable.

I don't trust the class of programs that would want to open input devices as
root in exclusive mode.  Desktop fluff might decide to use EVIOCGRAB or open
input devices in exclusive mode for some reason, and break SysRQ.  I'd like
to preserve the hability of userspace to EVIOCGRAB if it feels there's a
need to, while preserving the kernel's hability to NEVER ignore SysRQ and
SAK while enabled.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
