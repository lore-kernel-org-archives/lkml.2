Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab2JWQRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:17:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:64122 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab2JWQRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:17:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="208031433"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tang Chen <tangchen@cn.fujitsu.com>, Borislav Petkov <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in
 cmci_rediscover().
Thread-Topic: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in
 cmci_rediscover().
Thread-Index: AQHNrb0jdvCwOrrZIEmc53v3j025AJfBStaAgAPD0wCAAIdPAIABF4uAgAB0mwCAABtSgP//1uRA
Date: Tue, 23 Oct 2012 16:16:50 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D58D8E@ORSMSX108.amr.corp.intel.com>
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
 <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com>
 <20121019164045.GE11958@aftab.osrc.amd.com>
 <5084AB10.7010807@cn.fujitsu.com> <20121022101442.GB8352@liondog.tnic>
 <50860711.10807@cn.fujitsu.com> <20121023095234.GA22715@liondog.tnic>
 <50867FCD.9010907@cn.fujitsu.com>
In-Reply-To: <50867FCD.9010907@cn.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9NGHFGd004383

> First of all, I do think I was answering your question. As I said
> before, if an online cpu == dying here, there must be something wrong.
> Am I right here ?

Yes - but there is a fuzzy line over where it is good to check for "something wrong"
or whether to trust that the caller of the function knew what they were doing.

For example we trust that "dying" is a valid cpu number.  If we were
super-paranoid that someone might change the code and call us with a
bad argument, we might add:

	BUG_ON(dying < 0 || dying >= MAX_NR_CPUS);

This would certainly help debug the case if someone did make a bogus
change ... but I think it is clear that this test is way past the fuzzy line and
into pointless.

Back to the case in question: do we think there is a credible case where
the "dying" cpu can show up in our "for_each_cpu_online()" loop? The
original author of the code was worried enough to make a test, but thought
that the appropriate action was to silently skip it. You want to add a WARN_ON,
which will cause users who read the console logs to worry, but that most users
will never see.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
