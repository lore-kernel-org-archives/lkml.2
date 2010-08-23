Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0HWPFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:05:47 -0400
Received: from mail.vyatta.com ([76.74.103.46]:41962 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab0HWPFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:05:45 -0400
Date: Mon, 23 Aug 2010 08:05:43 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Marc Aurele La France <tsi@ualberta.ca>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: RFC:  MTU for serving NFS on Infiniband
Message-ID: <20100823080543.319143e3@nehalam>
In-Reply-To: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca>
References: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 08:44:37 -0600 (MDT)
Marc Aurele La France <tsi@ualberta.ca> wrote:

> My apologies for the multiple post.  I got bit the first time around by my 
> MUA's configuration.
> 
> ----
> 
> Greetings.
> 
> For some time now, the kernel and I have been having an argument over what 
> the MTU should be for serving NFS over Infiniband.  I say 65520, the 
> documented maximum for connected mode.  But, so far, I've been unable to have 
> anything over 32192 remain stable.
> 
> Back in the 2.6.14 -> .15 period, sunrpc's sk_buff allocations were changed 
> from GFP_KERNEL to GFP_ATOMIC (b079fa7baa86b47579f3f60f86d03d21c76159b8 
> mainstream commit).  Understandably, this was to prevent recursion through 
> the NFS and sunrpc code.  This is fine for the most common MTU out there, as 
> the kernel is almost certain to find a free page.  But, as one increases the 
> MTU, memory fragmentation starts to play a role in nixing these allocations.
> 
> These allocation failures ultimately result in sparse files being written 
> through NFS.  Granted, many of my users' application are oblivious to 
> this because they don't check for such errors.  But it would be nice if the 
> kernel were more resilient in this regard.
> 
> For a few months now, I've been running with sunrpc sk_buff allocations using 
> GFP_NOFS instead, which allows for dirty data to be flushed out and still 
> avoids recursion through sunrpc.  With this, I've been able to increase the 
> stable MTU to 32192.  But no further, as eventually there is no dirty data 
> left and memory fragmentation becomes mostly due to yet-to-be-sync'ed 
> filesystem data.  There's also the matter that using GFP_NOFS for this can 
> slow down NFS quite a bit.
> 
> In regrouping for my next tack at this, I noticed that all stack traces go 
> through ip_append_data().  This would be ipv6_append_data() in the IPv6 case.
> A _very_ rough draft that would have ip_append_data() temporarily drop down 
> to a smaller fake MTU follows ...

Why doesn't NFS generate page size fragments?  Does Infiniband or your
device not support this?  Any thing that requires higher order allocation
is going to unstable under load.  Let's fix the cause not the apply bandaid
solution to the symptom.
