Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab1LGTkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:40:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226Ab1LGTk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:40:28 -0500
Date: Wed, 7 Dec 2011 20:40:22 +0100
From: Petr Holasek <pholasek@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: NUMA x86: add constraints check for nid parameters
Message-ID: <20111207194021.GA26060@dhcp-27-244.brq.redhat.com>
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com>
 <20111201133451.5fc1ee7b.akpm@linux-foundation.org>
 <20111201231441.GA3293@stainedmachine.redhat.com>
 <20111201152851.7e39f034.akpm@linux-foundation.org>
 <20111202105538.GB2188@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112061233330.28251@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112061233330.28251@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Dec 2011, David Rientjes wrote:

> 
> On Fri, 2 Dec 2011, Petr Holasek wrote:
> 
> > > > > > This patch adds constraints checks into __node_distance() and
> > > > > > numa_set_distance() functions. If from or to parameters are
> > > > > > lower than zero, it results into oops now.
> > > > > 
> > > > > Passing negative numbers into __node_distance() sounds like a bug in
> > > > > the caller, and this patch will remove our means of detecting that bug.
> > > > 
> > > > That's true, but upper boundary is checked now, so why not to check lower?
> > > 
> > > Because it adds more code to the kernel and can hide bugs?
> > > 
> 
> The upper bound is checked to ensure that we don't dereference past end of 
> the array that stores the distance table, so it will catch errors for 
> things like memory hotplug when additional nodes are onlined and the data 
> structure isn't updated accordingly.

Thanks for clarification, I missed this case.

> 
> > > If what we're doing here is to be defensive against buggy BIOS tables
> > > (a good idea) then we should validate the BIOS table values as close as
> > > possible to the point where they were read frmo the BIOS.  And we should
> > > (probably) emit a warning if a bad table entry is detected, rather than
> > > silently fixing it up.
> > 
> > numa_set_distance() does exactly what you described above, only emits a
> > warning. I agree with your objections with __node_distance() checks, it
> > really can hide bugs in caller. So silent fix-up is the main problem and
> > we shouldn't check anything so the caller will be advised when using 
> > wrong nid by oops with a benefit of less code for us. Do I understand your
> > opinion on this type of code?
> 
> I'd have no objection to adding a check to numa_set_distance() to ensure 
> the node ids are non-negative in the same way we check that the distances 
> themselves are non-negative; that can catch errors when pxms are used 
> uninitialized when parsing the SRAT.  However, I think adding the check to 
> __node_distance() is unnecessary.

Ok, I'll try v2 without __node_distance()
