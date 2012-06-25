Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab2FYMin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:38:43 -0400
Received: from bar.sig21.net ([80.81.252.164]:54574 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271Ab2FYMim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:38:42 -0400
Date: Mon, 25 Jun 2012 14:38:09 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Marc Dionne <marc.c.dionne@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120625123809.GA12623@sig21.net>
References: <20120605231550.GA20981@electric-eye.fr.zoreil.com>
 <20120606014656.GA24870@redhat.com>
 <20120606054251.GA24467@electric-eye.fr.zoreil.com>
 <20120608023420.GD7191@redhat.com>
 <alpine.LFD.2.02.1206080954440.3086@ionos>
 <20120608142333.GB1711@redhat.com>
 <alpine.LFD.2.02.1206081641040.3086@ionos>
 <20120608202701.GA26175@electric-eye.fr.zoreil.com>
 <alpine.LFD.2.02.1206082238120.3086@ionos>
 <20120608215328.GB26175@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608215328.GB26175@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 08, 2012 at 11:53:28PM +0200, Francois Romieu wrote:
> Thomas Gleixner <tglx@linutronix.de> :
> [...]
> > Though the problem is, that it is neither called in interrupt context
> > nor with bh disabled, so nothing invokes the softirq before it reaches
> > idle.
> > 
> > In hard interrupt context the pending flag is evaluated in irq_exit()
> > and the softirqs are invoked from there. If you call that from thread
> > context, then a bh_disable/enable pair will make sure that the pending
> > softirq is invoked. Did I miss some more ___underscore magic which
> > does that ?
> 
> No. You _are_ right.
> 
> That's why 98ddf986fca17840e46e070354b7e2cd2169da15 triggered the
> message: it removed the last bh lock in the r8169 slow work context.
> 
> /me slaps head...
> 
> The whole thing is probably moot. Dave, can you apply the patch
> below on top of a fresh kernel tree ?
> 
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 4a05b68..d452441 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -5934,11 +5934,7 @@ static void rtl_slow_event_work(struct rtl8169_private *tp)
>  	if (status & LinkChg)
>  		__rtl8169_check_link_status(dev, tp, tp->mmio_addr, true);
>  
> -	napi_disable(&tp->napi);
> -	rtl_irq_disable(tp);
> -
> -	napi_enable(&tp->napi);
> -	napi_schedule(&tp->napi);
> +	rtl_irq_enable_all(tp);
>  }
>  
>  static void rtl_task(struct work_struct *work)

I just upgraded my rarely-used Atom based netbook from 3.3.5 to 3.4.4
and got the "NOHZ: local_softirq_pending 08" message.
Should this patch go into stable?

Johannes
