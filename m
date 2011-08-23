Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1HWNcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:32:05 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:42187 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab1HWNbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:31:51 -0400
Message-Id: <20110823132941.744407154@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 15:29:41 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>
Subject: [patch 0/3] [RFC] tick_program_event/clockevents_program_event tweaking
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
I rediscovered a couple of clockevents patches which have patiently
been sitting on my hard drive for a rather long time. After some
polishing I guess they are now ready for a review. The aim is to
improve the handling of the clockevents device for s390.

The first patch addresses an issue with the automatic adjustment of
the minimum delay of the clockevents device. We have seen situations
where this adjustment errornously increased the minimum delay on a
virtual system running under z/VM. The only way to get the delay back
to a sane value is a reboot.
To solve this problem a new config option GENERIC_CLOCKEVENTS_MIN_ADJUST
is introduced that allows to select if the automatic increase of the
minimum delay of a clockevents device should be done or not.
The patch enables GENERIC_CLOCKEVENTS_MIN_ADJUST for x86, for s390
we never want to do an adjustment.
Question to the architecture maintainers: are there any other platforms
which will need the adjustment as well?


The second issue that patches #2 and #3 are trying to solve is the fact
that the current code only supports clockevents devices which use a time
delta. The clock comparator found on s390 uses a wall-time value that is
constantly compared to the current TOD clock. If the clock comparator
value is smaller than the TOD clock value an interrupt is made pending. 

The current clockevents code is needlessly complex for this clockevents
device, the function trace of a tick_program_event call looks like this:

  0)               |  tick_program_event() {
  0)               |    tick_dev_program_event() {
  0)               |      ktime_get() {
  0)               |        read_tod_clock() {
  0)   0.336 us    |        } /* read_tod_clock */
  0)   0.692 us    |      } /* ktime_get */
  0)               |      clockevents_program_event() {
  0)               |        s390_next_event() {
  0)   0.190 us    |        } /* s390_next_event */
  0)   0.701 us    |      } /* clockevents_program_event */
  0)   1.901 us    |    } /* tick_dev_program_event */
  0)   2.370 us    |  } /* tick_program_event */

The code does a ktime_get and substracts the result from the expires
value, then passes the delta to the s390_next_event function. This
function then uses get_clock and adds that value to the delta. So
basically the current ktime is first subtracted and then readded to
the expires value for no gain.

The new code implemented by the patches #2 and #3 gives this call trace:

  0)               |  tick_program_event() {
  0)               |    clockevents_program_event() {
  0)               |      s390_next_ktime() {
  0)               |        ktime_get_monotonic_offset() {
  0)   0.183 us    |        } /* ktime_get_monotonic_offset */
  0)   0.734 us    |      } /* s390_next_ktime */
  0)   1.120 us    |    } /* clockevents_program_event */
  0)   1.557 us    |  } /* tick_program_event */

The function tick_dev_program_event is gone, clockevents_program_event
passes the unmodified expires value to s390_next_ktime. This new
function only needs to subtract the wall_to_monotonic offset to get
the wall-clock value to program the clock comparator. And forcing the
minimum delay on a clockevent device with CLOCK_EVT_FEAT_KTIME is not
necessary anymore. Any ktime value can be programmed to the clock
comparator, even one that is in the past. As soon as the irqs are
open again we will simply get an interrupt.

The old code needs 151 instruction for a tick_program_event call,
the new one only 85. A nice improvement.

To: linux-arch@vger.kernel.org
To: linux-kernel@vger.kernel.org
To: linux-s390@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
