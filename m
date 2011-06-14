Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1FNISr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:18:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43486 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1FNISl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=bAC9fBf83RKvpikyhpHH6eBZwOk8TRT1/eCUoMmsNOXrIi4PBgI0Zr5jsLF30xJZfV
         8l8k7LZegrH0Ro977hMagDg8DyNNq2IBEBGLveN2Z01PX5PMZtDwXnyvWVf1itx8djpD
         MpD3UdHf8sp1q13RkGeXrngRTW+WMzIMPvcWQ=
Date: Tue, 14 Jun 2011 10:18:36 +0200
From: Tejun Heo <tj@kernel.org>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Girdwood, Liam" <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: Re: Re: [PATCH v4 11/18] input: Add initial support for
 TWL6040 vibrator
Message-ID: <20110614081836.GG8141@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
 <8556714.NHVg2d8yTv@barack>
 <20110614073130.GF8141@htj.dyndns.org>
 <4476185.bf2jyafmHt@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4476185.bf2jyafmHt@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 14, 2011 at 10:51:35AM +0300, Péter Ujfalusi wrote:
> On Tuesday 14 June 2011 09:31:30 Tejun Heo wrote:
> > Thanks for the explanation.  I have a couple more questions.
> > 
> > * While transferring data from I2C, I suppose the work item is fully
> >   occupying the CPU?
> 
> Not exactly on OMAP platforms at least. We do not have busy looping in low 
> level driver (we wait with wait_for_completion_timeout for the transfer to be 
> done), so scheduling on the same CPU can be possible.
> 
> >   If so, how long delay are we talking about?
> >   Millisecs?
> 
> It is hard to predict, but it can be few tens of ms for one device, if we have 
> several devices on the same bus (which we tend to have), and they want to 
> read/write something at the same time we can see hundred(s) ms in total - it 
> is rare to happen, and hard to reproduce, but it does happen for sure.
>  
> > * You said that the if one task is accessing I2C bus, the other would
> >   wait even if scheduled on a different CPU.  Is access to I2C bus
> >   protected with a spinlock?
> 
> At the bottom it is using rt_mutex_lock/unlick to protect the bus.
> And yes, the others need to wait till the ongoing transfer has been finished.

I see, so IIUC,

* If it's using mutex and not holding CPU for the whole duration, you
  shouldn't need to do anything special for latency for other work
  items.  Workqueue code will start executing other work items as soon
  as the I2C work item goes to sleep.

* If I2C work item is burning CPU cycles for the whole duration which
  may stretch to tens / few hundreds millsecs, 1. it's doing something
  quite wrong, 2. should be marked WQ_CPU_INTENSIVE.

So, if something needs to be modified, it's the I2C stuff, not the
vibrator driver.  If I2C stuff isn't doing something wonky, there
shouldn't be a latency problem to begin with.

Thank you.

-- 
tejun
