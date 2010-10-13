Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0JMKme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 06:42:34 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:10139 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078Ab0JMKmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 06:42:33 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: xen-devel@lists.xensource.com
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        torvalds@linux-foundation.org
In-Reply-To: <1286553657-22110-1-git-send-email-ian.campbell@citrix.com>
References: <1286553657-22110-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 11:29:52 +0100
Message-ID: <1286965792.2003.3270.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] xen: ensure that all event channels start off bound to
 VCPU 0
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=4QByPj+6Iq2k/6L54d+eVKTdgQxdscpRskJJReCfdXo= c=1 sm=0 a=9u17sUOTbNgA:10 a=IkcTkHD0fZMA:10 a=mLnsDVdbAAAA:8 a=tHz9FfFoAAAA:8 a=ZfRw4ET0AAAA:8 a=VwQbUJbxAAAA:8 a=9Ma9n7p-Y1fz5pow1_wA:9 a=a8UwzF-SguYX_kuJMc8A:7 a=b1H3_-aW9z9_KwV-0kJNh9SylgUA:4 a=QEXdDO2ut3YA:10 a=6O0IECtVFhoA:10 a=KciULlu47koA:10 a=LI9Vle30uBYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy,

I think its a bit late for 2.6.36 for this fix. Even though the fix is
pretty obvious and the issue is quite serious if you are unlucky enough
to hit it there seems to have been no reports of anyone seeing it in a
guest domain so I don't think we need to push it in at the last minute.

I plan to send the following to Linus for the 2.6.37 merge window and
request that the fix goes into the various stable trees. Sound good to
you?

The following changes since commit cb655d0f3d57c23db51b981648e452988c0223f9:
  Linus Torvalds (1):
        Linux 2.6.36-rc7

are available in the git repository at:

  git://xenbits.xen.org/people/ianc/linux-2.6.git for-linus/bugfixes

Ian Campbell (1):
      xen: ensure that all event channels start off bound to VCPU 0

 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Thanks,
Ian.

I fleshed out the description a bit since the original post:

On Fri, 2010-10-08 at 17:00 +0100, Ian Campbell wrote:

xen: ensure that all event channels start off bound to VCPU 0

All event channels startbound to VCPU 0 so ensure that cpu_evtchn_mask
is initialised to reflect this. Otherwise there is a race after registering an
event channel but before the affinity is explicitly set where the event channel
can be delivered. If this happens then the event channel remains pending in the
L1 (evtchn_pending) array but is cleared in L2 (evtchn_pending_sel), this means
the event channel cannot be reraised until another event channel happens to
trigger the same L2 entry on that VCPU.
    
sizeof(cpu_evtchn_mask(0))==sizeof(unsigned long*) which is not correct, and
causes only the first 32 or 64 event channels (depending on architecture) to be
initially bound to VCPU0. Use sizeof(struct cpu_evtchn_s) instead.

> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: stable@kernel.org
> ---
>  drivers/xen/events.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 075e709..175e931 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -290,7 +290,7 @@ static void init_evtchn_cpu_bindings(void)
>  	}
>  #endif
>  
> -	memset(cpu_evtchn_mask(0), ~0, sizeof(cpu_evtchn_mask(0)));
> +	memset(cpu_evtchn_mask(0), ~0, sizeof(struct cpu_evtchn_s));
>  }
>  
>  static inline void clear_evtchn(int port)

-- 
Ian Campbell
Current Noise: Sabbat - I For An Eye

The New England Journal of Medicine reports that 9 out of 10 doctors agree
that 1 out of 10 doctors is an idiot.

