Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab2EWKFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:05:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab2EWKFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:05:44 -0400
MIME-Version: 1.0
In-Reply-To: <87wr4458n9.fsf@xmission.com>
References: <Pine.LNX.4.44L0.1205221008530.2100-100000@iolanthe.rowland.org>
	<87wr4458n9.fsf@xmission.com>
Date: Wed, 23 May 2012 18:05:41 +0800
Message-ID: <CACVXFVOUmFvEoADMQoc1S4vcW80v1efNvX=eHJheQTZzkcV9gA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Race_condition_between_driver=5Fprobe=5Fdevice_and_d?=
	=?UTF-8?Q?evice=5Fshutdown=E2=80=8F?=
From: Ming Lei <ming.lei@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 3:16 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
>
>> On Tue, 22 May 2012, Ming Lei wrote:
>>
>>> On Tue, May 22, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>>> > On Mon, 21 May 2012, Ming Lei wrote:
>>> >> Another candidate fix is to register a reboot notifier in driver core to prevent
>>> >> driver from being bound or unbound from start of reboot/shutdown, but looks
>>> >> not easy as the way of holding device locks.
>
> You might also be able to look at system_state and simply not do any
> hotplug work if the state is neither SYSTEM_BOOTING or SYSTEM_RUNNING.

As Alan pointed, we need to handle the case of device probing or releasing
at the same time of starting shutdown, so maybe waiting for completing of
device probe or release is needed if device lock is to be avoided.

>
>>> > I'd guess it was done this way so that the shutdown task wouldn't have
>>> > to wait for a buggy driver that didn't want to release the device lock
>>> > (or that crashed while holding the lock).
>>>
>>> Maybe, so I understand you agree on adding the device lock as did
>>> in the patch, don't I?
>>
>> I don't know.  It depends on the intention behind the shutdown
>> callback.  Maybe each driver is supposed to be responsible for doing
>> its own locking.
>>
>> Do you think that a buggy driver should be able to prevent the system
>> from shutting down?

IMO, the buggy driver should be fixed first, not only in .probe or .release, but
also in .runtime_resume, all may affect shutting down.

>
> The original intent of the shutdown callback was to just the hardware
> part of the device shutdown and not do muck with kernel data structures
> because just the device portion should be more reliable and was all
> that is needed.

The .shutdown callback pointer is got from device->driver, which is
changed in probe and release path. Also runtime PM thing has been
involved into shutting down recently, so looks not only hardware parts
are involved now.

>
> Given the current minimal usage of the device shutdown callback I'm not
> convinced the original reasoning made sense but shrug.  So we might
> want to reorg things and merge remove and shutdown.  I missed the start
> of this thread so I don't know how ambitious everyone is.

Generally remove/release may take much more time than shutdown only, which
may slow down the 'power off'. Also some device may require special handling
in .shutdown, such as, network driver may need to enable WoL or change power
state in .shutdown, so it is not easy to merge remove with shutdown safely.


Thanks,
--
Ming Lei
