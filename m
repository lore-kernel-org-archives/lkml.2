Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab0HSKqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:46:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:42741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab0HSKqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:46:10 -0400
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100817152225.GQ26154@erda.amd.com>
References: <20100804151858.GB5130@lenovo>
	 <20100804155002.GS3353@redhat.com> <20100804161046.GC5130@lenovo>
	 <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo>
	 <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo>
	 <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com>
	 <20100809194829.GB26154@erda.amd.com> <20100817152225.GQ26154@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Aug 2010 12:45:53 +0200
Message-ID: <1282214753.1926.4669.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 17:22 +0200, Robert Richter wrote:
> +       this_nmi = percpu_read(irq_stat.__nmi_count);
> +       if (handled > 1)
> +               goto mark_nmi;
> +       if ((__get_cpu_var(nmi).marked == this_nmi)
> +           && (__get_cpu_var(nmi).handled > 1))
> +               /*
> +                * We could have two subsequent back-to-back nmis: The
> +                * first handles more than one counter, the 2nd
> +                * handles only one counter and the 3rd handles no
> +                * counter.
> +                *
> +                * This is the 2nd nmi because the previous was
> +                * handling more than one counter. We will mark the
> +                * next (3rd) and then drop it if unhandled.
> +                */
> +               goto mark_nmi;
> +
> +       /* this may not trigger back-to-back nmis */
> +       return NOTIFY_STOP;
> +
> + mark_nmi:
> +       /* the next nmi could be a back-to-back nmi */
> +       __get_cpu_var(nmi).marked       = this_nmi + 1;
> +       __get_cpu_var(nmi).handled      = handled;
>  
>         return NOTIFY_STOP;
>  } 

I queued it with that part changed to:

+       this_nmi = percpu_read(irq_stat.__nmi_count);
+       if ((handled > 1) ||
+               /* the next nmi could be a back-to-back nmi */
+           ((__get_cpu_var(nmi).marked == this_nmi) &&
+            (__get_cpu_var(nmi).handled > 1))) {
+               /*
+                * We could have two subsequent back-to-back nmis: The
+                * first handles more than one counter, the 2nd
+                * handles only one counter and the 3rd handles no
+                * counter.
+                *
+                * This is the 2nd nmi because the previous was
+                * handling more than one counter. We will mark the
+                * next (3rd) and then drop it if unhandled.
+                */
+               __get_cpu_var(nmi).marked       = this_nmi + 1;
+               __get_cpu_var(nmi).handled      = handled;
+       }

        return NOTIFY_STOP;
 }


