Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab0LHWyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:54:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:41343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230Ab0LHWyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:54:54 -0500
Message-ID: <4D000C8B.5040904@kernel.org>
Date: Wed, 08 Dec 2010 23:54:03 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jian Peng <jipeng@broadcom.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver
References: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com> <4CFEE569.4030204@gmail.com> <4CFF58D2.4040006@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>,<4CFFCD56.6050608@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>,<4CFFD3EB.10800@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com> <4CFFE29C.7080205@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA38CD3@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <E18F441196CA634DB8E1F1C56A50A874319FA38CD3@IRVEXCHCCR01.corp.ad.broadcom.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 22:54:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jian.

On 12/08/2010 09:09 PM, Jian Peng wrote:
> The controller may take much longer time to recover in this case,
> and leads to wrong HW state after stop_engine() inside
> ahci_hardreset() and cause device type checking failure due to
> unfinished HW state change and missing D2H FIS after start_engine()
> again inside ahci_hardreset(). I guess this is the reason why AHCI
> spec try to emphasize.

I don't necessarily agree there.  The requirement is impossible to
reliably satisfy to begin with (it's inherently racy) and most specs
are filled with "the outcome is undefined" when they don't _need_ to
be well defined.  The hardware can do "eh.. well, whatever, I don't
know" but shouldn't get lost and fail to react to further
state-resetting actions.

> Yes, without this change, Broadcom controller will fail due to above
> reason.

Okay, so, the controller goes bonkers if ST is set when prerequisites
are not met.  You know that the problem can still happen with the
proposed change, right?  It's much less likely but definitely can and
actually is likely to happen once in a blue moon.  It isn't too
uncommon for link to take some time to stabilize after a PHY event
(including hardreset) and some devices will end up sending multiple
D2H Reg FISes in the process with conflicting status.  Also, note that
the delay between the check and ST setting could be substantial
especially with parallel probing / booting.

I'm not objecting to the change but you guys probably want to fix the
controller in following revisions.  If we're gonna make the change,
I'd like to go with the previous version without the vendor check.
What is the timeframe for the controller release?  Would it be enough
to merge the change during 2.6.38-rc1?  After baking it for some time
in 2.6.38, we can propagate the change back through -stable.

Thanks.

-- 
tejun
