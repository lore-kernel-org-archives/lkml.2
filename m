Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab2EGUtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:49:01 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57952 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab2EGUs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:48:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [RFC v2 2/5] PM, Add sysfs file power_off to control device power off policy
Date: Mon, 7 May 2012 22:53:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <201205042133.51339.rjw@sisk.pl> <CAC=cRTPcP4BFjSWDMimmUEjz-ABfhiPZh5VrfLHO6e9oj8VxZw@mail.gmail.com>
In-Reply-To: <CAC=cRTPcP4BFjSWDMimmUEjz-ABfhiPZh5VrfLHO6e9oj8VxZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205072253.47736.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 05, 2012, huang ying wrote:
> On Sat, May 5, 2012 at 3:33 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, May 04, 2012, Huang Ying wrote:
> >> From: Lan Tianyu <tianyu.lan@intel.com>
> >>
> >> Some devices can be powered off to save more power via some platform
> >> mechanism, e.g., ACPI.  But that may not work as expected for some
> >> device or platform.  So, this patch adds a sysfs file named power_off
> >> under <device>/power directory to provide a mechanism for user to control
> >> whether to allow the device to be power off.
> >>
> >> power_off => "enabled" means allowing the device to be powered off if
> >> possible.
> >>
> >> power_off => "disabled" means the device must be power on anytime.
> >>
> >> Also add flag power_off_user to struct dev_pm_info to record users'
> >> choice. The bus layer can use this field to determine whether to
> >> power off the device.
> >
> > It looks like the new attribute is added for all devices regardless of whether
> > or not they actually can be powered off?  If so, then please don't do that,
> > it's _extremely_ confusing.
> 
> Yes.  You are right.
> 
> > If you need user space to be able to control that functionality (and I can
> > think of a couple of cases in which you do), there need to be 2 flags,
> > can_power_off and may_power_off, where the first one is set by the kernel
> > if it is known that power can be removed from the device - the attribute
> > should be created when this flag is set and removed when it is unset.
> >
> > Then, the setting of the second flag will be controlled by the new attribute.
> >
> > And you'll need to patch quite a few places where devices actually have that
> > capability, like where power domains are in use, so that's quire a lot of
> > work.
> 
> If so, I think maybe we need 3 flags:
> 
> - can_power_off, set by kernel when it is possible to power off the device

Well, on a second thought, it may be difficult to determine that in some
cases (eg. for devices belonging to power domains with additional constraints
related to the other devices in the same domain etc.).

In other cases power may be removed from devices indirectly, like for example
by putting a device's parent into a low power state.

So I guess the can_power_off flag may not be practical after all.

> - may_power_off_user, set by user via sysfs attribute

I'd call that one power_off_allowed, meaning "allowed by user space".

> - may_power_off, set by kernel according to may_power_off_user, power
> QoS and some other conditions

And I'd call that one power_must_be_on, meaning "don't power off even if
allowed by user space".

> Sysfs attribute for may_power_off_user is only created if can_power_off is true.
> 
> I think we still can do that step by step.  For example, when we add
> power off support to PCI devices, we set can_power_off to true for PCI
> devices that is possible to be powered off;  when we add power domain
> support, we set can_power_off to true for devices in power domain.  Do
> you agree?

I think we may add helpers for exporting/unexporting power_off_allowed
like for the PM QoS latency attribute.  Then, whoever wants to support
power_off_allowed and use it will export it through that helper.

Still, I'm afraid we're trying to special case something that really ins't
a special case.  Namely, we may want to restrict devices from using some
other low-power states as well, not only power off (eg. we may want to
prevent devices' clocks from being stopped).

Thanks,
Rafael
