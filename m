Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1JBKIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 06:08:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab1JBKH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 06:07:57 -0400
Message-ID: <4E8837D4.5040607@redhat.com>
Date: Sun, 02 Oct 2011 12:07:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Robert Richter <robert.richter@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V6][PATCH 4/6] x86, nmi:  add in logic to handle multiple events
 and unknown NMIs
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com> <1316805435-14832-5-git-send-email-dzickus@redhat.com> <20110928103140.GD6063@erda.amd.com> <20110928123720.GL5795@redhat.com>
In-Reply-To: <20110928123720.GL5795@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 03:37 PM, Don Zickus wrote:
> On Wed, Sep 28, 2011 at 12:31:40PM +0200, Robert Richter wrote:
> >  On 23.09.11 15:17:13, Don Zickus wrote:
> >  >  @@ -89,6 +89,15 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
> >  >
> >  >   		handled += a->handler(type, regs);
> >  >
> >  >  +		/*
> >  >  + 		 * Optimization: only loop once if this is not a
> >  >  + 		 * back-to-back NMI.  The idea is nothing is dropped
> >  >  + 		 * on the first NMI, only on the second of a back-to-back
> >  >  + 		 * NMI.  No need to waste cycles going through all the
> >  >  + 		 * handlers.
> >  >  + 		 */
> >  >  +		if (!b2b&&  handled)
> >  >  +			break;
> >
> >  I don't think we can leave this in. As said, there are cases that 2
> >  nmis trigger but the handler is called only once. Only the first would
> >  be handled then, and the second get lost cause there is no 2nd nmi
> >  call.
>
> Right.  Avi, Jeremy what was your objection that needed this optimization
> in the first place?
>

First, iterating over all NMI sources is going to be slow, and a lot 
more so in a guest.  This reduces the performance of perf.

Second, I wanted to use NMIs as a way of waking up a vcpu sleeping with 
interrupts disabled (in the context of Jeremy's paravirt spinlock 
patches).  Looks like we'll have to use paravirtualization for that.

-- 
error compiling committee.c: too many arguments to function

