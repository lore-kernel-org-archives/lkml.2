Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab0KOVCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:02:13 -0500
Received: from claw.goop.org ([74.207.240.146]:53719 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376Ab0KOVCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:02:12 -0500
Message-ID: <4CE19FD1.2000804@goop.org>
Date: Mon, 15 Nov 2010 13:02:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 00/20] x86: ticket lock rewrite and paravirtualization
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>	 <4CDDBBD3.5050903@zytor.com> <4CDDBCE4.80906@goop.org>	 <4CDDBDB5.8000800@zytor.com> <4CE1915F.60507@goop.org>	 <4CE1920F.5000509@zytor.com> <1289852088.2109.553.camel@laptop>
In-Reply-To: <1289852088.2109.553.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 12:14 PM, Peter Zijlstra wrote:
> On Mon, 2010-11-15 at 12:03 -0800, H. Peter Anvin wrote:
>> On 11/15/2010 12:00 PM, Jeremy Fitzhardinge wrote:
>>> Another approach I discussed with PeterZ and Mathieu is to steal the LSB
>>> of the ticket counters (halving the max CPU count) to use as a "there is
>>> someone in slowpath waiting on this lock".  But I haven't spent the time
>>> to work out an algorithm to maintain that flag (or flags, since there
>>> are bits available) in a correct and efficient way.
>>>
>> Definitely worth pondering.
> Right, so the idea was to make the ticket increment 2, which would leave
> the LSB of both the head and tail available. I think that if one were to
> set both (using a cmpxchg), the ticket fast-path wouldn't need any
> changes since head==tail is still the correct condition for acquisition.
>
> Then the unlock needs an added conditional:
>   if (tail & 1) 
> 	unlock_slowpath()

The tricky part is knowing how to clear the bit(s) on the last person
dropping out of the slow path, and making that race-free with respect to
new lockers entering the slow path.  I guess you could leave it in
slowpath state until you're the last unlocker (ie, you're unlocking into
uncontended state), whereupon you also clear the bits; I guess that
would probably need a cmpxchg to make it safe WRT new lockers entering
slowpath.

As a heuristic, it shouldn't be too bad performancewise, since
(handwaving) if ticketholder N has entered the slowpath, then its likely
that N+1 will as well.

    J

