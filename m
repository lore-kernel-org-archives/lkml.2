Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab2EAX6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:58:24 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60922 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755622Ab2EAX6V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:58:21 -0400
MIME-Version: 1.0
In-Reply-To: <1332135781-13695-18-git-send-email-yinghai@kernel.org>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org> <1332135781-13695-18-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 1 May 2012 17:57:58 -0600
Message-ID: <CAErSpo4BZAf_i3ojXpg5WSFJ00G5i_vscVTu2va_Z3WJ0UHg=g@mail.gmail.com>
Subject: Re: [PATCH -v11 17/30] resources: Add probe_resource()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 11:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> It is changed from busn_res only version, because Bjorn found that version
> was not holding resource_lock.
> Even it may be ok for busn_res not holding resource_lock.
> It would be better to have it to be generic and use lock and we would
> use it for other resources.
>
> probe_resource() will try to find specified size or more in parent bus.
> If can not find current parent resource, and it will try to expand parents
> top.
> If still can not find that specified on top, it will try to reduce target size
> until find one.
>
> It will return 0, if it find any resource that it could use.
>
> Returned resource already register in the tree.
>
> So caller may still need call resource_replace to put real resource in
> the tree.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/ioport.h |    7 ++
>  kernel/resource.c      |  160 ++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 162 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index e885ba2..20a30df 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -156,6 +156,13 @@ extern int allocate_resource(struct resource *root, struct resource *new,
>                                                       resource_size_t,
>                                                       resource_size_t),
>                             void *alignf_data);
> +void resource_shrink_parents_top(struct resource *b_res,
> +                                long size, struct resource *parent_res);
> +struct device;
> +int probe_resource(struct resource *b_res,
> +                       struct device *dev, struct resource *busn_res,
> +                       resource_size_t needed_size, struct resource **p,
> +                       int skip_nr, int limit, char *name);

This interface is a mess.  I have a vague impression that this is
supposed to figure out whether a resource can be expanded, but why
does it need a struct device *?  (I can read the code and see how you
use it, but it just doesn't fit in the resource abstraction.)
Supplying one struct resource * makes sense, but you have three.  A
char * name?  What's skip_nr?  This just doesn't make sense to me.

I think you need a simpler, more general interface.  update_resource()
seems OK to me -- it's pretty straightforward and has an obvious
meaning.  Maybe you can make a resource_expand() or something that
just expands a resource in both directions as far as possible (until
it hits a sibling or the parent limits).  Then you would know the
maximum possible size, and you could use update_resource() to shrink
it again and give up anything you don't need.

I spent most of the day merging the patches up to this point, and they
mostly make sense, but this one and the following ones are beyond my
ken, so I gave up.

>  struct resource *lookup_resource(struct resource *root, resource_size_t start);
>  int adjust_resource(struct resource *res, resource_size_t start,
>                    resource_size_t size);
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 7640b3a..0c9616f 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -521,14 +521,14 @@ out:
>  * @alignf: alignment function, optional, called if not NULL
>  * @alignf_data: arbitrary data to pass to the @alignf function
>  */
> -int allocate_resource(struct resource *root, struct resource *new,
> +static int __allocate_resource(struct resource *root, struct resource *new,
>                      resource_size_t size, resource_size_t min,
>                      resource_size_t max, resource_size_t align,
>                      resource_size_t (*alignf)(void *,
>                                                const struct resource *,
>                                                resource_size_t,
>                                                resource_size_t),
> -                     void *alignf_data)
> +                     void *alignf_data, bool lock)
>  {
>        int err;
>        struct resource_constraint constraint;
> @@ -542,19 +542,33 @@ int allocate_resource(struct resource *root, struct resource *new,
>        constraint.alignf = alignf;
>        constraint.alignf_data = alignf_data;
>
> -       if ( new->parent ) {
> +       if (new->parent && lock) {
>                /* resource is already allocated, try reallocating with
>                   the new constraints */
>                return reallocate_resource(root, new, size, &constraint);
>        }
>
> -       write_lock(&resource_lock);
> +       if (lock)
> +               write_lock(&resource_lock);
>        err = find_resource(root, new, size, &constraint);
>        if (err >= 0 && __request_resource(root, new))
>                err = -EBUSY;
> -       write_unlock(&resource_lock);
> +       if (lock)
> +               write_unlock(&resource_lock);
>        return err;
>  }
> +int allocate_resource(struct resource *root, struct resource *new,
> +                     resource_size_t size, resource_size_t min,
> +                     resource_size_t max, resource_size_t align,
> +                     resource_size_t (*alignf)(void *,
> +                                               const struct resource *,
> +                                               resource_size_t,
> +                                               resource_size_t),
> +                     void *alignf_data)
> +{
> +       return __allocate_resource(root, new, size, min, max, align,
> +                                  alignf, alignf_data, true);
> +}
>
>  EXPORT_SYMBOL(allocate_resource);
>
> @@ -962,6 +976,142 @@ void __release_region(struct resource *parent, resource_size_t start,
>  }
>  EXPORT_SYMBOL(__release_region);
>
> +static void __resource_update_parents_top(struct resource *b_res,
> +                long size, struct resource *parent_res)
> +{
> +       struct resource *res = b_res;
> +
> +       if (!size)
> +               return;
> +
> +       while (res) {
> +               if (res == parent_res)
> +                       break;
> +               res->end += size;
> +               res = res->parent;
> +       }
> +}
> +
> +static void __resource_extend_parents_top(struct resource *b_res,
> +                long size, struct resource *parent_res)
> +{
> +       __resource_update_parents_top(b_res, size, parent_res);
> +}
> +
> +void resource_shrink_parents_top(struct resource *b_res,
> +                long size, struct resource *parent_res)
> +{
> +       write_lock(&resource_lock);
> +       __resource_update_parents_top(b_res, -size, parent_res);
> +       write_unlock(&resource_lock);
> +}
> +
> +static resource_size_t __find_res_top_free_size(struct resource *res)
> +{
> +       resource_size_t n_size;
> +       struct resource tmp_res;
> +
> +       /*
> +        *   find out number below res->end, that we can use at first
> +        *      res->start can not be used.
> +        */
> +       n_size = resource_size(res) - 1;
> +       memset(&tmp_res, 0, sizeof(struct resource));
> +       while (n_size > 0) {
> +               int ret;
> +
> +               ret = __allocate_resource(res, &tmp_res, n_size,
> +                       res->end - n_size + 1, res->end,
> +                       1, NULL, NULL, false);
> +               if (ret == 0) {
> +                       __release_resource(&tmp_res);
> +                       break;
> +               }
> +               n_size--;
> +       }
> +
> +       return n_size;
> +}
> +
> +int probe_resource(struct resource *b_res,
> +                        struct device *dev, struct resource *busn_res,
> +                        resource_size_t needed_size, struct resource **p,
> +                        int skip_nr, int limit, char *name)
> +{
> +       int ret = -ENOMEM;
> +       resource_size_t n_size;
> +       struct resource *parent_res = NULL;
> +       resource_size_t tmp = b_res->end + 1;
> +
> +again:
> +       /*
> +        * find biggest range in b_res that we can use in the middle
> +        *  and we can not use some spots from start of b_res.
> +        */
> +       n_size = resource_size(b_res);
> +       if (n_size > skip_nr)
> +               n_size -= skip_nr;
> +       else
> +               n_size = 0;
> +
> +       memset(busn_res, 0, sizeof(struct resource));
> +       dev_printk(KERN_DEBUG, dev, "find free %s in res: %pR\n", name, b_res);
> +       while (n_size >= needed_size) {
> +               ret = allocate_resource(b_res, busn_res, n_size,
> +                               b_res->start + skip_nr, b_res->end,
> +                               1, NULL, NULL);
> +               if (!ret)
> +                       return ret;
> +               n_size--;
> +       }
> +
> +       /* try extend the top of parent bus, find free under top at first */
> +       write_lock(&resource_lock);
> +       n_size = __find_res_top_free_size(b_res);
> +       dev_printk(KERN_DEBUG, dev, "found free %s %ld in res: %pR top\n",
> +                       name, (unsigned long)n_size, b_res);
> +
> +       /* can not extend cross local boundary */
> +       if ((limit - b_res->end) < (needed_size - n_size))
> +               goto reduce_needed_size;
> +
> +       /* find extended range */
> +       memset(busn_res, 0, sizeof(struct resource));
> +       parent_res = b_res;
> +       while (parent_res) {
> +               ret = __allocate_resource(parent_res, busn_res,
> +                        needed_size - n_size,
> +                        tmp, tmp + needed_size - n_size - 1,
> +                        1, NULL, NULL, false);
> +               if (!ret) {
> +                       /* save parent_res, we need it as stopper later */
> +                       *p = parent_res;
> +
> +                       /* prepare busn_res for return */
> +                       __release_resource(busn_res);
> +                       busn_res->start -= n_size;
> +
> +                       /* extend parent bus top*/
> +                       __resource_extend_parents_top(b_res,
> +                                        needed_size - n_size, parent_res);
> +                       __request_resource(b_res, busn_res);
> +
> +                       write_unlock(&resource_lock);
> +                       return ret;
> +               }
> +               parent_res = parent_res->parent;
> +       }
> +
> +reduce_needed_size:
> +       write_unlock(&resource_lock);
> +       /* ret must not be 0 here */
> +       needed_size--;
> +       if (needed_size)
> +               goto again;
> +
> +       return ret;
> +}
> +
>  /*
>  * Managed region resource
>  */
> --
> 1.7.7
>
