Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab1ANQbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:31:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23416 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab1ANQa7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 14 Jan 2011 11:30:59 -0500
Date: Fri, 14 Jan 2011 11:28:45 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        williams@redhat.com, schwidefsky@de.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] acpi/pm: If failed at validating ACPI PM timer,
 inhibit future reads.
Message-ID: <20110114162845.GB12102@dumpdata.com>
References: <20110111083054.GB22867@shutemov.name>
 <alpine.LFD.2.00.1101110936291.12146@localhost6.localdomain6>
 <20110111095640.GC22867@shutemov.name>
 <20110113174909.GA28738@dumpdata.com>
 <1294941698.5617.12.camel@work-vm>
 <20110113214022.GA12097@dumpdata.com>
 <alpine.LFD.2.00.1101132301300.2678@localhost6.localdomain6>
 <20110114140941.GA3062@dumpdata.com>
 <1295019849.2655.8.camel@work-vm>
 <1295020487.2655.17.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295020487.2655.17.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 07:54:47AM -0800, john stultz wrote:
> On Fri, 2011-01-14 at 07:44 -0800, john stultz wrote:
> > I'm actually looking at a different fix, as I'm worried by Thomas'
> > comment about hitting the same issue on real hardware if we catch the
> > same pmtrm value both times.
> 
> Konrad: Mind trying the following?
> 
> 
> The conditional (!hpet && !ref_start && !ref_stop) doesn't really make
> sense. If the refs are null, but hpet is on, we still want to break out.
> 
> So checking if both the ref values are the same should handle if we
> don't have hardware (both null) or if they are the same value (either by
> invalid hardware, or by chance), which can cause a divzero issue.
> 
> NOT FOR INCLUSION, I haven't had my coffee yet.
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Works great. (I pulled out my patch to test this).

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 823f79a..fa2cb5e 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -935,7 +935,7 @@ static void tsc_refine_calibration_work(struct work_struct *work)
>  	tsc_stop = tsc_read_refs(&ref_stop, hpet);
>  
>  	/* hpet or pmtimer available ? */
> -	if (!hpet && !ref_start && !ref_stop)
> +	if (ref_start == ref_stop)
>  		goto out;
>  
>  	/* Check, whether the sampling was disturbed by an SMI */
> 
> 
> 
