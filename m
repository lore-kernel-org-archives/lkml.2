Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1AHRur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 12:50:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61717 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab1AHRuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 12:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C91/w64iafOIJOvfxbMjCd7huWOZ34c7RN8Bp5s7bxGcoSjsip/Rj8FAR0Cn/K55NA
         +zBahaRW40ye+tOJNAUO1g4U/rUW17sUQJ2RoikyF5TZx1/s2DH37AtrHgNUPolicRTp
         SP6qEJOpADq0rr4RNHvmcWfAZt+uG1LBkTEuc=
Date: Sat, 8 Jan 2011 18:50:28 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V8 02/13] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <20110108175028.GA22308@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
 <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 02, 2011 at 05:38:19AM +0900, Kuwahara,T. wrote:
> As you know, it conflicts with MOD_PPSMAX.  And also, it is logically
> the same as ADJ_OFFSET, unless the kernel PLL is enabled explicitly.

I choose another bit, for the next version of the patch series.

> 
> So here's my simple solution:
> 

I have read the API documentation in the nanokernel source archive. It
explains the (very complex looking) timex structure quite clearly and
nicely. Now I am more convinced than ever that adding a new mode bit
is the best way to go, as opposed to ADJ_OFFSET/!STA_PLL, because:

1. The mode bits update kernel variables. That is what we want.
2. Clearing STA_PLL means disable adjustments.
3. The range of the timex.offset is way too small.

I expand on each point, below. BTW, the API document is also available
for online reading here:

   http://www.slac.stanford.edu/comp/unix/package/rtems/src/ssrlApps/ntpNanoclock/api.htm

1. Looking at the API, the documentation for the bits of the 'modes'
   field states:

        These bits control which field of the timex structure are used
        to update the corresponding kernel variable. The bits may be
        set in any combination. See the description below for which
        bits control which variable.

   With the ADJ_SETOFFSET mode, we are telling the kernel to update
   the instantaneous value of the 'current time' variable. That usage
   agrees with the sematics of the other mode bits.

2. The documentation for STA_PLL states:

        Master enable switch for the PLL/FLL loop. The algorithm is
        responsive to time and/or frequency updates if set; otherwise,
        no change in the current time or frequency will be made other
        than to complete a pending phase adjustment. This bit does not
        affect the PPS loop.

   So when we clear this bit, the kernel promises that it will make
   "no change in the current time." The proposed ADJ_OFFSET/!STA_PLL
   solution would break this pattern.

3. The timex.offset field is of type "long" and represents either
   nanoseconds or microseconds. On 32 bit architectures, the maximum
   possible adjustment would be

   2^31 * 10^-6 = 2147.5 seconds

   which is less than one hour. For the first adjustment of a clock,
   we want to be able to jump the clock arbitrarily. Not every
   computer has an RTC, and so some boot up believing that it is still
   the year 1970.

Richard
