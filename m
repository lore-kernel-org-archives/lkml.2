Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab1IUN6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:58:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab1IUN6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:58:10 -0400
Date: Wed, 21 Sep 2011 09:57:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110921135717.GO5795@redhat.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
 <1316529792-6560-5-git-send-email-dzickus@redhat.com>
 <4E79799D.4040507@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E79799D.4040507@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 01:43:57PM +0800, Huang Ying wrote:
> On 09/20/2011 10:43 PM, Don Zickus wrote:
> [snip]
> > @@ -313,7 +359,31 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> >  	}
> >  	raw_spin_unlock(&nmi_reason_lock);
> >  
> > -	unknown_nmi_error(reason, regs);
> > +	/*
> > +	 * Only one NMI can be latched at a time.  To handle
> > +	 * this we may process multiple nmi handlers at once to
> > +	 * cover the case where an NMI is dropped.  The downside
> > +	 * to this approach is we may process an NMI prematurely,
> > +	 * while its real NMI is sitting latched.  This will cause
> > +	 * an unknown NMI on the next run of the NMI processing.
> > +	 * 
> > +	 * We tried to flag that condition above, by setting the
> > +	 * swallow_nmi flag when we process more than one event.
> > +	 * This condition is also only present on the second half
> > +	 * of a back-to-back NMI, so we flag that condition too.
> > +	 *
> > +	 * If both are true, we assume we already processed this
> > +	 * NMI previously and we swallow it.  Otherwise we reset
> > +	 * the logic.
> > +	 *
> > +	 * I am sure there are scenarios where we accidentally
> > +	 * swallow a real 'unknown' NMI.  But this is the best
> > +	 * we can do for now.
> 
> Why not describe a scenario where we swallow a real 'unknown' NMI?  So
> that someone working on the code in the future will know the challenge?

I can add a couple of lines of comment for that.

Thanks,
Don
