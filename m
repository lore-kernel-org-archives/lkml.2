Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab1AKSXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:23:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39439 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab1AKSX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:23:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xqi+Gka3zINkY9zmMz91Ehkx9CvUBYDX1etCtG0a/q98iX7XP7lAjBQ+XKj29p69uR
         0hdMfc/uK2vtI14AGWNVE2KdTd8piXzE9GzcHPwn/v8rpS6BCdKruCIfzqEWyahCKYY4
         JPpahcT1EBhzU0If8L2pB5WLORoH7c1gC4CkM=
Date: Tue, 11 Jan 2011 19:23:23 +0100
From: Tejun Heo <tj@kernel.org>
To: Jian Peng <jipeng@broadcom.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: questions regarding possible violation of AHCI spec in AHCI
 driver
Message-ID: <20110111182323.GG15933@htj.dyndns.org>
References: <4CFF58D2.4040006@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFCD56.6050608@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFD3EB.10800@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFE29C.7080205@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38CD3@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4D000C8B.5040904@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FD72B23@IRVEXCHCCR01.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E18F441196CA634DB8E1F1C56A50A874319FD72B23@IRVEXCHCCR01.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 11, 2011 at 10:09:08AM -0800, Jian Peng wrote:
> Happy Holiday! I want to revisit this issue and hopefully get
> consensus on it asap.

Happy new year!

> Here is the sequence that will cause problem if BSY|DRQ and SSTS.DET
> was not checked in start_engine:
> 
> 1. SUD bit was set in ahci_power_up() to start communication between
>    host and device
> 2. START bit was set in ahci_start_engine() to prepare for data
>    transfer (should check condition and do not set START bit here
>    per spec)
> By the time, host did not receive first FIS so BSY|DRQ was not
> cleared
> 3. inside ahci_hardreset(), call ahci_stop_engine() first, host
>    controller will take time to clean up internal pipeline and
>    transit to idle state
> 4. toggle SCTL.DET to reset interface, now COMRESET was not sent
>    since internal state machine stuck at #2 and #3 (per> spec),
>    BSY|DRQ bit was not cleared
> 5. call ahci_start_engine() again and try to read ID from device but
>    interface is busy since BSY bit was not cleared, failed here
>
> At the end of section 10.1 of AHCI spec (rev 1.3), it states
> 
> Software shall not set PxCMD.ST to '1' until it is determined that a
> functional device is present on the port as determined by
> PxTFD.STS.BSY = '0', PxTFD.STS.DRQ = '0', and PxSSTS.DET = 3h.
> 
> It is likely used to prevent host controller from jumping into wrong
> state before first FIS was received.

I still have to say it's pretty silly of the controller to stall
inrecoverably.

> Please review this issue, and let me know how to resolve it by
> either adopting my previous patch, or creating a new patch.

You haven't really brought up any new issue so my comment stays the
same.

>> I'm not objecting to the change but you guys probably want to fix
>> the controller in following revisions.  If we're gonna make the
>> change, I'd like to go with the previous version without the vendor
>> check.  What is the timeframe for the controller release?  Would it
>> be enough to merge the change during 2.6.38-rc1?  After baking it
>> for some time in 2.6.38, we can propagate the change back through
>> -stable.

So, yeah, let's proceed with the patch.  Please make the following
changes and resubmit.

* Please don't do readl() on the same line as variable declaration and
  drop the unnecessary & 0xff.

* Hmmm... please consider adding a KERN_DEBUG message when
  ahci_start_port() exits without starting the port.  Just in case it
  causes problems on other controllers.

Thank you.

-- 
tejun
