Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab2KHJwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:52:01 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:33792 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab2KHJv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:51:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
Date: Thu, 08 Nov 2012 10:56:11 +0100
Message-ID: <1434035.IipKXWk2Vr@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1352340276.7176.37.camel@yhuang-dev>
References: <Pine.LNX.4.44L0.1211071653140.1188-100000@iolanthe.rowland.org> <5312356.pH16Qh7ECV@vostro.rjw.lan> <1352340276.7176.37.camel@yhuang-dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 08, 2012 10:04:36 AM Huang Ying wrote:
> On Thu, 2012-11-08 at 02:35 +0100, Rafael J. Wysocki wrote:
> > On Thursday, November 08, 2012 09:15:08 AM Huang Ying wrote:
> > > On Thu, 2012-11-08 at 00:09 +0100, Rafael J. Wysocki wrote:

[...]

> > > I think the patch can fix the issue in a better way.
> > 
> > I'm not sure what you mean.
> 
> I mean your patch can fix the driver-less VGA issue.  And it is better
> than my original patch.  The following discussion is not about this
> specific issue.  Just about PM core logic.

OK

> > > Do we still need to clarify state about disabled and forbidden?  When a
> > > device is forbidden and the usage_count > 0,
> > 
> > "Forbidden" always means usage_count > 0.
> 
> Yes.
> 
> > > is it a good idea to allow to set device state to SUSPENDED if the device
> > > is disabled?
> > 
> > No, it is not.  The status should always be ACTIVE as long as usage_count > 0.
> > However, in some cases we actually would like to change the status to
> > SUSPENDED when usage_count becomes equal to 0, because that means we can
> > suspend (I mean really suspend) the parents of the devices in question
> > (and we want to notify the parents in those cases).
> 
> So do you think Alan Stern's suggestion about forbidden and disabled is
> the right way to go?

I'm not really sure about that.

My original idea was that the runtime PM status and usage counter would
only matter when runtime PM of a device was enabled.  That leads to
problems, though, when we enable runtime PM of a device whose usage
counter is greater from zero and status is SUSPENDED.  Also when the
device's status is ACTIVE, but its parent's child count is 0.

It's not very easy to fix this at the core level, though, because we
depend on the current behavior in some places.  I'm thinking that
perhaps pm_runtime_enable() should just WARN() if things are obviously
inconsistent (although there still may be problems, for example, if the
parent's child count is 2 when we enable runtime PM for its child, but that
child is the only one it actually has).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
