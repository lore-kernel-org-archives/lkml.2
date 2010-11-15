Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab0KOUOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:14:53 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50541 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933720Ab0KOUOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:14:51 -0500
Subject: Re: [PATCH 00/20] x86: ticket lock rewrite and paravirtualization
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <4CE1920F.5000509@zytor.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
	 <4CDDBBD3.5050903@zytor.com> <4CDDBCE4.80906@goop.org>
	 <4CDDBDB5.8000800@zytor.com> <4CE1915F.60507@goop.org>
	 <4CE1920F.5000509@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 21:14:48 +0100
Message-ID: <1289852088.2109.553.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 12:03 -0800, H. Peter Anvin wrote:
> On 11/15/2010 12:00 PM, Jeremy Fitzhardinge wrote:
> > 
> > Another approach I discussed with PeterZ and Mathieu is to steal the LSB
> > of the ticket counters (halving the max CPU count) to use as a "there is
> > someone in slowpath waiting on this lock".  But I haven't spent the time
> > to work out an algorithm to maintain that flag (or flags, since there
> > are bits available) in a correct and efficient way.
> > 
> 
> Definitely worth pondering.

Right, so the idea was to make the ticket increment 2, which would leave
the LSB of both the head and tail available. I think that if one were to
set both (using a cmpxchg), the ticket fast-path wouldn't need any
changes since head==tail is still the correct condition for acquisition.

Then the unlock needs an added conditional:
  if (tail & 1) 
	unlock_slowpath()

