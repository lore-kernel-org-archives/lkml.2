Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab2JQRjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:39:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:44848 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419Ab2JQRjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:39:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,602,1344236400"; 
   d="scan'208";a="157324138"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v9 05/12] x86, hotplug, suspend: Online CPU0 for suspend
 or hibernate
Thread-Topic: [PATCH v9 05/12] x86, hotplug, suspend: Online CPU0 for
 suspend or hibernate
Thread-Index: AQHNqJme/Qw6Fjvfd02W7L5t8fGuVJe7UXUAgACSvQCAALOPAIAAA5yA///kHbCAAPJ+gIAARypw
Date: Wed, 17 Oct 2012 17:39:48 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122030B1A8BC@ORSMSX105.amr.corp.intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
 <507D8BBD.3010306@linux.vnet.ibm.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122030B18671@ORSMSX105.amr.corp.intel.com>
 <35538834.Boc5416YXf@vostro.rjw.lan>
In-Reply-To: <35538834.Boc5416YXf@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9HHdtxg006265

> > > On Tuesday, October 16, 2012 10:19 PM Rafael J. Wysocki wrote:
> On Tuesday 16 of October 2012 22:12:27 Yu, Fenghua wrote:
> > > On 10/16/2012 09:47 PM, Rafael J. Wysocki wrote:
> > > > On Tuesday 16 of October 2012 11:05:18 Srivatsa S. Bhat wrote:
> > > >> On 10/16/2012 02:20 AM, Rafael J. Wysocki wrote:
> > > >>> On Friday 12 of October 2012 09:09:42 Fenghua Yu wrote:
> > > >>>> From: Fenghua Yu <fenghua.yu@intel.com>
> > > fix the bug I
> > > pointed out in my other mail.
> Because things like this are often overlooked by people trying to
> optimize
> stuff and the fact that you have to add a comment explaining that
> dependency
> only means that it is not exactly straightforward.

If people try to optimize pm notifier, they really need to know
pm_notifier() API and its priority. If they ignore the priority, they will
screw up kernel no matter how many comments in it.

> 
> Moreover, you should also add a corresponding comment in the other
> notifier
> indicating that its priority should be higher than the priority of the
> new thing and explaining why.

The comment in the patch explains this very clearly. I don't think it's
necessary to add comments in other notifiers.

If adding comments in other notifiers each time when you add a new notifier,
will you add 10 more comments in all other notifiers if you add 10 new notifiers?

I would think when people try to change notifier priority, they should
know what they are going to do and search the notifiers and see the comments.

BTW, the other notifier is in generic code. Adding a paranoid comment in
it doesn't seem to be worth. The comment in this patch code is very clear
already.

> 
> I really think that notifiers are fragile in general and this
> particular
> one is no exception.

If we think pm_notifier API is fragile, we need to fix the API instead of
leaving it there and not allowing people to use it because it's suspected
fragile.

It's simply not realistic to tell people not to use the API each
time in code review while in the meantime the API and its priority are staying
in kernel to allow people to use it.

> 
> > It's not a good idea to move bsp_pm_callback() into
> > cpu_hotplug_pm_callback(). There is no architecture specific hook to
> > call x86 bsp specific hotplug in cpu_hotplug_pm_callback(). Moving
> > bsp_pm_callback() into cpu_hotplug_pm_callback() is hacking while
> > this patch follows well defined API and has better coding.
> 
> I'm not sure it is better coding.  You really want one piece of code
> to always follow another piece of code and the best way to ensure
> that is to execute them both explicitly in sequence.

Besides notifiers, there are other places relying on priority (e.g. initcall).
Again, if we think the priority in notifiers and other APIs are fragile,
why don't we fix the APIs?

The problem of calling bsp_pm_callback() in cpu_hotplug_pm_callback() is that
cpu_hotplug_pm_callback() is defined in generic kernel/cpu.c. This bsp hotplug
patchset is x86 arch specific code so far. Changing kernel/cpu.c to hook 
arch specific code is more like hacking kernel compared to the systematic way
to do so in the patch.

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
