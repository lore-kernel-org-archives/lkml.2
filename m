Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2KTQcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:32:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63027 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KTQcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:32:07 -0500
Date: Tue, 20 Nov 2012 17:31:58 +0100
From: Robert Richter <rric@kernel.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Maynard Johnson <maynardj@us.ibm.com>,
        "jgq516@gmail.com" <jgq516@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: oprofile: add A5/A7/A15 entries in op_perf_name
Message-ID: <20121120163158.GO2504@rric.localhost>
References: <1351853016-4476-1-git-send-email-jgq516@gmail.com>
 <20121105113102.GF3351@mudshark.cambridge.arm.com>
 <20121120121747.GJ2504@rric.localhost>
 <20121120155717.GD26475@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120155717.GD26475@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.11.12 15:57:17, Will Deacon wrote:
> On Tue, Nov 20, 2012 at 12:17:47PM +0000, Robert Richter wrote:
> > Will,
> > 
> > On 05.11.12 11:31:03, Will Deacon wrote:
> > > > diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> > > > index 99c63d4b..ec10db1 100644
> > > > --- a/arch/arm/oprofile/common.c
> > > > +++ b/arch/arm/oprofile/common.c
> > > > @@ -37,8 +37,11 @@ static struct op_perf_name {
> > > >  	{ "xscale1",		"arm/xscale2"	},
> > > >  	{ "v6",			"arm/armv6"	},
> > > >  	{ "v6mpcore",		"arm/mpcore"	},
> > > > +	{ "ARMv7 Cortex-A5",	"arm/armv7-ca5"	},
> > > > +	{ "ARMv7 Cortex-A7",	"arm/armv7-ca7"	},
> > > >  	{ "ARMv7 Cortex-A8",	"arm/armv7"	},
> > > >  	{ "ARMv7 Cortex-A9",	"arm/armv7-ca9"	},
> > > > +	{ "ARMv7 Cortex-A15",	"arm/armv7-ca15" },
> > > >  };
> > 
> > > I'd rather not go down this route now that we have the operf tool as part of
> > > oprofile, which can use the perf syscall directly and doesn't need this
> > > string translation.
> > 
> > since this is just an update of cpu detection I would be willing to
> > include this into kernel code anyway.
> 
> Perhaps, but one day we might like to remove this compatibility layer as
> tools move over to the perf system call, so adding new CPUs here is actively
> going against that.

This would help people to use oprofile as they did before with legacy
oprofile tools. There is not much effort to keep oprofile kernel
support for these tools if in-kernel perf_event support exists for new
hardware. As this is not much effort to maintain, we could keep
supporting this.  Forcing users to use operf since this is the only
way to connect to newer hardware might not be what they want.

> > We could further move the cpu detection to userspace if perf_event
> > exists. We let the kernel enable oprofile with cpu_type="unknown".
> > User space then could either bind mount the file (user could do this
> > manually) or we implement to write to cpu_type. Doing so oprofile
> > could use in-kernel perf_events if it exists always as fallback.
> 
> Not sure I follow you... operf already does the CPU detection from
> userspace, so I guess that code could simply be re-used. What does the bind
> mount involve?

I am thinking of the following:

 # cat /root/cpu_type
 arm/armv7-ca5
 # cat /dev/oprofile/cpu_type
 unknown
 # mount --bind /root/cpu_type /dev/oprofile/cpu_type
 # cat /dev/oprofile/cpu_type
 arm/armv7-ca5

>From here legacy oprofile tools work as expected using oprofilefs. (I
think. Did not test it.) We need to change the kernel for this a bit
to return 'unknown'. The mount could be done by the oprofile tools
using existing cpu detection code. This is only one way to setup
cpu_type from userland, there could be other ways too.

-Robert
