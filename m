Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1HBCev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 22:34:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31098 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab1HBCeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 22:34:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ULc2mNBNywxKBF4lF01uWFdmdCBuoLsB0q8NmNCYkcglm2SNuycAXiJVQ3ToM6WKn
	x0xmQmLf9QehbAWTYr/AQ==
Date: Mon, 1 Aug 2011 19:34:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
In-Reply-To: <20110802005206.GA3832@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.00.1108011928530.15596@chino.kir.corp.google.com>
References: <20110802005206.GA3832@tassilo.jf.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, Andi Kleen wrote:

> 
> Hi Linus,
> 
> Can you please revert 
> 
> commit be8f684d73d8d916847e996bf69cef14352872c6
> Author: David Rientjes <rientjes@google.com>
> Date:   Mon Jul 25 17:12:18 2011 -0700
> 
>     oom: make deprecated use of oom_adj more verbose
> 
>     /proc/pid/oom_adj is deprecated and scheduled for removal in August 2012
>     according to Documentation/feature-removal-schedule.txt.
> 
> 
> This makes most of my test systems (suse 11.1, 11.2) spew scary WARN_ONs
> on every boot. GNOME then also complains. While it doesn't cause actual 
> misfunction it scares me every time I boot and other people who can't
> read git logs like me will be unnecessary scared.
> 

If you look at the warning, you should be able to infer that an 
application is writing to /proc/pid/oom_adj when it should be using the 
new /proc/pid/oom_score_adj interface instead.

> Also the warning is completely useless: noone will be "fixing"
> udev on old distributions.
> 

udev was fixed for v162, but admittedly that won't help on old 
distributions.  The WARN_ONCE() was intended to be in place for a year 
just like its previous form, printk_once(), and then the tunable will 
disappear and result in no error message.

> IMHO that's not acceptable to break common user land like this.
> Linux is supposed to be binary compatible and this patch is not
> in this spirit.
> 

Can you show additional breakage that still need to be fixed in userspace 
applications (we can't do anything about old distributions, it'll be a 
silent failure in a year's time)?  udev was fixed for v162, kde was fixed 
for 4.6.1, chromium is in the process of being fixed as a result of this 
WARN_ON() (see http://code.google.com/p/chromium/issues/detail?id=65009), 
and opensshd was fixed in 5.7p1.  oom_adj isn't that common of an 
interface, so if there are others that are largely popular than please let 
me know and we'll get it fixed up.

So I'm certainly not changing an interface and leaving people to fix it 
up, I've been actively involved in doing so for the known userspace that 
does touch the tunable.  I think it's better for users to be notified 
whether by "scary" warnings in the log (come on, we should be able to warn 
about deprecated interfaces in a log without mass failures) as some due 
diligence before removing the tunable.  Most applications use it only to 
disable oom killing entirely, so a silent failure and allowing a vital 
task to be killed is the alternative to getting them fixed up.
