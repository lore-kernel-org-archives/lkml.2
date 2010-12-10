Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab0LJUtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:49:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49074 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab0LJUta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:49:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OH0jL1sRVucYkJm4dOYEHSSWmmSCvRTSubJZMAyx/pz8izUx0gn4egsWKi6xl5mNRd
         e25J9cwgVVzO/Kf+N056V625C6zsuJtvJtwr3MoS4cNc5vXP2u0b66+EzTsIGl5/8gH+
         XaYcaVPcn5abv3qPXOM19bDFoD7UivePDCrCE=
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <1292013590.2746.2.camel@edumazet-laptop>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	 <1291851079-27061-1-git-send-email-venki@google.com>
	 <1291899120.29292.7.camel@twins>
	 <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
	 <1291917330.6803.7.camel@twins>
	 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
	 <1291920939.6803.38.camel@twins>
	 <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
	 <1291936593.13513.3.camel@laptop>
	 <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
	 <1291975704.6803.59.camel@twins>  <1291987065.6803.151.camel@twins>
	 <1291987635.6803.161.camel@twins>  <1291988866.6803.171.camel@twins>
	 <1292001500.3580.268.camel@edumazet-laptop>
	 <1292003346.13513.30.camel@laptop>
	 <1292004859.3580.387.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1012101236300.13986@router.home>
	 <1292006788.13513.43.camel@laptop>
	 <alpine.DEB.2.00.1012101344570.13986@router.home>
	 <1292011644.13513.61.camel@laptop>
	 <alpine.DEB.2.00.1012101410571.13986@router.home>
	 <1292013590.2746.2.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 21:49:25 +0100
Message-ID: <1292014165.2746.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 10 décembre 2010 à 21:39 +0100, Eric Dumazet a écrit :

> This was exactly my suggestion Christoph.
> 
> I am glad you understand it now.
> 
> 

By the way, we need smp_wmb(), not barrier(), even only the "owner cpu"
can write into its 'percpu' seqcount.

There is nothing special about a seqcount being percpu or a 'global'
one. We must have same memory barrier semantics.

	this_cpu_write_seqcount_begin(&myseqcount);
	this_cpu_add(mydata1, add1);
	this_cpu_add(mydata2, add2);
	this_cpu_inc(mydata3);
	this_cpu_write_seqcount_end(&myseqcount);

We protect the data[1,2,3] set with a seqcount, so need smp_wmb() in
both _begin() and _end()



