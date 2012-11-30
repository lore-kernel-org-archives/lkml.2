Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab2K3Nmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:42:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50647 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959Ab2K3Nmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:42:36 -0500
Date: Fri, 30 Nov 2012 14:42:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] aerdrv: Trace Event for AER
Message-ID: <20121130134232.GD6869@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
	lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
	mchehab@redhat.com, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121129215443.5483.43364.stgit@grignak.americas.hpqcorp.net>
 <1354240279.6276.131.camel@gandalf.local.home>
 <20121130105311.GA6869@liondog.tnic>
 <1354275551.6276.140.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354275551.6276.140.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 06:39:11AM -0500, Steven Rostedt wrote:
> On Fri, 2012-11-30 at 11:53 +0100, Borislav Petkov wrote:
> > On Thu, Nov 29, 2012 at 08:51:19PM -0500, Steven Rostedt wrote:
> > > >  include/ras/aer_event.h |   77 +++++++++++++++++++++++++++++++++++++++++++++++
> > > 
> > > Is there a reason this header is here? Egad, I never noticed the
> > > ras_event.h that is there. This include/ras directory was created for
> > > the sole purpose of trace events! This is not the way to do this.
> > 
> > Well, the idea for the ras event was to be able to use it in multiple
> > places. It is currently used only by EDAC but it could be that memory
> > errors could be reported by other agents which would reuse that TP.
> > 
> 
> If it's generic, then place it into the include/trace/events directory,
> the you don't need to have the TRACE_INCLUDE_PATH as that is the default
> path the macros will use.

Hmm, so I'm thinking maybe we should add a ras.h header there which
contains all RAS TPs.

> > > Please look at the sample in samples/trace_events/
> > > 
> > > The proper way is to keep the header by the driver. Then you can simply
> > > include the header with "aer_event.h".
> > > 
> > > But to have the macro magic work, you need to modify the Makefile to
> > > have something like:
> > > 
> > > CFLAGS_aerdrv_errprint.o = -I$(src)
> > 
> > So I'm guessing that every .c file including the TP should also -I
> > include the TP definition header wherever it is. Is that agreeable?
> 
> You only need the -I$(src) for the .c file that uses the
> CREATE_TRACE_POINTS macro, as the trace point macro magic headers
> require it to find the TP header.

This is done like this from EDAC's single usage site:

#define CREATE_TRACE_POINTS
#define TRACE_INCLUDE_PATH ../../include/ras
#include <ras/ras_event.h>

This is in <drivers/edac/edac_mc.c> and it doesn't to "-I$(src)" in the
edac Makefile.

> Other files just need "foo.h", or <trace/events/foo.h> if it's in the
> generic location.

So, it sounds to me like we should we move all RAS-specific tracepoints
to <trace/events/ras.h> and then in each usage site do:

#define CREATE_TRACE_POINTS
#include <trace/events/ras.h>

Correct?

FWIW, it looks neat and clean to me that way.

Thanks.

-- 
Regards/Gruss,
    Boris.
