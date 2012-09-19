Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab2ISTQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:16:43 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:18512 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab2ISTQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:16:38 -0400
Message-ID: <1348082193.2707.64.camel@lorien2>
Subject: Re: [PATCH] dma-debug: New interfaces to debug dma mapping errors
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Greg KH <greg@kroah.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, bhelgaas@google.com,
        stern@rowland.harvard.edu, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org, shuahkhan@gmail.com
Date: Wed, 19 Sep 2012 13:16:33 -0600
In-Reply-To: <20120919130859.GR2505@amd.com>
References: <1347843171.4370.13.camel@lorien2>
	 <20120917133937.GC11553@phenom.dumpdata.com>
	 <1347897172.3227.61.camel@lorien2>
	 <20120917172317.GB15783@phenom.dumpdata.com>
	 <1347921915.3227.143.camel@lorien2> <20120918133414.GM2505@amd.com>
	 <1347997369.2747.68.camel@lorien2> <20120919130859.GR2505@amd.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 15:08 +0200, Joerg Roedel wrote:
> On Tue, Sep 18, 2012 at 01:42:49PM -0600, Shuah Khan wrote:
> > Are you ok with the system wide and per device error counts I added? Any
> > comments on the overall approach?
> 
> The general approach of having error counters is fine. But the addresses
> allocated/addresses checked thing should be done per allocation and not
> with counter comparison for several reasons:
> 
> 	1. When doing it per-allocation we know exactly which allocation
> 	   was not checked and can tell the driver developer. The code
> 	   saves stack-traces for that. This is much more useful than
> 	   telling the developer 'somewhere you do not check your
> 	   dma-handles'
Right. It would point directly the actual mapping instead of a blind
count.

> 
> 	2. Checking this per-allocation gives you the per-device and
> 	   also the per-driver checking you want.

Yes it would.
> 
> 	3. You don't need to change 'struct device' for that.

Right - heard from others as well on this one :)

> 
> There are more reasons, like that this approach fits a lot better to the
> general idea of the DMA-API debugging code.
> 
> > The approach you suggested will cover the cases where drivers fail to
> > check good map cases. We won't able to catch failed maps that get used
> > without checks. Are you not concerned about these cases? These could
> > cause a silent error with wild writes or could bring the system down. Or
> > are you recommending changing the infrastructure to track failed maps as
> > well?
> 
> It is fine to only check the good-map cases. Think about what
> DMA-debugging is good for: It is a tool for driver developers to find
> bugs in their code they wouldn't notice otherwise. An unchecked bad-map
> case is a bug they would notice otherwise. So if we check only the
> good-map cases and warn the driver developers about non-checked
> addresses they fix it and make the drivers more robust against failed
> allocations, fixing also the bad-map cases.

ok makes sense now that understand the scope of the dma-debug api. Here
is what I will do then, do checks on good maps. With that scope, there
is no need for another table.

> 
> > I am still pursuing a way to track failed map cases. I combined the flag
> > idea with one of the ideas I am looking into. Details below: (if this
> > sounds like a reasonable approach, I can do v2 patch and we can discuss
> > the code)
> 
> Why do you want to track the bad-map cases?

I am still concerned about data corruption type issues that will be hard
to debug and hoping having a error count might be an indicator. However,
I agree with what you said about not having the actual mapping
association is not very useful.

-- Shuah

