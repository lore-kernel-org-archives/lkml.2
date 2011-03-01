Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab1CARS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:18:57 -0500
Received: from smtp-out.google.com ([74.125.121.67]:55880 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab1CARSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=QazxMhyQO1ybYQww++fXDOxL7wu8IkwDWACzh57TNaG4T6D4cHI+KCVJZou+NkkJ1I
         AFE2SemnCS2yXKoyKLLQ==
Date: Tue, 1 Mar 2011 09:18:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL tip:x86/mm]
In-Reply-To: <4D66B176.9030300@kernel.org>
Message-ID: <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Yinghai Lu wrote:

> DavidR reported that x86/mm broke his numa emulation with 128M etc.
> 
> So wonder if that would hold you to push whole tip/x86/mm to Linus for .39
> or need to rebase it while taking the tip/x86/numa-emulation-unify out.
> 

Ok, so 1f565a896ee1 (x86-64, NUMA: Fix size of numa_distance array) fixes 
the boot failure when using numa=fake, but there's still another issue 
that was introduced with regard to emulated distances between fake nodes 
sitting hardware using a SLIT.

This is important because we want to ensure that the physical topoloy of 
the machine is still represented in an emulated environment to 
appropriately describe the expected latencies between the nodes.  It also 
allows users who are using numa=fake purely as a debugging tool to test 
more interesting configurations and benchmark memory accesses between 
emulated nodes as though they were real.

For example, on my four-node system with a custom SLIT, this is the 
distance when booting without numa=fake:

	$ cat /sys/devices/system/node/node*/distance 
	10 20 20 30
	20 10 20 20
	20 20 10 20
	30 20 20 10

These physical nodes are all symmetric in size.

With numa=fake=16, we expect to see the fake nodes interleaved (as the 
default) over the set of physical nodes.  This would suggest distance 
files for these nodes to be:

	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20
	20 20 10 20 20 20 10 20 20 20 10 20 20 20 10 20
	30 20 20 10 30 20 20 10 30 20 20 10 30 20 20 10
	10 20 20 30 10 20 20 30 10 20 20 30 10 20 20 30
	20 10 20 20 20 10 20 20 20 10 20 20 20 10 20 20

(And that is what we see with 2.6.37.)

However, x86/mm describes these distances differently:

	node0/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
	node1/distance:10 10 20 20 10 20 20 20 10 20 20 20 10 20 20 20
	node2/distance:10 20 10 20 10 20 20 20 10 20 20 20 10 20 20 20
	node3/distance:10 20 20 10 10 20 20 20 10 20 20 20 10 20 20 20
	node4/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
	node5/distance:10 20 20 20 10 10 20 20 10 20 20 20 10 20 20 20
	node6/distance:10 20 20 20 10 20 10 20 10 20 20 20 10 20 20 20
	node7/distance:10 20 20 20 10 20 20 10 10 20 20 20 10 20 20 20
	node8/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
	node9/distance:10 20 20 20 10 20 20 20 10 10 20 20 10 20 20 20
	node10/distance:10 20 20 20 10 20 20 20 10 20 10 20 10 20 20 20
	node11/distance:10 20 20 20 10 20 20 20 10 20 20 10 10 20 20 20
	node12/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 20
	node13/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 10 20 20
	node14/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 10 20
	node15/distance:10 20 20 20 10 20 20 20 10 20 20 20 10 20 20 10

It looks as though the emulation changes sitting in x86/mm have dropped 
the SLIT and are merely describing the emulated nodes as either having 
physical affinity or not.
