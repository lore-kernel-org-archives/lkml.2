Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0ICKCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:02:02 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:31052 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756634Ab0ICKCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:02:00 -0400
Message-ID: <000801cb4b4f$0bc76e70$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Joe Perches" <joe@perches.com>
Cc: "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Crane Cai" <crane.cai@amd.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yong.y.wang@intel.com>, <qi.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "Arnd Bergmann" <arnd@arndb.de>
References: <4C80A089.508@dsn.okisemi.com> <1283501437.1797.441.camel@Joe-Laptop>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35
Date: Fri, 3 Sep 2010 19:01:52 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Joe Perches" <joe@perches.com>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>; "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>;
"Crane Cai" <crane.cai@amd.com>; "Samuel Ortiz" <sameo@linux.intel.com>; "Linus Walleij" <linus.walleij@stericsson.com>;
"Ralf Baechle" <ralf@linux-mips.org>; "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>; <linux-i2c@vger.kernel.org>;
<linux-kernel@vger.kernel.org>; <yong.y.wang@intel.com>; <qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>;
<arjan@linux.intel.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>; "Arnd Bergmann" <arnd@arndb.de>
Sent: Friday, September 03, 2010 5:10 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35


> On Fri, 2010-09-03 at 16:15 +0900, Masayuki Ohtak wrote:
> []
> > +#define pch_dbg(adap, fmt, arg...)  \
> > + dev_dbg(adap->pch_adapter.dev.parent, "%s :"fmt, __func__, ##arg)
> > +
> > +#define pch_err(adap, fmt, arg...)  \
> > + dev_err(adap->pch_adapter.dev.parent, "%s :"fmt, __func__, ##arg)
> > +
> > +#define pch_pci_err(pdev, fmt, arg...)  \
> > + dev_err(&pdev->dev, "%s :"fmt, __func__, ##arg)
> > +#define pch_pci_dbg(pdev, fmt, arg...)  \
> > + dev_dbg(&pdev->dev, "%s :"fmt, __func__, ##arg)
>
> OK, but it seems careless because the two types
> are not uniformly indented, there's a blank line
> between pch_dbg and pch_err, and the two pch_pci_<level>
> defines are in the reverse order without a blank line
> between them.
>
> I think it's better to use separate multiple strings
> that are concatentated by the preprocessor like:
> "%s :" fmt
> not
> "%s :"fmt
>
> Almost all code in kernel uses "%s: " to format __func__.
> Some use "%s(): ".  I think "%s :" is unique.
>
> The rest of the logging messages look good.
>
> Some other comments:
>
> > + if ((pch_wait_for_xfer_complete(adap) == 0) &&
> > + (pch_getack(adap) == 0)) {
>
> This would look better as:
>
> if ((pch_wait_for_xfer_complete(adap) == 0) &&
>     (pch_getack(adap) == 0)) {
>
> > + if ((pch_wait_for_xfer_complete(adap) == 0)
> > +     && (pch_getack(adap) == 0)) {
>
> Here too.
>
> > + for (i = 0; i < PCH_MAX_CHN; i++) {
> > + while ((adap_info->pch_data[i].pch_xfer_in_progress)) {
> > + /* Wait until all channel transfers are completed */
> > + msleep(1);
> > + }
> > + /* Disable the i2c interrupts */
> > + pch_disbl_int(&adap_info->pch_data[i]);
> > + }
>
> Would it be better to disable all possible interrupts first
> or do you need to disable them in order?

* Your proposal
If pch_disbl_int is executed firstly,
queued data  is destroyed.

 * Current spec
If checking status firstly,
all data can be sent.

Thus, I think current spec is better than yours.

>
> Something like:
>
> bool *disabled = kzalloc(PCH_MAX_CHN * sizeof(bool), GFP_KERNEL);
> /*
>  * or a static with a memset, or check something
>  * like pch_is_int_enabled(&adap_info->pch_data[i])
>  * then remove the else because the kzalloc couldn't fail.
>  */
> if (disabled) {
> bool alldone;
> do {
> alldone = true;
> for (i = 0; i < PCH_MAX_CHN; i++) {
> if (!adap_info->pch_data[i].pch_xfer_in_progress &&
>     !disabled[i])) {
> pch_disbl_int(&adap_info->pch_data[i]);
> disabled[i] = true;
> } else
> alldone = false;
> }
> if (!alldone) {
> /* Wait until all channel transfers are completed */
> msleep(1);
> }
> } while (!alldone);
> kfree(disabled);
>
> /* remove the else if there's a static etc */
>
> } else {
> for (i = 0; i < PCH_MAX_CHN; i++) {
> while ((adap_info->pch_data[i].pch_xfer_in_progress)) {
> /* Wait until all channel transfers are completed */
> msleep(1);
> }
> /* Disable the i2c interrupts */
> pch_disbl_int(&adap_info->pch_data[i]);
> }
> }
>
> cheers, Joe
>

I will resubmit modified patch soon.


Thanks, Ohtake(OKISemi)


