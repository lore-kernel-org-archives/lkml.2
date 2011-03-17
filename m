Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1CQWTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:19:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab1CQWTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:19:15 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=XYJHFtupD_QA:10 a=9vjHhYGmBowA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=YgUFFZ79AAAA:8 a=DPBwiRG5LSrKnsrFpKkA:9 a=m5Z2RGGAlmKkdiwKJjeZ5_MLk5UA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 17 Mar 2011 18:19:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Curt Howland <Howland@priss.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Compile error: arch/x86/kernel/entry_32.S:1422: Error: .size
 expression does not evaluate to a constant
Message-ID: <20110317221914.GG14675@home.goodmis.org>
References: <201103171741.39876.Howland@priss.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103171741.39876.Howland@priss.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 05:41:39PM -0400, Curt Howland wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> 
> arch/x86/kernel/entry_32.S: Assembler messages: 
> arch/x86/kernel/entry_32.S:1422: Error: .size expression does not 
> evaluate to a constant make[3]: *** [arch/x86/kernel/entry_32.o] 
> Error 1
> 
> I searched for this error and saw this had been posted to the LKML:
> 
> http://www.gossamer-threads.com/lists/linux/kernel/1347760
> 
> This was when the error happened in -rc7, but it was not fixed 
> for -rc8 or the released stable.
> 
> I'm just a user, not a developer, but I figure if its happening to me 
> with very generic tools it may be happening to other people who don't 
> use git, who don't apply patches, and such.
> 
> I don't have the warewithall to subscribe to the LKML, so I would be 
> obliged if you would copy me on any replies. I would be glad to 
> supply any further information if needed.

Thanks for reporting. This is a known problem. Unfortunately, it is due
to the new binutils (version 2.21) that decided to make something that
it use to ingore into something that is now an error.

The problem is that we have macros that create functions for us in
assembly:

ENTRY(foo)
	[ body of foo ]
END(foo)

But there also are some areas where we had a typo:

ENTRY(foo)
	[ body of foo ]
END(xfoo)

binutils version 2.20 and before ignored this little bug. Version 2.21
now fails with the error you get.

Sure we can go about fixing this bug, but because of this stupid
decision by the developers of binutils, older kernels will no longer
build. The correct thing for them to have done, was just to make it into
a warning and not fail the entire build.

-- Steve

