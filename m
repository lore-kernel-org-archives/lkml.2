Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936795Ab0COVBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:01:13 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39503 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab0COVBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=S1kk7q10mv1HVHU3dlYA8a3J2xg/T0zT8Z3b2fYDxW2PhorepHUkWeIKD0WINCBsZ4
         hLYoYbmadc2wMeCAWrcb/EnXUjrR7+Nwhm1uxLZIMw6vtjncoVLCNQjQgiTcGIZemKPO
         PFMSvlQyCp4HbyF5KHJcds/RBCp9fPKMKdjk0=
Subject: Re: inconsistent lock state
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
In-Reply-To: <20100308125122.GA11242@redhat.com>
References: <20100307192305.GA598@elte.hu>
	 <20100308125122.GA11242@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 22:01:05 +0100
Message-ID: <1268686865.2824.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 08 mars 2010 à 13:51 +0100, Oleg Nesterov a écrit :
> Sergey Senozhatsky wrote:
> >
> > Hello,
> >
> > Hardly reproducible.
> > /*
> > * 2.6.33. x86. ASUS f3jc
> > */
> >
> > [329645.010697] =================================
> > [329645.010699] [ INFO: inconsistent lock state ]
> > [329645.010703] 2.6.33-33-0-dbg #31
> > [329645.010705] ---------------------------------
> > [329645.010708] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> >
> > ...
> >
> > [329645.011083]  [<c128858d>] netif_receive_skb+0x340/0x360
> > [329645.011093]  [<fd1ab6f4>] rtl8169_rx_interrupt+0x2bf/0x37e [r8169]
> > [329645.011100]  [<fd1aba02>] rtl8169_reset_task+0x38/0xcd [r8169]
> > [329645.011105]  [<c1044f71>] worker_thread+0x1ac/0x27c
> 
> I don't understand this code, but at first glance drivers/net/r8169.c
> is obviously buggy.
> 
> The work->func, rtl8169_reset_task(), calls rtl8169_rx_interrupt() ->
> netif_receive_skb(), and the last one may only be called from softirq.
> 

Yes, this is wrong. In this context (process context, not softirq), we
should use netif_rx() or just drop frames if we are in reset phase.

Also, this driver schedules a reset in case a fifo error is reported in
rtl8169_rx_interrupt()

                if (status & RxFOVF) {
                        rtl8169_schedule_work(dev, rtl8169_reset_task);
                        dev->stats.rx_fifo_errors++;
                }


This seems very strange too : In case of a RX spike, we reset card ?


