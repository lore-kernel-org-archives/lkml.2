Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559Ab2FGKIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:08:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62916 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2FGKIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:08:04 -0400
Date: Thu, 7 Jun 2012 12:07:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 04/16] perf: Add ability to attach user stack dump to
 sample
Message-ID: <20120607100752.GD19842@somewhere.redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
 <1337801535-12865-5-git-send-email-jolsa@redhat.com>
 <1337856680.9783.111.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337856680.9783.111.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:51:20PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
> > +static void
> > +perf_output_sample_ustack(struct perf_output_handle *handle, u64 dump_size,
> > +                         struct pt_regs *regs)
> > +{
> > +       u64 size;
> > +
> > +       /* Case of a kernel thread, nothing to dump */
> > +       if (!regs) {
> > +               size = 0;
> > +               perf_output_put(handle, size);
> > +       } else {
> > +               unsigned long sp;
> > +               unsigned int rem;
> > +               u64 dyn_size;
> > +
> > +               /*
> > +                * Static size: we always dump the size
> > +                * requested by the user because most of the
> > +                * time, the top of the user stack is not
> > +                * paged out.
> > +                */
> > +               size = round_up(dump_size, sizeof(u64));
> 
> You also do this in the prepare thing..
> 
> > +               perf_output_put(handle, size);
> > +
> > +               sp = user_stack_pointer(regs);
> > +               rem = __output_copy_user(handle, (void *)sp, size);
> > +               dyn_size = size - rem;
> > +
> > +               /* What couldn't be dumped is zero padded */
> > +               while (rem--) {
> > +                       char zero = 0;
> > +                       perf_output_put(handle, zero);
> > +               }
> 
> Does this matter? If we don't write it the worst that can happen is that
> we leave previous ring-bugger content around, but since we already are
> privileged to read that (and very likely already have) there's no
> problem with that..
> 
> I know not zero-ing is ugly, but its also faster.. and do we care about
> them silly zeros?

The problem there is that the unwinder may then deal with random values
from previous records in the buffer and think it is some real stack values.
This may give strange results. At least zeroing was limiting this effect.

I think the best would be to do like you say: if we can't dump everything
then just leave the state of the buffer as is. But also output in the end
the effective size of the stack that has been dumped. So that we know what
we can give to the unwinder and what we can not.
