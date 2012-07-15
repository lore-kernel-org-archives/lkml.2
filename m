Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2GOXYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 19:24:40 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53778 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2GOXYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 19:24:38 -0400
Date: Sun, 15 Jul 2012 18:24:30 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Lars Boegild Thomsen <lth@cow.dk>
Cc: Feng Tang <feng.tang@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Andreas Wallberg <andreas.wallberg@gmail.com>,
        Robert Scott <bugs@humanleg.org.uk>,
        Damjan Georgievski <gdamjan@gmail.com>
Subject: Re: [regression] Ideapad S10-3 does not wake up from suspend
Message-ID: <20120715232430.GB3657@burratino>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <625BA99ED14B2D499DC4E29D8138F15063048B864D@shsmsx502.ccr.corp.intel.com>
 <20120512231349.GA17443@burratino>
 <201205130922.10945.lth@cow.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205130922.10945.lth@cow.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

In May, Lars Boegild Thomsen wrote:
> On Sunday 13 May 2012 07:13:49 Jonathan Nieder wrote:
>>>> Lars Boegild Thomsen writes:

>>>>> After update from 2.6 kernel to 3.0 my Idepad S10-3 will not wake up
>>>>> after sleep.  Back to latest 2.6 kernel works fine.
>>
>>  - passing parameters "hpet=disable highres=off nohz=off" helps some
>>    people if I understand correctly,
[...]
> I didn't notice this one before but that actually works for me.  Adding those 
> kernel params and sleep works again.  I tried combinations thereof but no-go - 
> all 3 required.
>
>> I'd be interested to hear whether the same problem occurs when trying
>> to suspend from the minimal initramfs environment.
[...]
> And I just tried this loading no modules manually and it's the same - never 
> wakes up after sleep.

Thanks.  Please test with the debugging patch below from Feng Tang[1].
I don't know if it will get any useful information because e.g. serial
console and netconsole are not very convenient on this machine[2], but
it seems worth a try.

If one of the people cc-ed needs help building a patched kernel to
test, feel free to write privately and I can give more detailed
instructions.

Hope that helps,
Jonathan

[1] https://bugzilla.kernel.org/show_bug.cgi?id=41932#c18
[2] http://thread.gmane.org/gmane.linux.kernel/1136253/focus=1285790

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..d2e0c90 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -439,6 +439,14 @@ again:
 	 * in the event mask
 	 */
 	if (next_event.tv64 != KTIME_MAX) {
+		s64 delta;
+
+		delta = next_event.tv64 - now.tv64;
+		if (delta >= 10000000000) {
+			printk("%s(): The delta is big: %lld\n", __func__, delta);
+			next_event.tv64 = now.tv64 + 3000000000;
+		}
+
 		/*
 		 * Rearm the broadcast device. If event expired,
 		 * repeat the above
