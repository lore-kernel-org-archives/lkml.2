Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab0I2Lwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:52:51 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60207 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab0I2Lwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:52:50 -0400
Date: Wed, 29 Sep 2010 13:52:48 +0200
From: Florian Mickler <florian@mickler.org>
To: tmhikaru@gmail.com
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.35.6
Message-ID: <20100929135248.09cd7a84@schatten.dmk.lab>
In-Reply-To: <20100929110247.GA2032@roll>
References: <20100927003608.GA20395@kroah.com>
	<20100927163208.GA4892@roll>
	<20100927215135.3d11d587@schatten.dmk.lab>
	<20100927233956.GA15705@roll>
	<20100928083505.0a808ffd@schatten.dmk.lab>
	<20100928190358.GA24303@roll>
	<20100929092924.2090f19e@schatten.dmk.lab>
	<20100929110247.GA2032@roll>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 07:02:48 -0400
tmhikaru@gmail.com wrote:

> On Wed, Sep 29, 2010 at 09:29:24AM +0200, Florian Mickler wrote:
> > Do you know what load average conky is showing you? If I
> > type 'uptime' on a console, i get three load numbers: 1minute-,
> > 5minutes- and 15minutes-average. 
> > If there is a systematic bias it should be visible on the
> > 15minutes-average.  If there are only bursts of 'load' it should be
> > visible on the 1 minutes average numbers.
> 
> It is giving the same averages that uptime does in the same format, and
> there is a routine problem - it remains high on all averages on the kernels
> that do not work properly, and zeroes eventually if I leave it alone long
> enough on kernels that do work properly. When I discovered X was part of the
> problem somehow, it was due to me testing in X with mrxvt running bash and
> uptime, and in console without X using bash with uptime. uptime consistently
> gives the same numbers that conky does, so I don't think I need to worry
> about conky confusing the issue.

Ok. I just asked out of curiosity and to establish a common baseline. 

> 
> > 
> > But it doesn't really matter for now what kind of load disturbance you
> > are seeing, because you actually have a better way to distinguish a good
> > kernel from a bad:
> 
> You may think a timed kernel compile is a better way to determine if there
> is a fault with the kernel, but it takes my machine around two hours (WITH
> ccache) to build my kernel. Since the use of ccache speeds up the builds
> dramatically and would give misleading readings if I compiled the exact
> kernel source twice, I'd have to disable it if I wanted it to be a
> worthwhile test. So it would take even *longer* to build than normally. This
> is not something I'm willing to use as a 'better' test - especially since
> the loadavg numbers are consistently high when on a bad kernel and
> consistently zeroed or very close to it when not.

I didn't know that. The right thing to do is to bisect using the
criteria that is easiest for you. After all the likelihood of those two
symptoms (kernel build taking longer and higher load average) beeing
correlated is quite high. 

I termed it 'better way' because a performance regression is actually a
serious issue, while load averages going crazy may or may not be
serious. Also I didn't know that the difference between the load-average
figures would be easy to reproduce.

In all cases, you can simply do the bisection based on the 'load
average' criteria and then later check if the changeset that you've
found that way also influences the kernel compile times. 

> Here's an uptime sample from a working version:
> 
> 06:20:31 up 21 min,  4 users,  load average: 0.00, 0.02, 0.06
> 
> I've been typing up this email while waiting for the load to flatten from
> the initial boot. I think it's pretty obvious here that it's working
> properly, so I'm going to git bisect good it...
> 
> Bisecting: 27 revisions left to test after this (roughly 5 steps)
> 
> I'm getting fairly close at least.

Out of curiosity, what region are you circling in?

 
> Here's an uptime output from a version of the kernel that was NOT working
> properly, 2.6.35.6:
> 14:30:12 up  3:46,  4 users,  load average: 0.85, 0.93, 0.89
> 
> I think simply letting the machine idle is just as good a test for
> determining wether or not any particular kernel is good/bad since the
> readings are like night and day. I only brought up that the timed kernel
> runs were taking longer on the kernel with the higher load average since it
> meant that it wasn't simply a broken statistic giving false readings;
> something *is* wrong, and I can't simply ignore it.
> 
> It's taken me several days to bisect this far. If greg insists, I'll restart
> the bisection from scratch using a kernel compile as a test, but I implore
> you not to ask me to do so; it will more than likely give me the same
> results I'm getting now for more than double the amount of time invested.
> 
> > Yes, the sample rate was one of the things I wanted to know, but also which of
> > the 3 load figures you were graphing.  
> To be honest, I actually don't know. I'm *terrible* at regex, this is what
> the bash script is doing:

It's taking the first column of the line in  /proc/loadavg which
corresponds to the 15 min avg on my machine. 
 
> cat /proc/loadavg     | perl -p -e 

's/'

s before the / means, we are replacing something.  After the / begins
the pattern we are searching. 

then the next '^' is the beginning of line marker

	'([^ ]+)'
This matches one or more non-whitespace characters. Inside a character
group [] the ^ negates the character group, so that it matches
everything not in that group. The plus means "one or more" and the
brackets () make the substring matched by the enclosed pattern
available as $1.

	' .+$/' 
The whitespace matches a whitespace, the . is a metacharacter meaning
"any char" and the + specifying the quantity "one or more" again.
Last the $ means 'end of line'.

So this part matches any whitespaced followed by at least one character.

In effect the whole expression replaces everything on the line with
the first consecutive non-blank character sequence, iff there are
non-blank characters at the beginning of the line.

One could also just use awk for this. ( awk '{print $1}' /proc/loadavg)


> 
> If you can explain what that's doing, I'd appreciate it. If it's not to your
> liking, I can change it to something else.

No, it's ok. 

Regards,
Flo
