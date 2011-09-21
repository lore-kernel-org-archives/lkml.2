Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1IUKJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:09:25 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:50871
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab1IUKJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:09:23 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRVAVG-01-05F-02
X-M-MSG: 
Date: Wed, 21 Sep 2011 12:08:42 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110921100842.GA6063@erda.amd.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
 <1316529792-6560-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316529792-6560-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.09.11 10:43:10, Don Zickus wrote:
> @@ -87,6 +87,16 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
>  
>  		handled += a->handler(type, regs);
>  
> +		/*
> + 		 * Optimization: only loop once if this is not a 
> + 		 * back-to-back NMI.  The idea is nothing is dropped
> + 		 * on the first NMI, only on the second of a back-to-back
> + 		 * NMI.  No need to waste cycles going through all the
> + 		 * handlers.
> + 		 */
> +		if (!b2b && handled)
> +			break;

In rare cases we will lose nmis here.

We see a back-to-back nmi in the case if a 2 nmi source triggers
*after* the nmi handler is entered. Depending on the internal cpu
timing influenced by microcode and SMM code execution, the nmi may not
entered immediately. So all sources that trigger *before* the nmi
handler is entered raise only one nmi with no subsequent nmi.

However, as these cases should be very rare, I think we can live with
it in favor of the optimization to jump out the handler chain and save
lot of cpu cycles esp. in the case of heavy PMI load.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

