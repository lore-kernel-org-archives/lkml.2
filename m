Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0CZVsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:48:47 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:31114 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab0CZVsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:48:45 -0400
Date: Fri, 26 Mar 2010 14:46:49 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Yury Polyanskiy <ypolyans@princeton.edu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100326214648.GF9984@mail.oracle.com>
Mail-Followup-To: Yury Polyanskiy <ypolyans@princeton.edu>,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
	john stultz <johnstul@us.ibm.com>,
	Jan Glauber <jan.glauber@de.ibm.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323233611.6dcbe4f4@penta.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0207.4BAD2B90.0065:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 11:36:11PM -0400, Yury Polyanskiy wrote:
> Second, and more importantly, loops_per_jiffy has little to do with the conversion from the
> the time scale of get_cycles() (aka rdtsc) to the time scale of jiffies.

	It used to!  Fundamentally, of course, we didn't have a
monotonic clock everywhere that satisfied hangcheck-timer's needs.  So
we had to use different approaches on different architectures.

> @@ -130,7 +129,9 @@ extern unsigned long long monotonic_clock(void);
>  #else
>  static inline unsigned long long monotonic_clock(void)
>  {
> -	return get_cycles();
> +	struct timespec ts;
> +	getrawmonotonic(&ts);
> +	return timespec_to_ns(&ts);
>  }
>  #endif  /* HAVE_MONOTONIC */

	I have two questions:

1) Does getrawmonotonic() satisfy hangcheck-timer?  What I mean is, will
it always return the wallclock nanoseconds even in the face of CPU speed
changes, suspend, udelay, or any other suspension of kernel operation?
Yes, I know this is a tougher standard than rdtsc(), but this is what
hangcheck-timer wants.  rdtsc() at least satisfied udelay and PCI hangs.

2) If it does satisfy, why not use it for all hangcheck usage instead of
any ifdefs?

Joel

-- 

"The cynics are right nine times out of ten."  
        - H. L. Mencken

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
