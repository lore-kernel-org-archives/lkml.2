Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab0KWTIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:08:36 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60183 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab0KWTIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:08:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K2kjkkem9gGjf2yh9/zOohIUjLs/VYgVi4vVyG9MtX0yGZqaQDUfu4vSQ33JRCeMId
         VSBQgUQXDzIQ1OnNbBVwYKp7bmcHmeyvqPmQ1OFWVRTFV1fwY1T6Qezf4lQjGju8PYIW
         V37rtySuSYpuJV/cvYn9LyhMmfwsRL1C6kHR8=
Date: Tue, 23 Nov 2010 22:08:28 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Tiago Vignatti <tiago.vignatti@nokia.com>,
        Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpu: vga: limit kmalloc'ed memory size
Message-ID: <20101123190828.GA27159@albatros>
References: <1290445864-13657-1-git-send-email-segoon@openwall.com>
 <20101122100915.5bf966fe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101122100915.5bf966fe.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 10:09 -0800, Andrew Morton wrote:
> Arguably we should just let the allocation attempt pass through to
> kmalloc() and let kmalloc() return an error if it was too large.  Possibly
> we need a __GFP_NOWARN in there somewhere.  Please send us that stack
> dump?


void *p = kmalloc(5L*1024*1024, GFP_KERNEL);
pr_err("p = %p\n", p);


[13896.001970] ------------[ cut here ]------------
[13896.001979] WARNING: at
/build/buildd/linux-lts-backport-maverick-2.6.35/mm/page_alloc.c:1968
__alloc_pages_slowpath+0x44b/0x590()
[13896.001983] Hardware name: Q310                       
[13896.001984] Modules linked in: test(+) easy_slow_down_manager rfcomm
sco bridge stp bnep l2cap vboxnetadp vboxnetflt vboxdrv nfsd exportfs
nfs lockd fscache nfs_acl auth_rpcgss sunrpc samsung_backlight
binfmt_misc ppdev input_polldev lp parport snd_seq_dummy uvcvideo
videodev v4l1_compat v4l2_compat_ioctl32 iTCO_vendor_support dm_crypt
usb_storage aes_x86_64 aes_generic vfat fat nls_cp437 nls_iso8859_1
usblp joydev arc4 btusb bluetooth snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device nouveau ath5k ttm mac80211 drm_kms_helper ath snd
cfg80211 video output drm soundcore led_class psmouse snd_page_alloc
sky2 serio_raw i2c_algo_bit intel_agp [last unloaded: test]
[13896.002045] Pid: 27627, comm: insmod Not tainted 2.6.35-22-generic
#34~lucid1-Ubuntu
[13896.002047] Call Trace:
[13896.002055]  [<ffffffff8106079f>] warn_slowpath_common+0x7f/0xc0
[13896.002059]  [<ffffffff810607fa>] warn_slowpath_null+0x1a/0x20
[13896.002063]  [<ffffffff811081bb>] __alloc_pages_slowpath+0x44b/0x590
[13896.002067]  [<ffffffff8112aaae>] ? lazy_max_pages+0x1e/0x30
[13896.002071]  [<ffffffff81104f74>] ? __probe_kernel_write+0x44/0x70
[13896.002075]  [<ffffffff8110849a>] __alloc_pages_nodemask+0x19a/0x1f0
[13896.002080]  [<ffffffff8113a30a>] alloc_pages_current+0x9a/0x100
[13896.002084]  [<ffffffffa01cb020>] ? hello_init+0x0/0xa0 [test]
[13896.002088]  [<ffffffff8110736e>] __get_free_pages+0xe/0x50
[13896.002091]  [<ffffffffa01cb04f>] hello_init+0x2f/0xa0 [test]
[13896.002095]  [<ffffffffa01cb020>] ? hello_init+0x0/0xa0 [test]
[13896.002099]  [<ffffffff8100204c>] do_one_initcall+0x3c/0x1a0
[13896.002104]  [<ffffffff8109bceb>] sys_init_module+0xbb/0x200
[13896.002109]  [<ffffffff8100a0f2>] system_call_fastpath+0x16/0x1b
[13896.002112] ---[ end trace b991655c592a1d6e ]---
[13896.002114] p = (null)



> And perhaps
> strndup_user() needs __GFP_NOWARN treatment.

strndup_user() silently return ERR_PTR(-EINVAL) if string is too long.

> The code should be using strndup_user() anyway.

Smth like this?

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 09e3090..3afd249 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -836,19 +836,10 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
        int ret_val;
        int i;
 
-       if (count > PAGE_SIZE)
-               count = PAGE_SIZE;
-
-       kbuf = kmalloc(count + 1, GFP_KERNEL);
-       if (!kbuf)
-               return -ENOMEM;
-
-       if (copy_from_user(kbuf, buf, count)) {
-               kfree(kbuf);
-               return -EFAULT;
-       }
+       kbuf = strndup_user(buf, PAGE_SIZE);
+       if (IS_ERR(kbuf))
+               return PTR_ERR(kbuf);
        curr_pos = kbuf;
-       kbuf[count] = '\0';     /* Just to make sure... */
 
        if (strncmp(curr_pos, "lock ", 5) == 0) {
                curr_pos += 5;
-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
