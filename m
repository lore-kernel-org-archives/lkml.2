Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2FFC1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 22:27:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55541 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab2FFC1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 22:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206051256130.1542-100000@iolanthe.rowland.org>
References: <CACVXFVMdidqhFE1AhenUi8VXbYhac492YdxsvPmVqcwmo=TrcA@mail.gmail.com>
	<Pine.LNX.4.44L0.1206051256130.1542-100000@iolanthe.rowland.org>
Date: Wed, 6 Jun 2012 10:27:04 +0800
Message-ID: <CACVXFVPjQmvmXnYNm4sSjJXq83qe-Xg8=YjRppSNMpUQYLokjQ@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 1:09 AM, Alan Stern <stern@rowland.harvard.edu> wrote:

>> After device_shutdown() has been called, the whole system will enter power down
>> or reset later, so it doesn't matter if who should manage the device.
>
> Maybe.  But there might be quite some time between the shutdown call
> and the eventual power-off or reboot.

Between device_shutdown and machine_halt, there is only syscore_shutdown left
to complete, so no much time is involved.

>
> On the whole, it might be easier just to hold the device lock during
> the shutdown call.

Yes, it is easier, but it is not efficient because there are very less
drivers which implemented .shutdown callback. Suppose there are some
drivers which have no .shutdown but are holding device lock,  extra
time will be consumed in the lock acquiring, which may slow down 'power
down'.

>
>> >> @@ -1803,6 +1806,9 @@ void device_shutdown(void)
>> >>  {
>> >>       struct device *dev;
>> >>
>> >> +     ACCESS_ONCE(device_shutdown_started) = 1;
>> >
>> > This does not need to be ACCESS_ONCE.  ACCESS_ONCE is needed only in
>> > situations where the compiler might insert multiple reads or writes.
>>
>> I have talked with Paul about the ACCESS_ONCE, and Paul thought it is needed
>> to prevent the compiler from doing byte-at-a-time stores.
>
> Why on earth would a compiler change this into a byte-at-a-time store?
> And even if it did, what problem would that cause?  Only one of the
> bytes would be different from the original value.

Maybe Paul can answer the question...

>
>> Maybe Paul has a detailed explanation about it.
>
>> >>  static int really_probe(struct device *dev, struct device_driver *drv)
>> >>  {
>> >>       int ret = 0;
>> >> +     int idx;
>> >>
>> >> +     idx = srcu_read_lock(&driver_srcu);
>> >>       atomic_inc(&probe_count);
>> >> +     if (ACCESS_ONCE(device_shutdown_started))
>> >
>> > This doesn't need to be ACCESS_ONCE either.  If it would make you feel
>>
>> Because the global variable of device_shutdown_started is not changed inside
>> the function, the compiler may put the above line after the line of
>> 'dev->driver = drv',
>
> No, it can't do that.  If the compiler moved this read farther down,
> and as a result the CPU wrote to dev->driver when it shouldn't have,
> the result would be incorrect (i.e., different from what would have
> happened if the statement hadn't been moved).  Hence the compiler is
> prohibited from making such an optimization.

There are some similar examples(check on global variable is moved) with
ACCESS_ONCE usage in Documentation/atomic_ops.txt. (from line 88)


Thanks,
--
Ming Lei
