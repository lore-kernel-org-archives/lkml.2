Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab0EaFEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 01:04:38 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:40540 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750933Ab0EaFEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 01:04:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:Subject:Message-ID:From:To:Cc:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Z5UvHiVsDzqJXcrVkzli3RxArlaG4PIG4j7TrdOxiseGf6XC7TFnKki5/SDlCrUIvhvq/GADtp+Jfaengcjz2XGEJb+LkzVuI3KD8FOpSnN9R2NHjr0SzUR6/O48SQth;
Date: Sun, 30 May 2010 22:03:10 -0700
Subject: Re: [RFC] Try a bit harder to get output on the screen at panic
 time
Message-ID: <vbf0pu1dqa60ojk7uuublww9.1275282082699@email.android.com>
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, James Simmons <jsimmons@infradead.org>
Content-Type: text/plain; charset=utf-8
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.210.28.220 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4V54iim001253

I'll test again this week.  I still don't see how these small patches could cause issues with suspend/resume unless we set oops_in_progress during that time on your machine...
Jesse
Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>On Sat, 2010-05-22 at 01:26 +0300, Maxim Levitsky wrote: >> On Fri, 2010-05-21 at 15:02 -0700, Jesse Barnes wrote: >> > On Sat, 22 May 2010 00:57:30 +0300>> > Maxim Levitsky <maximlevitsky@gmail.com> wrote:>> > >> > > On Fri, 2010-05-21 at 00:14 +0300, Maxim Levitsky wrote: >> > > > On Thu, 2010-05-20 at 09:28 -0700, Jesse Barnes wrote: >> > > > > On Thu, 20 May 2010 04:27:07 +0300>> > > > > Maxim Levitsky <maximlevitsky@gmail.com> wrote:>> > > > > >> > > > > > On Thu, 2010-05-20 at 04:13 +0300, Maxim Levitsky wrote: >> > > > > > > On Wed, 2010-05-19 at 17:34 -0700, Jesse Barnes wrote: >> > > > > > > > On Fri, 9 Apr 2010 15:10:50 -0700>> > > > > > > > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:>> > > > > > > > >> > > > > > > > > This set of 3 patches makes it a little more likely we'll get panic>> > > > > > > > > output onto the screen even when X is running, assuming a KMS enabled>> > > > > > > > > stack anyway.>> > > > > > > > > >> > > > > > > > > It gets me from a blank or very sparsely populated black screen at>> > > > > > > > > panic time, to one including the full backtrace and panic output at>> > > > > > > > > panic time (tested with "echo c > /proc/sysrq-trigger" from an X>> > > > > > > > > session).>> > > > > > > > > >> > > > > > > > > It doesn't cover every case; for instance I think it'll fail when X has>> > > > > > > > > disabled the display, but those cases need to be handled with separate>> > > > > > > > > patches anyway (need to add atomic DPMS paths for instance).>> > > > > > > > > >> > > > > > > > > Anyway, please test these out and let me know if they work for you.>> > > > > > > > >> > > > > > > > Ping Linus & Dave again.  Have you guys tried these?  Really, it's cool.>> > > > > > > > >> > > > > > > Second that, just tested these patches, and these work perfectly.>> > > > > > > One more reason for me to dump nvidia driver for nouveau.>> > > > > > >> > > > > > >> > > > > > Unfortunately I spoke too soon.>> > > > > > >> > > > > > >> > > > > > After suspend to ram, system doesn't properly resume now.>> > > > > > >> > > > > > My system is based on nvidia G86, I use latest nouveau drivers, and>> > > > > > suspend with compiz running.>> > > > > > >> > > > > > I also patched kernel not to do vt switch on suspend/resume:>> > > > > > >> > > > > > diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c>> > > > > > b/drivers/gpu/drm/nouveau/nouveau_state.c>> > > > > > index 062b7f6..b3ef08b 100644>> > > > > > --- a/drivers/gpu/drm/nouveau/nouveau_state.c>> > > > > > +++ b/drivers/gpu/drm/nouveau/nouveau_state.c>> > > > > > @@ -31,6 +31,7 @@>> > > > > > #include "drm_crtc_helper.h">> > > > > > #include <linux/vgaarb.h>>> > > > > > #include <linux/vga_switcheroo.h>>> > > > > > +#include <linux/suspend.h>>> > > > > > >> > > > > > #include "nouveau_drv.h">> > > > > > #include "nouveau_drm.h">> > > > > > @@ -771,6 +772,8 @@ int nouveau_load(struct drm_device *dev, unsigned>> > > > > > long flags)>> > > > > >                 int ret = nouveau_card_init(dev);>> > > > > >                 if (ret)>> > > > > >                         return ret;>> > > > > > +>> > > > > > +               pm_set_vt_switch(0);>> > > > > >         }>> > > > > > >> > > > > >         return 0;>> > > > > >> > > > > Hm I don't see how my patches would have affected suspend/resume, since>> > > > > they just add "oops_in_progress" checks to a few places.  Are you sure>> > > > > something else isn't breaking your resume path?>> > > > I am sure. I just reverted them, and everything works again.>> > > > I refer to 3 patches in this thread.>> > > In fact I might look a bit silly, but I applied these patches on top of>> > > linus master tree + nouveau master, and suspend to ram works just fine.>> > > >> > > Maybe it shows up when kgdb+kdb isn't compiled in or so.>> > > Maybe it just triggered some bug in nouveau drivers...>> > > >> > > >> > > (Note that I also enabled kgdb, and kdb, and breaking into kdb (SysRQ+g)>> > > doesn't switch console mode, just hangs till I press 'g'.>> > >> > Ok so it sounds like these particular patches are innocent?>> > >> > As for kdb, I think the latest tree is probably missing the graphics>> > switch support on the driver side...>> In what part? nouveau or kdb?>> >> Screen does switch to text mode and displays the backtrace on 'panic'>> (Tested with sysrq+c).>> (If kdb is enabled, screen doesn't switch, but allowing kdb to continue>> via 'g' command eventually breaks into it.)>>Ping.>>Best regards,>Maxim Levitsky>>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
