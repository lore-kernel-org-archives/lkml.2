Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1HPMQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 08:16:15 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50428 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1HPMQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 08:16:14 -0400
Date: Tue, 16 Aug 2011 14:16:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        melwyn lobo <linux.melwyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 memcpy performance
Message-ID: <20110816121604.GA29251@aftab>
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
 <20110812195220.GA29051@elte.hu>
 <20110814095910.GA18809@liondog.tnic>
 <6296.1313462075@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <6296.1313462075@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 15, 2011 at 10:34:35PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 14 Aug 2011 11:59:10 +0200, Borislav Petkov said:
> 
> > Benchmarking with 10000 iterations, average results:
> > size    XM              MM              speedup
> > 119     540.58          449.491         0.8314969419
> 
> > 12273   2307.86         4042.88         1.751787902
> > 13924   2431.8          4224.48         1.737184756
> > 14335   2469.4          4218.82         1.708440514
> > 15018   2675.67         1904.07         0.711622886
> > 16374   2989.75         5296.26         1.771470902
> > 24564   4262.15         7696.86         1.805863077
> > 27852   4362.53         3347.72         0.7673805572
> > 28672   5122.8          7113.14         1.388524413
> > 30033   4874.62         8740.04         1.792967931
> 
> The numbers for 15018 and 27852 are *way* odd for the MM case. I don't feel
> really good about this till we understand what happened for those two cases.

Yep.

> Also, anytime I see "10000 iterations", I ask myself if the benchmark
> rigging took proper note of hot/cold cache issues. That *may* explain
> the two oddball results we see above - but not knowing more about how
> it was benched, it's hard to say.

Yeah, the more scrutiny this gets the better. So I've cleaned up my
setup and have attached it.

xm_mem.c does the benchmarking and in bench_memcpy() there's the
sse_memcpy call which is the SSE memcpy implementation using inline asm.
It looks like gcc produces pretty crappy code here because if I replace
the sse_memcpy call with xm_memcpy() from xm_memcpy.S - this is the
same function but in pure asm - I get much better numbers, sometimes
even over 2x. It all depends on the alignment of the buffers though.
Also, those numbers don't include the context saving/restoring which the
kernel does for us.

7491    1509.89         2346.94         1.554378381
8170    2166.81         2857.78         1.318890326
12277   2659.03         4179.31         1.571744176
13907   2571.24         4125.7          1.604558427
14319   2638.74         5799.67         2.19789466	<----
14993   2752.42         4413.85         1.603625603
16371   3479.11         5562.65         1.59887055

So please take a look and let me know what you think.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

--Nq2Wo0NMKNjxTN9z
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="sse_memcpy.tar.bz2"
Content-Transfer-Encoding: base64

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

--Nq2Wo0NMKNjxTN9z--
