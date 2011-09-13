Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1IMBWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 21:22:45 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46210 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab1IMBWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 21:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <201109122344.02386.rjw@sisk.pl>
References: <201108310017.03103.rjw@sisk.pl>
	<201108310020.26104.rjw@sisk.pl>
	<CACVXFVPshpc-aVHGMYWkthffMRYLFh4BadnEAhf+eQ47CwWLZw@mail.gmail.com>
	<201109122344.02386.rjw@sisk.pl>
Date: Tue, 13 Sep 2011 09:22:43 +0800
Message-ID: <CACVXFVN5E6pToFk_nn0xgNrUW-DQzVssmPFDpHckSaHSRwWjoQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] PM / Runtime: Do not run callbacks under lock for
 power.irq_safe set
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 13, 2011 at 5:44 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> On Monday, September 12, 2011, Ming Lei wrote:
>
>> Hi,
>
>>
>
>> On Wed, Aug 31, 2011 at 6:20 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>
>> >
>
>> > The rpm_suspend() and rpm_resume() routines execute subsystem or PM
>
>> > domain callbacks under power.lock if power.irq_safe is set for the
>
>> > given device.  This is inconsistent with that rpm_idle() does after
>
>> > commit 02b2677 (PM / Runtime: Allow _put_sync() from
>
>> > interrupts-disabled context) and is problematic for subsystems and PM
>
>> > domains wanting to use power.lock for synchronization in their
>
>> > runtime PM callbacks.  For this reason, make runtime PM core functions
>
>> > always release power.lock before invoking subsystem or PM domain
>
>>
>
>> If power.lock is released, the transition states(resuming or suspending)
>
>> may be observed in rpm_suspend or rpm_resume, then tasks schedule
>
>> will be produced in these two functions,
>
> I don't think so, because the interrupts are still off.

Yes, the interrupts are still off on local CPU, but the release of spin lock may
cause another CPUs to run into rpm_suspend or rpm_resume and produce
task schedule inside the two functions.

>
>> so the functions below can't be
>
>>
>
>> pm_runtime_suspend()
>
>> pm_runtime_autosuspend()
>
>> pm_runtime_resume()
>
>> pm_runtime_put_sync_suspend()
>
>> pm_runtime_put_sync_autosuspend()
>
>>
>
>> called in irq-off contexts safely even though irq_safe flag is set.
>
> The patch doesn't cause rpm_suspend() and rpm_resume() to turn interrupts
>
> on if irq_safe is set, it only causes them to release the lock
> (temporarily).


thanks,
-- 
Ming Lei
