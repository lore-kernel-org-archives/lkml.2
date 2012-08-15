Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab2HOGgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 02:36:47 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17295 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2HOGgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 02:36:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 14 Aug 2012 23:34:24 -0700
Date: Wed, 15 Aug 2012 09:34:21 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        Chris Wright <chrisw@sous-sol.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iommu/tegra: smmu: Use __debugfs_create_dir
Message-ID: <20120815093421.c08fdbbf4d7ce6c3986861f2@nvidia.com>
In-Reply-To: <20120808153100.GE9091@arwen.pp.htv.fi>
References: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
	<1344407073-12030-3-git-send-email-hdoyu@nvidia.com>
	<20120808151128.GC9091@arwen.pp.htv.fi>
	<20120808153100.GE9091@arwen.pp.htv.fi>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for review. Already sent the another version of patch(v2:
*1), but I tried to answer the remaining questions inlined.....

On Wed, 8 Aug 2012 17:31:02 +0200
Felipe Balbi <balbi@ti.com> wrote:

> * PGP Signed by an unknown key
> 
> Hi,
> 
> On Wed, Aug 08, 2012 at 06:11:29PM +0300, Felipe Balbi wrote:
> > Hi,
> >
> > On Wed, Aug 08, 2012 at 09:24:33AM +0300, Hiroshi Doyu wrote:
> > > The commit c3b1a35 "debugfs: make sure that debugfs_create_file() gets
> > > used only for regulars" doesn't allow to use debugfs_create_file() for
> > > dir. Use the version with "data", __debugfs_create_dir().
> > >
> > > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > > Reported-by: Laxman Dewangan <ldewangan@nvidia.com>
> > > ---
> > >  drivers/iommu/tegra-smmu.c |    4 +---
> > >  1 files changed, 1 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> > > index 5e51fb7..41aff7a 100644
> > > --- a/drivers/iommu/tegra-smmu.c
> > > +++ b/drivers/iommu/tegra-smmu.c
> > > @@ -1035,9 +1035,7 @@ static void smmu_debugfs_create(struct smmu_device *smmu)
> > >     int i;
> > >     struct dentry *root;
> > >
> > > -   root = debugfs_create_file(dev_name(smmu->dev),
> > > -                              S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
> > > -                              NULL, smmu, NULL);
> > > +   root = __debugfs_create_dir(dev_name(smmu->dev), NULL, smmu);
> >
> > why would the directory need extra data ? Looking in mainline,
> > tegra-smmu.c doesn't have any debugfs support, where can I see the
> > patches adding debugfs to tegra-smmu ? It doesn't look correct that the
> > directory will have a data field.
> 
> Looking at linux-next I found the commit which added it:

FYI: The original tegra smmu debugfs patch is:
  http://lists.linuxfoundation.org/pipermail/iommu/2012-August/004507.html

> > @@ -892,6 +909,164 @@ static struct iommu_ops smmu_iommu_ops = {
> >       .pgsize_bitmap  = SMMU_IOMMU_PGSIZES,
> >  };
> >
> > +/* Should be in the order of enum */
> > +static const char * const smmu_debugfs_mc[] = { "mc", };
> > +static const char * const smmu_debugfs_cache[] = {  "tlb", "ptc", };
> > +
> > +static ssize_t smmu_debugfs_stats_write(struct file *file,
> > +                                     const char __user *buffer,
> > +                                     size_t count, loff_t *pos)
> > +{
> > +     struct smmu_device *smmu;
> > +     struct dentry *dent;
> > +     int i, cache, mc;
> > +     enum {
> > +             _OFF = 0,
> > +             _ON,
> > +             _RESET,
> > +     };
> > +     const char * const command[] = {
> > +             [_OFF]          = "off",
> > +             [_ON]           = "on",
> > +             [_RESET]        = "reset",
> > +     };
> > +     char str[] = "reset";
> > +     u32 val;
> > +     size_t offs;
> > +
> > +     count = min_t(size_t, count, sizeof(str));
> > +     if (copy_from_user(str, buffer, count))
> > +             return -EINVAL;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(command); i++)
> > +             if (strncmp(str, command[i],
> > +                         strlen(command[i])) == 0)
> > +                     break;
> > +
> > +     if (i == ARRAY_SIZE(command))
> > +             return -EINVAL;
> > +
> > +     dent = file->f_dentry;
> > +     cache = (int)dent->d_inode->i_private;
> 
> cache you can figure out by the filename. In fact, it would be much
> better to have tlc and ptc directories with a "status" filename which
> you write ON/OFF/RESET or enable/disable/reset to trigger what you need.

Actually I also considered {ptc,tlb} directories, but I thought that
those might be residual, or nested one more unnecessarily.

The current usage is:

  $ echo "reset" > /sys/kernel/debug/smmu/mc/{tlb,ptc}
  $ echo "on" > /sys/kernel/debug/smmu/mc/{tlb,ptc}
  $ echo "off" > /sys/kernel/debug/smmu/mc/{tlb,ptc}
  $ cat /sys/kernel/debug/smmu/mc/{tlb,ptc}
  hit:0014910c miss:00014d22

  The above format is:
  hit:<HIT count><SPC>miss:<MISS count><SPC><CR+LF>

  fscanf(fp, "hit:%lx miss:%lx", &hit, &miss);


If {ptc,tlb} was dir, the usage would be:

  $ echo "reset" > /sys/kernel/debug/smmu/mc/{tlb,ptc}/status
  $ echo "on" > /sys/kernel/debug/smmu/mc/{tlb,ptc}/status
  $ echo "off" > /sys/kernel/debug/smmu/mc/{tlb,ptc}/status
  $ cat /sys/kernel/debug/smmu/mc/{tlb,ptc}/data
  hit:0014910c miss:00014d22

One advantage of dirs could be, you may be able to check the current
status by reading "status". It might be less likely read back
practically because if writing succeeded, the state should be what was
written.

> For that to work, you should probably hold tlb and ptc on an array of
> some sort, and pass those as data to their respective "status" files as
> the data field. If tlb and ptc are properly defined structures which can
> point back to smmu, then you have everything you need.

I also considered to introduce new structure like what you suggested
below, but I felt that the parent<-chile relationships are already in
directory hierarchy, and I wanted to avoid the residual data with
introducing new structures. Instead of introducing new structure,
those parent<-child relationships are always gotton from debugfs
directory hierarchy on demand. That was why I wanted to put data in
debugfs dir. With debugfs directories having private data, the
connections between entities would be kept in filesystem.

I've already sent another version of patch(v2, *1), which passes all
necessary data to a file, put in a structure. This v2 patch may be a
little bit simliear to what Felipe suggested below.

*1: http://lists.linuxfoundation.org/pipermail/iommu/2012-August/004535.html

> I mean something like:
> 
> struct smmu;
> 
> struct mc {
>         const char *name;
>         void __iomem *regs;
> 
>         struct smmu *smmu;
> };
> 
> struct smmu {
>         struct mc mc[2]; /*what does mc stand for ? memory controller ? */
> 
>         ...
> };
> 
> debugfs_create_dir(smmu);
> debugfs_create_dir(mc);
> debugfs_create_dir(smmu->mc[1].name);
> debugfs_create_dir(smmu->mc[2].name);
> debugfs_create_file(&smmu->mc[1], status);
> debugfs_create_file(&smmu->mc[2], status);
> 
> or something similar. You will avoid all the trickery you did here to
> achieve what you need.
> 
> > +     mc = (int)dent->d_parent->d_inode->i_private;
> > +     smmu = dent->d_parent->d_parent->d_inode->i_private;
> > +
> > +     offs = SMMU_CACHE_CONFIG(cache);
> > +     val = smmu_read(smmu, offs);
> > +     switch (i) {
> > +     case _OFF:
> > +             val &= ~SMMU_CACHE_CONFIG_STATS_ENABLE;
> > +             val &= ~SMMU_CACHE_CONFIG_STATS_TEST;
> > +             smmu_write(smmu, val, offs);
> > +             break;
> > +     case _ON:
> > +             val |= SMMU_CACHE_CONFIG_STATS_ENABLE;
> > +             val &= ~SMMU_CACHE_CONFIG_STATS_TEST;
> > +             smmu_write(smmu, val, offs);
> > +             break;
> > +     case _RESET:
> > +             val |= SMMU_CACHE_CONFIG_STATS_TEST;
> > +             smmu_write(smmu, val, offs);
> > +             val &= ~SMMU_CACHE_CONFIG_STATS_TEST;
> > +             smmu_write(smmu, val, offs);
> > +             break;
> > +     default:
> > +             BUG();
> > +             break;
> > +     }
> > +
> > +     dev_dbg(smmu->dev, "%s() %08x, %08x @%08x\n", __func__,
> > +             val, smmu_read(smmu, offs), offs);
> > +
> > +     return count;
> > +}
> > +
> > +static int smmu_debugfs_stats_show(struct seq_file *s, void *v)
> > +{
> > +     struct smmu_device *smmu;
> > +     struct dentry *dent;
> > +     int i, cache, mc;
> > +     const char * const stats[] = { "hit", "miss", };
> > +
> > +     dent = d_find_alias(s->private);
> > +     cache = (int)dent->d_inode->i_private;
> > +     mc = (int)dent->d_parent->d_inode->i_private;
> > +     smmu = dent->d_parent->d_parent->d_inode->i_private;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(stats); i++) {
> > +             u32 val;
> > +             size_t offs;
> > +
> > +             offs = SMMU_STATS_CACHE_COUNT(mc, cache, i);
> > +             val = smmu_read(smmu, offs);
> > +             seq_printf(s, "%s:%08x ", stats[i], val);
> > +
> > +             dev_dbg(smmu->dev, "%s() %s %08x @%08x\n", __func__,
> > +                     stats[i], val, offs);
> > +     }
> > +     seq_printf(s, "\n");
> > +
> > +     return 0;
> > +}
> > +
> > +static int smmu_debugfs_stats_open(struct inode *inode, struct file *file)
> > +{
> > +     return single_open(file, smmu_debugfs_stats_show, inode);
> > +}
> > +
> > +static const struct file_operations smmu_debugfs_stats_fops = {
> > +     .open           = smmu_debugfs_stats_open,
> > +     .read           = seq_read,
> > +     .llseek         = seq_lseek,
> > +     .release        = single_release,
> > +     .write          = smmu_debugfs_stats_write,
> > +};
> > +
> > +static void smmu_debugfs_delete(struct smmu_device *smmu)
> > +{
> > +     debugfs_remove_recursive(smmu->debugfs_root);
> > +}
> > +
> > +static void smmu_debugfs_create(struct smmu_device *smmu)
> > +{
> > +     int i;
> > +     struct dentry *root;
> > +
> > +     root = debugfs_create_file(dev_name(smmu->dev),
> > +                                S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
> > +                                NULL, smmu, NULL);
> 
> directories don't need data. You don't even have a file_operations
> structure so when exactly are you going to access the data ? What you
> did above is actually wrong. You need to either patch this ASAP or drop
> the patch you wrote and rewrite the whole debugfs support.
> 
> > +     if (!root)
> > +             goto err_out;
> > +     smmu->debugfs_root = root;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(smmu_debugfs_mc); i++) {
> > +             int j;
> > +             struct dentry *mc;
> > +
> > +             mc = debugfs_create_file(smmu_debugfs_mc[i],
> > +                                      S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
> > +                                      root, (void *)i, NULL);
> 
> likewise here. What would you use that index for ? Even if you were to
> access it, how would you use it ? Not to mention that you never, ever
> access the private_data of the directory :-)
> 
> Just convert these two to the proper debugfs_create_dir()
> 
> > +             if (!mc)
> > +                     goto err_out;
> > +
> > +             for (j = 0; j < ARRAY_SIZE(smmu_debugfs_cache); j++) {
> > +                     struct dentry *cache;
> > +
> > +                     cache = debugfs_create_file(smmu_debugfs_cache[j],
> > +                                                 S_IWUGO | S_IRUGO, mc,
> > +                                                 (void *)j,
> > +                                                 &smmu_debugfs_stats_fops);
> 
> it would be far better to pass a structure which you actually need. In
> this case 'smmu'. That will be a lot more useful for your code.
