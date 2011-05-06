Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1EFAVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:21:31 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53834 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab1EFAV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WEjs7rbhmJavUfRdT+QXp/JwY86dKAvlpuKwpKxjHNjhQzmx52B1madfh45svbhBNl
         3oNDP4/aLMnpbhb0K161edKZNbU7OrSxcJQBDt9+rApVut5936neGO4c5dJAuVL+zjZ9
         DyhmlcmK0qctlHYorJKdgcc62jeLyD1jRf5WI=
MIME-Version: 1.0
In-Reply-To: <1304617307-7389-2-git-send-email-tim.gardner@canonical.com>
References: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com>
	<1304617307-7389-2-git-send-email-tim.gardner@canonical.com>
Date: Fri, 6 May 2011 03:21:25 +0300
Message-ID: <BANLkTik4FDvBBE6syMj_kUNsCMG5x5wvuQ@mail.gmail.com>
Subject: Re: [PATCH] fbcon -- fix race between open and removal of framebuffers
From: Anca Emanuel <anca.emanuel@gmail.com>
To: tim.gardner@canonical.com
Cc: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 5, 2011 at 8:41 PM,  <tim.gardner@canonical.com> wrote:
> From: Andy Whitcroft <apw@canonical.com>
>
> Currently there is no locking for updates to the registered_fb list.
> This allows an open through /dev/fbN to pick up a registered framebuffer
> pointer in parallel with it being released, as happens when a conflicting
> framebuffer is ejected or on module unload.  There is also no reference
> counting on the framebuffer descriptor which is referenced from all open
> files, leading to references to released or reused memory to persist on
> these open files.
>
> This patch adds a reference count to the framebuffer descriptor to prevent
> it from being released until after all pending opens are closed.  This
> allows the pending opens to detect the closed status and unmap themselves.
> It also adds locking to the framebuffer lookup path, locking it against
> the removal path such that it is possible to atomically lookup and take a
> reference to the descriptor.  It also adds locking to the read and write
> paths which currently could access the framebuffer descriptor after it
> has been freed.  Finally it moves the device to FBINFO_STATE_REMOVED to
> indicate that all access should be errored for this device.
>
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> Acked-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/video/fbmem.c |  132 ++++++++++++++++++++++++++++++++++++++-----------
>  include/linux/fb.h    |    2 +
>  2 files changed, 105 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index e0c2284..c8562c1 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -42,6 +42,8 @@
>
>  #define FBPIXMAPSIZE   (1024 * 8)
>
> +/* Protects the registered framebuffer list and count. */
> +static DEFINE_SPINLOCK(registered_lock);
>  struct fb_info *registered_fb[FB_MAX] __read_mostly;
>  int num_registered_fb __read_mostly;
>
> @@ -694,9 +696,7 @@ static ssize_t
>  fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  {
>        unsigned long p = *ppos;
> -       struct inode *inode = file->f_path.dentry->d_inode;
> -       int fbidx = iminor(inode);
> -       struct fb_info *info = registered_fb[fbidx];
> +       struct fb_info *info = file->private_data;
>        u8 *buffer, *dst;
>        u8 __iomem *src;
>        int c, cnt = 0, err = 0;
> @@ -705,19 +705,28 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>        if (!info || ! info->screen_base)
>                return -ENODEV;
>
> -       if (info->state != FBINFO_STATE_RUNNING)
> -               return -EPERM;
> +       if (!lock_fb_info(info))
> +               return -ENODEV;
> +
> +       if (info->state != FBINFO_STATE_RUNNING) {
> +               err = -EPERM;
> +               goto out_fb_info;
> +       }
>
> -       if (info->fbops->fb_read)
> -               return info->fbops->fb_read(info, buf, count, ppos);
> +       if (info->fbops->fb_read) {
> +               err = info->fbops->fb_read(info, buf, count, ppos);
> +               goto out_fb_info;
> +       }
>
>        total_size = info->screen_size;
>
>        if (total_size == 0)
>                total_size = info->fix.smem_len;
>
> -       if (p >= total_size)
> -               return 0;
> +       if (p >= total_size) {
> +               err = 0;
> +               goto out_fb_info;
> +       }
>
>        if (count >= total_size)
>                count = total_size;
> @@ -727,8 +736,10 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>
>        buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count,
>                         GFP_KERNEL);
> -       if (!buffer)
> -               return -ENOMEM;
> +       if (!buffer) {
> +               err = -ENOMEM;
> +               goto out_fb_info;
> +       }
>
>        src = (u8 __iomem *) (info->screen_base + p);
>
> @@ -751,19 +762,21 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>                cnt += c;
>                count -= c;
>        }
> +       if (!err)
> +               err = cnt;
>
>        kfree(buffer);
> +out_fb_info:
> +       unlock_fb_info(info);
>
> -       return (err) ? err : cnt;
> +       return err;
>  }
>
>  static ssize_t
>  fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
>  {
>        unsigned long p = *ppos;
> -       struct inode *inode = file->f_path.dentry->d_inode;
> -       int fbidx = iminor(inode);
> -       struct fb_info *info = registered_fb[fbidx];
> +       struct fb_info *info = file->private_data;
>        u8 *buffer, *src;
>        u8 __iomem *dst;
>        int c, cnt = 0, err = 0;
> @@ -772,8 +785,13 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
>        if (!info || !info->screen_base)
>                return -ENODEV;
>
> -       if (info->state != FBINFO_STATE_RUNNING)
> -               return -EPERM;
> +       if (!lock_fb_info(info))
> +               return -ENODEV;
> +
> +       if (info->state != FBINFO_STATE_RUNNING) {
> +               err = -EPERM;
> +               goto out_fb_info;
> +       }
>
>        if (info->fbops->fb_write)
>                return info->fbops->fb_write(info, buf, count, ppos);
> @@ -783,8 +801,10 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
>        if (total_size == 0)
>                total_size = info->fix.smem_len;
>
> -       if (p > total_size)
> -               return -EFBIG;
> +       if (p > total_size) {
> +               err = -EFBIG;
> +               goto out_fb_info;
> +       }
>
>        if (count > total_size) {
>                err = -EFBIG;
> @@ -800,8 +820,10 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
>
>        buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count,
>                         GFP_KERNEL);
> -       if (!buffer)
> -               return -ENOMEM;
> +       if (!buffer) {
> +               err = -ENOMEM;
> +               goto out_fb_info;
> +       }
>
>        dst = (u8 __iomem *) (info->screen_base + p);
>
> @@ -825,10 +847,14 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
>                cnt += c;
>                count -= c;
>        }
> +       if (cnt)
> +               err = cnt;
>
>        kfree(buffer);
> +out_fb_info:
> +       unlock_fb_info(info);
>
> -       return (cnt) ? cnt : err;
> +       return err;
>  }
>
>  int
> @@ -1303,8 +1329,7 @@ static long fb_compat_ioctl(struct file *file, unsigned int cmd,
>  static int
>  fb_mmap(struct file *file, struct vm_area_struct * vma)
>  {
> -       int fbidx = iminor(file->f_path.dentry->d_inode);
> -       struct fb_info *info = registered_fb[fbidx];
> +       struct fb_info * const info = file->private_data;
>        struct fb_ops *fb = info->fbops;
>        unsigned long off;
>        unsigned long start;
> @@ -1316,6 +1341,11 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
>        if (!fb)
>                return -ENODEV;
>        mutex_lock(&info->mm_lock);
> +       if (info->state == FBINFO_STATE_REMOVED) {
> +               mutex_unlock(&info->mm_lock);
> +               return -ENODEV;
> +       }
> +
>        if (fb->fb_mmap) {
>                int res;
>                res = fb->fb_mmap(info, vma);
> @@ -1352,6 +1382,34 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
>        return 0;
>  }
>
> +static struct fb_info *get_framebuffer_info(int idx)
> +__acquires(&registered_lock)
> +__releases(&registered_lock)
> +{
> +       struct fb_info *fb_info;
> +
> +       spin_lock(&registered_lock);
> +       fb_info = registered_fb[idx];
> +       fb_info->ref_count++;
> +       spin_unlock(&registered_lock);
> +
> +       return fb_info;
> +}
> +
> +static void put_framebuffer_info(struct fb_info *fb_info)
> +__acquires(&registered_lock)
> +__releases(&registered_lock)
> +{
> +       int keep;
> +
> +       spin_lock(&registered_lock);
> +       keep = --fb_info->ref_count;
> +       spin_unlock(&registered_lock);
> +
> +       if (!keep && fb_info->fbops->fb_destroy)
> +               fb_info->fbops->fb_destroy(fb_info);
> +}
> +
>  static int
>  fb_open(struct inode *inode, struct file *file)
>  __acquires(&info->lock)
> @@ -1363,13 +1421,17 @@ __releases(&info->lock)
>
>        if (fbidx >= FB_MAX)
>                return -ENODEV;
> -       info = registered_fb[fbidx];
> +       info = get_framebuffer_info(fbidx);
>        if (!info)
>                request_module("fb%d", fbidx);
> -       info = registered_fb[fbidx];
> +       info = get_framebuffer_info(fbidx);
>        if (!info)
>                return -ENODEV;
>        mutex_lock(&info->lock);
> +       if (info->state == FBINFO_STATE_REMOVED) {
> +               res = -ENODEV;
> +               goto out;
> +       }
>        if (!try_module_get(info->fbops->owner)) {
>                res = -ENODEV;
>                goto out;
> @@ -1386,6 +1448,8 @@ __releases(&info->lock)
>  #endif
>  out:
>        mutex_unlock(&info->lock);
> +       if (res)
> +               put_framebuffer_info(info);
>        return res;
>  }
>
> @@ -1401,6 +1465,7 @@ __releases(&info->lock)
>                info->fbops->fb_release(info,1);
>        module_put(info->fbops->owner);
>        mutex_unlock(&info->lock);
> +       put_framebuffer_info(info);
>        return 0;
>  }
>
> @@ -1549,6 +1614,7 @@ register_framebuffer(struct fb_info *fb_info)
>        fb_info->node = i;
>        mutex_init(&fb_info->lock);
>        mutex_init(&fb_info->mm_lock);
> +       fb_info->ref_count = 1;
>
>        fb_info->dev = device_create(fb_class, fb_info->device,
>                                     MKDEV(FB_MAJOR, i), NULL, "fb%d", i);
> @@ -1592,7 +1658,6 @@ register_framebuffer(struct fb_info *fb_info)
>        return 0;
>  }
>
> -
>  /**
>  *     unregister_framebuffer - releases a frame buffer device
>  *     @fb_info: frame buffer info structure
> @@ -1627,6 +1692,16 @@ unregister_framebuffer(struct fb_info *fb_info)
>                return -ENODEV;
>        event.info = fb_info;
>        ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
> +       if (!ret) {
> +               mutex_lock(&fb_info->mm_lock);
> +               /*
> +                * We must prevent any operations for this transition, we
> +                * already have info->lock so grab the info->mm_lock to hold
> +                * the remainder.
> +                */
> +               fb_info->state = FBINFO_STATE_REMOVED;
> +               mutex_unlock(&fb_info->mm_lock);
> +       }
>        unlock_fb_info(fb_info);
>
>        if (ret) {
> @@ -1646,8 +1721,7 @@ unregister_framebuffer(struct fb_info *fb_info)
>        fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
>
>        /* this may free fb info */
> -       if (fb_info->fbops->fb_destroy)
> -               fb_info->fbops->fb_destroy(fb_info);
> +       put_framebuffer_info(fb_info);
>  done:
>        return ret;
>  }
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index df728c1..60de3fa 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -834,6 +834,7 @@ struct fb_tile_ops {
>  struct fb_info {
>        int node;
>        int flags;
> +       int ref_count;
>        struct mutex lock;              /* Lock for open/release/ioctl funcs */
>        struct mutex mm_lock;           /* Lock for fb_mmap and smem_* fields */
>        struct fb_var_screeninfo var;   /* Current var */
> @@ -873,6 +874,7 @@ struct fb_info {
>        void *pseudo_palette;           /* Fake palette of 16 colors */
>  #define FBINFO_STATE_RUNNING   0
>  #define FBINFO_STATE_SUSPENDED 1
> +#define FBINFO_STATE_REMOVED   2
>        u32 state;                      /* Hardware state i.e suspend */
>        void *fbcon_par;                /* fbcon use-only private area */
>        /* From here on everything is device dependent */
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Tested-by: Anca Emanuel <anca.emanuel.gmail.com>

I can not use S3 resume without this.
[   21.964367] BUG: unable to handle kernel paging request at 0000010a00000010
[   21.964396] IP: [<ffffffff8130abe0>] fb_release+0x30/0x70
[   21.964410] PGD 0
[   21.964416] Oops: 0000 [#1] SMP
[   21.964424] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
[   21.964434] CPU 1
[   21.964438] Modules linked in: parport_pc ppdev
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
adt7475 hwmon_vid snd_seq_midi snd_rawmidi snd_seq_midi_event nouveau
snd_seq snd_timer snd_seq_device ttm drm_kms_helper snd intel_agp
psmouse soundcore serio_raw intel_gtt snd_page_alloc drm i2c_algo_bit
video lp parport pata_marvell ahci libahci r8169 mii
[   21.964528]
[   21.964533] Pid: 221, comm: plymouthd Not tainted 2.6.39-rc6 #7
MICRO-STAR INTERNATIONAL CO.,LTD MS-7360/MS-7360
[   21.964548] RIP: 0010:[<ffffffff8130abe0>]  [<ffffffff8130abe0>]
fb_release+0x30/0x70
[   21.964560] RSP: 0018:ffff880037211eb8  EFLAGS: 00010286
[   21.964566] RAX: ffff880037210000 RBX: ffff88007f817000 RCX: 0000000000000001
[   21.964573] RDX: 0000010a00000000 RSI: ffff8800370f5540 RDI: ffff88007f817008
[   21.964580] RBP: ffff880037211ec8 R08: 0000000000000000 R09: 0000000000000000
[   21.964588] R10: ffff8800370f5550 R11: 0000000000000246 R12: ffff88007f817008
[   21.964595] R13: ffff88007d3db540 R14: ffff88007be34d90 R15: ffff88007be34d90
[   21.964604] FS:  00007fb335025720(0000) GS:ffff88007fc80000(0000)
knlGS:0000000000000000
[   21.964739] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   21.964746] CR2: 0000010a00000010 CR3: 000000007b41a000 CR4: 00000000000006e0
[   21.964754] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   21.964762] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   21.964770] Process plymouthd (pid: 221, threadinfo
ffff880037210000, task ffff880036cd16c0)
[   21.964778] Stack:
[   21.964782]  ffff8800370f5540 0000000000000008 ffff880037211f18
ffffffff8115cfaa
[   21.964797]  ffff8800370f5550 ffff8800793c7b00 ffff88006744fcd0
ffff8800370f5540
[   21.964811]  ffff88007c3b9080 0000000000000000 000000000000000b
0000000000000000
[   21.964825] Call Trace:
[   21.964834]  [<ffffffff8115cfaa>] fput+0xea/0x220
[   21.964842]  [<ffffffff811591f6>] filp_close+0x66/0x90
[   21.964849]  [<ffffffff811597c7>] sys_close+0xb7/0x120
[   21.964858]  [<ffffffff815b3002>] system_call_fastpath+0x16/0x1b
[   21.964865] Code: 83 ec 10 48 89 1c 24 4c 89 64 24 08 0f 1f 44 00
00 48 8b 9e a0 00 00 00 4c 8d 63 08 4c 89 e7 e8 d7 ea 29 00 48 8b 93
b8 03 00 00
[   21.964944]  8b 42 10 48 85 c0 74 11 be 01 00 00 00 48 89 df ff d0 48 8b
[   21.964983] RIP  [<ffffffff8130abe0>] fb_release+0x30/0x70
[   21.964992]  RSP <ffff880037211eb8>
[   21.964997] CR2: 0000010a00000010
