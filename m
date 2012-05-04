Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab2EDTug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:50:36 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43208 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754506Ab2EDTuf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:50:35 -0400
MIME-Version: 1.0
In-Reply-To: <1336119221-21146-2-git-send-email-ying.huang@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <1336119221-21146-2-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 May 2012 13:50:13 -0600
Message-ID: <CAErSpo4EGWndS0c_6SZrCz_O=3WmfZoRoRrU=9AN5TG3QfxHbg@mail.gmail.com>
Subject: Re: [RFC v2 1/5] PM, Runtime, Add power_must_be_on flag
To: Huang Ying <ying.huang@intel.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 2:13 AM, Huang Ying <ying.huang@intel.com> wrote:
> The extreme way to save device power in runtime is to turn off power
> of device.  For example, D3cold for PCIe bus and ZPODD (Zero Power
> Optical Disk Drive) for SATA bus will do that.
>
> But sometimes power off is not expected, some possible reason is as
> follow
>
> - power off device usually incurs longer resume latency, if it exceeds
>  power QoS requirement, power off should be disabled.
>
> - For some buses, device in power off state can not support remote
>  wakeup.  If remote wakeup is desired, power off should be disabled.
>
> In general, whether to put a device into power off state should be
> decided by the driver of the device, but for some buses, whether to
> put a device into power off state may be done by the parent of the
> device.  For example, a PCIe end point device may be put into power
> off state by the PCIe port connected to it.
>
> So a flag is introduced for the children devices to tell the parent
> device, whether it should be put into power off state.
>
> This flag is also used for device driver to tell bus layer whether it
> is OK to be powered off.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  include/linux/pm.h |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -536,6 +536,7 @@ struct dev_pm_info {
>        unsigned int            irq_safe:1;
>        unsigned int            use_autosuspend:1;
>        unsigned int            timer_autosuspends:1;
> +       unsigned int            power_must_be_on:1;
>        enum rpm_request        request;
>        enum rpm_status         runtime_status;
>        int                     runtime_error;

It's a little weird to just add the field, with no users.  Would it
make sense to pull out the bits of patch 5 that use this and combine
them into a single smaller patch?  But see related comments there; it
might be safer to have a function that computes this whenever you need
it instead of caching the value.

Bjorn
