Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1IEHo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 03:44:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43096 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1IEHou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 03:44:50 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.117.118]
In-Reply-To: <201109030155.28031.rjw@sisk.pl>
References: <201108310017.03103.rjw@sisk.pl>
	<201109020007.22743.rjw@sisk.pl>
	<CAORVsuVAzc8Q2tG0-WW+96Ad9GhR5OCq2bAuweggs1rimFMcqg@mail.gmail.com>
	<201109030155.28031.rjw@sisk.pl>
Date: Mon, 5 Sep 2011 09:44:49 +0200
Message-ID: <CAORVsuWKFK3zc9XAwK37QwEw4g3VfuhcUb=rZUSzcyjz2NJcHQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] PM / QoS: Add function dev_pm_qos_read_value()
From: Jean Pihet <jean.pihet@newoldbits.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sat, Sep 3, 2011 at 1:55 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, September 02, 2011, Jean Pihet wrote:
>> On Fri, Sep 2, 2011 at 12:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
...

>> >> >  */
>> >> >  int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
>> >> >                           s32 value)
>> >> > @@ -195,28 +219,35 @@ int dev_pm_qos_add_request(struct device
>> >> >                return -EINVAL;
>> >> >        }
>> >> >
>> >> > -       mutex_lock(&dev_pm_qos_mtx);
>> >> >        req->dev = dev;
>> >> >
>> >> > -       /* Return if the device has been removed */
>> >> > -       if (req->dev->power.constraints_state == DEV_PM_QOS_NO_DEVICE) {
>> >> > -               ret = -ENODEV;
>> >> > -               goto out;
>> >> > -       }
>> >> > +       device_pm_lock();
>> >> > +       mutex_lock(&dev_pm_qos_mtx);
>> >> >
>> >> > -       /*
>> >> > -        * Allocate the constraints data on the first call to add_request,
>> >> > -        * i.e. only if the data is not already allocated and if the device has
>> >> > -        * not been removed
>> >> > -        */
>> >> > -       if (dev->power.constraints_state == DEV_PM_QOS_DEVICE_PRESENT)
>> >> > -               ret = dev_pm_qos_constraints_allocate(dev);
>> >> > +       if (dev->power.constraints) {
>> >> > +               device_pm_unlock();
>> >> > +       } else {
>> >> > +               if (list_empty(&dev->power.entry)) {
>> >> > +                       /* The device has been removed from the system. */
>> >> > +                       device_pm_unlock();
>> >> > +                       goto out;
>> >> 0 is silently returned in case the device has been removed. Is that
>> >> the intention?
>> >
>> > Pretty much it is.  Is that a problem?
>> I think the caller needs to know if the constraint has been applied
>> correctly or not.
>
> However, the removal of the device is a special case.  What would the caller
> be supposed to do when it learned that the device had been removed while it had
> been trying to add a QoS constraing for it?  Not much I guess.
When the device is removed from the system the constraints list id
flushed and the requests are zero'ed using memset.
In that case the caller needs to be aware of that otherwise the next
call to the API will throw an error.

>
> Thanks,
> Rafael
>

Thanks,
Jean
