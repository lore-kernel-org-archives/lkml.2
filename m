Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899Ab1DNSV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:21:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52908 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933872Ab1DNSVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:21:09 -0400
Subject: Re: Improved TSC calculation
From: john stultz <johnstul@us.ibm.com>
To: Ed W <lists@wildgooses.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4DA6D85A.8000800@wildgooses.com>
References: <4DA6D85A.8000800@wildgooses.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 11:20:53 -0700
Message-ID: <1302805253.2673.17.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 12:19 +0100, Ed W wrote:
> Hi, Thanks for the new stable TSC calculation commit
> (08ec0c58fb8a05d3191d5cb6f5d6f81adb419798).
> 
> My situation is that I don't have a PM or HPET timer (x86 Alix board),
> and my requirements are embedded type use, but with only intermittently
> connected network/gps, so accurate timekeeping between reboots is
> important.
> 
> I had been experimenting with extending the existing PIT timer routines
> at boot, but I had the problem that it was taking 1s+ to get a very
> stable calculation (which is undesirable for my requirements), however,
> having spotted your commit it seems like a much more sensible solution.

Thanks!

> Before I try and hack probably an (inadequate) solution myself, do you
> have any thoughts on the best solution to extend your commit to non
> PM/HEPT machine?  My initial thought was to repeatedly call
> pit_calibrate_tsc() with an extended latch, looking for a stable
> solution (ie refactor native_calibrate_tsc() ).  Is this workable?
> Better ideas?

Oof. So with the PIT you can maybe utilize the second channel/counter,
using a largish long countdown to try to get a similar functionality.
The only big concern is that the timer interrupt hardware is always
problematic (every time we chanage our usage, some random chunk of
laptops seem to stop working). So whatever solution that works for you
might not be able to be generically deployed. But I think it could be
interesting and might be worth you giving it a shot.

I'd probably look at reworking tsc_refine_calibration_work, extending
the tsc_read_refs() code to also get PIT count values and then start the
long PIT countdown on the second channel before we
schedule_delayed_work.

thanks
-john

