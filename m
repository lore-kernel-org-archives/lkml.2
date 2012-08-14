Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2HNGbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 02:31:11 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:57495 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2HNGar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 02:30:47 -0400
Date: Tue, 14 Aug 2012 08:30:44 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/7] HID: picoLCD updates
Message-ID: <20120814083044.78b401d2@pluto.restena.lu>
In-Reply-To: <20120813232708.GF25632@google.com>
References: <20120730213656.0a9f6d30@neptune.home>
	<20120809200947.2194e89f@neptune.home>
	<20120813232708.GF25632@google.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

[Tejun: sorry for duplicate, did hit "reply" instead of "reply to all"]

On Mon, 13 Aug 2012 16:27:08 Tejun Heo <tj@kernel.org> wrote:
> On Thu, Aug 09, 2012 at 08:09:47PM +0200, Bruno Prémont wrote:
> > As you are working on workqueues and related code, could you have a look
> > at my usage of them in combination with db_defio?
> > 
> > The delayed memory corruptions or system reboots after unbinding/unplugging
> > the PicoLCD seem very much related to workqueue used to handle the deferred
> > IO to framebuffer.
> > 
> > I think things don't get cleaned-up as they should though I'm not sure
> > where the trouble lies.
> > 
> > For ease of reading, I'm inlineing below the framebuffer related code of
> > PicoLCD (for complete driver after this patch series apply the whole series
> > on top of 3.5 https://lkml.org/lkml/2012/7/30/375 )
> ...
> > void picolcd_exit_framebuffer(struct picolcd_data *data)
> > {
> > 	struct fb_info *info = data->fb_info;
> > 	u8 *fb_vbitmap = data->fb_vbitmap;
> > 
> > 	if (!info)
> > 		return;
> > 
> > 	device_remove_file(&data->hdev->dev, &dev_attr_fb_update_rate);
> > 	info->par = NULL;
> > 	unregister_framebuffer(info);
> > 	data->fb_vbitmap = NULL;
> > 	data->fb_bitmap  = NULL;
> > 	data->fb_bpp     = 0;
> > 	data->fb_info    = NULL;
> > 	kfree(fb_vbitmap);
> > }
> 
> I'm kinda shooting in the dark but who flushes / cancels
> fb_info->deferred_work?

fb_deferred_io_cleanup() does so and is called by destroy fbops
(when last reference to fb_info is returned):


static void picolcd_fb_destroy(struct fb_info *info)
{
	/* make sure no work is deferred */
	fb_deferred_io_cleanup(info);

	vfree((u8 *)info->fix.smem_start);
	framebuffer_release(info);
	printk(KERN_DEBUG "picolcd_fb_destroy(%p)\n", info);
}


===== drivers/video/fb_defio.c =====
void fb_deferred_io_cleanup(struct fb_info *info)
{
        struct fb_deferred_io *fbdefio = info->fbdefio;
        struct page *page;
        int i;

        BUG_ON(!fbdefio);
        cancel_delayed_work_sync(&info->deferred_work);

        /* clear out the mapping that we setup */
        for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {
                page = fb_deferred_io_page(info, i);
                page->mapping = NULL;
        }

        info->fbops->fb_mmap = NULL;
        mutex_destroy(&fbdefio->lock);
}



Thanks,
Bruno
