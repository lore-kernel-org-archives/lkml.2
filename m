Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1JLM3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:29:44 -0400
Received: from smtp-cpk.frontbridge.com ([204.231.192.41]:54889 "EHLO
	WA2EHSNDR003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753173Ab1JLM3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:29:41 -0400
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: -11
X-BigFish: VS-11(z21eNz14e0M98dKzz1202h1082kzzz2dh87h2a8h668h839h944h41h42h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:94.101.220.16;KIP:(null);UIP:(null);IPVD:NLI;H:nzt0015e.dknz.nzcorp.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 12 Oct 2011 14:29:33 +0200
From: Anders Ossowicki <aowi@novozymes.com>
To: Dave Chinner <david@fromorbit.com>
CC: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aradford@gmail.com" <aradford@gmail.com>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
Message-ID: <20111012122933.GA3719@otto.nzcorp.net>
Reply-To: <aowi@novozymes.com>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"aradford@gmail.com" <aradford@gmail.com>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>
References: <20111011091757.GA32589@otto.nzcorp.net>
 <20111011133448.GA10692@infradead.org>
 <20111011141338.GA11808@otto.nzcorp.net>
 <20111012003526.GI3159@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111012003526.GI3159@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SMTP-Mail-From: aowi@otto.nzcorp.net
X-OriginatorOrg: novozymes.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 02:35:26AM +0200, Dave Chinner wrote:
> Memory corruption can be caused by more than just a bad memory
> stick. You've got a brand new driver running your brand new
> controller and it may still have bugs - it might be scribbling over
> memory it doesn't own because of off-by-one index errors, etc. It's
> much more likely that that new hardware or driver code is the cause
> of your problem than an undetected ECC memory error or core VM
> problem.
Ah, now that I agree on. A few more observations from today's experiments:

First of all, there are two MegaRAID controllers in the machine. The 
old'n'reliable 8888ELP and the new'n'wonky 9285-8e. Both are using the megaraid
driver and the 8888ELP card ran with the megaraid driver prior to the 
refactoring that introduced support for 9285-8e without a hitch for about a
year.

We've gotten to a point where we can reliably reproduce this by running certain
queries in postgresql when data from the disk is cached. E.g 
 foo=# select count(*) from foo.sequence;
 ERROR:  invalid page header in block 529134 of relation base/16385/58318945

If we echo 3 >/proc/sys/vm/drop_caches and reload postgres, the same queries
work. This does indeed smell like memory corruption.

The 9285-8e controller has FastPath enabled.

> FWIW, if it's a repeatable problem, you might want to update the
> driver and controller firmware to something more recent and see if
> that solves the problem....
I upgraded the firmware (post-accident) but we're still seeing the corruption.
-- 
Anders

