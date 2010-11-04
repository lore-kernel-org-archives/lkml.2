Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0KDLoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 07:44:06 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:36314 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021Ab0KDLoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 07:44:04 -0400
Message-ID: <4CD29C7D.4050500@stericsson.com>
Date: Thu, 4 Nov 2010 12:43:57 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH] regulator: lock supply in regulator enable
References: <4CD2847B.1060009@stericsson.com>	 <1288865910.3277.23.camel@odin>  <4CD28FA6.9030303@stericsson.com> <1288869112.3277.25.camel@odin>
In-Reply-To: <1288869112.3277.25.camel@odin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sorry, got a busy schedule atm. Can you give us your reasoning behind
> why you think we need a lock here ?
Yes, when we enter regulator_enable() we take the lock only for that specific regulator rdev->mutex
and calls the locked function _regulator_enable().
This locked function then checks if we have a supply and recursively calls the locked _regulator_enable() again but with the supply rdev as argument.
The supply rdev regulator is however not locked at this stage, only the "original" supplied regulator is locked.
So if we have two regulators with the same supply regulator trying to enable at approx. the same time they will both
enter the _regulator_enable without locks and we could get a race condition.
This would probably result in reference counting error and unbalanced regulator warnings.

In our system we make use the regulator hierarchy quite heavily.
> 
> Thanks
> 
> Liam

/Mattias Wallin
