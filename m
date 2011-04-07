Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1DGGfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 02:35:33 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:53229 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab1DGGfc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 02:35:32 -0400
From: Robert ROSENGREN <robert.rosengren@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 7 Apr 2011 08:31:47 +0200
Subject: RE: [PATCH] regulator: recursive locking detected
Thread-Topic: [PATCH] regulator: recursive locking detected
Thread-Index: Acvw0vXB6GxvLaQOTbqvNzO5n4etPgEGoK4B
Message-ID: <CEE6BB42CAD6E947908279175AF8470A0C79DEC0E1@EXDCVYMBSTM006.EQ1STM.local>
References: <1301652257-19347-1-git-send-email-robert.rosengren@stericsson.com>,<20110402011202.GC25424@opensource.wolfsonmicro.com>
In-Reply-To: <20110402011202.GC25424@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-02 at 10:12 +0900, Mark Brown wrote:
> On Fri, Apr 01, 2011 at 12:04:17PM +0200, Robert Rosengren wrote:
> > "possible recursive locking detected"-warnings are issued when a
> > regulator has specified supply regulator. Both when enabling and
> > disabling regulators uses recursive call chains for notify the supply
> > regulators. This is due to locking mutexes of the same lock class,
> > i.e. the locks reside in the regulator_dev struct.
>
> There's actually a race here reported by David Brown in the past week
> when working with supplies so the lock warning is probably a real issue
> which should be fixed rather than overriding the warning.  Search the
> list for the past week or so for the details.

Thanks for letting me know, sorry I missed that discussion. Having
checked that out, few comments regarding the mutex_lock_nested
discussion.

If going for silencing the mutex warning in _notifier_call_chain, it
will not be sufficient to use SINGLE_DEPTH_NESTING as there is no limit
of just using one supply regulator, the next one may also have a supply
so for each one we need to increase the subclass in mutex_lock_nested.
Don't know if we have real use cases here, but at least the code admits
it. 