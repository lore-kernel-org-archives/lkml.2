Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab1INUW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:22:28 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:37069
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933142Ab1INUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:22:27 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRJ4HT-01-875-02
X-M-MSG: 
Date: Wed, 14 Sep 2011 22:20:15 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V4][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110914202015.GL6063@erda.amd.com>
References: <1315947509-6429-1-git-send-email-dzickus@redhat.com>
 <1315947509-6429-5-git-send-email-dzickus@redhat.com>
 <20110914125640.GT5795@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110914125640.GT5795@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.11 08:56:40, Don Zickus wrote:
> On Tue, Sep 13, 2011 at 04:58:27PM -0400, Don Zickus wrote:
> > 
> > V3:
> >   - redesigned the algorithm to utilize Avi's idea of detecting a back-to-back
> >     NMI with %rip.
> 
> Hi Robert,
> 
> I realized I added an optimization for executing the nmi handlers to help
> minimize the impact on the virt folks and realize it might break your IBS
> stuff.
> 
> > -static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
> > +static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
> >  {
> >  	struct nmi_desc *desc = nmi_to_desc(type);
> >  	struct nmiaction *next_a, *a, **ap = &desc->head;
> > @@ -87,6 +87,16 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
> >  
> >  		handled += a->handler(type, regs);
> >  
> > +		/*
> > + 		 * Optimization: only loop once if this is not a 
> > + 		 * back-to-back NMI.  The idea is nothing is dropped
> > + 		 * on the first NMI, only on the second of a back-to-back
> > + 		 * NMI.  No need to waste cycles going through all the
> > + 		 * handlers.
> > + 		 */
> > +		if (!b2b && handled)
> > +			break;
> > +
> >  		a = next_a;
> >  	}
> >  	rcu_read_unlock();
> 
> The optimization is to run through the handlers until one of them claims
> the NMI but only for the first NMI.  Whereas on the second half of a
> back-to-back NMI, run through all the handlers regardless of how many
> claim they handled it.
> 
> Does your IBS stuff need to always run through two handlers?

As said in my previous answer, it might probably work, but I will test
it.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

