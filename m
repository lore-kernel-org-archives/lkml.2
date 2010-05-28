Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0E1AA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:00:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38295 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab0E1AAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:00:24 -0400
Subject: Re: Clock jumps
From: john stultz <johnstul@us.ibm.com>
To: Bernhard Schmidt <berni@birkenwald.de>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4BFEE8A2.30706@birkenwald.de>
References: <loom.20100524T171038-56@post.gmane.org>
	 <20100525062100.GP22163@redhat.com>	<4BFD5616.6070302@cora.nwra.com>
	 <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>
	 <htmdsk$9kn$1@dough.gmane.org>
	 <AANLkTindrSuRdOI30l4P5XMuUVv3j7Zso9fMi1xREb3A@mail.gmail.com>
	 <4BFEE8A2.30706@birkenwald.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 17:00:16 -0700
Message-ID: <1275004816.1813.15.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 23:48 +0200, Bernhard Schmidt wrote:
> On 27.05.2010 21:08, john stultz wrote:
> > I'd be very interested in hearing more about the host side issue. So
> > this happened with the same kernel that you were using before, with no
> > trouble?
> 
> Correct.
> 
> > Could you also send dmesg output from this boot? And if you can find
> > any older dmesg logs to compare with, send those too?
> 
> See http://users.birkenwald.de/~berni/temp/dmesg-lenny and 
> http://users.birkenwald.de/~berni/temp/dmesg-squeeze . Although running 
> on the same kernel binary the initrd changed greatly when upgrading, so 
> ordering/timing between those two is off.
> 
> Note that the dmesg output is captured right after boot. I think I 
> remember seeing a "TSC unstable" message pretty soon after boot, but I 
> might be mixing it up with my other AMD-based KVM server. I don't hold 
> normal (non-boot) logs that long, so I can't tell for sure.

Looking at the diff:
--- dmesg-lenny 2010-05-27 16:45:33.000000000 -0700
+++ dmesg-squeeze       2010-05-27 16:46:14.000000000 -0700
@@ -132,8 +132,8 @@
 console [ttyS1] enabled
 hpet clockevent registered
 Fast TSC calibration using PIT
-Detected 2660.398 MHz processor.
-Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.79 BogoMIPS (lpj=10641592)
+Detected 2613.324 MHz processor.
+Calibrating delay loop (skipped), value calculated using timer frequency.. 5226.64 BogoMIPS (lpj=10453296)
 Security Framework initialized
 Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
 Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
@@ -160,7 +160,7 @@
 CPU0: Intel(R) Xeon(R) CPU            3075  @ 2.66GHz stepping 0b
 Booting Node   0, Processors  #1
 Brought up 2 CPUs
-Total of 2 processors activated (10640.79 BogoMIPS).
+Total of 2 processors activated (10546.63 BogoMIPS).
 NET: Registered protocol family 16
 ACPI: bus type pci registered
 PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)

So you can see in the above the during the second boot the TSC
calibration was badly mis-calculated. This was the cause of the skew.

Not sure how that might be linked to the distro upgrade. It could have
been something like SMI damage during the calibration time, but I
thought the calibration loop watched for that.

Bernhard: I expect with all those vms, this machine isn't rebooted
frequently. So could you look at the logs to see how much the  "Detected
xxxx.yyy MHz processor." line varies by across a few other boots (if
they still exist?).

Ingo/Thomas: Any thoughts, should we be considering dropping the
quick_pit_calibrate() code and always do the slower route?

thanks
-john

