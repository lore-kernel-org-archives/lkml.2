Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab0G0Q3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:29:21 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:11938 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab0G0Q3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:29:19 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Tue, 27 Jul 2010 11:28:54 -0500
From: Scott Wood <scottwood@freescale.com>
To: Paul Mackerras <paulus@samba.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Kumar Gala <kumar.gala@freescale.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Please pull my perf.git urgent branch
Message-ID: <20100727112854.7bf97d48@schlenkerla.am.freescale.net>
In-Reply-To: <20100727124019.GB14947@brick.ozlabs.ibm.com>
References: <20100727124019.GB14947@brick.ozlabs.ibm.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2010 16:28:55.0521 (UTC) FILETIME=[CEAA3D10:01CB2DA8]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 22:40:19 +1000
Paul Mackerras <paulus@samba.org> wrote:

> Please do a pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perf.git urgent
> 
> to get one commit that fixes a problem where, on some Freescale
> embedded PowerPC machines, unprivileged userspace could oops the
> kernel using the perf_event subsystem.  I know it's late, but it is a
> potential security hole (but only on Freescale embedded systems), the
> fix is small (3 lines) and only affects Freescale embedded processors,
> and I was on vacation for the past two weeks. :)
[snip]
> diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
> index 369872f..babccee 100644
> --- a/arch/powerpc/kernel/perf_event_fsl_emb.c
> +++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
> @@ -566,9 +566,9 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
>  	 * Finally record data if requested.
>  	 */
>  	if (record) {
> -		struct perf_sample_data data = {
> -			.period	= event->hw.last_period,
> -		};
> +		struct perf_sample_data data;
> +
> +		perf_sample_data_init(&data, 0);
>  
>  		if (perf_event_overflow(event, nmi, &data, regs)) {
>  			/*

Doesn't the setting of .period need to be maintained (it is in the other
powerpc perf_event implementation that this is derived from)?

I don't see how this is a security fix -- the existing initializer above
should zero-fill the fields that are not explicitly initialized.  In fact,
it's taking other fields that were previously initialized to zero and is
making them uninitialized, since perf_sample_data_init only sets addr and
raw.

CCing linuxppc-dev on the original patch would have been nice...

-Scott

