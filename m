Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab0HVLGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 07:06:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48928 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0HVLG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 07:06:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causes hibernationto hang
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C677A49.4030904@superonline.com>
References: <4C677A49.4030904@superonline.com>
Message-Id: <20100820115449.5FF1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------_4C6DEE790000000064AC_MULTIPART_MIXED_"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 22 Aug 2010 20:06:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------_4C6DEE790000000064AC_MULTIPART_MIXED_
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

> Hello all,
> 
> I am using Debian Sid on a Toshiba Satellite A100 laptop. After testing
> 2.6.35 for a while, I noticed that sometimes my hibernation attempts
> would fail. I should say that I never had such a problem before 2.6.35.
> The hibernation process hangs with 2.6.35 after printing the following:
> 
> === 8< ===
> ...
> Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> PM: Preallocating image memory...
> === >8 ===
> 
> After a short investigation, I found out that this only happens when my
> tmpfs filesystem on /tmp had a lot of data in it. When my tmpfs is empty,
> I have no problems.
> 
> So I wrote a short script which fills up the tmpfs on /tmp and tries to
> hibernate, and I bisected the kernel using this script.
> 
> The end result is that the following commit causes this regression:
> 
> === 8< ===
> commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
> Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date:   Fri Jun 4 14:15:05 2010 -0700
> 
>     vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure
> 
>     ...
> === >8 ===
> 
> I have run 2.6.35-rc6, 2.6.35 and 2.6.35.1 with this commit reverted,
> and I am happy to say that I haven't experienced any problems for at
> least 17 days.
> 
> It looks like this change was included with 2.6.35-rc1. I am sorry
> for not testing earlier.
> 
> I am willing to do testing in case anyone would like me to try patches.
> 
> Regards,
> 
> M. Vefa Bicakci

Hmm... 
I've tested hibernation case for a while. but I have no luck. I couldn't
reproduce your issue. Very sorry. Can you please help our debugging? 
If possible, I hope to run following three test.

1. Please let me know your machine & test script

% cat /proc/meminfo
% cat /proc/vmstat
% cat /proc/zoneinfo
% df
% cat your-fills-up-the-tmpfs-script

2. call shrink_all_memory() forcely and show result

% cat /proc/meminfo
% cat /proc/zoneinfo
# echo 1 > /proc/sys/vm/shrink_all_memory
# tail /var/log/messages
% cat /proc/meminfo
% cat /proc/zoneinfo


3. reset zone_reclaim_stat and rerun shrink_all_memory

# echo 1 > /proc/sys/vm/reset_reclaim_stat
% cat /proc/meminfo
% cat /proc/zoneinfo
# echo 1 > /proc/sys/vm/shrink_all_memory
# tail /var/log/messages
% cat /proc/meminfo
% cat /proc/zoneinfo



--------_4C6DEE790000000064AC_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="0001-debug-print-sysctl.patch"
Content-Disposition: attachment;
 filename="0001-debug-print-sysctl.patch"
Content-Transfer-Encoding: base64

RnJvbSA1NzU0NGUzMWU1YWQ5NjZhODZmN2ZmOWRiZTkyOTk4NzdiMmZiOWM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLT1NBS0kgTW90b2hpcm8gPGtvc2FraS5tb3RvaGlyb0BqcC5m
dWppdHN1LmNvbT4KRGF0ZTogRnJpLCAyMCBBdWcgMjAxMCAxMTowODozMyArMDkwMApTdWJqZWN0
OiBbUEFUQ0ggMS80XSBkZWJ1ZyBwcmludCArIHN5c2N0bAoKU2lnbmVkLW9mZi1ieTogS09TQUtJ
IE1vdG9oaXJvIDxrb3Nha2kubW90b2hpcm9AanAuZnVqaXRzdS5jb20+Ci0tLQoga2VybmVsL3N5
c2N0bC5jIHwgICAyMCArKysrKysrKysrKysrKysrKysrKwogbW0vdm1zY2FuLmMgICAgIHwgICAg
NyArKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3N5c2N0bC5jIGIva2VybmVsL3N5c2N0bC5jCmluZGV4
IGQyNGY3NjEuLmUxYjIyZWQgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9zeXNjdGwuYworKysgYi9rZXJu
ZWwvc3lzY3RsLmMKQEAgLTk2MSw2ICs5NjEsMTkgQEAgc3RhdGljIHN0cnVjdCBjdGxfdGFibGUg
a2Vybl90YWJsZVtdID0gewogCXsgfQogfTsKIAorc3RhdGljIGludCBzeXNjdGxfc2hyaW5rX2Fs
bF9tZW1vcnk7CitzdGF0aWMgaW50IHNocmlua19hbGxfbWVtb3J5X2hhbmRsZXIoY3RsX3RhYmxl
ICp0YWJsZSwgaW50IHdyaXRlLAorCQkJCSAgICAgdm9pZCBfX3VzZXIgKmJ1ZmZlciwgc2l6ZV90
ICpsZW5ndGgsCisJCQkJICAgICBsb2ZmX3QgKnBwb3MpCit7CisJcHJvY19kb2ludHZlY19taW5t
YXgodGFibGUsIHdyaXRlLCBidWZmZXIsIGxlbmd0aCwgcHBvcyk7CisJaWYgKHdyaXRlKSB7CisJ
CXNocmlua19hbGxfbWVtb3J5KHN5c2N0bF9zaHJpbmtfYWxsX21lbW9yeSk7CisJfQorCXJldHVy
biAwOworfQorCisKIHN0YXRpYyBzdHJ1Y3QgY3RsX3RhYmxlIHZtX3RhYmxlW10gPSB7CiAJewog
CQkucHJvY25hbWUJPSAib3ZlcmNvbW1pdF9tZW1vcnkiLApAQCAtMTMxOCw2ICsxMzMxLDEzIEBA
IHN0YXRpYyBzdHJ1Y3QgY3RsX3RhYmxlIHZtX3RhYmxlW10gPSB7CiAJCS5leHRyYTIJCT0gJm9u
ZSwKIAl9LAogI2VuZGlmCisJeworCQkucHJvY25hbWUJPSAic2hyaW5rX2FsbF9tZW1vcnkiLAor
CQkuZGF0YQkJPSAmc3lzY3RsX3Nocmlua19hbGxfbWVtb3J5LAorCQkubWF4bGVuCQk9IHNpemVv
ZihzeXNjdGxfc2hyaW5rX2FsbF9tZW1vcnkpLAorCQkubW9kZQkJPSAwNjQ0LAorCQkucHJvY19o
YW5kbGVyCT0gc2hyaW5rX2FsbF9tZW1vcnlfaGFuZGxlciwKKwl9LAogCiAvKgogICogTk9URTog
ZG8gbm90IGFkZCBuZXcgZW50cmllcyB0byB0aGlzIHRhYmxlIHVubGVzcyB5b3UgaGF2ZSByZWFk
CmRpZmYgLS1naXQgYS9tbS92bXNjYW4uYyBiL21tL3Ztc2Nhbi5jCmluZGV4IGI5NGZlMWIuLjFj
ZTZjNDMgMTAwNjQ0Ci0tLSBhL21tL3Ztc2Nhbi5jCisrKyBiL21tL3Ztc2Nhbi5jCkBAIC0yNDEw
LDYgKzI0MTAsOCBAQCB1bnNpZ25lZCBsb25nIHNocmlua19hbGxfbWVtb3J5KHVuc2lnbmVkIGxv
bmcgbnJfdG9fcmVjbGFpbSkKIAlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAgPSBjdXJyZW50OwogCXVu
c2lnbmVkIGxvbmcgbnJfcmVjbGFpbWVkOwogCisJcHJpbnRrKEtFUk5fRVJSICJzaHJpbmtfYWxs
X21lbW9yeSBzdGFydFxuIik7CisKIAlwLT5mbGFncyB8PSBQRl9NRU1BTExPQzsKIAlsb2NrZGVw
X3NldF9jdXJyZW50X3JlY2xhaW1fc3RhdGUoc2MuZ2ZwX21hc2spOwogCXJlY2xhaW1fc3RhdGUu
cmVjbGFpbWVkX3NsYWIgPSAwOwpAQCAtMjQyMSw2ICsyNDIzLDExIEBAIHVuc2lnbmVkIGxvbmcg
c2hyaW5rX2FsbF9tZW1vcnkodW5zaWduZWQgbG9uZyBucl90b19yZWNsYWltKQogCWxvY2tkZXBf
Y2xlYXJfY3VycmVudF9yZWNsYWltX3N0YXRlKCk7CiAJcC0+ZmxhZ3MgJj0gflBGX01FTUFMTE9D
OwogCisJcHJpbnRrKEtFUk5fRVJSICJzaHJpbmtfYWxsX21lbW9yeTogcmVxOiVsZCByZWNsYWlt
ZWQ6JWxkIGZyZWU6JWxkXG4iLAorCSAgICAgICBucl90b19yZWNsYWltLAorCQlucl9yZWNsYWlt
ZWQsCisJICAgICAgIGdsb2JhbF9wYWdlX3N0YXRlKE5SX0ZSRUVfUEFHRVMpKTsKKwogCXJldHVy
biBucl9yZWNsYWltZWQ7CiB9CiAjZW5kaWYgLyogQ09ORklHX0hJQkVSTkFUSU9OICovCi0tIAox
LjYuNS4yCgo=
--------_4C6DEE790000000064AC_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="0003-debug-reset_reclaim_stat.patch"
Content-Disposition: attachment;
 filename="0003-debug-reset_reclaim_stat.patch"
Content-Transfer-Encoding: base64

RnJvbSA5YjU3NzYzNTJmOGQ0NmUzYWRhODBmOTFmOWQ5Nzg4NzAxMDU2MzBmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLT1NBS0kgTW90b2hpcm8gPGtvc2FraS5tb3RvaGlyb0BqcC5m
dWppdHN1LmNvbT4KRGF0ZTogRnJpLCAyMCBBdWcgMjAxMCAxNToyODoyMiArMDkwMApTdWJqZWN0
OiBbUEFUQ0ggMy80XSBkZWJ1ZzogcmVzZXRfcmVjbGFpbV9zdGF0CgpTaWduZWQtb2ZmLWJ5OiBL
T1NBS0kgTW90b2hpcm8gPGtvc2FraS5tb3RvaGlyb0BqcC5mdWppdHN1LmNvbT4KLS0tCiBrZXJu
ZWwvc3lzY3RsLmMgfCAgIDMxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDEgZmls
ZXMgY2hhbmdlZCwgMzEgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9rZXJuZWwvc3lzY3RsLmMgYi9rZXJuZWwvc3lzY3RsLmMKaW5kZXggZTFiMjJlZC4uM2I3Mjgz
NiAxMDA2NDQKLS0tIGEva2VybmVsL3N5c2N0bC5jCisrKyBiL2tlcm5lbC9zeXNjdGwuYwpAQCAt
OTczLDYgKzk3MywzMCBAQCBzdGF0aWMgaW50IHNocmlua19hbGxfbWVtb3J5X2hhbmRsZXIoY3Rs
X3RhYmxlICp0YWJsZSwgaW50IHdyaXRlLAogCXJldHVybiAwOwogfQogCisjaW5jbHVkZSA8bGlu
dXgvbW1fdHlwZXMuaD4KKyNpbmNsdWRlIDxsaW51eC9tbXpvbmUuaD4KKworc3RhdGljIGludCBy
ZXNldF9yZWNsYWltX3N0YXRfaGFuZGxlcihjdGxfdGFibGUgKnRhYmxlLCBpbnQgd3JpdGUsCisJ
CQkJICAgICAgdm9pZCBfX3VzZXIgKmJ1ZmZlciwgc2l6ZV90ICpsZW5ndGgsCisJCQkJICAgICAg
bG9mZl90ICpwcG9zKQoreworCXN0cnVjdCB6b25lICp6b25lOworCXN0cnVjdCB6b25lX3JlY2xh
aW1fc3RhdCAqcnN0YXQ7CisKKwlpZiAod3JpdGUpIHsKKwkJZm9yX2VhY2hfcG9wdWxhdGVkX3pv
bmUoem9uZSkgeworCQkJc3Bpbl9sb2NrX2lycSgmem9uZS0+bHJ1X2xvY2spOworCQkJcnN0YXQg
PSAmem9uZS0+cmVjbGFpbV9zdGF0OworCQkJcnN0YXQtPnJlY2VudF9zY2FubmVkWzBdID0gMDsK
KwkJCXJzdGF0LT5yZWNlbnRfcm90YXRlZFswXSA9IDA7CisJCQlyc3RhdC0+cmVjZW50X3NjYW5u
ZWRbMV0gPSAwOworCQkJcnN0YXQtPnJlY2VudF9yb3RhdGVkWzFdID0gMDsKKwkJCXNwaW5fdW5s
b2NrX2lycSgmem9uZS0+bHJ1X2xvY2spOworCQl9CisKKwl9CisJcmV0dXJuIDA7Cit9CiAKIHN0
YXRpYyBzdHJ1Y3QgY3RsX3RhYmxlIHZtX3RhYmxlW10gPSB7CiAJewpAQCAtMTMzOCw2ICsxMzYy
LDEzIEBAIHN0YXRpYyBzdHJ1Y3QgY3RsX3RhYmxlIHZtX3RhYmxlW10gPSB7CiAJCS5tb2RlCQk9
IDA2NDQsCiAJCS5wcm9jX2hhbmRsZXIJPSBzaHJpbmtfYWxsX21lbW9yeV9oYW5kbGVyLAogCX0s
CisJeworCQkucHJvY25hbWUJPSAicmVzZXRfcmVjbGFpbV9zdGF0IiwKKwkJLmRhdGEJCT0gJnN5
c2N0bF9zaHJpbmtfYWxsX21lbW9yeSwKKwkJLm1heGxlbgkJPSBzaXplb2Yoc3lzY3RsX3Nocmlu
a19hbGxfbWVtb3J5KSwKKwkJLm1vZGUJCT0gMDY0NCwKKwkJLnByb2NfaGFuZGxlcgk9IHJlc2V0
X3JlY2xhaW1fc3RhdF9oYW5kbGVyLAorCX0sCiAKIC8qCiAgKiBOT1RFOiBkbyBub3QgYWRkIG5l
dyBlbnRyaWVzIHRvIHRoaXMgdGFibGUgdW5sZXNzIHlvdSBoYXZlIHJlYWQKLS0gCjEuNi41LjIK
Cg==
--------_4C6DEE790000000064AC_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="0004-debug-zone_info-reclaim_stat.patch"
Content-Disposition: attachment;
 filename="0004-debug-zone_info-reclaim_stat.patch"
Content-Transfer-Encoding: base64

RnJvbSA4N2NlN2I0YTI0ZjNiMzgxYTIwNGViZDY1NDA1MGFjMmM2YmMyZDE0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLT1NBS0kgTW90b2hpcm8gPGtvc2FraS5tb3RvaGlyb0BqcC5m
dWppdHN1LmNvbT4KRGF0ZTogRnJpLCAyMCBBdWcgMjAxMCAxNTo1Mjo0NyArMDkwMApTdWJqZWN0
OiBbUEFUQ0ggNC80XSBkZWJ1Zzogem9uZV9pbmZvIHJlY2xhaW1fc3RhdAoKU2lnbmVkLW9mZi1i
eTogS09TQUtJIE1vdG9oaXJvIDxrb3Nha2kubW90b2hpcm9AanAuZnVqaXRzdS5jb20+Ci0tLQog
bW0vdm1zdGF0LmMgfCAgIDI3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxlcyBj
aGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL21t
L3Ztc3RhdC5jIGIvbW0vdm1zdGF0LmMKaW5kZXggNzc1OTk0MS4uYmVlM2JhMyAxMDA2NDQKLS0t
IGEvbW0vdm1zdGF0LmMKKysrIGIvbW0vdm1zdGF0LmMKQEAgLTg2MCw2ICs4NjAsMzMgQEAgc3Rh
dGljIHZvaWQgem9uZWluZm9fc2hvd19wcmludChzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHBnX2RhdGFf
dCAqcGdkYXQsCiAJCSAgIHpvbmUtPnByZXZfcHJpb3JpdHksCiAJCSAgIHpvbmUtPnpvbmVfc3Rh
cnRfcGZuLAogCQkgICB6b25lLT5pbmFjdGl2ZV9yYXRpbyk7CisKKwl7CisJCWV4dGVybiBpbnQg
dm1fc3dhcHBpbmVzczsKKwkJaW50IGFub25fcHJpbyA9IHZtX3N3YXBwaW5lc3M7CisJCWludCBm
aWxlX3ByaW8gPSAyMDAgLSB2bV9zd2FwcGluZXNzOworCQl1bnNpZ25lZCBsb25nIGFwOworCQl1
bnNpZ25lZCBsb25nIGZwOworCQlzdHJ1Y3Qgem9uZV9yZWNsYWltX3N0YXQgKnJlY2xhaW1fc3Rh
dCA9ICZ6b25lLT5yZWNsYWltX3N0YXQ7CisKKwkJYXAgPSAoYW5vbl9wcmlvICsgMSkgKiAocmVj
bGFpbV9zdGF0LT5yZWNlbnRfc2Nhbm5lZFswXSArIDEpOworCQlhcCAvPSByZWNsYWltX3N0YXQt
PnJlY2VudF9yb3RhdGVkWzBdICsgMTsKKwkJZnAgPSAoZmlsZV9wcmlvICsgMSkgKiAocmVjbGFp
bV9zdGF0LT5yZWNlbnRfc2Nhbm5lZFsxXSArIDEpOworCQlmcCAvPSByZWNsYWltX3N0YXQtPnJl
Y2VudF9yb3RhdGVkWzFdICsgMTsKKworCQlzZXFfcHJpbnRmKG0sCisJCQkgICAiXG4gcmVjZW50
X2Fub25fcm90YXRlZDogJWx1IgorCQkJICAgIlxuIHJlY2VudF9hbm9uX3NjYW5uZWQ6ICVsdSIK
KwkJCSAgICJcbiByZWNlbnRfZmlsZV9yb3RhdGVkOiAlbHUiCisJCQkgICAiXG4gcmVjZW50X2Zp
bGVfc2Nhbm5lZDogJWx1IgorCQkJICAgIlxuIGFub25fcmF0aW86ICAgICAgICAgICVsdSIKKwkJ
CSAgICwKKwkJCSAgIHpvbmUtPnJlY2xhaW1fc3RhdC5yZWNlbnRfcm90YXRlZFswXSwKKwkJCSAg
IHpvbmUtPnJlY2xhaW1fc3RhdC5yZWNlbnRfc2Nhbm5lZFswXSwKKwkJCSAgIHpvbmUtPnJlY2xh
aW1fc3RhdC5yZWNlbnRfcm90YXRlZFsxXSwKKwkJCSAgIHpvbmUtPnJlY2xhaW1fc3RhdC5yZWNl
bnRfc2Nhbm5lZFsxXSwKKwkJCSAgIChhcCAqIDEwMCkgLyAoYXAgKyBmcCArMSkpOworCX0KIAlz
ZXFfcHV0YyhtLCAnXG4nKTsKIH0KIAotLSAKMS42LjUuMgoK
--------_4C6DEE790000000064AC_MULTIPART_MIXED_--


