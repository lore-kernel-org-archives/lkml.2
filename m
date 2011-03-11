Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1CKN7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:59:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab1CKN7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:59:22 -0500
Date: Fri, 11 Mar 2011 14:50:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
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
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re:
	timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes.patch
	added to -mm tree
Message-ID: <20110311135023.GA23552@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -218,10 +266,12 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
>  	 * it to the new values.
>  	 */
>  	for (;;) {
> +		spin_lock(&notifiers_lock);
>  		spin_lock_irq(&ctx->wqh.lock);
> -		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
> +		if (!list_empty(&notifiers_list) || hrtimer_try_to_cancel(&ctx->tmr) >= 0)
>  			break;

Confused. Why do we check the global notifiers_list?

IOW. Suppose that this list is not empty and timerfd_settime() is called
without TFD_NOTIFY_CLOCK_SET. Now we are going to reprogramm the timer
without stopping it?

And. What if timerfd_settime(TFD_NOTIFY_CLOCK_SET, utmr => NULL) is called
twice? timerfd_setup() blindly does list_add(), and we corrupt the list, no?

Oleg.

