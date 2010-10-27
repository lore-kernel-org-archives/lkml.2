Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0J0TAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:00:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:42073 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0J0TAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:00:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,247,1286175600"; 
   d="scan'208";a="620905279"
Message-ID: <4CC876DC.3090708@linux.intel.com>
Date: Wed, 27 Oct 2010 12:00:44 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Borislav Petkov <bp@alien8.de>, Ian Campbell <ian.campbell@citrix.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com> <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org> <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org> <4CC8649F.5060408@linux.intel.com> <4CC866B0.8000802@goop.org> <4CC86B4A.2050408@linux.intel.com> <4CC87499.9050207@goop.org>
In-Reply-To: <4CC87499.9050207@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 11:51 AM, Jeremy Fitzhardinge wrote:
>
> "pvops" as a single thing is a bit of a misnomer these days, in that it
> has been devolving into a number of different functional pieces specific
> to different problem domains, with the only unifying thing is that they
> share the patching machinery.  They're also all controlled by a single
> fat CONFIG_PARAVIRT, but someone posted a patch to separate them out
> into distinct config options so they could be enabled/disabled
> independently as needed, but it seems it was never merged.  I even
> remember acking it.
>
> Aside from that, the notion of pvops has been extending into this
> broader notion of supporting non-traditional x86 platforms, and indeed
> the hooks I'm referring to here are now part of that (or at least tglx
> factored them out of the pvops infrastructure at the same time as the
> things like timers and the like).  So really what you're complaining
> about is that we have lots of indirection and late binding - and yes,
> well, there is rather a lot of that in the kernel overall.
>

tglx's changes are part of the work to clean up and eliminate pvops 
where it is redundant.  However, the pvops machinery has been too rigid 
to be reused, resulting in that we now have something like four 
different patching machineries in the kernel.

But of course, the worst part of pvops is that it is used at a low level 
in a lot of hot paths, and the resulting header files looking like 
someone barfed on a piece of paper, full little inlines pointing "here, 
no over here, no over here."

The indirection and late binding is a problem, especially when the 
indirection layer is badly designed, and encodes design bugs.  Last I 
checked, as an example, there are three paravirt_ops to deal with two 
levels of page tables on non-PAE i386.  One of them (not sure which one) 
doesn't do anything on native, but hell if anyone knows if they are 
actually dead.

	-hpa
