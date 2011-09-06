Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1IFRuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:50:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab1IFRuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:50:00 -0400
Date: Tue, 6 Sep 2011 13:49:38 -0400
From: Don Zickus <dzickus@redhat.com>
To: Corey Minyard <minyard@acm.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        Jason Wessel <jason.wessel@windriver.com>,
        Andi Kleen <ak@linux.intel.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [V3][PATCH 3/6] x86, nmi: wire up NMI handlers to new routines
Message-ID: <20110906174938.GP6838@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
 <1314290748-23569-4-git-send-email-dzickus@redhat.com>
 <4E665653.7070807@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E665653.7070807@acm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 12:20:19PM -0500, Corey Minyard wrote:
> >+ipmi_nmi(unsigned int val, struct pt_regs *regs)
> >  {
> >-	struct die_args *args = data;
> >-
> >-	if (val != DIE_NMIUNKNOWN)
> >-		return NOTIFY_OK;
> >-
> >-	/* Hack, if it's a memory or I/O error, ignore it. */
> >-	if (args->err&  0xc0)
> >-		return NOTIFY_OK;
> >-
> >  	/*
> >  	 * If we get here, it's an NMI that's not a memory or I/O
> >  	 * error.  We can't truly tell if it's from IPMI or not
> From the comment above, this will not actually work for the IPMI
> watchdog.  The only way to tell if an NMI is from the IPMI
> controller is to send a message to the IPMI controller and wait for
> the response.  Not an option in an NMI handler.  So the IPMI
> watchdog driver relied on it being last, and if nothing else handled
> the NMI, then it must have been from the IPMI controller.
> 
> This is stupid, I know, but that's the way it works in IPMI.  If we
> decide to do what you are suggesting we will have to disable this
> function in the IPMI watchdog driver or we need some way to say "if
> nothing else handled the NMI, call this."

Hi Corey,

Thanks for the review.

I know and you aren't the only driver that has an issue like this, hpwdt
is in the same boat.  This is why I registered the driver against
NMI_UNKNOWN instead of NMI_LOCAL.  The ipmi driver should only be called
when no one else claims the NMI (including a possible external one).

The only drivers I know that have to do it this way are hpwdt, sgi and
ipmi.  By design, none of those drivers should be loaded at the same time
(as they are all uniquely hardware specific).

BTW, this is also why I removed the 'Hack, if it's a memory or I/O error',
because the ipmi handler should not be called for an external NMI now.

I hope that clears things up.

Cheers,
Don
