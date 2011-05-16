Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1EPMdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:33:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12821 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab1EPMdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=F2rkA+dtSVeV/LhLlC57EpdeZBNnK81EdAnGDUjMrogCaTAZ9zYFLFE6LECUwhm+pm
         sRywjbt+moUfC/L7oe9w==
MIME-Version: 1.0
In-Reply-To: <1305539020.2466.4063.camel@twins>
References: <20110503092846.022272244@google.com> <20110503092904.806273470@google.com>
 <1305539020.2466.4063.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Mon, 16 May 2011 05:32:31 -0700
Message-ID: <BANLkTinba-p6FJNYAPyE+B8A==vSfK1-rg@mail.gmail.com>
Subject: Re: [patch 04/15] sched: validate CFS quota hierarchies
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 2:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
> > This behavior may be disabled (allowing child bandwidth to exceed parent) via
> > kernel.sched_cfs_bandwidth_consistent=0
>
> why? this needs very good justification.

I think it was lost in other discussion before, but I think there are
two useful use-cases for it:

Posting (condensed) relevant snippet:
-----------------------------------------------------------
Consider:

- I have some application that I want to limit to 3 cpus
I have a 2 workers in that application, across a period I would like
those workers to use a maximum of say 2.5 cpus each (suppose they
serve some sort of co-processor request per user and we want to
prevent a single user eating our entire limit and starving out
everything else).

The goal in this case is not preventing increasing availability within a
given limit, while not destroying the (relatively) work-conserving aspect of
its performance in general.

(...)

- There's also the case of managing an abusive user, use cases such
as the above means that users can usefully be given write permission
to their relevant sub-hierarchy.

If the system size changes, or a user becomes newly abusive then being
able to set non-conformant constraint avoids the adversarial problem of having
to find and bring all of their set (possibly maliciously large) limits
within the global limit.
-----------------------------------------------------------
(Previously: https://lkml.org/lkml/2011/2/24/477)
