Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1FNGeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:34:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51882 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1FNGeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=o1aByRjnkYNHkXtZTwnkKlG0+Fz2TXDlQp3cXxcql8//66F+W8VhYtUpPYNx6oTmrb
         RKAPTglMbzY9mJayYxnlq51yev9ZbF/DVltdFSnTTMaeOF0770sfbMjIOfQu/O97jfaG
         rMMxLF1SKcx/U53kB+HKILYkbw8EYOTs1NOZk=
Date: Tue, 14 Jun 2011 08:34:00 +0200
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>,
        "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>
Subject: Re: Re: [PATCH v4 11/18] input: Add initial support for TWL6040
 vibrator
Message-ID: <20110614063400.GB8141@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
 <1307706876-4768-12-git-send-email-peter.ujfalusi@ti.com>
 <20110611231854.GA3979@core.coreip.homeip.net>
 <1530216.k8lJ4nKZ1s@barack>
 <20110613212028.GA13138@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110613212028.GA13138@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 13, 2011 at 02:20:28PM -0700, Dmitry Torokhov wrote:
> On Mon, Jun 13, 2011 at 12:51:16PM +0300, Péter Ujfalusi wrote:
> > On Sunday 12 June 2011 01:18:54 Dmitry Torokhov wrote:
> > 
> > > > +static int twl6040_vibra_open(struct input_dev *input)
> > > > +{
> > > > +     struct vibra_info *info = input_get_drvdata(input);
> > > > +
> > > > +     info->workqueue = create_singlethread_workqueue("vibra");
> > > > +     if (info->workqueue == NULL) {
> > > > +             dev_err(&input->dev, "couldn't create workqueue\n");
> > > > +             return -ENOMEM;
> > > > +     }
> > > 
> > > Why do we need to create a separate workqueue? With arrival of CWQ
> > > it looks like we should be able to use one of the system-wide
> > > workqueues for this.
> > 
> > The reason for this is to ensure that we have the lowest latency as possible 
> > in most case. In the embedded devices we use the vibra for tactile type of 
> > feedbacks as well, where few tens of ms delay can be felt.
> 
> Even if you create a dedicated workqueue with CWQ it will still be using
> shared pool of threads so I do not think that latency will be affected
> by using system-wide workqueue. I might be mistaken though, Tejun will
> correct me if I am wrong...

Yeap, using a separate workqueue doesn't do anything for latency
unless WQ_HIGHPRI and/or WQ_CPU_INTENSIVE is used; however, _please_
stay away from it unless absolutely sure it's necessary (ie. unless
you can pin point to where latency is coming from - even in that case,
the thing which induces the latency probably is the one which should
be fixed).

CMWQ is pretty good at keeping latency low unless something is
consuming large amount of CPU cycles and those work items are marked
WQ_CPU_INTENSIVE, not the other way around and WQ_HIGHPRI is for
things like MCE error reporting.

Thanks.

-- 
tejun
