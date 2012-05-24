Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2EXKv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:51:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42489 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2EXKv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:51:26 -0400
Subject: Re: [PATCH 04/16] perf: Add ability to attach user stack dump to
 sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
In-Reply-To: <1337801535-12865-5-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	 <1337801535-12865-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 12:51:20 +0200
Message-ID: <1337856680.9783.111.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
> +static void
> +perf_output_sample_ustack(struct perf_output_handle *handle, u64 dump_size,
> +                         struct pt_regs *regs)
> +{
> +       u64 size;
> +
> +       /* Case of a kernel thread, nothing to dump */
> +       if (!regs) {
> +               size = 0;
> +               perf_output_put(handle, size);
> +       } else {
> +               unsigned long sp;
> +               unsigned int rem;
> +               u64 dyn_size;
> +
> +               /*
> +                * Static size: we always dump the size
> +                * requested by the user because most of the
> +                * time, the top of the user stack is not
> +                * paged out.
> +                */
> +               size = round_up(dump_size, sizeof(u64));

You also do this in the prepare thing..

> +               perf_output_put(handle, size);
> +
> +               sp = user_stack_pointer(regs);
> +               rem = __output_copy_user(handle, (void *)sp, size);
> +               dyn_size = size - rem;
> +
> +               /* What couldn't be dumped is zero padded */
> +               while (rem--) {
> +                       char zero = 0;
> +                       perf_output_put(handle, zero);
> +               }

Does this matter? If we don't write it the worst that can happen is that
we leave previous ring-bugger content around, but since we already are
privileged to read that (and very likely already have) there's no
problem with that..

I know not zero-ing is ugly, but its also faster.. and do we care about
them silly zeros?

> +
> +               /* Dynamic size: whole dump - padding */
> +               perf_output_put(handle, dyn_size);
> +       }
> +}
> +
>  static struct pt_regs *perf_sample_regs_user(struct pt_regs *regs)
>  {
>         if (!user_mode(regs)) {
> @@ -4066,6 +4105,17 @@ void perf_output_sample(struct perf_output_handle *handle,
>                         }
>                 }
>         }
> +
> +       if (sample_type & PERF_SAMPLE_STACK) {
> +               u64 mode = event->attr.sample_stack;
> +
> +               if (mode & PERF_SAMPLE_STACK_USER) {
> +                       u64 dump_size = event->attr.sample_stack_user;
> +
> +                       perf_output_sample_ustack(handle, dump_size,
> +                                                 data->regs_user);

OK, so that function is called _ustack() I read that as userstack, so
why this strange split up?

> +               }
> +       }
>  }
>  
>  void perf_prepare_sample(struct perf_event_header *header,
> @@ -4135,6 +4185,39 @@ void perf_prepare_sample(struct perf_event_header *header,
>  
>                 header->size += size;
>         }
> +
> +       if (sample_type & PERF_SAMPLE_STACK) {
> +               u64 mode = event->attr.sample_stack;
> +               int size = 0;
> +
> +               if (mode & PERF_SAMPLE_STACK_USER) {

This is very much similar to ->sample_stack_user, since a non-zero size
usually means you want something.

> +                       if (!data->regs_user)
> +                               data->regs_user = perf_sample_regs_user(regs);
> +
> +                       /*
> +                        * A first field that tells the _static_ size of the
> +                        * dump. 0 if there is nothing to dump (ie: we are in
> +                        * a kernel thread) otherwise the requested size.
> +                        */
> +                       size += sizeof(u64);
> +
> +                       /*
> +                        * If there is something to dump, add space for the
> +                        * dump itself and for the field that tells the
> +                        * dynamic size, which is how many have been actually
> +                        * dumped. What couldn't be dumped will be zero-padded.
> +                        */
> +                       if (data->regs_user) {
> +                               u64 user_size = event->attr.sample_stack_user;
> +
> +                               user_size = round_up(user_size, sizeof(u64));

Right, and here we go again.. so how about you either reject sizes that
aren't properly aligned in perf_copy_attr() or just fix it up there.

> +                               size += user_size;
> +                               size += sizeof(u64);
> +                       }
> +               }
> +
> +               header->size += size;
> +       }
>  } 

