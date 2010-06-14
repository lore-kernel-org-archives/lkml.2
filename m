Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0FNXST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:18:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47328 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0FNXSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eaY2SBmiPcJNAMwERM4H/ajrX/mV4zJJCCrLB5V5UROW7YCEdfnO3vXgh91Y28OXiS
         z0yHYf96DsJFGxLyKyaLHwdF6nr6isKlA1f4NznSkVbhO2/PY4QupyphcG23fjy4cxxq
         n4kRYw47K2aEg26kNH6vjhjMmOSowXGdxRoG4=
Subject: Re: [PATCH v2] MMC: fix all hangs related to mmc/sd card
 insert/removal during suspend/resume.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
In-Reply-To: <20100614160106.bcd92997.akpm@linux-foundation.org>
References: <1276283791.8557.29.camel@maxim-laptop>
	 <1276283995-10812-1-git-send-email-maximlevitsky@gmail.com>
	 <20100614160106.bcd92997.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 02:18:11 +0300
Message-ID: <1276557491.7837.10.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 16:01 -0700, Andrew Morton wrote: 
> On Fri, 11 Jun 2010 22:19:55 +0300
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > If you don't use CONFIG_MMC_UNSAFE_RESUME, card will now be removed
> > in pm notified while userspace is still running.
> > Thus it will be possible to sync it propely.
> > 
> > Card detect workqueue is now freezeable, therefore a card insert/removal event will
> > wait till userspace is unfrozen.
> > 
> > Tested with and without CONFIG_MMC_UNSAFE_RESUME with suspend and hibernate.
> > 
> >
> > ...
> >
> > @@ -158,6 +162,8 @@ void mmc_remove_host(struct mmc_host *host)
> >  	device_del(&host->class_dev);
> >  
> >  	led_trigger_unregister_simple(host->led);
> > +
> > +	unregister_pm_notifier(&host->pm_notify);
> >  }
> 
> This looks a little risky.  There's a window where the pm notifier
> remains registered after we've done the device_del() and the
> led_trigger_unregister_simple().
> 
> I don't know if the code's really buggy, nor if it might become buggy
> in the future as things evolve.  But as register_pm_notifier() is the
> last thing we do before mmc_start_host(), I'd have though that
> unregister_pm_notifier() should be the first thing we do after
> mmc_stop_host()?

Absolutely right!


> 
> >
> > ...
> >
> > --- a/include/linux/mmc/host.h
> > +++ b/include/linux/mmc/host.h
> > @@ -124,6 +124,7 @@ struct mmc_host {
> >  	unsigned int		f_min;
> >  	unsigned int		f_max;
> >  	u32			ocr_avail;
> > +	struct notifier_block	pm_notify;
> >  
> >  #define MMC_VDD_165_195		0x00000080	/* VDD voltage 1.65 - 1.95 */
> >  #define MMC_VDD_20_21		0x00000100	/* VDD voltage 2.0 ~ 2.1 */
> > @@ -257,6 +258,8 @@ int mmc_card_can_sleep(struct mmc_host *host);
> >  int mmc_host_enable(struct mmc_host *host);
> >  int mmc_host_disable(struct mmc_host *host);
> >  int mmc_host_lazy_disable(struct mmc_host *host);
> > +int mmc_pm_notify(struct notifier_block *notify_block, unsigned long, void *);
> 
> It's unusual to provide names for some of the arguments and to leave
> them out for others.
Will fix that too.



Best regards,
Maxim Levitsky

