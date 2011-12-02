Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1LBKzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 05:55:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab1LBKzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 05:55:48 -0500
Date: Fri, 2 Dec 2011 11:55:39 +0100
From: Petr Holasek <pholasek@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: NUMA x86: add constraints check for nid parameters
Message-ID: <20111202105538.GB2188@dhcp-27-244.brq.redhat.com>
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com>
 <20111201133451.5fc1ee7b.akpm@linux-foundation.org>
 <20111201231441.GA3293@stainedmachine.redhat.com>
 <20111201152851.7e39f034.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201152851.7e39f034.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Dec 2011, Andrew Morton wrote:
> 
> On Fri, 2 Dec 2011 00:14:42 +0100
> Petr Holasek <pholasek@redhat.com> wrote:
> 
> > On Thu, 01 Dec 2011, Andrew Morton wrote:
> > 
> > > On Thu,  1 Dec 2011 12:45:07 +0100
> > > Petr Holasek <pholasek@redhat.com> wrote:
> > > 
> > > > This patch adds constraints checks into __node_distance() and
> > > > numa_set_distance() functions. If from or to parameters are
> > > > lower than zero, it results into oops now.
> > > 
> > > Passing negative numbers into __node_distance() sounds like a bug in
> > > the caller, and this patch will remove our means of detecting that bug.
> > 
> > That's true, but upper boundary is checked now, so why not to check lower?
> 
> Because it adds more code to the kernel and can hide bugs?
> 
> > Seems inconsistent to me - from this point of view even don't check anything
> > would be better for detecting bug in the caller.
> > 
> > > 
> > > Perhaps we need to be told more about this patch.  Is the bug
> > > user-triggerable?  If so, how?  How was this fault triggered? 
> > > Etcetera.
> > > 
> > 
> > AFAIK, neither __node_distance() nor numa_set_distance() aren't in any
> > path from user-space inputs. Their paramaters are based on ACPI tables
> > provided by HW vendors.
> 
> That didn't answer my questions.  Have you observed any problems in
> this code?  If so, please fully describe them.  Or was it purely from
> code inspection?

Code inspection only, nothing from real life.

> 
> If what we're doing here is to be defensive against buggy BIOS tables
> (a good idea) then we should validate the BIOS table values as close as
> possible to the point where they were read frmo the BIOS.  And we should
> (probably) emit a warning if a bad table entry is detected, rather than
> silently fixing it up.

numa_set_distance() does exactly what you described above, only emits a
warning. I agree with your objections with __node_distance() checks, it
really can hide bugs in caller. So silent fix-up is the main problem and
we shouldn't check anything so the caller will be advised when using 
wrong nid by oops with a benefit of less code for us. Do I understand your
opinion on this type of code?
