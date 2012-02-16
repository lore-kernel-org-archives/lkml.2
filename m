Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2BPEjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 23:39:08 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53084 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab2BPEjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:39:03 -0500
MIME-Version: 1.0
In-Reply-To: <201202152324.08073.rjw@sisk.pl>
References: <201202152318.04206.rjw@sisk.pl>
	<201202152324.08073.rjw@sisk.pl>
Date: Wed, 15 Feb 2012 20:39:02 -0800
Message-ID: <CAMP5XgenQF11AUSkn2iWT679bWHe8XeQ1mbrKcSzbDNQLctp5w@mail.gmail.com>
Subject: Re: [PATCH 3/3] PM / Sleep: Make __pm_stay_awake() delete wakeup
 source timers
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> If __pm_stay_awake() is called after __pm_wakeup_event() for the same
> wakep source object before its timer expires, it won't cancel the
> timer, so the wakeup source will be deactivated from the timer
> function as scheduled by __pm_wakeup_event().  In that case
> __pm_stay_awake() doesn't have any effect beyond incrementing
> the wakeup source's event_count field, although it should cancel
> the timer and make the wakeup source stay active until __pm_relax()
> is called for it.
>
> Conversely, if __pm_wakeup_event() is called for a wakeup source
> that has been activated by __pm_stay_awake() before, it will set up
> the timer to deactivate the wakeup source, although it should leave
> it active until __pm_relax() is called for it.

We have many drivers that call wake_lock_timeout instead of
wake_unlock to cancel a previous wake_lock call. These drivers will
need to use two wakeup sources if __pm_wakeup_event does not always
set the timeout. I think it is better to have the state of the wakeup
source only depend on the last function you called, instead of that
last function being a noop in some cases.

-- 
Arve Hjønnevåg
