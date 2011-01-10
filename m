Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1AJKbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:31:40 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:40663 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab1AJKbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:31:38 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291593600"; 
   d="scan'208";a="3677707"
Date: Mon, 10 Jan 2011 10:33:05 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [Xen-devel] [PATCH 02/11] xen/gntdev: allow usermode to map
 granted pages
In-Reply-To: <20110105202512.GF29993@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1101071439540.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop> <1292420446-3348-2-git-send-email-stefano.stabellini@eu.citrix.com> <20110105202512.GF29993@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011, Konrad Rzeszutek Wilk wrote:
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Derek G. Murray <Derek.Murray@cl.cam.ac.uk>, "
> > +           "Gerd Hoffmann <kraxel@redhat.com>");
> > +MODULE_DESCRIPTION("User-space granted page access driver");
> > +
> > +static int debug = 0;
> > +module_param(debug, int, 0644);
> 
> You need to add:
> MODULE_PARM_DESC
> 

I removed the debug option altogether and substituted all the if (debug)
printk with pr_debug.


> > +static int limit = 1024;
> > +module_param(limit, int, 0644);
> 
> ditto

I added MODULE_PARM_DESC in this case.


> > +
> > +struct gntdev_priv {
> > +     struct list_head maps;
> > +     uint32_t used;
> > +     uint32_t limit;
> > +     spinlock_t lock;
> 
> and some description about what the lock is protecting.

done


> > +     struct mm_struct *mm;
> > +     struct mmu_notifier mn;
> > +};
> > +
> > +struct grant_map {
> > +     struct list_head next;
> > +     struct gntdev_priv *priv;
> > +     struct vm_area_struct *vma;
> > +     int index;
> > +     int count;
> > +     int flags;
> > +     int is_mapped;
> > +     struct ioctl_gntdev_grant_ref *grants;
> > +     struct gnttab_map_grant_ref   *map_ops;
> > +     struct gnttab_unmap_grant_ref *unmap_ops;
> > +};
> > +
> > +/* ------------------------------------------------------------------ */
> > +
> > +static void gntdev_print_maps(struct gntdev_priv *priv,
> > +                           char *text, int text_index)
> > +{
> > +     struct grant_map *map;
> > +
> > +     printk("%s: maps list (priv %p, usage %d/%d)\n",
> > +            __FUNCTION__, priv, priv->used, priv->limit);
> > +     list_for_each_entry(map, &priv->maps, next)
> > +             printk("  index %2d, count %2d %s\n",
> 
> Use pr_debug.
> 

I changed all the printk into pr_debug apart from the few that actually
print error or warning messages.


> > +             err = unmap_grant_pages(map,
> > +                                     (mstart - map->vma->vm_start) >> PAGE_SHIFT,
> > +                                     (mend - mstart) >> PAGE_SHIFT);
> > +             WARN_ON(err);
> 
> Ah you WARN here.. so two WARN_ON in case the hypervisor call fails.
> Maybe you just remove the WARN_ON in the unmap_grant_pages and let this
> WARN_ON do the job?

Right. I have done the same in map_grant_pages for consistency.


> > +             err = unmap_grant_pages(map, 0, map->count);
> 
> Ok, so offset set to zero (might want a put /* offset */ comment in there.
>

done


> > +static int gntdev_open(struct inode *inode, struct file *flip)
> > +{
> > +     struct gntdev_priv *priv;
> > +
> > +     priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> > +     if (!priv)
> > +             return -ENOMEM;
> > +
> > +     INIT_LIST_HEAD(&priv->maps);
> > +     spin_lock_init(&priv->lock);
> > +     priv->limit = limit;
> > +
> > +     priv->mm = get_task_mm(current);
> > +     if (!priv->mm) {
> > +             kfree(priv);
> > +             return -ENOMEM;
> > +     }
> > +     priv->mn.ops = &gntdev_mmu_ops;
> > +     mmu_notifier_register(&priv->mn, priv->mm);
> 
> You might want to check that this does not fail.
>

done


> > +     mmput(priv->mm);
> > +
> > +     flip->private_data = priv;
> > +     if (debug)
> > +             printk("%s: priv %p\n", __FUNCTION__, priv);
> > +
> > +     return 0;
> > +}
> > +
> > +static int gntdev_release(struct inode *inode, struct file *flip)
> > +{
> > +     struct gntdev_priv *priv = flip->private_data;
> > +     struct grant_map *map;
> > +     int err;
> > +
> > +     if (debug)
> > +             printk("%s: priv %p\n", __FUNCTION__, priv);
> > +
> > +     spin_lock(&priv->lock);
> > +     while (!list_empty(&priv->maps)) {
> > +             map = list_entry(priv->maps.next, struct grant_map, next);
> > +             err = gntdev_del_map(map);
> > +             if (WARN_ON(err))
> 
> Hmm, so if we fail (b/c we get -EBUSY) we free it? Would it be possible
> to race with whoever is responsible for releasing this VMA  (mn_release)
> clearning this map while the holder of this map is trying to dereference
> the map->unmap_ops ?
> 
> Oh wait, you and mn_release are both using  a spinlock.. so, under what
> conditions would this actually happend?

It shouldn't be possible because at the time gntdev_release is called
all the vma should have been unmmapped by mn_release already.
However I would like to keep the WARN_ON anyway because it might turn
out to be useful in the future.


> 
> > +                     gntdev_free_map(map);
> > +
> > +     }
> > +     spin_unlock(&priv->lock);
> > +
> > +     mmu_notifier_unregister(&priv->mn, priv->mm);
> > +     kfree(priv);
> > +     return 0;
> > +}
> > +
> > +static long gntdev_ioctl_map_grant_ref(struct gntdev_priv *priv,
> 
> The decleration is for 'long' but you return int. Looking at the
> other ioctl (kvm ones) they all seem to return 'int' so this
> decleration looks wrong.
> 

Unlocked_ioctl in file_operations returns long, hence gntdev_ioctl has
to return long. At this point it makes sense to return long from all the
ioctl related functions in gntdev.


> > +                                      struct ioctl_gntdev_unmap_grant_ref __user *u)
> > +{
> > +     struct ioctl_gntdev_unmap_grant_ref op;
> > +     struct grant_map *map;
> > +     int err = -EINVAL;
> 
> Not -ENOENT? If you can't find the map .. well, the arguments are valid.
> It is just that the map is not found. Or are the tools hard-coded to look
> for -EINVAL?
> 

No, I don't think so. ENOENT is more appropriate.


> > +static long gntdev_ioctl_set_max_grants(struct gntdev_priv *priv,
> > +                                     struct ioctl_gntdev_set_max_grants __user *u)
> > +{
> > +     struct ioctl_gntdev_set_max_grants op;
> > +
> > +     if (copy_from_user(&op, u, sizeof(op)) != 0)
> > +             return -EFAULT;
> > +     if (debug)
> > +             printk("%s: priv %p, limit %d\n", __FUNCTION__, priv, op.count);
> > +     if (op.count > limit)
> > +             return -EINVAL;
> 
> Not -E2BIG?
> 

OK

> > +     vma->vm_ops = &gntdev_vmops;
> > +
> > +     vma->vm_flags |= VM_RESERVED;
> > +     vma->vm_flags |= VM_DONTCOPY;
> > +     vma->vm_flags |= VM_DONTEXPAND;
> 
> You can squish those.

done

> > +     if (err) {
> > +             goto unlock_out;
> > +             if (debug)
> > +                     printk("%s: find_grant_ptes() failure.\n", __FUNCTION__);
> 
> Heh.. . You do a 'goto' and then 'if debug..' Swap them around.
> 

done

> > +     }
> > +
> > +     err = map_grant_pages(map);
> > +     if (err) {
> > +             goto unlock_out;
> > +             if (debug)
> > +                     printk("%s: map_grant_pages() failure.\n", __FUNCTION__);
> 
> Ditto.

done

