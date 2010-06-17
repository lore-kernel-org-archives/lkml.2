Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab0FQUCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525Ab0FQUCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:02:08 -0400
Message-ID: <4C1A7D61.8010900@redhat.com>
Date: Thu, 17 Jun 2010 15:54:09 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Randy Dunlap <randy.dunlap@oracle.com>, dzickus@redhat.com
Subject: Re: [PATCH] Add TAINT_HARDWARE_UNSUPPORTED flag
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com> <20100617091322.b7d21473.randy.dunlap@oracle.com>
In-Reply-To: <20100617091322.b7d21473.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 12:13 PM, Randy Dunlap wrote:
> On Thu, 17 Jun 2010 09:54:45 -0400 Prarit Bhargava wrote:
> 
>> This patch is similar to Theordore Ts'o's TAINT_USER patch,
>> linux-2.6 commit 34f5a39899f3f3e815da64f48ddb72942d86c366.
> 
> and augmented by 92946bc72f2e74c3281b7fc12be9704d455fb3ed, so please
> add similar info to Documentation/oops-tracing.txt.
> 
> 
>> This patch introduces the TAINT_HARDWARE_UNSUPPORTED flag for distributions
>> to use.

<snip>

>> +		       "unsupported.\n");
> 
> Preferable not to split the string, so more like:
> 
> 		printk(KERN_CRIT
> 			"WARNING: This system's hardware is unsupported.\n");
>>  
>>  	set_bit(flag, &tainted_mask);

Hey Randy, thanks for the input.  New patch.

This patch is similar to Theordore Ts'o's TAINT_USER patch,
linux-2.6 commit 34f5a39899f3f3e815da64f48ddb72942d86c366.

Individual distributions may enable "generic" features such as X86 support,
PPC support, and driver support.

Some of the features that are enabled by these "generic" feature flags may
not be considered supported by the individual distribution.

For example, a distribution may want to support PPC but not the Power5
chipset, or the e1000e driver but not a card with a specific DeviceID because
of known firmware issues.

Typically, one would push a config patch to enable and disable the feature and
patch the distribution.  However, in some cases this is not feasible in order
to preserve kabi and at the same time maintain parity with the upstream kernel.
In some cases the distribution may want to allow booting of these features but
explicitly notify a user that they are not "officially" supported.  It is also
possible that the hardware is fixed via a firmware update at a later date,
making it supported again.

It would be useful for a distribution to notify the installer and
bug reporting applications, and notify users that the hardware they are using
is unsupported during panic, oops, BUG(), and WARN().

This patch introduces the TAINT_HARDWARE_UNSUPPORTED flag for distributions
to use.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index 6fe9001..e337b0a 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -263,6 +263,8 @@ characters, each representing a particular tainted value.
  12: 'I' if the kernel is working around a severe bug in the platform
      firmware (BIOS or similar).
 
+ 13: 'H' if the hardware is unsupported by the distribution
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..f722b0d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -347,6 +347,7 @@ extern enum system_states {
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
 #define TAINT_FIRMWARE_WORKAROUND	11
+#define TAINT_HARDWARE_UNSUPPORTED	12
 
 extern void dump_stack(void) __cold;
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 3b16cd9..8d081ff 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -180,6 +180,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_WARN,			'W', ' ' },
 	{ TAINT_CRAP,			'C', ' ' },
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
+	{ TAINT_HARDWARE_UNSUPPORTED,	'H', ' ' },
 };
 
 /**
@@ -197,6 +198,7 @@ static const struct tnt tnts[] = {
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
  *  'I' - Working around severe firmware bug.
+ *  'H' - Hardware is unsupported.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
@@ -243,6 +245,9 @@ void add_taint(unsigned flag)
 	 */
 	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
 		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+	if (flag == TAINT_HARDWARE_UNSUPPORTED)
+		printk(KERN_CRIT
+		       "WARNING: This system's hardware is unsupported.\n");
 
 	set_bit(flag, &tainted_mask);
 }
