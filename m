Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab0ELX40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:56:26 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46711 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0ELX4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eDGGghq1uiBnVoguNRMR+eF3RcELnLPULF1Mlu21Qq6ujb/Gn2Cm0oD90mHxRPZzZ8
         mukYZZxs2WzaaxarGCEWpFfO8FrcqHlBNju25NsMFNq62gPLGOXd38syWtP3TBKo6CMG
         zDKJhG1hIxfNeBsiBTIOwqSdxuz68Pz+4pPC8=
MIME-Version: 1.0
In-Reply-To: <SNT111-DS115B558E5855C0FAEA860CA7F60@phx.gbl>
References: <SNT111-DS115B558E5855C0FAEA860CA7F60@phx.gbl>
Date: Wed, 12 May 2010 16:56:23 -0700
X-Google-Sender-Auth: 6i7yV-MMBUMt_uusFnzNaIsWj-k
Message-ID: <AANLkTin7itFVRzywm9g776bpE5IaFNsGVVW_PUbv0RKm@mail.gmail.com>
Subject: Re: Weird timer handler used with LAPIC selected
From: john stultz <johnstul@us.ibm.com>
To: limp <johnkyr83@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 4:10 AM, limp <johnkyr83@hotmail.com> wrote:
> Hi all,
>
> I have configured my kernel (2.6.31.6) so that I get periodic ticks from the
> timer interrupt (i.e. tickless is not configured) with a rate determined by
> the HZ value. I have also selected the "Local APIC support on uniprocessors"
> option so that the LAPIC timer is used as a tick source. The problem is that
> the handler used for the timer is not the "local_apic_timer_interrupt"
> handler as I was excepted but the "tick_handle_periodic" handler. This can
> be verified by seeing the output of /proc/timer_list:
>
> Tick Device: mode:     0
> Per CPU device: 0
> Clock Event Device: lapic
>  max_delta_ns:   1006457290
>  min_delta_ns:   1799
>  mult:           35797637
>  shift:          32
>  mode:           1
>  next_event:     9223372036854775807 nsecs
>  set_next_event: lapic_next_event
>  set_mode:       lapic_timer_setup
>  event_handler:  tick_handle_periodic

You might want to read the code in further detail. The clockevent
device is an abstraction on top of the actual hardware, so the
event_handler method is not mapped into the irq handler directly.

So the local_apic_timer_interrupt() is called by the apic hardware
interrupt, it then calls lapic clockevent device's event_handler()
method, which is set to tick_handle_periodic(). Since you're in
_PERIODIC mode, not _ONESHOT (hrtimers/nohz), this seems correct to
me.



> Is there an explanation for that? The board in which I am running the kernel
> is a Kontron 986LCD-M/mITX one with an Intel Celeron M 440 installed on it.
> I have verified that Intel Celeron M Processors have a LAPIC and
> consequently, a LAPIC timer.
>
> --------------------------------------------
> Another weird thing that I noticed is that by running the same kernel but
> configured for "Core 2/newer Xeon" processors, the timer handler used is the
> "hrtimer_interrupt" handler. Again, this is verified by /proc/timer_list:
>
> Tick Device: mode:     1
> Per CPU device: 0
> Clock Event Device: lapic
> event_handler:  hrtimer_interrupt

Yep. On this system I'm guessing you have hrtimers or nohz/tickless enabled?


> I have put some printks inside "local_apic_timer_interrupt" handler which
> should never be executed as the handler selected for the timer is
> "hrtimer_interrupt" and not "local_apic_timer_interrupt" as verified.

Nope. Again, local_apic_timer_interrupt is the actual irq hook. It
then calls the lapic clockevent device's event_handler() method, which
is hrtimer_interrupt.

thanks
-john
