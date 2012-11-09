Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2KIQ0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:26:31 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:56172 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2KIQ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:26:29 -0500
MIME-Version: 1.0
In-Reply-To: <20121109160002.GA6474@avionic-0098.mockup.avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
	<1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
	<CAF6AEGs4bk3umkbQmJmB+Gf4UctKWa2Rj9GEi=DZSqU8MUd+9w@mail.gmail.com>
	<20121109160002.GA6474@avionic-0098.mockup.avionic-design.de>
Date: Fri, 9 Nov 2012 10:26:27 -0600
Message-ID: <CAF6AEGu0j1E96tzsTcJ91-FdTekAoWL7w1GBadRQ7p2h0smVDA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm: Add NVIDIA Tegra20 support
From: Rob Clark <robdclark@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Dave Airlie <airlied@redhat.com>, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 10:00 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Fri, Nov 09, 2012 at 09:18:58AM -0600, Rob Clark wrote:
>> On Fri, Nov 9, 2012 at 7:59 AM, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:
> [...]
>> > +static int regs_open(struct inode *inode, struct file *file)
>> > +{
>> > +       return single_open(file, regs_show, inode->i_private);
>> > +}
>> > +
>> > +static const struct file_operations regs_fops = {
>> > +       .open = regs_open,
>> > +       .read = seq_read,
>> > +       .llseek = seq_lseek,
>> > +       .release = single_release,
>> > +};
>> > +
>> > +static int tegra_dc_debugfs_init(struct tegra_dc *dc, struct dentry *parent)
>> > +{
>> > +       char *name;
>> > +
>> > +       name = kasprintf(GFP_KERNEL, "dc.%d", dc->pipe);
>> > +       dc->debugfs = debugfs_create_dir(name, parent);
>> > +       kfree(name);
>> > +
>> > +       debugfs_create_file("regs", 0400, dc->debugfs, dc, &regs_fops);
>> > +
>>
>> note that drm already has it's own debugfs helpers, see
>> drm_debugfs_create_files() and drm_debugfs_remove_files()
>>
>> And also see debugfs_init/debugfs_cleanup in 'struct drm_driver'.
>>
>> You probably want to be using that rather than rolling your own.  You
>> can have a look at omapdrm for a quite simple example, or i915 for a
>> more complex example.
>
> I actually tried to make use of those functions, but unfortunately it's
> not possible to hook it up properly. The reason is that I need to pass
> in some reference to the tegra_dc structure in order to read the
> registers, but the DRM debugfs support doesn't allow to do that. Or
> maybe it can. There's the void *arg argument that I could possibly use.
> Then again it won't allow the creation of separate directories for each
> of the display controllers. Or maybe I'm missing something.

yeah, no separate directories.. but you could use the void *arg.  It
is a bit awkward for dealing with multiple subdevices, we have the
same issue w/ omapdrm where dmm is a separate subdevice (and
dsi/dpi/hdmi/etc too shortly, as we merge omapdss and omapdrm).

But I guess better handling in drm for subdevices would help a lot of
the SoC platforms.  Maybe something that I'll give some more thought
later after the atomic pageflip/modeset stuff is sorted.


>> > +/* synchronization points */
>> > +#define SYNCPT_VBLANK0 26
>> > +#define SYNCPT_VBLANK1 27
>>
>> maybe these should be in dc.h?  Seems like these are related to the dc hw block?
>
> Yes, they could go into dc.h. This is one of the things that is likely
> to change at some point as more of the host1x support is added, which is
> where those syncpts are actually used.

hmm, are these values defined by the hw?  They look like register
offsets into the DC block?

>> > +int host1x_unregister_client(struct host1x *host1x,
>> > +                            struct host1x_client *client)
>> > +{
>> > +       struct host1x_drm_client *drm, *tmp;
>> > +       int err;
>> > +
>> > +       list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
>> > +               if (drm->client == client) {
>> > +                       err = host1x_drm_exit(host1x);
>> > +                       if (err < 0) {
>> > +                               dev_err(host1x->dev, "host1x_drm_exit(): %d\n",
>> > +                                       err);
>> > +                               return err;
>> > +                       }
>> > +
>> > +                       host1x_remove_drm_client(host1x, drm);
>> > +                       break;
>> > +               }
>> > +       }
>> > +
>> > +       mutex_lock(&host1x->clients_lock);
>> > +       list_del_init(&client->list);
>> > +       mutex_unlock(&host1x->clients_lock);
>> > +
>> > +       return 0;
>> > +}
>>
>> btw, if I understand the register/unregister client stuff, I think
>> there can be some potential issues.  If I understand correctly, you
>> will create the crtc's in register.  But unregister doesn't destroy
>> them, drm_mode_config_cleanup() when the container drm device is
>> unloaded does.  So if there is any possibility to unregister a client
>> without tearing down everything, you might get into some problems
>> here.
>>
>> Also, you might be breaking some assumptions about when the crtc's are
>> created.. at least if there is some possibility for userspace to sneak
>> in and do a getresources ioctl between the first and second client.
>> That might be easy enough to solve by adding some event for userspace
>> to get notified that it should getresources again.  The unregister is
>> what I worry about more.
>>
>> In general drm isn't set up to well for drivers that are a collection
>> of sub-devices.  It is probably worth trying to improve this, although
>> I am still a bit skittish about the edge cases, like what happens when
>> you unload a sub-device mid-modeset.  The issue comes up again for
>> common panel/display framework.
>>
>> But for now you might just want to do something to ensure that all the
>> sub-devices are loaded/unloaded together as a whole.
>
> The way that the above is supposed to work is that the DRM relevant
> host1x clients are kept in a separate list and only if all of them have
> successfully been probed is the DRM portion initialized. Upon
> unregistration, as soon as the first of these clients is unregistered,
> all of the DRM stuff is torn down.

ahh, ok, I guess if DRM is torn down on first unregister, then you
shouldn't be hitting issues.  I wasn't sure if the intention was to be
able to load/unload clients independently (such as building them as
separate modules eventually)

BR,
-R

> I don't believe there's an issue here. It's precisely what I've been
> testing for a while, always making sure that when built as a module it
> can properly be unloaded.
>
> That said it probably won't matter very much since on Tegra all drivers
> are usually builtin, so none of this may even be used in the end.
>
> Thanks for the quick review.
>
> Thierry
