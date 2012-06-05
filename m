Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2FERli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:41:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:47118 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2FERlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:41:36 -0400
Date: Tue, 5 Jun 2012 19:40:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Jan Beulich <JBeulich@suse.com>, Russell King <linux@arm.linux.org.uk>,
        yong.zhang0@gmail.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        peterz@infradead.org, mingo@kernel.org, x86@kernel.org,
        akpm@linux-foundation.org, nikunj@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, rusty@rustcorp.com.au, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keir Fraser <keir@xen.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 05/27] xen, cpu hotplug: Don't call cpu_bringup()
 in xen_play_dead()
In-Reply-To: <4FCA5608.2010404@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1206051921320.3086@ionos>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091124.31979.91984.stgit@srivatsabhat.in.ibm.com> <4FC8D8E30200007800087D2B@nat28.tlf.novell.com> <4FC8DC19.4000007@linux.vnet.ibm.com> <4FC8FD9C0200007800087DF5@nat28.tlf.novell.com>
 <4FCA5608.2010404@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2012, Srivatsa S. Bhat wrote:
> Ok.. So, I would love to hear a confirmation about whether this patch (which
> removes cpu_bringup() in xen_play_dead()) will break things or it is good as is.
> 
> If its not correct, then we can probably make __cpu_post_online() return an int,
> with the meaning:
> 
> 0 => success, go ahead and call cpu_idle()
> non-zero => stop here, thanks for your services so far.. now leave the rest to me.
> 
> So all other archs will return 0, Xen will return non-zero, and it will handle
> when to call cpu_idle() and when not to do so.
> 
> Might sound a bit ugly, but I don't see much other option. Suggestions are
> appreciated!

Yes, it's butt ugly. 

You are tripping over the main misconception of the current hotplug
code: It's asymetric.

So people added warts and workarounds like the xen one. What you are
proposing is another wart and workaround.

The real way to avoid it, is to have the symetric state machine in
place first and then convert everything to that instead of introducing
an intermediate state which resembles the existing state.

One of the main things we need to do to make it symetric is to kill
the play_dead() thing in the idle loop and make idle a function which
returns on cpu_should_die().

Give me a day or two and I get you a working version of that. (Up is
functional, just down refuses to play along)

Thanks,

	tglx

