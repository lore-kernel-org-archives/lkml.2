Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1CJA0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:26:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab1CJAZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:25:54 -0500
Date: Wed, 9 Mar 2011 16:25:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
Message-Id: <20110309162513.5058c824.akpm@linux-foundation.org>
In-Reply-To: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Mar 2011 16:36:51 +0200
Alexander Shishkin <virtuoso@slind.org> wrote:

> Changes since v3:
>  - changed timerfd_settime() semantics (see below)
> Changes since v2:
>  - replaced sysfs interface with a syscall
>  - added sysctl/procfs handle to set a limit to the number of users
>  - fixed issues pointed out by Greg.
> Changes since v1:
>  - updated against 2.6.36-rc1,
>  - added notification/filtering options,
>  - added Documentation/ABI/sysfs-kernel-time-notify interface description.
> 
> Certain userspace applications (like "clock" desktop applets or cron or
> systemd) might want to be notified when some other application changes
> the system time. There are several known to me reasons for this:
>  - avoiding periodic wakeups to poll time changes;
>  - rearming CLOCK_REALTIME timers when said changes happen;
>  - changing system timekeeping policy for system-wide time management
>    programs;
>  - keeping guest applications/operating systems running in emulators
>    up to date;
>  - recalculation of traffic signal cycles in Advanced Traffic Controllers
>    (ATC), which is part of ATC API requirements [1] as developed by ATC
>    working group of the U.S. Institute of Transportation Engineers (ITE).
> 
> The major change since the previous version is the new semantics of
> timerfd_settime() when it's called on a time change notification
> descriptor: it will set the system time to utmr.it_value if the time
> change counter is zero, otherwise it will return EBUSY, this is required
> to prevent a race between setting the time and reading the counter, when
> the time controlling procees changes the time immediately after another
> process in the system did the same (the counter is greater than one),
> that process' time change will be lost. Thus, the time controlling
> process should use timerfd_settime() instead of clock_settime() or
> settimeofday() to ensure that other processes' time changes don't get
> lost.
> 
> This is another attempt to approach notifying userspace about system
> clock changes. The other one is using an eventfd and a syscall [1]. In
> the course of discussing the necessity of a syscall for this kind of
> notifications, it was suggested that this functionality can be achieved
> via timers [2] (and timerfd in particular [3]). This idea got quite
> some support [4], [5], [6] and some vague criticism [7], so I decided
> to try and go a bit further with it.

Looks sane to me.  The changelog is a bit of a pickle - I stole a
useful-looking paragraph from your other please-ignore-this-email
email.

I also cc'ed Michael and linux-api: there isn't much point in adding
kernel features if we don't tell anyone about them.

It would be helpful to know if the identified users of this feature
actually find it useful and adequate.  I guess the most common
application is the 1,001 desktop clock widgets.  Do you have any
feedback from any of the owners of those?

Thanks.

