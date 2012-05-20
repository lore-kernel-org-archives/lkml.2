Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2ETOIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 10:08:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45946 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab2ETOIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 10:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120518045907.GA3397@kroah.com>
References: <20120518045907.GA3397@kroah.com>
Date: Sun, 20 May 2012 22:08:08 +0800
Message-ID: <CACVXFVPhPmTfdB-pKpz7NpL+N03cxDvPpiFdPWeZcqBNNSffYw@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Race_condition_between_driver=5Fprobe=5Fdevice_and_d?=
	=?UTF-8?Q?evice=5Fshutdown=E2=80=8F?=
From: Ming Lei <ming.lei@canonical.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 18, 2012 at 12:59 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> Hi,
>
> First off, sorry for missing this, and thanks to Andrew for pointing it
> out to me.  You might want to use the tool, scripts/get_maintainer.pl
> for who to know to cc: for patches like this, so I don't miss it.
>
>> I'm seeing a driver crash in its shutdown routine because it's
>> touching some uninitialized state. It turns out that the driver's
>> probe routine was still running [for the same device]. There also
>> appears to be an issue in the remove path, where device_shutdown()
>> checks the dev->driver pointer and uses it later, with seemingly
>> nothing to guarantee that it doesn't change.
>
> What type of driver is having this problem?  What type of bus is it on?
> Usually the bus prevents this from happening with its own serialization.

Looks it is a generic problem.

There are two races, one is between .probe and .shutdown, and another
is between .release  and .shutdown, see below:


void device_shutdown(void)

		......
		/* Don't allow any more runtime suspends */
		pm_runtime_get_noresume(dev);
		pm_runtime_barrier(dev);

		if (dev->bus && dev->bus->shutdown) {
			dev_dbg(dev, "shutdown\n");
			dev->bus->shutdown(dev);
		} else if (dev->driver && dev->driver->shutdown) {  /*line-driver*/
			dev_dbg(dev, "shutdown\n");
			dev->driver->shutdown(dev);                              /*line-shut*/
		}
		......

If dev->driver is just set(really_probe) before 'line-driver' and .probe is
not executed before 'line-shut', the .shutdown may touch a uninitialized
device.

Also if dev->driver is just cleared(__device_release_driver) after "line-driver"
and before "line-shut", null pointer will be referenced and oops will
be triggered.


>> Shouldn't we synchronize the shutdown routine with probe/remove to
>> prevent such races?
>
> Normally, yes, and for some reason, I thought we already were doing
> that.

Looks the races are still there.

>> The patch below should take care of these races.
>
> Does this patch solve your problem?  Care to show me the oops you get
> without it?
>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index e28ce98..f2c63c6 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -1823,6 +1823,9 @@ void device_shutdown(void)
>>                 pm_runtime_get_noresume(dev);
>>                 pm_runtime_barrier(dev);
>>
>> +               if (dev->parent)        /* Needed for USB */
>> +                       device_lock(dev->parent);
>> +               device_lock(dev);

Looks the above makes sense to serialize .shutdown with
.probe and .release.


Thanks,
--
Ming Lei
