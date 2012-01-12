Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2ALPkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:40:46 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34031 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754023Ab2ALPkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:40:43 -0500
MIME-Version: 1.0
In-Reply-To: <CANOLnOP_aXGw2nxRE+VnW2ii2UV4JqJaxcfMbd3oVm6qfWxsGA@mail.gmail.com>
References: <1324324914-14584-1-git-send-email-felipe.contreras@nokia.com>
	<CANOLnOP_aXGw2nxRE+VnW2ii2UV4JqJaxcfMbd3oVm6qfWxsGA@mail.gmail.com>
Date: Thu, 12 Jan 2012 17:40:39 +0200
Message-ID: <CAMP44s07EnB7d+ZNHQR9RSG=+c+aXDbAOK0_wL_CCDuoWOcrCQ@mail.gmail.com>
Subject: Re: [PATCH v2] usb: musb: fix pm_runtime mismatch
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, stable@vger.kernel.org,
        Hema HK <hemahk@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 1:56 PM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> On Mon, Dec 19, 2011 at 10:01 PM, Felipe Contreras
> <felipe.contreras@nokia.com> wrote:
>> From: Felipe Contreras <felipe.contreras@gmail.com>
>>
>> In musb_init_controller() there's a pm_runtime_put(), but there's no
>> pm_runtime_get(), which creates a mismatch that causes the driver to
>> sleep when it shouldn't.
>
> This patch is causing problems here, the device never suspends, I've
> verified musb_runtime_suspend and omap2430_runtime_suspend are never
> called in my setup, unless I revert this patch. I'm using musb with
> ethernet gadget; cable removal also doesn't suspend musb.
>
> It seems pm_runtime_put() that was removed was balancing out
> pm_runtime_get in musb_platform_init(), which is called at the
> beginning of musb_init_controller(). I think this pm_runtime_get()
> from musb_platform_init() should be moved to musb_init_controller() to
> stop confusing people and pm_runtime_put() needs to be brought back. I
> can do a patch if nobody objects.

You mean have both get and put in musb_init_controller()? That's OK,
it would be balanced then, but you would have to remove the
pm_runtime_put() from omap2430_remove() that presumably was balancing
the pm_runtime_get_sync() in omap2430_musb_init().

>> This was introduced in 7acc619[1], but it wasn't triggered in my setup
>> until 18a2689[2] was merged to Linus' branch at point df0914[3]. IOW;
>> when PM is working as it was supposed to.
>>
>> However, it seems most of the time this is used in a way that keeps the
>> counter above 0, so nobody noticed. Also, it seems to depend on the
>> configuration used in versions before 3.1, but not later (or in it).
>>
>> I found the problem by loading isp1704_charger before any usb gadgets:
>> http://article.gmane.org/gmane.linux.kernel/1226122
>
> isp1704_charger seems to be doing otg_io_read(), and it's perfectly
> normal that musb can be suspended at the time isp1704 decides to do
> this. I think proper fix is to wake up must on musb_ulpi_read() and
> musb_ulpi_write() instead.

I guess so. If you send these patches I can give them a try.

-- 
Felipe Contreras
