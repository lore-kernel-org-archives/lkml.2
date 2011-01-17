Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1AQOPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:15:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1AQOPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:15:44 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=44vUGAvzfu8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=J1Y8HTJGAAAA:8 a=g5AiCj800SNtcLfSbAYA:9 a=cE2LEhI8drb5n6Zt5KMA:7 a=2mEUBDCPuhNGgCQGc9RbA3a7nEcA:4 a=PUjeQqilurYA:10 a=4N9Db7Z2_RYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: Steven Rostedt <rostedt@goodmis.org>
To: Richard Mortimer <richm@oldelvet.org.uk>
Cc: David Miller <davem@davemloft.net>, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
        Jesper.Nilsson@axis.com, jeffm@suse.com,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1295259761.32152.20.camel@duncow>
References: <4D302B2F.7030108@oldelvet.org.uk>
	 <4D3074FE.3030707@oldelvet.org.uk>
	 <20110115.211722.39173519.davem@davemloft.net>
	 <20110116.220755.179947617.davem@davemloft.net>
	 <1295259761.32152.20.camel@duncow>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 17 Jan 2011 09:15:41 -0500
Message-ID: <1295273741.16479.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 10:22 +0000, Richard Mortimer wrote:
> On Sun, 2011-01-16 at 22:07 -0800, David Miller wrote:
> > From: David Miller <davem@davemloft.net>
> > Date: Sat, 15 Jan 2011 21:17:22 -0800 (PST)
> 
> > > I think the problem we have here is that the _ftrace_events section is
> > > not aligned sufficiently.  That ".align 4" mnemonic is a good indication
> > > of this.  It should at least "8" on sparc64.
> > 
> I noticed another potentially 64 bit unfriendly alignment on struct
> tracepoint in include/linux/tracepoint.h. I don't think that the
> alignment of 32 breaks anything but it does leave a 24 byte hole. I
> don't know enough about tracing to know if that is necessary.
> 
> struct tracepoint {
>         const char *name;               /* Tracepoint name */
>         int state;                      /* State. */
>         void (*regfunc)(void);
>         void (*unregfunc)(void);
>         struct tracepoint_func *funcs;
> }  __attribute__((aligned(32)));        /*
>                                          * Aligned on 32 bytes because it is
>                                          * globally visible and gcc happily
>                                          * align these on the structure size.
>                                          * Keep in sync with vmlinux.lds.h.
>                                          */
> 
> Note I spotted this when looking at some residual sparc64 relocation
> issues when _ftrace_events alignment is changed to 8. I'll follow those
> issues up in a separate email when I get time later today.

Again, this is to help the linker keep arrays in tacked. Tracepoints are
allocated into the tracepoint section, and then read like an array. If
the linker adds holes as it links sections into one big one, then the
reading of the array breaks.

We either need to compact it (with the align(4)) which is undesirable,
or add our own holes like the above does.

-- Steve



