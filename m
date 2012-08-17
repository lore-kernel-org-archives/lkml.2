Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2HQV2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:28:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36802 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2HQV2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:28:01 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D413800155@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413800090@USINDEM103.corp.hds.com>
 <CAGTjWtA-zE-UCsqC5H4VvLfz94J_5bjYzMwF5RaHLdr9O_MoRA@mail.gmail.com> <A5ED84D3BB3A384992CBB9C77DEDA4D413800155@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Fri, 17 Aug 2012 14:27:40 -0700
Message-ID: <CAGTjWtAiW1=BVTj0HdkVRbq5DVJjFs7jjNLp6bSVXmGq6rcvkA@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] efi_pstore: Introducing workqueue updating sysfs entries
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 2:15 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
>
>> I'm not a fan of creating a periodic timer that wakes up here to check for an event that should be considered very rare.
>>
>> Can this just become scheduled work?  Scheduling work itself is a very lightweight process and should be relatively safe to do from a
>> pstore write.
>
> I agree that the periodic timer is heavy a bit.
> But I would like to keep a write callback simple as much as possible in panic situation.
> For example, I'm concerned that efi_pstore hangs up due to some spin_locks related workqueue like gcwq->lock.
>
> Also,  a situation which this workqueue is needed is just oops case because, system will be down and users can't access to sysfs files
>  in other cases, panic, reboot and emergency_restart.
>
> So, Can I call schedule_work in oops case only as follows?
>
> efi_pstore_write()
> {
>    <write log to NVRAM>
>
>  if (reason != KMSG_DUMP_OOPS)
>         return;
>
> schedule_work()

You could, but why not always just schedule_work()?  If we are hosed
by broken workqueue/scheduler locking, the user isn't going to see
those files in sysfs either way :)  If you are going to insist that we
shouldn't schedule_work() in the other cases, I'd prefer:

/* The user may want to see an entry for this write in sysfs. */
if (reason == KMSG_DUMP_OOPS)
        schedule_work(...);

>
> }
