Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1I0QUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:20:16 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25440 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1I0QUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:20:15 -0400
MIME-Version: 1.0
Message-ID: <f42e2a83-15f6-4767-a7df-8a23ceac239e@default>
Date: Tue, 27 Sep 2011 09:19:37 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: RE: [PATCH v2] xen: Fix selfballooning and ensure it doesn't go too
 far
References: <2de59b55-4ecc-4155-8709-f8b0f5e012bc@default
 4E81F278.5040107@citrix.com>
In-Reply-To: <4E81F278.5040107@citrix.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A02020A.4E81F7BA.01CA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Vrabel [mailto:david.vrabel@citrix.com]
> Subject: Re: [PATCH v2] xen: Fix selfballooning and ensure it doesn't go too far
> 
> On 27/09/11 16:03, Dan Magenheimer wrote:
> > Note: This patch is also now in a git tree at:
> >
> > git://oss.oracle.com/git/djm/tmem.git#selfballoon-fix-v2
> >
> > The balloon driver's "current_pages" is very different from
> > totalram_pages.  Self-ballooning needs to be driven by
> > the latter.

Hi David --

Thanks for the feedback!
 
> I don't think this part of the change makes any difference. It looks like it
> rearranges the maths without changing the end result (other than
> slightly increasing the rate of change).
> I think this (partial, untested) patch is equivalent:

Actually it does.  The key difference is the parameter to the
call to balloon_set_new_target.  The math in my patch is
done in "internal" math (e.g. kernel-relevant variables)
and the math in your patch is done in "external" math (e.g.
Xen-relevant variables).  Balloon_set_new_target requires
"external" math, so I convert at the point of call.
 
> The sysfs file isn't documented (but then neither are any of the other
> (self-)balloon driver sysfs files).

Yep.  This is a bug fix, so I'm not trying to fix all the sins
of others (and myself).  Since you are familiar with the
meaning of all the core balloon driver variables exposed through
sysfs, perhaps you might submit a patch to document them
and/or suggest which ones should be in debugfs instead?
 
> I don't think "safety_margin" is the right name.  Perhaps,
> "min_reservation_ratio" or something like that?

Yeah, I struggled with the name because the concept that
the variable implements is pretty complex. I finally decided
on safety_margin because I think it will draw the attention
of a user who has reason to look for it.  I don't expect that
it will be used anyway, but it is there in case I am wrong.
