Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab0LIUUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:20:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab0LIUUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:20:30 -0500
Date: Thu, 9 Dec 2010 15:20:08 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, gorcunov@gmail.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101209202008.GA24143@redhat.com>
References: <20101201195835.GE2511@redhat.com>
 <1291234036.32004.2008.camel@laptop>
 <m162vdp3l4.fsf@fess.ebiederm.org>
 <20101202052321.GH18100@redhat.com>
 <1291275270.4023.20.camel@twins>
 <20101202161502.GL18100@redhat.com>
 <1291764620.2032.1293.camel@laptop>
 <20101208140103.GM21786@redhat.com>
 <1291818005.28378.38.camel@laptop>
 <1291820356.28378.83.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291820356.28378.83.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 03:59:16PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-08 at 15:20 +0100, Peter Zijlstra wrote:
> 
> > > I wonder if you should reverse these checks.  If the bios has the perf
> > > counter enabled, there might be a high chance that it fails the first
> > > check and never gets to the actually bios checks.
> > 
> > Ah, good point. 
> 
> Something like so..

Getting closer...

Pentium4s are special they need the double write, so...

> +	/*
> +	 * Now write a value and read it back to see if it matches,
> +	 * this is needed to detect certain hardware emulators (qemu/kvm)
> +	 * that don't trap on the MSR access and always return 0s.
> +	 */
>  	val = 0xabcdUL;
> -	ret |= checking_wrmsrl(x86_pmu.perfctr, val);
> +	ret = checking_wrmsrl(x86_pmu.perfctr, val);

	if (x86_pmu.perfctr_second_write)
		ret |= checking_wrmsrl(x86_pmu.perfctr, val);


solved my p4 problems for kexec.

>  	ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
>  	if (ret || val != val_new)
> -		return false;
> +		goto msr_fail;
>  
>  	return true;

Cheers,
Don
