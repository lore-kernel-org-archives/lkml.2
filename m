Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1CGEeK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 23:34:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43763 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab1CGEeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 23:34:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=lTf3aUy8KtYC5Y8XXq56qxv6r1Yi+Tq8ZlTiyV/+NvppNWkgEAt3cgFqCTrx5xKeuT
         X+jJoG/GeXDa42vYF0CNipR/snr0vue7qet8qQG3XVCjpczfrWMXLaqXSO6YEG/y1c3n
         XDUqRm+s7wyUend4JC7M6INj1jKMT2Qr3+E/k=
MIME-Version: 1.0
Date: Mon, 7 Mar 2011 15:34:02 +1100
Message-ID: <AANLkTinaTbqccp0D3DwFBA2BTkY9RLyYZ7NWAK_9udKn@mail.gmail.com>
Subject: Intermittent problem with BogoMIPs calculation on Intel AP CPUs
From: Andrew Worsley <amworsley@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Content-Type: multipart/mixed; boundary=00261883a59c513948049ddd0136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00261883a59c513948049ddd0136
Content-Type: text/plain; charset=ISO-8859-1

I am seeing an occasional problem with the value of the bogoMIPs value
calculated by calibrate_delay_direct() in init/calibrate.c
on the 2nd CPU of a "Intel(R) Core(TM)2 Duo CPU     E8500  @ 3.16GHz
stepping 0a" system on a 2.6.30 kernel running in 32bit mode.
This code has hardly changed in trunk - I just took the single patch
different and it makes no difference.

Occasionally it generates a very large number or a smaller number.
Both happen to cause failures reading an
i2c memory as udelay() doesn't delay long enough. Either because lpj
is too small or it is too big and causes an overflow in
part of the calculation - loops_per_jiffy * (HZ/4) in __const_udelay()
at arch/x86/lib/delay.c

Anyway either of these is very painful on my system and forcing the
lpj value to a good one via a grub appears to fix everything which
will allow me to live with this but I think the code in
calibrate_delay_direct() is buggy, as I describe below.

 Is it acceptable to just compare the value with the directly
calculated value from the first Boot CPU?

 Is this calibrate_delay_direct() calculation adding any value on
other CPUs when the direct calculation appears to be fine for the
first CPU?

The code in commit 8a9e1b0f564615bd92ba50162623e25c2904e564 added
calibrate_delay_direct() with some detailed comments
describing how it is trying to avoid problems caused by SMM (see
http://en.wikipedia.org/wiki/System_Management_Mode) interrupts
which presumably either cause TSC (Time Stamp Counter) and jiffies to
increment suddenly in the middle of a tight loop and stuff up
the calculation.

I illustrate with some output (with an extra printk) showing the
problems I have seen (perhaps 1 in 10 boots)

  This one I think is because under 32bit mode the TSC lower 32bits
will wrap and the code doesn't handle that:

...
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
calibrate_delay_direct() timer_rate_max=31666645
timer_rate_min=31666293 pre_start=3378627722 pre_end=3410294234
calibrate_delay_direct() timer_rate_max=31666673
timer_rate_min=31666255 pre_start=3473627114 pre_end=3505293578
calibrate_delay_direct() timer_rate_max=31666597
timer_rate_min=31666283 pre_start=3568626535 pre_end=3600292951
calibrate_delay_direct() timer_rate_max=31666635
timer_rate_min=31666293 pre_start=3663625870 pre_end=3695292372
calibrate_delay_direct() timer_rate_max=31666607
timer_rate_min=31666293 pre_start=3758625290 pre_end=3790291773
Calibrating delay using timer specific routine.. 6333.32 BogoMIPS (lpj=31666631)

.... the next boot actually hits the wrap around and gets the bad value...

Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
calibrate_delay_direct() timer_rate_max=2453994723
timer_rate_min=2453994372 pre_start=4262693219 pre_end=2421720428
<==== screwy value here
calibrate_delay_direct() timer_rate_max=31666664
timer_rate_min=31666255 pre_start=2469376541 pre_end=2501043005
calibrate_delay_direct() timer_rate_max=31666578
timer_rate_min=31666321 pre_start=2564375962 pre_end=2596042416
calibrate_delay_direct() timer_rate_max=31666616
timer_rate_min=31666303 pre_start=2659375344 pre_end=2691041837
calibrate_delay_direct() timer_rate_max=31666644
timer_rate_min=31666245 pre_start=2754374727 pre_end=2786041162
Calibrating delay using timer specific routine.. 103226.44 BogoMIPS
(lpj=516132245)
...

     * Here's a different style failure where we end up with a
anomalously low value - SMI interrupts??? - also causes i2c issues for
me :-(
...
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
calibrate_delay_direct() timer_rate_max=31666682
timer_rate_min=31666255 pre_start=4176760694 pre_end=4208427167
calibrate_delay_direct() timer_rate_max=289455 timer_rate_min=289209
pre_start=2383154760 pre_end=2383444092
calibrate_delay_direct() timer_rate_max=31666606
timer_rate_min=31666264 pre_start=2446777001 pre_end=2478443474
calibrate_delay_direct() timer_rate_max=31666597
timer_rate_min=31666284 pre_start=2541776383 pre_end=2573442857
calibrate_delay_direct() timer_rate_max=31666683
timer_rate_min=31666284 pre_start=2636775756 pre_end=2668442230
Calibrating delay using timer specific routine.. 5078.24 BogoMIPS (lpj=25391204)
....

  * I added a patch to work around the TWC wrap and also some
additional code that tries to through out bad values (due to SMI?) but
still get issues very occasionally. Fortunately this time it at least
fell back to the original calculation which appeared to work so
perhaps that's okay. I attach my patch below if others want to see my
printk's et cetera.

....
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
calibrate_delay_direct() timer_rate_max=31666597
timer_rate_min=31666331 pre_start=4100065645 pre_end=4131732109
calibrate_delay_direct() timer_rate_max=31666587
timer_rate_min=31666255 pre_start=4195065047 pre_end=4226731511
calibrate_delay_direct() timer_rate_max=10694540
timer_rate_min=10694283 pre_start=2391054019 pre_end=2401748435
<==== screwy value
calibrate_delay_direct() timer_rate_max=31666654
timer_rate_min=31666245 pre_start=2465081325 pre_end=2496747770
calibrate_delay_direct() timer_rate_max=31666987
timer_rate_min=31666654 pre_start=2560080717 pre_end=2591747580
calibrate_delay_direct() dropping bad bogoMips estimate 0 = 31666597
calibrate_delay_direct() dropping bad bogoMips estimate 1 = 31666587
calibrate_delay_direct() dropping bad bogoMips estimate 2 = 10694540
calibrate_delay_direct() dropping bad bogoMips estimate 3 = 31666654
calibrate_delay_direct() dropping bad bogoMips estimate 4 = 31666987
calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
Probably due to long platform interrupts. Consider using "lpj=" boot option.
Calibrating delay loop... 6330.77 BogoMIPS (lpj=31653888)
....

I am not on the mailing list, but would be interesting in hearing
people's suggestions. Also this might be helpful to some people with
strange intermittent issues
as lpj is correct for the first CPU which is calculated directly from
the frequency, so depending which CPU runs the i2c driver it works or
fails....

Also I noticed this bug listed:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/375791 : Bogomips
incorrect on second core

Thanks

Andrew

--00261883a59c513948049ddd0136
Content-Type: text/x-diff; charset=US-ASCII; name="calibrate.patch"
Content-Disposition: attachment; filename="calibrate.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkywb8oe0

ZGlmZiAtLWdpdCBhL2luaXQvY2FsaWJyYXRlLmMgYi9pbml0L2NhbGlicmF0ZS5jCmluZGV4IGEz
NzljOTAuLjU2MDJmNGYgMTAwNjQ0Ci0tLSBhL2luaXQvY2FsaWJyYXRlLmMKKysrIGIvaW5pdC9j
YWxpYnJhdGUuYwpAQCAtMzgsNiArMzgsNyBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBfX2NwdWlu
aXQgY2FsaWJyYXRlX2RlbGF5X2RpcmVjdCh2b2lkKQogCXVuc2lnbmVkIGxvbmcgdGltZXJfcmF0
ZV9taW4sIHRpbWVyX3JhdGVfbWF4OwogCXVuc2lnbmVkIGxvbmcgZ29vZF90aW1lcl9zdW0gPSAw
OwogCXVuc2lnbmVkIGxvbmcgZ29vZF90aW1lcl9jb3VudCA9IDA7CisJdW5zaWduZWQgbG9uZyBt
ZWFzdXJlZF90aW1lc1tNQVhfRElSRUNUX0NBTElCUkFUSU9OX1JFVFJJRVNdOwogCWludCBpOwog
CiAJaWYgKHJlYWRfY3VycmVudF90aW1lcigmcHJlX3N0YXJ0KSA8IDAgKQpAQCAtNjYsNyArNjcs
NyBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBfX2NwdWluaXQgY2FsaWJyYXRlX2RlbGF5X2RpcmVj
dCh2b2lkKQogCQlwcmVfc3RhcnQgPSAwOwogCQlyZWFkX2N1cnJlbnRfdGltZXIoJnN0YXJ0KTsK
IAkJc3RhcnRfamlmZmllcyA9IGppZmZpZXM7Ci0JCXdoaWxlIChqaWZmaWVzIDw9IChzdGFydF9q
aWZmaWVzICsgMSkpIHsKKwkJd2hpbGUgKHRpbWVfYmVmb3JlX2VxKGppZmZpZXMsIHN0YXJ0X2pp
ZmZpZXMgKyAxKSkgewogCQkJcHJlX3N0YXJ0ID0gc3RhcnQ7CiAJCQlyZWFkX2N1cnJlbnRfdGlt
ZXIoJnN0YXJ0KTsKIAkJfQpAQCAtNzQsOCArNzUsOCBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBf
X2NwdWluaXQgY2FsaWJyYXRlX2RlbGF5X2RpcmVjdCh2b2lkKQogCiAJCXByZV9lbmQgPSAwOwog
CQllbmQgPSBwb3N0X3N0YXJ0OwotCQl3aGlsZSAoamlmZmllcyA8PQotCQkgICAgICAgKHN0YXJ0
X2ppZmZpZXMgKyAxICsgREVMQVlfQ0FMSUJSQVRJT05fVElDS1MpKSB7CisJCXdoaWxlICh0aW1l
X2JlZm9yZV9lcShqaWZmaWVzLCBzdGFydF9qaWZmaWVzICsgMSArCisJCQkJCSAgICAgICBERUxB
WV9DQUxJQlJBVElPTl9USUNLUykpIHsKIAkJCXByZV9lbmQgPSBlbmQ7CiAJCQlyZWFkX2N1cnJl
bnRfdGltZXIoJmVuZCk7CiAJCX0KQEAgLTkwLDE1ICs5MSw1MCBAQCBzdGF0aWMgdW5zaWduZWQg
bG9uZyBfX2NwdWluaXQgY2FsaWJyYXRlX2RlbGF5X2RpcmVjdCh2b2lkKQogCQkgKiBJZiB0aGUg
dXBwZXIgbGltaXQgYW5kIGxvd2VyIGxpbWl0IG9mIHRoZSB0aW1lcl9yYXRlIGlzCiAJCSAqID49
IDEyLjUlIGFwYXJ0LCByZWRvIGNhbGlicmF0aW9uLgogCQkgKi8KLQkJaWYgKHByZV9zdGFydCAh
PSAwICYmIHByZV9lbmQgIT0gMCAmJgorCXByaW50ayhLRVJOX1dBUk5JTkcKKyJjYWxpYnJhdGVf
ZGVsYXlfZGlyZWN0KCkgdGltZXJfcmF0ZV9tYXg9JWx1IHRpbWVyX3JhdGVfbWluPSVsdSBwcmVf
c3RhcnQ9JWx1IHByZV9lbmQ9JWx1XG4iLAorCQkJICB0aW1lcl9yYXRlX21heCwgdGltZXJfcmF0
ZV9taW4sIHByZV9zdGFydCwgcHJlX2VuZCk7CisJCWlmIChzdGFydCA+PSBwb3N0X2VuZCkKKwkJ
CXByaW50ayhLRVJOX1dBUk5JTkcKKwkJCQkiY2FsaWJyYXRlX2RlbGF5X2RpcmVjdCgpIGlnbm9y
aW5nIHRpbWVyX3JhdGUgYXMgd2UgaGFkIGEgVFNDIHdyYXAgYXJvdW5kIHN0YXJ0PSVsdSA+PXBv
c3RfZW5kPSVsdVxuIiwKKwkJCQlzdGFydCwgcG9zdF9lbmQpOworCQlpZiAoc3RhcnQgPCBwb3N0
X2VuZCAmJiBwcmVfc3RhcnQgIT0gMCAmJiBwcmVfZW5kICE9IDAgJiYKIAkJICAgICh0aW1lcl9y
YXRlX21heCAtIHRpbWVyX3JhdGVfbWluKSA8ICh0aW1lcl9yYXRlX21heCA+PiAzKSkgewogCQkJ
Z29vZF90aW1lcl9jb3VudCsrOwogCQkJZ29vZF90aW1lcl9zdW0gKz0gdGltZXJfcmF0ZV9tYXg7
Ci0JCX0KKwkJCW1lYXN1cmVkX3RpbWVzW2ldID0gdGltZXJfcmF0ZV9tYXg7CisJCX0gZWxzZQor
CQkJbWVhc3VyZWRfdGltZXNbaV0gPSAwOworCiAJfQogCi0JaWYgKGdvb2RfdGltZXJfY291bnQp
Ci0JCXJldHVybiAoZ29vZF90aW1lcl9zdW0vZ29vZF90aW1lcl9jb3VudCk7CisJaWYgKGdvb2Rf
dGltZXJfY291bnQpIHsKKwkJdW5zaWduZWQgbG9uZyBlc3RpbWF0ZSA9IChnb29kX3RpbWVyX3N1
bS9nb29kX3RpbWVyX2NvdW50KTsKKwkJdW5zaWduZWQgbG9uZyBtYXhkaWZmID0gZXN0aW1hdGUg
Pj4gMzsKKworCQlnb29kX3RpbWVyX3N1bSA9IDA7CisJCWdvb2RfdGltZXJfY291bnQgPSAwOwor
CQlmb3IgKGkgPSAwOyBpIDwgTUFYX0RJUkVDVF9DQUxJQlJBVElPTl9SRVRSSUVTOyBpKyspIHsK
KwkJCWlmIChtZWFzdXJlZF90aW1lc1tpXSA9PSAwKQorCQkJCWNvbnRpbnVlOworCQkJaWYgKG1l
YXN1cmVkX3RpbWVzW2ldID4gZXN0aW1hdGUpIHsKKwkJCQkJaWYgKChtZWFzdXJlZF90aW1lc1tp
XSAtIGVzdGltYXRlKSA+IG1heGRpZmYpIHsKKwkJCQkJCXByaW50ayhLRVJOX1dBUk5JTkcKKwki
Y2FsaWJyYXRlX2RlbGF5X2RpcmVjdCgpIGRyb3BwaW5nIGJhZCBib2dvTWlwcyBlc3RpbWF0ZSAl
ZCA9ICVsdVxuIiwgaSwgbWVhc3VyZWRfdGltZXNbaV0pOworCQkJCQkJY29udGludWU7CisJCQkJ
CX0KKwkJCX0gZWxzZSBpZiAoKGVzdGltYXRlIC0gbWVhc3VyZWRfdGltZXNbaV0pID4gbWF4ZGlm
ZikgeworCQkJCQlwcmludGsoS0VSTl9XQVJOSU5HCisJImNhbGlicmF0ZV9kZWxheV9kaXJlY3Qo
KSBkcm9wcGluZyBiYWQgYm9nb01pcHMgZXN0aW1hdGUgJWQgPSAlbHVcbiIsIGksIG1lYXN1cmVk
X3RpbWVzW2ldKTsKKwkJCQkJY29udGludWU7CisJCQl9CisJCQlnb29kX3RpbWVyX2NvdW50Kys7
CisJCQlnb29kX3RpbWVyX3N1bSArPSB0aW1lcl9yYXRlX21heDsKKwkJfQorCisJCWlmIChnb29k
X3RpbWVyX2NvdW50KQorCQkJcmV0dXJuIChnb29kX3RpbWVyX3N1bS9nb29kX3RpbWVyX2NvdW50
KTsKKwl9CiAKIAlwcmludGsoS0VSTl9XQVJOSU5HICJjYWxpYnJhdGVfZGVsYXlfZGlyZWN0KCkg
ZmFpbGVkIHRvIGdldCBhIGdvb2QgIgogCSAgICAgICAiZXN0aW1hdGUgZm9yIGxvb3BzX3Blcl9q
aWZmeS5cblByb2JhYmx5IGR1ZSB0byBsb25nIHBsYXRmb3JtIGludGVycnVwdHMuIENvbnNpZGVy
IHVzaW5nIFwibHBqPVwiIGJvb3Qgb3B0aW9uLlxuIik7Cg==
--00261883a59c513948049ddd0136--
