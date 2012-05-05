Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2EEG3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 02:29:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60757 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2EEG3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 02:29:53 -0400
MIME-Version: 1.0
In-Reply-To: <201205042133.51339.rjw@sisk.pl>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	<1336119221-21146-3-git-send-email-ying.huang@intel.com>
	<201205042133.51339.rjw@sisk.pl>
Date: Sat, 5 May 2012 14:29:52 +0800
Message-ID: <CAC=cRTPcP4BFjSWDMimmUEjz-ABfhiPZh5VrfLHO6e9oj8VxZw@mail.gmail.com>
Subject: Re: [RFC v2 2/5] PM, Add sysfs file power_off to control device power
 off policy
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 3:33 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, May 04, 2012, Huang Ying wrote:
>> From: Lan Tianyu <tianyu.lan@intel.com>
>>
>> Some devices can be powered off to save more power via some platform
>> mechanism, e.g., ACPI.  But that may not work as expected for some
>> device or platform.  So, this patch adds a sysfs file named power_off
>> under <device>/power directory to provide a mechanism for user to control
>> whether to allow the device to be power off.
>>
>> power_off => "enabled" means allowing the device to be powered off if
>> possible.
>>
>> power_off => "disabled" means the device must be power on anytime.
>>
>> Also add flag power_off_user to struct dev_pm_info to record users'
>> choice. The bus layer can use this field to determine whether to
>> power off the device.
>
> It looks like the new attribute is added for all devices regardless of whether
> or not they actually can be powered off?  If so, then please don't do that,
> it's _extremely_ confusing.

Yes.  You are right.

> If you need user space to be able to control that functionality (and I can
> think of a couple of cases in which you do), there need to be 2 flags,
> can_power_off and may_power_off, where the first one is set by the kernel
> if it is known that power can be removed from the device - the attribute
> should be created when this flag is set and removed when it is unset.
>
> Then, the setting of the second flag will be controlled by the new attribute.
>
> And you'll need to patch quite a few places where devices actually have that
> capability, like where power domains are in use, so that's quire a lot of
> work.

If so, I think maybe we need 3 flags:

- can_power_off, set by kernel when it is possible to power off the device
- may_power_off_user, set by user via sysfs attribute
- may_power_off, set by kernel according to may_power_off_user, power
QoS and some other conditions

Sysfs attribute for may_power_off_user is only created if can_power_off is true.

I think we still can do that step by step.  For example, when we add
power off support to PCI devices, we set can_power_off to true for PCI
devices that is possible to be powered off;  when we add power domain
support, we set can_power_off to true for devices in power domain.  Do
you agree?

Best Regards,
Huang Ying
