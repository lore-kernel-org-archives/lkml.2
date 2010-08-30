Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0H3C2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 22:28:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54446 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0H3C2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 22:28:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernationto hang
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C7643C7.4010904@superonline.com>
References: <20100826134506.F676.A69D9226@jp.fujitsu.com> <4C7643C7.4010904@superonline.com>
Message-Id: <20100830083704.5231.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------_4C7AEF2000000000522D_MULTIPART_MIXED_"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 30 Aug 2010 11:28:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------_4C7AEF2000000000522D_MULTIPART_MIXED_
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

> On 26/08/10 11:09 AM, KOSAKI Motohiro wrote:
> >> If there is anything I can do to debug this problem please let me
> >> know.
> > 
> > Vefa, your above log is very useful. really thanks.
> > So, I'm convinced two things.
> >  - my patch is purely unrelated.
> >  - how to fix your issue.
> > 
> > Can you please try attached patch? I bet this can solve your issue.
> > 
> > Thanks for your patience.
> 
> Hello!
> 
> First of all, thanks a lot for your help - I really appreciate it.
> 
> I applied your new patches on top of your old patches. Hopefully that
> was okay.
> 
> Unfortunately, it didn't work this time. Here's a sample output from the
> new patch.
> 
> === 8< ===
> [58.050208] PM: Preallocating image memory...
> [58.159881] shrink_all_memory start
> [58.232411] PM: shrink memory: pass=1, req:312373 reclaimed:15864 free:358420
> [58.342041] PM: shrink memory: pass=2, req:296509 reclaimed:21837 free:362167
> [60.690035] PM: shrink memory: pass=3, req:274672 reclaimed:25982 free:348006
> [61.754931] PM: shrink memory: pass=4, req:248690 reclaimed:49623 free:371589
> [64.361714] PM: shrink memory: pass=5, req:199067 reclaimed:74683 free:396695
> [64.361769] shrink_all_memory: req:124384 reclaimed:74683 free:396695
> === >8 ===
> 
> The interesting thing is that even though there is a lot of free memory at the
> end, it still hangs. 

Grr. I'm surprised this result ;-)
shrink_all_memory() finish to shrink memory successfully. but your
system still hang immediately after. I have no idea why this mysterious
occur. 

I prepared next debugging patch. It added prenty debug printk. I hope
it enlighten up which path makes system hang-up.

1. apply my new patch

2. Enable following PM debug option in Kconfig

  [*] Power Management support
  [*]   Power Management Debug Support
  [*]     Extra PM attributes in sysfs for low-level debugging/testing
  [*]     Verbose Power Management debugging

3. append following kernel boot option into grub configration file

	no_console_suspend=1

3. kernel build and reboot
4. some prepare
   # echo 8 > /proc/sysrq-trigger
   # cd /sys/power
   # echo 1 > pm_trace
   # echo 0 > pm_async

5. run your test program


> I also included the timestamps; note the one and two second
> delays between the passes.

This is expected result because tmpfs shrink need swap-out. then
we need i/o time.

> 
> Please let me know if there is anything I can do.

Please send me your .config and full dmesg.


Thanks many and many help us!

--------_4C7AEF2000000000522D_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="0001-debug-messages.patch"
Content-Disposition: attachment;
 filename="0001-debug-messages.patch"
Content-Transfer-Encoding: base64

RnJvbSAxYjA3MWQ3OTU4Y2I5MzNjZjk5ZmJiZTU2NWZkMzNkYmRkNjI2YTRkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLT1NBS0kgTW90b2hpcm8gPGtvc2FraS5tb3RvaGlyb0BqcC5m
dWppdHN1LmNvbT4KRGF0ZTogTW9uLCAxNSBGZWIgMjA0NCAxMDozNDozNyArMDkwMApTdWJqZWN0
OiBbUEFUQ0hdIGRlYnVnIG1lc3NhZ2VzCgpTaWduZWQtb2ZmLWJ5OiBLT1NBS0kgTW90b2hpcm8g
PGtvc2FraS5tb3RvaGlyb0BqcC5mdWppdHN1LmNvbT4KLS0tCiBrZXJuZWwvcG93ZXIvc25hcHNo
b3QuYyB8ICAgMjUgKysrKysrKysrKysrKysrKysrKysrLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAy
MSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9wb3dl
ci9zbmFwc2hvdC5jIGIva2VybmVsL3Bvd2VyL3NuYXBzaG90LmMKaW5kZXggNWU3ZWRmYi4uYzg2
NDgwNiAxMDA2NDQKLS0tIGEva2VybmVsL3Bvd2VyL3NuYXBzaG90LmMKKysrIGIva2VybmVsL3Bv
d2VyL3NuYXBzaG90LmMKQEAgLTEyNjMsNyArMTI2Myw3IEBAIGludCBoaWJlcm5hdGVfcHJlYWxs
b2NhdGVfbWVtb3J5KHZvaWQpCiAJc3RydWN0IHRpbWV2YWwgc3RhcnQsIHN0b3A7CiAJaW50IGVy
cm9yOwogCi0JcHJpbnRrKEtFUk5fSU5GTyAiUE06IFByZWFsbG9jYXRpbmcgaW1hZ2UgbWVtb3J5
Li4uICIpOworCXByaW50ayhLRVJOX0lORk8gIlBNOiBQcmVhbGxvY2F0aW5nIGltYWdlIG1lbW9y
eS4uLiBcbiIpOwogCWRvX2dldHRpbWVvZmRheSgmc3RhcnQpOwogCiAJZXJyb3IgPSBtZW1vcnlf
Ym1fY3JlYXRlKCZvcmlnX2JtLCBHRlBfSU1BR0UsIFBHX0FOWSk7CkBAIC0xMzA5LDYgKzEzMDks
NyBAQCBpbnQgaGliZXJuYXRlX3ByZWFsbG9jYXRlX21lbW9yeSh2b2lkKQogCSAqIGluIG1lbW9y
eSwgYWxsb2NhdGUgcGFnZSBmcmFtZXMgZm9yIHRoZSBpbWFnZSBhbmQgd2UncmUgZG9uZS4KIAkg
Ki8KIAlpZiAoc2l6ZSA+PSBzYXZlYWJsZSkgeworCQlwcmludGsoS0VSTl9JTkZPICJQTTogc2l6
ZSA+PSBzYXZlYWJsZS4gc2tpcCBcbiIpOwogCQlwYWdlcyA9IHByZWFsbG9jYXRlX2ltYWdlX2hp
Z2htZW0oc2F2ZV9oaWdobWVtKTsKIAkJcGFnZXMgKz0gcHJlYWxsb2NhdGVfaW1hZ2VfbWVtb3J5
KHNhdmVhYmxlIC0gcGFnZXMpOwogCQlnb3RvIG91dDsKQEAgLTEzMzUsMTYgKzEzMzYsMzAgQEAg
aW50IGhpYmVybmF0ZV9wcmVhbGxvY2F0ZV9tZW1vcnkodm9pZCkKIAkgKiBoaWdobWVtIGFuZCBu
b24taGlnaG1lbSB6b25lcyBzZXBhcmF0ZWx5LgogCSAqLwogCXBhZ2VzX2hpZ2htZW0gPSBwcmVh
bGxvY2F0ZV9pbWFnZV9oaWdobWVtKGhpZ2htZW0gLyAyKTsKKwlwcmludGsoS0VSTl9JTkZPICJQ
TTogcHJlYWxsb2NhdGVfaW1hZ2VfaGlnaG1lbSAlbHUgJWx1XG4iLAorCSAgICAgICBoaWdobWVt
LCBwYWdlc19oaWdobWVtKTsKKwogCWFsbG9jID0gKGNvdW50IC0gbWF4X3NpemUpIC0gcGFnZXNf
aGlnaG1lbTsKIAlwYWdlcyA9IHByZWFsbG9jYXRlX2ltYWdlX21lbW9yeShhbGxvYyk7Ci0JaWYg
KHBhZ2VzIDwgYWxsb2MpCisJcHJpbnRrKEtFUk5fSU5GTyAiUE06IHByZWFsbG9jYXRlX2ltYWdl
X21lbW9yeSAlbHUgJWx1XG4iLAorCSAgICAgICBhbGxvYywgcGFnZXMpOworCisJaWYgKHBhZ2Vz
IDwgYWxsb2MpIHsKKwkJcHJpbnRrKEtFUk5fSU5GTyAiUE06IHBhZ2VzKCVsdSkgPCBhbGxvYygl
bHUpLiBlcnJvci4gXG4iLAorCQkgICAgICAgcGFnZXMsIGFsbG9jKTsKIAkJZ290byBlcnJfb3V0
OworCX0KIAlzaXplID0gbWF4X3NpemUgLSBzaXplOwogCWFsbG9jID0gc2l6ZTsKIAlzaXplID0g
cHJlYWxsb2NhdGVfaGlnaG1lbV9mcmFjdGlvbihzaXplLCBoaWdobWVtLCBjb3VudCk7CisJcHJp
bnRrKEtFUk5fSU5GTyAiUE06IHByZWFsbG9jYXRlX2hpZ2htZW1fZnJhY3Rpb24gJWx1ICVsdSAl
bHUgLT4gJWx1XG4iLAorCSAgICAgICBzaXplLCBoaWdobWVtLCBjb3VudCwgc2l6ZSk7CisKIAlw
YWdlc19oaWdobWVtICs9IHNpemU7CiAJYWxsb2MgLT0gc2l6ZTsKIAlwYWdlcyArPSBwcmVhbGxv
Y2F0ZV9pbWFnZV9tZW1vcnkoYWxsb2MpOworCXByaW50ayhLRVJOX0lORk8gIlBNOiBwcmVhbGxv
Y2F0ZV9pbWFnZV9tZW1vcnkgJWx1ICVsdVxuIiwKKwkgICAgICAgYWxsb2MsIHBhZ2VzKTsKIAlw
YWdlcyArPSBwYWdlc19oaWdobWVtOwogCiAJLyoKQEAgLTEzNTIsMTggKzEzNjcsMjAgQEAgaW50
IGhpYmVybmF0ZV9wcmVhbGxvY2F0ZV9tZW1vcnkodm9pZCkKIAkgKiBwYWdlcyBpbiBtZW1vcnks
IGJ1dCB3ZSBoYXZlIGFsbG9jYXRlZCBtb3JlLiAgUmVsZWFzZSB0aGUgZXhjZXNzaXZlCiAJICog
b25lcyBub3cuCiAJICovCisJcHJpbnRrKEtFUk5fSU5GTyAiUE06IGZyZWVfdW5uZWNlc3Nhcnlf
cGFnZXMoKSBcbiIpOwogCWZyZWVfdW5uZWNlc3NhcnlfcGFnZXMoKTsKIAogIG91dDoKIAlkb19n
ZXR0aW1lb2ZkYXkoJnN0b3ApOwotCXByaW50ayhLRVJOX0NPTlQgImRvbmUgKGFsbG9jYXRlZCAl
bHUgcGFnZXMpXG4iLCBwYWdlcyk7CisJcHJpbnRrKEtFUk5fSU5GTyAiZG9uZSAoYWxsb2NhdGVk
ICVsdSBwYWdlcylcbiIsIHBhZ2VzKTsKIAlzd3N1c3Bfc2hvd19zcGVlZCgmc3RhcnQsICZzdG9w
LCBwYWdlcywgIkFsbG9jYXRlZCIpOwogCiAJcmV0dXJuIDA7CiAKICBlcnJfb3V0OgotCXByaW50
ayhLRVJOX0NPTlQgIlxuIik7CisJcHJpbnRrKEtFUk5fSU5GTyAiUE06IGVycl9vdXQgXG4iKTsK
IAlzd3N1c3BfZnJlZSgpOworCXByaW50ayhLRVJOX0lORk8gIlBNOiBzd3N1c3BfZnJlZSgpIGVu
ZCBcbiIpOwogCXJldHVybiAtRU5PTUVNOwogfQogCi0tIAoxLjYuNS4yCgo=
--------_4C7AEF2000000000522D_MULTIPART_MIXED_--


