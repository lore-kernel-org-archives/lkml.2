Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030546Ab2GLTDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:03:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47624 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab2GLTDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <1342114028-21407-1-git-send-email-octavian.purdila@intel.com>
References: <1342114028-21407-1-git-send-email-octavian.purdila@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 12 Jul 2012 13:02:53 -0600
Message-ID: <CAErSpo6X6PzXCy3a2DfctvAtiWDoO81-5AfRy7rN=qBBOytFYg@mail.gmail.com>
Subject: Re: [PATCH v2] resource: make sure requested range is included in the
 root range
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 11:27 AM, Octavian Purdila
<octavian.purdila@intel.com> wrote:
> When the requested range is outside of the root range the logic in
> __reserve_region_with_split will cause an infinite recursion which
> will overflow the stack as seen in the warning bellow.

I think reserve_region_with_split() is a dubious design to begin with.
 We're trying to mark these regions as "not available for devices,"
and we have to do all these contortions like reserving some things
early, reserving other things late, and doing
reserve_region_with_split() because of the restriction that resources
must be strictly hierarchical.

The hierarchy might be important in some cases, but for "do not use
this region," it's not, and it just gets in the way.

> This particular stack overflow was caused by requesting the
> (100000000-107ffffff) range while the root range was (0-ffffffff). In
> this case __request_resource would return the whole root range as
> conflict range (i.e. 0-ffffffff). Then, the logic in
> __reserve_region_with_split would continue the recursion requesting
> the new range as (conflict->end+1, end) which incidentally in this
> case equals the originally requested range.

Why don't you fix this right where the problem occurs, in
__reserve_region_with_split(), with something like this:

        if (end > conflict->start && conflict->start > start)
                __reserve_region_with_split(root, start,
conflict->start-1, name);
        if (start < conflict->end && conflict->end < end && )
                __reserve_region_with_split(root, conflict->end+1, end, name);

Here's my visualization (O=root, -=new, *=overlap):
    ----- OOOOOOOOO     no overlap              => returns r, reserve
nothing (currently broken)
    ---**OOOOOOOOOO     overlap root start      => returns r, reserve
[start,c->start-1]
    OOOOO*****OOOOO     full overlap            => returns 0, done
    OOOOOOOOOO**---     overlap root end        => returns r, reserve
[c->end+1,end]
    OOOOOOOOO -----     no overlap              => returns r, reserve
nothing (currently broken)

> This patch aborts looking for an usable range when the request does
> not intersect with the root range. When the request partially overlaps
> with the root range, it ajust the request to fall in the root range
> and then continues with the new request.
>
> When the request is modified or aborted errors and a stack trace are
> logged to allow catching the errors in the upper layers.
>
> [    5.968374] WARNING: at kernel/sched.c:4129 sub_preempt_count+0x63/0x89()
> [    5.975150] Modules linked in:
> [    5.978184] Pid: 1, comm: swapper Not tainted 3.0.22-mid27-00004-gb72c817 #46
> [    5.985324] Call Trace:
> [    5.987759]  [<c1039dfc>] ? console_unlock+0x17b/0x18d
> [    5.992891]  [<c1039620>] warn_slowpath_common+0x48/0x5d
> [    5.998194]  [<c1031758>] ? sub_preempt_count+0x63/0x89
> [    6.003412]  [<c1039644>] warn_slowpath_null+0xf/0x13
> [    6.008453]  [<c1031758>] sub_preempt_count+0x63/0x89
> [    6.013499]  [<c14d60c4>] _raw_spin_unlock+0x27/0x3f
> [    6.018453]  [<c10c6349>] add_partial+0x36/0x3b
> [    6.022973]  [<c10c7c0a>] deactivate_slab+0x96/0xb4
> [    6.027842]  [<c14cf9d9>] __slab_alloc.isra.54.constprop.63+0x204/0x241
> [    6.034456]  [<c103f78f>] ? kzalloc.constprop.5+0x29/0x38
> [    6.039842]  [<c103f78f>] ? kzalloc.constprop.5+0x29/0x38
> [    6.045232]  [<c10c7dc9>] kmem_cache_alloc_trace+0x51/0xb0
> [    6.050710]  [<c103f78f>] ? kzalloc.constprop.5+0x29/0x38
> [    6.056100]  [<c103f78f>] kzalloc.constprop.5+0x29/0x38
> [    6.061320]  [<c17b45e9>] __reserve_region_with_split+0x1c/0xd1
> [    6.067230]  [<c17b4693>] __reserve_region_with_split+0xc6/0xd1
> ...
> [    7.179057]  [<c17b4693>] __reserve_region_with_split+0xc6/0xd1
> [    7.184970]  [<c17b4779>] reserve_region_with_split+0x30/0x42
> [    7.190709]  [<c17a8ebf>] e820_reserve_resources_late+0xd1/0xe9
> [    7.196623]  [<c17c9526>] pcibios_resource_survey+0x23/0x2a
> [    7.202184]  [<c17cad8a>] pcibios_init+0x23/0x35
> [    7.206789]  [<c17ca574>] pci_subsys_init+0x3f/0x44
> [    7.211659]  [<c1002088>] do_one_initcall+0x72/0x122
> [    7.216615]  [<c17ca535>] ? pci_legacy_init+0x3d/0x3d
> [    7.221659]  [<c17a27ff>] kernel_init+0xa6/0x118
> [    7.226265]  [<c17a2759>] ? start_kernel+0x334/0x334
> [    7.231223]  [<c14d7482>] kernel_thread_helper+0x6/0x10
>
> Cc: Ram Pai <linuxram@us.ibm.com>
>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>  kernel/resource.c |   25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/resource.c b/kernel/resource.c
> index e1d2b8e..84e3aa4 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -7,6 +7,8 @@
>   * Arbitrary resource management.
>   */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/export.h>
>  #include <linux/errno.h>
>  #include <linux/ioport.h>
> @@ -788,8 +790,29 @@ void __init reserve_region_with_split(struct resource *root,
>                 resource_size_t start, resource_size_t end,
>                 const char *name)
>  {
> +       int abort = 0;
> +
>         write_lock(&resource_lock);
> -       __reserve_region_with_split(root, start, end, name);
> +       if (root->start > start || root->end < end) {
> +               pr_err("requested range [0x%llx-0x%llx] not in root %pr\n",
> +                      (unsigned long long)start, (unsigned long long)end,
> +                      root);
> +               if (start > root->end || end < root->start) {
> +                       abort = 1;
> +                       pr_err("unable to fix request, aborting it\n");

This message doesn't contain any useful information (range/root/etc).

> +               } else {
> +                       if (end > root->end)
> +                               end = root->end;
> +                       if (start < root->start)
> +                               start = root->start;
> +                       pr_err("fixing request to [0x%llx-0x%llx]\n",
> +                              (unsigned long long)start,
> +                              (unsigned long long)end);
> +               }
> +               dump_stack();
> +       }
> +       if (!abort)
> +               __reserve_region_with_split(root, start, end, name);
>         write_unlock(&resource_lock);
>  }
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
