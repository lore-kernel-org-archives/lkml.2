Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab1IBLt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 07:49:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51041 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab1IBLt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 07:49:57 -0400
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <alpine.LFD.2.02.1109021135270.2723@ionos>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
	 <1314661157-22173-4-git-send-email-andi@firstfloor.org>
	 <alpine.LFD.2.02.1109021135270.2723@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 13:49:58 +0200
Message-ID: <1314964198.2573.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 02 septembre 2011 à 12:06 +0200, Thomas Gleixner a écrit :

> ------------------>
> Subject: posix-timers: Simplify deletion protection
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 02 Sep 2011 11:59:14 +0200
> 
> k_itimer->it_signal is soleley used to protect a timer lookup against
> a concurrent deletion. We can use k_itimer->list for the same purpose.
> 

Well, this patch is wrong too, unless you base it after Andi patch 1/4
(move global timer id management to signal_struct)

The test is also present to make sure one process doesnt try to use a
timer_id of another process.


> @@ -643,7 +643,7 @@ static struct k_itimer *__lock_timer(tim
>  	timr = idr_find(&posix_timers_id, (int)timer_id);
>  	if (timr) {
>  		spin_lock_irqsave(&timr->it_lock, *flags);
> -		if (timr->it_signal == current->signal) {
> +		if (!list_empty(&timr->list)) {
>  			rcu_read_unlock();
>  			return timr;
>  		}



