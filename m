Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1AZV2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 16:28:54 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52703 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab1AZV2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 16:28:52 -0500
X-Sasl-enc: wDOS1CfgcjpQjzJfOLniyWrOjH0Qd3WvbyOfADd4vA9I 1296077331
Date: Wed, 26 Jan 2011 19:28:48 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: Thomas Renninger <trenn@suse.de>, "R, Durgadoss" <durgadoss.r@intel.com>,
        "jdelvare@novell.com" <jdelvare@novell.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
	<linux-trace-users@vger.kernel.org>
Subject: Re: Thermal kernel events API to userspace - Was: Re: thermal:
 Avoid CONFIG_NET compile dependency
Message-ID: <20110126212848.GB21236@khazad-dum.debian.net>
References: <D6D887BA8C9DFF48B5233887EF046541094482F511@bgsmsx502.gar.corp.intel.com>
 <20110124160747.GD6424@khazad-dum.debian.net>
 <1295942269.1866.1201.camel@rui>
 <201101251112.28340.trenn@suse.de>
 <20110125161059.GD14803@khazad-dum.debian.net>
 <CF2F38D4AE21BB4CB845318E4C5ECB6731CC866A@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF2F38D4AE21BB4CB845318E4C5ECB6731CC866A@shsmsx501.ccr.corp.intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Zhang, Rui wrote:
> > > I wonder which events would need userspace to take specific
> > > (configured) actions at all and what kind of action it could be.
> > 
> > All of them can have sensible generic actions.  See my other email.
> > 
> > > What is THERMAL_USER_AUX0?
> > > When will it get thrown and what is userspace expected to do?
> > 
> > Good question.  What use are those "user defined" events in a generic
> > interface, anyway?  You will have to know exactly what device is
> > issuing the
> > "generic user defined" event, and what it means for that device.
> > 
> > When you need a device-specific interface, you design one that is well
> > defined, such as thinkpad-acpi's thinkpad-specific "acpi" events.  If
> > you
> > get any thinkpad-acpi specific event, you know exactly what it is, and
> > nothing else ever issues those events, so you will never get them from
> > somewhere else with a different meaning.
> >
> I think you are talking about something like this:
> enum events {
> 	/* generic thermal event */
> 	THERMAL_WARN,
> 	THERMAL_EMERG,
> 	THERMAL_CRIT,
> 	/* coretemp thermal events */
> 	TEHRMAL_CT_AUX0,
> 	TEHRMAL_CT_AUX1,
> 	/* Thinkpad battery thermal events */
> 	THERMAL_TP_BAT_CRIT,
> 	THERMAL_TP_BAT_EMERG,
> 	THERMAL_DEV_FAULT,
> };
> Right?

Hmm, no.  I already perfectly fine, strictly defined driver-specific events.
And driver-specific events are useless crap in practice.  Nobody really
codes userspace utilities for them.  Maybe some 10-20 power users write ACPI
rules and scripts to deal with them, but that's it.

I am quite willing and happy to keep the driver-specific events for those 20
people in the world that actually used them to make something nice, and even
add new ones when necessary.  But that is NOT the way to go forward when
you have any sort of choice.

I.e.  I'd like THERMAL_BAT_CRIT, THERMAL_BAT_EMERG, and a strict enough
definition of what they mean, that userspace (or a kernel thermal event
handler) could process them and do the right thing regardless of which
driver generated the events, because it would be sure of what they mean.

You might want to change that to a two-axis or three-axis event, actually:

What:   THERMAL_NORMAL, THERMAL_WARN, THERMAL_EMERG, THERMAL_CRIT,
        THERMAL_SENSOR_FAULT...

Where:  SYSTEM (aka: unknown/generic), BATTERY, CPU, GPU, PSU, PCIDEV, USBDEV...

Extended code: (what,where)-specific.  For example, could be the specific
core or package for (*, CPU) events...

BTW: thermal_normal means "alarm condition cleared".  Like thermal_warn, I
wouldn't expect every device to be able to raise it.  Thinkpads, for
example, won't tell you when they're back to normal operating conditions
AFAIK.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
