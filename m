Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0LHSYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:24:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:48093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab0LHSYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:24:53 -0500
Message-ID: <4CFFCD56.6050608@kernel.org>
Date: Wed, 08 Dec 2010 19:24:22 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jian Peng <jipeng@broadcom.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver
References: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com> <4CFEE569.4030204@gmail.com> <4CFF58D2.4040006@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 18:24:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2010 07:14 PM, Jian Peng wrote:
> The problem happened as follow:
> 
> After power up, inside ahci_init_one(), it will call ahci_power_up()
> to toggle PxCMD.SUD bit first, then HBA will send COMRESET to
> device, and device will send first D2H FIS back. Here it will call
> ahci_start_engine() to turn on PxCMD.ST to process command. In this
> case, it may run into race condition that transaction triggered by
> toggling PxCMD.SUD is not completed yet, and that is the reason why
> extra check is required by spec to guarantee that HBA already
> received FIS and in sane state.
> 
> In most HBA, either staggered spin-up feature was not supported, or
> time required for transaction is less than that between two function
> calls, it may work. IMHO, this is a clear violation of spec, and not
> robust against all HBA design.
>
> The major concern is that ahci_start_engine() is used widely in EH
> and it does not return result to reflect whether ST bit was set or
> not, this may cause trouble in some cases. I am working on verifying
> those cases with different HBAs now.

I see, so it's not that the controller actually failed but you
observed the race condition.  During EH, ahci_start_engine() is used
rather liberally when the driver wants the controller in working
condition.  The assumption is that even if the driver tries to set ST
with the incorrect condition, the controller wouldn't go crazy where
it can't be restarted later, which _must_ be true as there's no atomic
way to check the condition and set ST.

The driver at the same time guarantees that if the whole
initialization protocol succeeds, the last ahci_start_engine() is
called after hardreset is sucessfully completed and thus all the
prerequisites are met.

So, yeap, the driver might set ST when the conditions are not met but
that can't be avoided completely anyway so the controller shouldn't go
completely bonkers for that (it's okay to fail in recoverable way) and
the driver will do the last ST setting after all the conditions are
met on the success path.

Thanks.

-- 
tejun
