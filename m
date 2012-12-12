Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2LLPUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:20:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:1951 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab2LLPU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:20:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,267,1355126400"; 
   d="scan'208";a="256449806"
From: "Lin, Mengdong" <mengdong.lin@intel.com>
To: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Takashi Iwai <tiwai@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: RE: pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x50
 [snd_hda_intel] returns -11
Thread-Topic: pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x50
 [snd_hda_intel] returns -11
Thread-Index: AQHN18F+ehv+58cwq0GGLBLoNLQTPpgTWc6AgAAB4wCAAGGggIAAumeAgADLFCA=
Date: Wed, 12 Dec 2012 15:20:25 +0000
Message-ID: <F46914AEC2663F4A9BB62374E5EEF8F829248F@SHSMSX101.ccr.corp.intel.com>
References: <20121211170315.GC28827@liondog.tnic>
 <2487425.bAQggRZzC4@vostro.rjw.lan> <20121211175508.GE28827@liondog.tnic>
 <15066310.xXEWfqCuJc@vostro.rjw.lan> <20121212105143.GA9252@liondog.tnic>
In-Reply-To: <20121212105143.GA9252@liondog.tnic>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBCFKbFo019162

> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Wednesday, December 12, 2012 6:52 PM


> > It looks like azx_runtime_suspend() is new in 3.7 and it returns
> > -EAGAIN to indicate that it actually can't be suspended (if my
> > understanding the code is correct).  However, it shouldn't do that,
> > because that causes the runtime PM core to repeat the attempts.  It
> > rather should implement a .runtime_idle() callback returning an error code
> instead.


Hi Boris and Rafael,

I remember I didn't observed repetitive attempts to suspend if the azx_runtime_suspend() returns -EAGAIN.

Because the HD-A driver does not implement the runtime idle callback, pci_pm_runtime_idle() will call pm_runtime_suspend(dev),
and then __pm_runtime_suspend(dev, 0) will be called. 
Finally the code will go to 'fail' of rpm_suspend: 
...
fail:
	__update_runtime_status(dev, RPM_ACTIVE);
	dev->power.deferred_resume = false;
	wake_up_all(&dev->power.wait_queue);

	if (retval == -EAGAIN || retval == -EBUSY) {
		dev->power.runtime_error = 0;
		...
		if ((rpmflags & RPM_AUTO) &&
		    pm_runtime_autosuspend_expiration(dev) != 0)      ... but since the rpmflags is 0, the code will not go to 'repeat' but to 'out'.
			goto repeat;
	} else {
		pm_runtime_cancel_pending(dev);
	}
	goto out;

Please correct me if I misunderstand something.

Thanks
Mengdong

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
