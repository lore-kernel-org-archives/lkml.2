Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0ETLMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:12:47 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:53656 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0ETLMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:12:46 -0400
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PREEMPT_RT (2.6.33-rt17) disabled printk-to-console after console_init
Date: Thu, 20 May 2010 15:12:38 +0400
User-Agent: KMail/1.9.9
Cc: Sujit K M <sjt.kar@gmail.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <AANLkTimxLHngWamPvWt-htGoZ7Nub72rvJAnmGtw4Eqw@mail.gmail.com> <201005201423.09075@zigzag.lvk.cs.msu.su> <alpine.LFD.2.00.1005201225170.3368@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005201225170.3368@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005201512.40304@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Still questions:
> >
> > 1) why does that prevent klogd from working?
>
> Patch below.
> ...
> @@ -1084,18 +1084,8 @@ void release_console_mutex(void)
>  #endif
>  	}
>  	console_locked = 0;
> -	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
>  	mutex_unlock(&console_mutex);

Hmm... that lock is taken inside loop body, then control goes out of loop 
at 'break' statement, and then, if this line is deteled, lock is still 
held at function return. Looks wrong.

> > 2) why does print not pass to non-CON_ATOMIC even if called from
> > non-atomic context?
>
> That's a good question. We call release_console_mutex() always with
> interrupts disabled from printk(), so that atomic check triggers. Have
> to look deeper to figure out whether we can enable interupts there,
> probably not, but with the klogd fix this should not matter.

IMO it still matters, since printk-over-serial is almost only available 
debugging tool when [while driver debugging] system just hangs and one is 
trying to find out why and where.

> > 3) I believe that 8250 serial driver is aware of preempt-rt.
> > Could you please comment on my "2.6.33.2-rt13: RFC: fix serial
> > console" post to linux-rt-users list
> > (http://eeek.borgchat.net/lists/linux-rt-users/msg05569.html)
>
> While that can work due to the trylock, it can introduce massive
> latencies just in case some driver reports a status change or what
> ever.

Isn't it better just manually disable console (with 'quiet' kernel command 
line option) when running in production? This may be recommended in proper 
guidelines.
But while developing, serial console functionality is essential.

Nikita
