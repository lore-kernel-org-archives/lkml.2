Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1AUPeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:34:11 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55408 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab1AUPeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:34:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bHo9e/Uj73HalBZ6Za0T6HfWJXGS539E0MJ1IVeEMjFqBvUhMONiQc/mtcMpUzzsHW
         BGYpaNPiutoSToo21HtNEtq/CZ8s9Muf0chwsBRuFmjyU7oBzzsOjIE3vpS3HzH9bqXA
         l2ToDCthtxUUSLknbSNR3LfBQSNq8J1L+BK0w=
MIME-Version: 1.0
In-Reply-To: <20110119103323.GC4693@hedu-HP-Z800-Workstation>
References: <20110119092011.GA23624@darkstar>
	<20110119103323.GC4693@hedu-HP-Z800-Workstation>
Date: Fri, 21 Jan 2011 17:34:08 +0200
Message-ID: <AANLkTimKfFAaOkCh_9EaUegYcv-rOVqvMCQ6t7qPbQeB@mail.gmail.com>
Subject: Re: [PATCH] usb otg: use atomic notifier instead of blocking notifier
From: Grazvydas Ignotas <notasas@gmail.com>
To: Heikki Krogerus <heikki.krogerus@nokia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Felipe Balbi <balbi@ti.com>, Tejun Heo <tj@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Hema HK <hemahk@ti.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Ruirui <ruirui.r.yang@tieto.com>,
        David Brownell <david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 12:33 PM, Heikki Krogerus
<heikki.krogerus@nokia.com> wrote:
> On Wed, Jan 19, 2011 at 05:20:11PM +0800, ext Yang Ruirui wrote:
>> --- linux-2.6.orig/include/linux/usb/otg.h      2011-01-17 09:39:11.000000000 +0800
>> +++ linux-2.6/include/linux/usb/otg.h   2011-01-19 16:38:06.649546989 +0800
>> @@ -74,7 +74,7 @@ struct otg_transceiver {
>>         void __iomem                    *io_priv;
>>
>>         /* for notification of usb_xceiv_events */
>> -       struct blocking_notifier_head   notifier;
>> +       struct atomic_notifier_head     notifier;
>>
>>         /* to pass extra port status to the root hub */
>>         u16                     port_status;
>> @@ -234,13 +234,13 @@ otg_start_srp(struct otg_transceiver *ot
>>  static inline int
>>  otg_register_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
>>  {
>> -       return blocking_notifier_chain_register(&otg->notifier, nb);
>> +       return atomic_notifier_chain_register(&otg->notifier, nb);
>>  }
>>
>>  static inline void
>>  otg_unregister_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
>>  {
>> -       blocking_notifier_chain_unregister(&otg->notifier, nb);
>> +       atomic_notifier_chain_unregister(&otg->notifier, nb);
>>  }
>>
>>  /* for OTG controller drivers (and maybe other stuff) */
>
> Is drivers/power/twl4030_charger.c ready for atomic notifiers?

No it is not, it's doing some i2c stuff. With twl4030 it's called from
threaded_irq in twl4030-usb instead of musb core and is working fine..
