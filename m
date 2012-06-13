Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab2FMLQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:16:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50167 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2FMLQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:16:46 -0400
MIME-Version: 1.0
In-Reply-To: <1339420814-7379-3-git-send-email-jolsa@redhat.com>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
	<1339420814-7379-3-git-send-email-jolsa@redhat.com>
Date: Wed, 13 Jun 2012 13:16:44 +0200
Message-ID: <CABPqkBRsBegm6gv6agHcGb0Hh1EWCV5gjVnbbwPHh-eOfROCuw@mail.gmail.com>
Subject: Re: [PATCH 02/19] perf: Add ability to attach user level registers
 dump to sample
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 3:19 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> Introducing sample_regs_user bitmask into perf_event_attr
> struct to define the user level registers we want to attach
> to the sample. The dump itself is triggered once the
> sample_regs_user is not empty.
>
> Only user level registers are dump at the moment. Meaning the
> register values of the user space context as it was before the
> user entered the kernel for whatever reason (syscall, irq,
> exception, or a PMI happening in userspace).
>
> The layout of the sample_regs_user bitmap is described in
> asm/perf_regs.h for archs that support register dump.
>
> This is going to be useful to bring Dwarf CFI based stack
> unwinding on top of samples.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/perf_event.h |   10 ++++++-
>  kernel/events/core.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 1ce887a..d66cbeb 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -271,7 +271,13 @@ struct perf_event_attr {
>                __u64           bp_len;
>                __u64           config2; /* extension of config1 */
>        };
> -       __u64   branch_sample_type; /* enum branch_sample_type */
> +       __u64   branch_sample_type; /* enum perf_branch_sample_type */
> +
> +       /*
> +        * Defines set of user regs to dump on samples.
> +        * See asm/perf_regs.h for details.
> +        */
> +       __u64   sample_regs_user;
>  };
That's not enough. You also need to define PERF_SAMPLE_USER_REGS
for sample_type. Although the sample_regs_users might look like it's enough
to capture regs, there is a problem when it comes to parsing the record. You
need an ordering guarantee that is explicitly spelled out in the API (the header
file). In your current patch, I have no way of knowing that sample_regs_users
are saved after BRANCH_STACK (should you have that enabled). Remember
that you can turn on/off sampled infos at will in sample_type. Yet to find the
infos when parsing, you need to know the order.

The enum perf_event_sample_format provides that ordering information. You
need to add a new type for sampling user regs.

>
>  /*
> @@ -609,6 +615,7 @@ struct perf_guest_info_callbacks {
>  #include <linux/static_key.h>
>  #include <linux/atomic.h>
>  #include <linux/sysfs.h>
> +#include <linux/perf_regs.h>
>  #include <asm/local.h>
>
>  struct perf_callchain_entry {
> @@ -1131,6 +1138,7 @@ struct perf_sample_data {
>        struct perf_callchain_entry     *callchain;
>        struct perf_raw_record          *raw;
>        struct perf_branch_stack        *br_stack;
> +       struct pt_regs                  *regs_user;
>  };
>
>  static inline void perf_sample_data_init(struct perf_sample_data *data,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index f85c015..e4df59d 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3750,6 +3750,33 @@ int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>  }
>  EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
>
> +static void
> +perf_output_sample_regs(struct perf_output_handle *handle,
> +                       struct pt_regs *regs, u64 mask)
> +{
> +       int bit;
> +
> +       for_each_set_bit(bit, (const unsigned long *) &mask,
> +                        sizeof(mask) * BITS_PER_BYTE) {
> +               u64 val;
> +
> +               val = perf_reg_value(regs, bit);
> +               perf_output_put(handle, val);
> +       }
> +}
> +
> +static struct pt_regs *perf_sample_regs_user(struct pt_regs *regs)
> +{
> +       if (!user_mode(regs)) {
> +               if (current->mm)
> +                       regs = task_pt_regs(current);
> +               else
> +                       regs = NULL;
> +       }
> +
> +       return regs;
> +}
> +
>  static void __perf_event_header__init_id(struct perf_event_header *header,
>                                         struct perf_sample_data *data,
>                                         struct perf_event *event)
> @@ -4010,6 +4037,23 @@ void perf_output_sample(struct perf_output_handle *handle,
>                        perf_output_put(handle, nr);
>                }
>        }
> +
> +       if (event->attr.sample_regs_user) {
> +               u64 avail = (data->regs_user != NULL);
> +
> +               /*
> +                * If there are no regs to dump, notice it through
> +                * first u64 being zero.
> +                */
> +               perf_output_put(handle, avail);
> +
> +               if (avail) {
> +                       u64 mask = event->attr.sample_regs_user;
> +                       perf_output_sample_regs(handle,
> +                                               data->regs_user,
> +                                               mask);
> +               }
> +       }
>  }
>
>  void perf_prepare_sample(struct perf_event_header *header,
> @@ -4061,6 +4105,19 @@ void perf_prepare_sample(struct perf_event_header *header,
>                }
>                header->size += size;
>        }
> +
> +       if (event->attr.sample_regs_user) {
> +               /* regs dump available bool */
> +               int size = sizeof(u64);
> +
> +               data->regs_user = perf_sample_regs_user(regs);
> +               if (data->regs_user) {
> +                       u64 mask = event->attr.sample_regs_user;
> +                       size += hweight64(mask) * sizeof(u64);
> +               }
> +
> +               header->size += size;
> +       }
>  }
>
>  static void perf_event_output(struct perf_event *event,
> @@ -6110,6 +6167,10 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
>                        attr->branch_sample_type = mask;
>                }
>        }
> +
> +       if (attr->sample_regs_user)
> +               ret = perf_reg_validate(attr->sample_regs_user);
> +
>  out:
>        return ret;
>
> --
> 1.7.7.6
>
