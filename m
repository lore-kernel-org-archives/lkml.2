Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2GXQko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:40:44 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38313 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab2GXQkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:40:41 -0400
Date: Tue, 24 Jul 2012 08:58:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Question about tboot_wait_for_aps()
Message-ID: <20120724155853.GA32362@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072416-3534-0000-0000-00000ABD959B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

While taking another pass through the CPU_DYING notifiers, I came upon
the following:

	static int tboot_wait_for_aps(int num_aps)
	{
		unsigned long timeout;

		timeout = AP_WAIT_TIMEOUT*HZ;
		while (atomic_read((atomic_t *)&tboot->num_in_wfs) != num_aps &&
		       timeout) {
			mdelay(1);
			timeout--;
		}

		if (timeout)
			pr_warning("tboot wait for APs timeout\n");

		return !(atomic_read((atomic_t *)&tboot->num_in_wfs) == num_aps);
	}

Questions:

1.	Why AP_WAIT_TIMEOUT*HZ?  Given the mdelay(), shouldn't this
	instead be AP_WAIT_TIMEOUT*1000?  The definition of AP_WAIT_TIMEOUT
	indicates that it is in seconds.

2.	Who changes ->num_in_wfs?  Any other CPUs are in stop_machine(),
	plus I don't see any assignments to this field.  Does the boot
	firmware run again to make this change, sort of like SMIs?

I guess that the good news is that I don't seen anything that cares about
stop_machine().  ;-)

							Thanx, Paul

