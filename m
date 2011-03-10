Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1CJGDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:03:54 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64879 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab1CJGDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:03:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ooSBdGwVrsNvik31b0bGLTJzaQTCTI6UKTfdKe5TzobPG7hYwPrsyShJpRCMT18o3V
         QuA1S3QoPvJkQpFr6T70S0yupAL5ZzCLpBiOake9MuABkkM9lgz+/QsNSN+bKRfY27LP
         R/x2u8Pjia20xhaNny+22U4m1ikODlQOmwaaI=
MIME-Version: 1.0
Date: Thu, 10 Mar 2011 17:03:51 +1100
Message-ID: <AANLkTikTjBAZGBF2BirRpayiL6PX=ewmh+ZEnZkZBr=s@mail.gmail.com>
Subject: Fix for critical bogoMIPS intermittent calculation failure
From: Andrew Worsley <amworsley@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf301fc0c315772e049e1a9c23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf301fc0c315772e049e1a9c23
Content-Type: text/plain; charset=ISO-8859-1

Please find attach a fix to the TSC  (Time Stamp Counter) based
bogoMIPS calculation used on secondary CPUs which has two faults:

   1.  Not handling wrapping of the lower 32 bits of the TSC counter
on 32bit kernel - perhaps TSC is not reset by a warm reset?
   2.  TSC and Jiffies are no incrementing together properly. Either
jiffies increment too quickly or Time Stamp Counter isn't incremented
in during an SMI but the real time clock is and jiffies are incremented.

Case 1 can result in a factor of 16 too large a value which makes
udelay() values too small and can cause mysterious driver errors.
Case 2 appears to give smaller 10-15% errors after averaging but
enough to cause occasional failures on my own board

I have tested this code on my own branch and attach patch suitable for
current kernel code. See below for examples of the failures and
how the fix handles these situations now.

I reported this issue earlier here:
     Intermittent problem with BogoMIPs calculation on Intel AP CPUs -
http://marc.info/?l=linux-kernel&m=129947246316875&w=4

I suspect this issue has been seen by others but as it is intermittent
and bogoMIPS for secondary CPUs are no longer printed out it might
have been difficult to identify this as the cause.  Perhaps these
unresolved issues, although quite old, might be relevant as possibly
this fault has been around for a while. In particular Case 1 may only
be relevant to 32bit kernels on newer HW (most people run 64bit
kernels?). Case 2 is less dramatic since the earlier fix in this area
and also intermittent.

   Re: bogomips discrepancy on Intel Core2 Quad CPU -
http://marc.info/?l=linux-kernel&m=118929277524298&w=4
   slow system and bogus bogomips  -
http://marc.info/?l=linux-kernel&m=116791286716107&w=4
   Re: Re: [RFC-PATCH] clocksource: update lpj if clocksource has -
http://marc.info/?l=linux-kernel&m=128952775819467&w=4

This issue is masked a little by commit
feae3203d711db0a9965300ee6d592257fdaae4f which only prints out the
first bogoMIPS value making it
much harder to notice other values differing. Perhaps it should be
changed to only suppress them when they are similar values?

Here are some outputs showing faults occurring and the new code
handling them properly. See my earlier message for examples of the
original failure.

    Case 1:   A Time Stamp Counter wrap:
...
Calibrating delay loop (skipped), value calculated using timer
frequency.. 6332.70 BogoMIPS (lpj=31663540)
....
calibrate_delay_direct() timer_rate_max=31666493
timer_rate_min=31666151 pre_start=4170369255 pre_end=4202035539
calibrate_delay_direct() timer_rate_max=2425955274
timer_rate_min=2425954941 pre_start=4265368533 pre_end=2396356387
calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap
around start=4265368581 >=post_end=2396356511
calibrate_delay_direct() timer_rate_max=31666274
timer_rate_min=31665942 pre_start=2440373374 pre_end=2472039515
calibrate_delay_direct() timer_rate_max=31666492
timer_rate_min=31666160 pre_start=2535372139 pre_end=2567038422
calibrate_delay_direct() timer_rate_max=31666455
timer_rate_min=31666207 pre_start=2630371084 pre_end=2662037415
Calibrating delay using timer specific routine.. 6333.28 BogoMIPS (lpj=31666428)
Total of 2 processors activated (12665.99 BogoMIPS).
....

    Case 2:  Some thing (presumably the SMM interrupt?) causing the
very low increase in TSC counter for the DELAY_CALIBRATION_TICKS
increase in jiffies
...
Calibrating delay loop (skipped), value calculated using timer
frequency.. 6333.25 BogoMIPS (lpj=31666270)
...
calibrate_delay_direct() timer_rate_max=31666483
timer_rate_min=31666074 pre_start=4199536526 pre_end=4231202809
calibrate_delay_direct() timer_rate_max=864348 timer_rate_min=864016
pre_start=2405343672 pre_end=2406207897
calibrate_delay_direct() timer_rate_max=31666483
timer_rate_min=31666179 pre_start=2469540464 pre_end=2501206823
calibrate_delay_direct() timer_rate_max=31666511
timer_rate_min=31666122 pre_start=2564539400 pre_end=2596205712
calibrate_delay_direct() timer_rate_max=31666084
timer_rate_min=31665685 pre_start=2659538782 pre_end=2691204657
calibrate_delay_direct() dropping min bogoMips estimate 1 = 864348
Calibrating delay using timer specific routine.. 6333.27 BogoMIPS (lpj=31666390)
Total of 2 processors activated (12666.53 BogoMIPS).
...

After 70 boots I saw 2 variations <1% slip through

Andrew Worsley

--20cf301fc0c315772e049e1a9c23
Content-Type: text/x-diff; charset=US-ASCII; name="bogoMIPS.patch"
Content-Disposition: attachment; filename="bogoMIPS.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gl39cnuo0

ZGlmZiAtLWdpdCBhL2luaXQvY2FsaWJyYXRlLmMgYi9pbml0L2NhbGlicmF0ZS5jCmluZGV4IDI0
ZmUwMjIuLjExMzY2MjcgMTAwNjQ0Ci0tLSBhL2luaXQvY2FsaWJyYXRlLmMKKysrIGIvaW5pdC9j
YWxpYnJhdGUuYwpAQCAtMzgsNiArMzgsOSBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBfX2NwdWlu
aXQgY2FsaWJyYXRlX2RlbGF5X2RpcmVjdCh2b2lkKQogCXVuc2lnbmVkIGxvbmcgdGltZXJfcmF0
ZV9taW4sIHRpbWVyX3JhdGVfbWF4OwogCXVuc2lnbmVkIGxvbmcgZ29vZF90aW1lcl9zdW0gPSAw
OwogCXVuc2lnbmVkIGxvbmcgZ29vZF90aW1lcl9jb3VudCA9IDA7CisJdW5zaWduZWQgbG9uZyBt
ZWFzdXJlZF90aW1lc1tNQVhfRElSRUNUX0NBTElCUkFUSU9OX1JFVFJJRVNdOworCWludCBtYXgg
PSAtMTsgLyogaW5kZXggb2YgbWVhc3VyZWRfdGltZXMgd2l0aCBtYXgvbWluIHZhbHVlcyBvciBu
b3Qgc2V0ICovCisJaW50IG1pbiA9IC0xOwogCWludCBpOwogCiAJaWYgKHJlYWRfY3VycmVudF90
aW1lcigmcHJlX3N0YXJ0KSA8IDAgKQpAQCAtOTAsMTcgKzkzLDc0IEBAIHN0YXRpYyB1bnNpZ25l
ZCBsb25nIF9fY3B1aW5pdCBjYWxpYnJhdGVfZGVsYXlfZGlyZWN0KHZvaWQpCiAJCSAqIElmIHRo
ZSB1cHBlciBsaW1pdCBhbmQgbG93ZXIgbGltaXQgb2YgdGhlIHRpbWVyX3JhdGUgaXMKIAkJICog
Pj0gMTIuNSUgYXBhcnQsIHJlZG8gY2FsaWJyYXRpb24uCiAJCSAqLwotCQlpZiAocHJlX3N0YXJ0
ICE9IDAgJiYgcHJlX2VuZCAhPSAwICYmCisJCXByaW50ayhLRVJOX0RFQlVHCisiY2FsaWJyYXRl
X2RlbGF5X2RpcmVjdCgpIHRpbWVyX3JhdGVfbWF4PSVsdSB0aW1lcl9yYXRlX21pbj0lbHUgcHJl
X3N0YXJ0PSVsdSBwcmVfZW5kPSVsdVxuIiwKKwkJCSAgdGltZXJfcmF0ZV9tYXgsIHRpbWVyX3Jh
dGVfbWluLCBwcmVfc3RhcnQsIHByZV9lbmQpOworCQlpZiAoc3RhcnQgPj0gcG9zdF9lbmQpCisJ
CQlwcmludGsoS0VSTl9OT1RJQ0UKKwkJCQkiY2FsaWJyYXRlX2RlbGF5X2RpcmVjdCgpIGlnbm9y
aW5nIHRpbWVyX3JhdGUgYXMgd2UgaGFkIGEgVFNDIHdyYXAgYXJvdW5kIHN0YXJ0PSVsdSA+PXBv
c3RfZW5kPSVsdVxuIiwKKwkJCQlzdGFydCwgcG9zdF9lbmQpOworCQlpZiAoc3RhcnQgPCBwb3N0
X2VuZCAmJiBwcmVfc3RhcnQgIT0gMCAmJiBwcmVfZW5kICE9IDAgJiYKIAkJICAgICh0aW1lcl9y
YXRlX21heCAtIHRpbWVyX3JhdGVfbWluKSA8ICh0aW1lcl9yYXRlX21heCA+PiAzKSkgewogCQkJ
Z29vZF90aW1lcl9jb3VudCsrOwogCQkJZ29vZF90aW1lcl9zdW0gKz0gdGltZXJfcmF0ZV9tYXg7
Ci0JCX0KKwkJCW1lYXN1cmVkX3RpbWVzW2ldID0gdGltZXJfcmF0ZV9tYXg7CisJCQlpZiAobWF4
IDwgMCB8fCB0aW1lcl9yYXRlX21heCA+IG1lYXN1cmVkX3RpbWVzW21heF0pCisJCQkJbWF4ID0g
aTsKKwkJCWlmIChtaW4gPCAwIHx8IHRpbWVyX3JhdGVfbWF4IDwgbWVhc3VyZWRfdGltZXNbbWlu
XSkKKwkJCQltaW4gPSBpOworCQl9IGVsc2UKKwkJCW1lYXN1cmVkX3RpbWVzW2ldID0gMDsKKwog
CX0KIAotCWlmIChnb29kX3RpbWVyX2NvdW50KQotCQlyZXR1cm4gKGdvb2RfdGltZXJfc3VtL2dv
b2RfdGltZXJfY291bnQpOworCS8qCisJICogRmluZCB0aGUgbWF4aW11bSAmIG1pbmltdW0gLSBp
ZiB0aGV5IGRpZmZlciB0b28gbXVjaCB0aHJvdyBvdXQgdGhlIG9uZSB3aXRoIAorCSAqIHRoZSBs
YXJnZXN0IGRpZmZlcmVuY2UgZnJvbSB0aGUgbWVhbiBhbmQgdHJ5IGFnYWluLi4uCisJICovCisJ
d2hpbGUgKGdvb2RfdGltZXJfY291bnQgPiAxKSB7CisJCXVuc2lnbmVkIGxvbmcgZXN0aW1hdGU7
CisJCXVuc2lnbmVkIGxvbmcgbWF4ZGlmZjsKKworCQkvKiBjb21wdXRlIHRoZSBlc3RpbWF0ZSAq
LworCQllc3RpbWF0ZSA9IChnb29kX3RpbWVyX3N1bS9nb29kX3RpbWVyX2NvdW50KTsKKwkJbWF4
ZGlmZiA9IGVzdGltYXRlID4+IDM7CisKKwkJLyogaWYgcmFuZ2UgaXMgd2l0aGluIDEyJSBsZXQn
cyB0YWtlIGl0ICovCisJCWlmICgobWVhc3VyZWRfdGltZXNbbWF4XSAtIG1lYXN1cmVkX3RpbWVz
W21pbl0pIDwgbWF4ZGlmZikKKwkJCXJldHVybiAoZXN0aW1hdGUpOworCisJCS8qIG9rIC0gZHJv
cCB0aGUgd29yc2UgdmFsdWUgYW5kIHRyeSBhZ2Fpbi4uLiAqLworCQlnb29kX3RpbWVyX3N1bSA9
IDA7CisJCWdvb2RfdGltZXJfY291bnQgPSAwOworCQlpZiAoKG1lYXN1cmVkX3RpbWVzW21heF0g
LSBlc3RpbWF0ZSkgPCAoZXN0aW1hdGUgLSBtZWFzdXJlZF90aW1lc1ttaW5dKSkgeworCQkJcHJp
bnRrKEtFUk5fTk9USUNFCisJImNhbGlicmF0ZV9kZWxheV9kaXJlY3QoKSBkcm9wcGluZyBtaW4g
Ym9nb01pcHMgZXN0aW1hdGUgJWQgPSAlbHVcbiIsCisJCQkJbWluLCBtZWFzdXJlZF90aW1lc1tt
aW5dKTsKKwkJCW1lYXN1cmVkX3RpbWVzW21pbl0gPSAwOworCQkJbWluID0gbWF4OworCQl9IGVs
c2UgeworCQkJcHJpbnRrKEtFUk5fTk9USUNFCisJImNhbGlicmF0ZV9kZWxheV9kaXJlY3QoKSBk
cm9wcGluZyBtYXggYm9nb01pcHMgZXN0aW1hdGUgJWQgPSAlbHVcbiIsCisJCQkJbWF4LCBtZWFz
dXJlZF90aW1lc1ttYXhdKTsKKwkJCW1lYXN1cmVkX3RpbWVzW21heF0gPSAwOworCQkJbWF4ID0g
bWluOworCQl9CisKKwkJZm9yIChpID0gMDsgaSA8IE1BWF9ESVJFQ1RfQ0FMSUJSQVRJT05fUkVU
UklFUzsgaSsrKSB7CisJCQlpZiAobWVhc3VyZWRfdGltZXNbaV0gPT0gMCkKKwkJCQljb250aW51
ZTsKKwkJCWdvb2RfdGltZXJfY291bnQrKzsKKwkJCWdvb2RfdGltZXJfc3VtICs9IG1lYXN1cmVk
X3RpbWVzW2ldOworCQkJaWYgKG1lYXN1cmVkX3RpbWVzW2ldIDwgbWVhc3VyZWRfdGltZXNbbWlu
XSkKKwkJCQltaW4gPSBpOworCQkJaWYgKG1lYXN1cmVkX3RpbWVzW2ldID4gbWVhc3VyZWRfdGlt
ZXNbbWF4XSkKKwkJCQltYXggPSBpOworCQl9CisKKwl9CiAKLQlwcmludGsoS0VSTl9XQVJOSU5H
ICJjYWxpYnJhdGVfZGVsYXlfZGlyZWN0KCkgZmFpbGVkIHRvIGdldCBhIGdvb2QgIgorCXByaW50
ayhLRVJOX05PVElDRSAiY2FsaWJyYXRlX2RlbGF5X2RpcmVjdCgpIGZhaWxlZCB0byBnZXQgYSBn
b29kICIKIAkgICAgICAgImVzdGltYXRlIGZvciBsb29wc19wZXJfamlmZnkuXG5Qcm9iYWJseSBk
dWUgdG8gbG9uZyBwbGF0Zm9ybSBpbnRlcnJ1cHRzLiBDb25zaWRlciB1c2luZyBcImxwaj1cIiBi
b290IG9wdGlvbi5cbiIpOwogCXJldHVybiAwOwogfQo=
--20cf301fc0c315772e049e1a9c23--
