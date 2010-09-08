Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0IHW2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 18:28:02 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61491 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab0IHW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 18:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RdSEDb/ObtYiY1CcO9RBMdKl8I4g/DKtILOCARkJvRh8JAxWLD9+kyqMrx/WDxSF5V
         hYil8+VBzd77pDS2PRkzGleKV6PbZr5asGCOJRaGbGaBJ/EFeVpNo6eExSovJnbAWnOA
         Gk6hMINPxbbLnq7mNbORKmHKnrts0xSCpFK2k=
Date: Thu, 9 Sep 2010 02:27:51 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/8] sdhci: Move real work out of an atomic context
Message-ID: <20100908222751.GA23068@oksana.dev.rtsoft.ru>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
 <20100907153813.936db0c6.akpm@linux-foundation.org>
 <20100908213740.GA7550@void.printf.net>
 <20100908215750.GA17232@oksana.dev.rtsoft.ru>
 <20100908220548.GA7967@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100908220548.GA7967@void.printf.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 11:05:48PM +0100, Chris Ball wrote:
> Hi Anton,
> 
> On Thu, Sep 09, 2010 at 01:57:50AM +0400, Anton Vorontsov wrote:
> > Thanks!
> > 
> > Would be also great if you could point out which patch causes
> > most of the performance drop (if any)?
> > 
> > Albert, if you could find time, can you also "bisect" the
> > patchset? I wouldn't want to buy Nintendo WII just to debug the
> > perf regression. ;-) FWIW, I tried to disable multiblock
> > read/writes and test with SD cards, and still didn't notice
> > any performance drops.
> > 
> > Maybe it's SDIO IRQs that cause the performance drop for the
> > WII case, as we delay them a little bit? Or it could be the
> > patch that introduces threaded IRQ handler in whole causes
> > it. If so, I guess we'd need to move some of the processing to
> > the real IRQ context, keeping the handler lockless (if
> > possible) or introducing a very fine grained locking.
> 
> I didn't know anything about a reported performance drop, and I don't
> think Andrew did either -- Albert's test results don't seem to have
> made it to this list, or anywhere else that I can see.  Could you 
> link to/repost his comments?
> 
> (I'll be testing with libertas, so that will stress-test SDIO IRQs.)

Sure thing, here are Albert's results.

----- Forwarded message from Albert Herranz <albert_herranz@yahoo.es> -----

Date: Mon, 02 Aug 2010 21:23:51 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
	ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu,
	w.sang@pengutronix.de, mb@bu3sch.de
Subject: Re: + sdhci-use-work-structs-instead-of-tasklets.patch added to -mm
	tree

Hi,

Some initial numbers regarding performance. The patchset seems to cause a noticeable performance drop.
I've run two iperf client tests (see the two invocations of iperf -c) and two iperf server tests (see iperf -s invocation).

== 2.6.33 ==

$ iperf -c 192.168.1.130 
------------------------------------------------------------
Client connecting to 192.168.1.130, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.127 port 40119 connected with 192.168.1.130 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.1 sec  1.05 MBytes    872 Kbits/sec

$ iperf -c 192.168.1.130 
------------------------------------------------------------
Client connecting to 192.168.1.130, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.127 port 40120 connected with 192.168.1.130 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.04 MBytes    870 Kbits/sec

$ iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.127 port 5001 connected with 192.168.1.130 port 36691
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.2 sec  3.61 MBytes  2.98 Mbits/sec
[  5] local 192.168.1.127 port 5001 connected with 192.168.1.130 port 36692
[  5]  0.0-10.1 sec  4.94 MBytes  4.09 Mbits/sec


== 2.6.33 + "sdhci: Move real work out of an atomic context" patchset ==

$ iperf -c 192.168.1.130 
------------------------------------------------------------
Client connecting to 192.168.1.130, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.127 port 39210 connected with 192.168.1.130 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec    368 KBytes    301 Kbits/sec

$ iperf -c 192.168.1.130 
------------------------------------------------------------
Client connecting to 192.168.1.130, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.127 port 39211 connected with 192.168.1.130 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.2 sec    440 KBytes    354 Kbits/sec

$ iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.127 port 5001 connected with 192.168.1.130 port 57833
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.2 sec  2.37 MBytes  1.95 Mbits/sec
[  5] local 192.168.1.127 port 5001 connected with 192.168.1.130 port 57834
[  5]  0.0-10.2 sec  2.30 MBytes  1.90 Mbits/sec

The subjective feeling is too that the system is slower.

Cheers,
Albert

----- End forwarded message -----
