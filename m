Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab1CJIs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:48:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55308 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1CJIs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:48:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
Date: Thu, 10 Mar 2011 09:48:03 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
In-Reply-To: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103100948.03628.arnd@arndb.de>
X-Provags-ID: V02:K0:aBmVHZPZDsKnXJIo9pIHIXSoBUnmzQGsV9yNjKfhQzj
 3DTZamhqL99ddYMiY0JnRI15ptXXne3kVAqyF7KegzpzOU+bwU
 zcC4yoXQ2ydYGaJzkAAl8D9LzqNw4FO3oX29olbllTXa/CgNoZ
 92uoMH6h5GulT1jnjY8oM3RiQlByrklO7qJR0fmAjSo2rfrAKk
 LNiEvucRB27lyXbj8/kLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 March 2011 15:36:51 Alexander Shishkin wrote:
> This is another attempt to approach notifying userspace about system
> clock changes. The other one is using an eventfd and a syscall [1]. In
> the course of discussing the necessity of a syscall for this kind of
> notifications, it was suggested that this functionality can be achieved
> via timers [2] (and timerfd in particular [3]). This idea got quite
> some support [4], [5], [6] and some vague criticism [7], so I decided
> to try and go a bit further with it.

I don't understand from your description or from the patch how user
space gets notified. From your description, I would have expected
to see a change to the timerfd_poll() function to check if the
clock has changed, possibly returning POLLPRI, but the only such
change I can see is in the timerfd_read() function. Don't you need
to change poll() so that a task knows when to call read()?

> +/* TFD_NOTIFY_CLOCK_SET timers go here */
> +static DEFINE_SPINLOCK(notifiers_lock);
> +static LIST_HEAD(notifiers_list);

Maybe I was the only one to be confused by this, but I think t
he naming is slightly misleading, because it's easy to confuse
with a struct notifier_block. You could of course use the
notifier API instead of building your own, but if you don't,
I'd recommend coming up with a different name.

I also think that a mutex would be better here than a spinlock.
It's unlikely to be under heavy contention, but if you have
a lot of threads, it could be held for a significant amount
of time.

	Arnd
