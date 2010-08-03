Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab0HCWI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:08:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42974 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab0HCWIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:08:55 -0400
MIME-Version: 1.0
In-Reply-To: <1280851338.2774.30.camel@mulgrave.site>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<AANLkTi=hoGF7egpyB9sLKJoXv5aiGrxfa9_5iH-96SA=@mail.gmail.com>
	<1280851338.2774.30.camel@mulgrave.site>
Date: Tue, 3 Aug 2010 15:08:54 -0700
Message-ID: <AANLkTinJ2jy18bAS-=abtDLaQWVmQdK1Oq105FcNDNyJ@mail.gmail.com>
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: paulmck@linux.vnet.ibm.com, peterz@infradead.org, swetland@google.com,
        linux-kernel@vger.kernel.org, florian@mickler.org,
        linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/3 James Bottomley <James.Bottomley@suse.de>:
> On Mon, 2010-08-02 at 21:18 -0700, Arve Hjønnevåg wrote:
>> > o       A power-aware application must be able to efficiently communicate
>> >        its needs to the system, so that such communication can be
>> >        performed on hot code paths.  Communication via open() and
>> >        close() is considered too slow, but communication via ioctl()
>> >        is acceptable.
>> >
>>
>> The problem with using open and close to prevent an allow suspend is
>> not that it is too slow but that it interferes with collecting stats.
>
> Please elaborate on this.  I expect the pm-qos stats interface will
> collect stats across user open/close because that's how it currently
> works.  What's the problem?
>

The pm-qos interface creates the request object in open and destroys
it in release just like the suspend blocker interface. We need stats
for each client which is lost if you free the object every time you
unblock suspend.

Or are you talking about user space opening and closing the stats
interface (which does not cause any problems)?

>> The wakelock code has a sysfs interface that allow you to use a
>> open/write/close sequence to block or unblock suspend. There is no
>> limit to the amount of kernel memory that a process can consume with
>> this interface, so the suspend blocker patchset uses a /dev interface
>> with ioctls to block or unblock suspend and it destroys the kernel
>> object when the file descriptor is closed.
>
> This is an implementation detail only.

There is no way fix it without changing the user space visible
behavior of the API. The kernel does not know when it is safe to free
the objects.

> The pm-qos objects are long
> lived, so their stats would be too.  I would guess that explicit stat
> clearing might be a useful option.
>

Which pm-qos objects are you referring to? The struct pm_qos_object
that backs each pm-qos class is long lived (I don't know why this is
named pm_qos_object), but we need stats in struct pm_qos_request_list.

-- 
Arve Hjønnevåg
