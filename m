Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0DWDzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 23:55:06 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:37115 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0DWDzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 23:55:01 -0400
MIME-Version: 1.0
In-Reply-To: <20100423022522.GB32490@count0.beaverton.ibm.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
	 <1271984938-13920-2-git-send-email-arve@android.com>
	 <1271984938-13920-3-git-send-email-arve@android.com>
	 <20100423022522.GB32490@count0.beaverton.ibm.com>
Date: Thu, 22 Apr 2010 20:54:59 -0700
Message-ID: <z2wd6200be21004222054qaf4a0b0doa13aea4c7ef049d7@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access 
	suspend blockers from user-space
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/22 Matt Helsley <matthltc@us.ibm.com>:
...
> On Thu, Apr 22, 2010 at 06:08:51PM -0700, Arve Hjønnevåg wrote:
>> +To create a suspend_blocker from user-space, open the suspend_blocker device:
>> +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
>> +then call:
>> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);
>
> Why not initialize the user suspend blocker struct by default and then
> allow each BLOCK to specify the name? Also, my guess is it's not
> really a name so much as a description of why we're blocking suspend,
> right?
>

There are stats tracked as long as the suspend blocker exists.
Specifying a new name every time you block suspend would make this
less useful.

> Should the kernel reject empty strings or strings composed only of
> "non-printing" characters?
>

Is there an existing function that check if a sting is "unsafe". If
so, I can add a call to this.

>> +
>> +To activate a suspend_blocker call:
>> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_BLOCK);
>> +
>> +To unblock call:
>> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_UNBLOCK);
>
> lsof will show which tasks hold the device open but not which ones
> are blocking suspend. If merely keeping the device open corresponded to
> blocking suspend then this would be obvious and no ioctls would be
> necessary -- just write() the name/description.

We track more information about suspend blockers than this.

>
> Do you block/unblock often enough that frequent open/close of the device are
> a problem?

Yes.

...
>> +
>> +static DEFINE_MUTEX(ioctl_lock);
>
> nit: Usually locks protect data -- not functions.
>
> Couldn't this be part of the user_suspend_blocker struct? That would allow
> the description/name to change as described above.

It mainly protects the allocation of that struct, so no. Allocating a
separate struct in open would work, but does not seem worth it at the
moment.

>
>> +
>> +struct user_suspend_blocker {
>> +     struct suspend_blocker  blocker;
>> +     char                    name[0];
>> +};
>
> <snip>
>
> Cheers,
>        -Matt Helsley
>



-- 
Arve Hjønnevåg
