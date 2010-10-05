Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab0JEL1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:27:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62865 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0JEL1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=gM/35MAfgAneomI3aszHB1x5MTwmcnqmQec9WJJJkw5TWZcOyTgVWsO/iu92EmrThu
         DXSqgPjVe2REB26zffmKnFvUwu32aoid+KnOIFQhZvPlBpgNcAXEaOIQqSnNpcOeRp3G
         rxSemF2lZ8xfnzCPToSYWeyTatUY5q4R+yjuE=
MIME-Version: 1.0
Date: Tue, 5 Oct 2010 15:27:12 +0400
Message-ID: <AANLkTimLUKvo9DiwhfXvOg32NN7TaJCXJXKPyCF1PmWj@mail.gmail.com>
Subject: PROBLEM:
From: blondquirk <blondquirk@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_ips: 1. Integer overflow in update_average_power; 2. Value
returned by i915_read_mch_val is too high to be used as power in mW

Kernel version: linux-2.6.36-rc6 x64

I have Core i3 laptop y460 with dual intel/ati graphics (ati card is
powered off via acpi).
When I modprobe intel_ips (laptop is nearly idle), I get annoying messages:
 [  903.188705] intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match
expected value (found 25, expected 35)
 [  903.188739] intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
 [  903.190255] intel ips 0000:00:1f.6: IPS driver initialized, MCP
temp limit 65535
 [  908.382790] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
 [  913.381288] intel ips 0000:00:1f.6: CPU power or thermal limit exceeded
 [  918.379786] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
 [  923.378302] intel ips 0000:00:1f.6: CPU power or thermal limit exceeded
 [  928.376823] intel ips 0000:00:1f.6: CPU power or thermal limit exceeded
 [  933.375314] intel ips 0000:00:1f.6: CPU power or thermal limit exceeded
 [  938.373857] intel ips 0000:00:1f.6: CPU power or thermal limit exceeded
 [  943.372346] intel ips 0000:00:1f.6: CPU power or thermal limit exceeded
 [  948.370891] intel ips 0000:00:1f.6: CPU power or thermal limit exceeded
 [  953.369370] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded

Then if do
$ modprobe -r intel_ips
$ modprobe intel_ips
I get only
 [ 1097.310896] intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match
expected value (found 25, expected 35)
 [ 1097.312321] intel ips 0000:00:1f.6: IPS driver initialized, MCP
temp limit 65535
 [ 1102.505240] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
 [ 1132.496265] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
 [ 1212.472556] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded

Then I added debug output when calling read_mch_val() and noticed
possible integer overflow

diff -urN intel_ips.c.orig intel_ips.c
--- intel_ips.c.orig    2010-10-04 11:11:42.513203000 +0400
+++ intel_ips.c    2010-10-05 14:23:52.357869000 +0400
@@ -873,7 +873,7 @@
 }

 static const u16 power_decay_factor = 2;
-static u16 update_average_power(u32 avg, u32 val)
+static u32 update_average_power(u32 avg, u32 val)
 {
     u32 ret;

@@ -1039,6 +1039,7 @@
         /* Power */
         if (ips->read_mch_val) {
             mch_val = ips->read_mch_val();
+           dev_info(&ips->dev->dev, "mch_val is %u\n", mch_val);
             ips->mch_avg_power =
                 update_average_power(ips->mch_avg_power,
                              mch_val);

And now mch_power doesn't fluctuate, but it's unexpectedly huge, which
might indicate problem related to i915 :
$ while true; do cat /sys/kernel/debug/ips/mch_power; sleep 1; done;
8886864mW
11704782mW
5017037mW
7487929mW
5988348mW
6001705mW
4132710mW

Also there is possible overflow when converting from unsigned long to
u32, but it should not occur if i915_read_mch_val returns power in mW

Keywords: modules
---
blondquirk
