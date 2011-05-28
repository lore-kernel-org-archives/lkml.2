Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab1E1XJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 19:09:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47694 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab1E1XJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 19:09:33 -0400
MIME-Version: 1.0
Date: Sat, 28 May 2011 19:09:32 -0400
Message-ID: <BANLkTi=8b0ApzZ7v82tUE8-XBeScZEtzDw@mail.gmail.com>
Subject: [RFC] sdhci: timeouts
From: Charles Hannum <root@ihack.net>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636e0a66fa1319e04a45e25ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e0a66fa1319e04a45e25ba
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Between all the devices with special =93quirks=94 to use
SDHCI_QUIRK_BROKEN_TIMEOUT_VAL and
SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK, and the 19200 Google hits for
=93linux sdhci timeout=94, it sure seems like there's a problem there
somewhere.  Having been bitten by it on my own Dell laptop, I went
poking, and found:

1) The second term of the timeout calculation (based on tacc_clks) is
totally bogus.  It's dividing a whole number of SDCLK cycles by the
host clock frequency, but is expecting to get microseconds.  See
attached patch sdhci-timeout-clks.diff.

2) The SDHCI spec is very specific that in the presence of both a
Transfer Complete and a Data Timeout Error, that the Transfer Complete
takes precedence.  This is documented under the definition of the
Transfer Complete bit (page 53 of the SDHCI 2.0 spec).  See attached
patch sdhci-timeout-int.diff.

3) There's a lot of folklore about buggy clocks on various chips, but
no hard data.  I always hate this kind of folklore.  I found it
helpful to actually measure the timeout and see if it was what we
expected.  Ultimately this proved that the controllers in my machines
were in fact delivering timeouts pretty much exactly as expected.  See
attached patch sdhci-timeout-log.diff (depends on the previous two
diffs); it outputs message of the form:

May 28 18:53:01 lop-nor kernel: [24056.231401] sdhci: timeout,
requested 508400484ns actual 510006113ns, TMCLK configured 33000
estimated 32896
May 28 18:53:33 lop-nor kernel: [24088.002670] sdhci: timeout,
requested 508400484ns actual 510005815ns, TMCLK configured 33000
estimated 32896
May 28 18:55:29 lop-nor kernel: [24204.139937] sdhci: timeout,
requested 508400484ns actual 500006027ns, TMCLK configured 33000
estimated 33554
May 28 18:55:29 lop-nor kernel: [24204.887654] sdhci: timeout,
requested 508400484ns actual 500006025ns, TMCLK configured 33000
estimated 33554

4) Ultimately I found that some SDHC cards just seem to take a good
long time to respond.  I ended up increasing the write timeout to 1s
and I've encountered 0 problems since then.  Since this is only an
error condition, and therefore hardly of any performance concerns, I
suggest it may be a good idea to do this in general.  See attached
patch sdhci-timeout-limit.diff

--001636e0a66fa1319e04a45e25ba
Content-Type: text/x-patch; charset=US-ASCII; name="sdhci-timeout-clks.diff"
Content-Disposition: attachment; filename="sdhci-timeout-clks.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go966nrz0

LS0tIGxpbnV4LTIuNi4zOC9kcml2ZXJzL21tYy9ob3N0L3NkaGNpLmMJMjAxMS0wMy0xNCAyMToy
MDozMi4wMDAwMDAwMDAgLTA0MDAKKysrIGxpbnV4LTIuNi4zOC9kcml2ZXJzL21tYy9ob3N0L3Nk
aGNpLmMJMjAxMS0wNS0yOCAxODo0OTo0NS41MzgwNzcwNjUgLTA0MDAKQEAgLTYwNyw3ICs2MDcs
NyBAQAogCiAJLyogdGltZW91dCBpbiB1cyAqLwogCXRhcmdldF90aW1lb3V0ID0gZGF0YS0+dGlt
ZW91dF9ucyAvIDEwMDAgKwotCQlkYXRhLT50aW1lb3V0X2Nsa3MgLyBob3N0LT5jbG9jazsKKwkJ
KGRhdGEtPnRpbWVvdXRfY2xrcyAqIDEwMDApIC8gKGhvc3QtPmNsb2NrIC8gMTAwMCk7CiAKIAlp
ZiAoaG9zdC0+cXVpcmtzICYgU0RIQ0lfUVVJUktfREFUQV9USU1FT1VUX1VTRVNfU0RDTEspCiAJ
CWhvc3QtPnRpbWVvdXRfY2xrID0gaG9zdC0+Y2xvY2sgLyAxMDAwOwo=
--001636e0a66fa1319e04a45e25ba
Content-Type: text/x-patch; charset=US-ASCII; name="sdhci-timeout-int.diff"
Content-Disposition: attachment; filename="sdhci-timeout-int.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go967n081

LS0tIGxpbnV4LTIuNi4zOC9kcml2ZXJzL21tYy9ob3N0L3NkaGNpLmMJMjAxMS0wNS0yOCAxODo0
OTo0NS41MzgwNzcwNjUgLTA0MDAKKysrIGxpbnV4LTIuNi4zOC9kcml2ZXJzL21tYy9ob3N0L3Nk
aGNpLmMJMjAxMS0wNS0yOCAxODo1MjowMi43OTk3MDI2MTAgLTA0MDAKQEAgLTE1MjAsNyArMTUy
MCw4IEBACiAJCXJldHVybjsKIAl9CiAKLQlpZiAoaW50bWFzayAmIFNESENJX0lOVF9EQVRBX1RJ
TUVPVVQpCisJaWYgKChpbnRtYXNrICYgU0RIQ0lfSU5UX0RBVEFfVElNRU9VVCkgJiYKKwkgICAg
IShpbnRtYXNrICYgU0RIQ0lfSU5UX0RBVEFfRU5EKSkKIAkJaG9zdC0+ZGF0YS0+ZXJyb3IgPSAt
RVRJTUVET1VUOwogCWVsc2UgaWYgKGludG1hc2sgJiBTREhDSV9JTlRfREFUQV9FTkRfQklUKQog
CQlob3N0LT5kYXRhLT5lcnJvciA9IC1FSUxTRVE7Cg==
--001636e0a66fa1319e04a45e25ba
Content-Type: text/x-patch; charset=US-ASCII; name="sdhci-timeout-log.diff"
Content-Disposition: attachment; filename="sdhci-timeout-log.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go967vkg2

LS0tIGxpbnV4LTIuNi4zOC9kcml2ZXJzL21tYy9ob3N0L3NkaGNpLmMJMjAxMS0wNS0yOCAxODo1
MjowMi43OTk3MDI2MTAgLTA0MDAKKysrIGxpbnV4LTIuNi4zOC9kcml2ZXJzL21tYy9ob3N0L3Nk
aGNpLmMJMjAxMS0wNS0yOCAxODo0Njo1NS4zNTY0MDk5NTYgLTA0MDAKQEAgLTYwMiwxNSArNjAy
LDE5IEBACiAJICogbG9uZ2VyIHRvIHRpbWUgb3V0LCBidXQgdGhhdCdzIG11Y2ggYmV0dGVyIHRo
YW4gaGF2aW5nIGEgdG9vLXNob3J0CiAJICogdGltZW91dCB2YWx1ZS4KIAkgKi8KKyNpZm5kZWYg
Q09ORklHX1NESENJX1NUVURZX1RJTUVPVVRTCiAJaWYgKGhvc3QtPnF1aXJrcyAmIFNESENJX1FV
SVJLX0JST0tFTl9USU1FT1VUX1ZBTCkKIAkJcmV0dXJuIDB4RTsKKyNlbmRpZgogCiAJLyogdGlt
ZW91dCBpbiB1cyAqLwogCXRhcmdldF90aW1lb3V0ID0gZGF0YS0+dGltZW91dF9ucyAvIDEwMDAg
KwogCQkoZGF0YS0+dGltZW91dF9jbGtzICogMTAwMCkgLyAoaG9zdC0+Y2xvY2sgLyAxMDAwKTsK
IAorI2lmbmRlZiBDT05GSUdfU0RIQ0lfU1RVRFlfVElNRU9VVFMKIAlpZiAoaG9zdC0+cXVpcmtz
ICYgU0RIQ0lfUVVJUktfREFUQV9USU1FT1VUX1VTRVNfU0RDTEspCiAJCWhvc3QtPnRpbWVvdXRf
Y2xrID0gaG9zdC0+Y2xvY2sgLyAxMDAwOworI2VuZGlmCiAKIAkvKgogCSAqIEZpZ3VyZSBvdXQg
bmVlZGVkIGN5Y2xlcy4KQEAgLTY3MSw2ICs2NzUsMTQgQEAKIAlob3N0LT5kYXRhX2Vhcmx5ID0g
MDsKIAogCWNvdW50ID0gc2RoY2lfY2FsY190aW1lb3V0KGhvc3QsIGRhdGEpOworI2lmZGVmIENP
TkZJR19TREhDSV9TVFVEWV9USU1FT1VUUworCXsKKwkJc3RydWN0IHRpbWVzcGVjIG5vdyA9IENV
UlJFTlRfVElNRTsKKwkJaG9zdC0+c3RhcnRfdGltZSA9IHRpbWVzcGVjX3RvX25zKCZub3cpOwor
CQlob3N0LT5leHBlY3RlZF90aW1lb3V0ID0gKHU2NCkoMSA8PCAoMTMrY291bnQpKSAqIDEwMDAw
MDAgLyBob3N0LT50aW1lb3V0X2NsazsKKwkJaG9zdC0+dGltZW91dF9jb3VudGVyID0gY291bnQ7
CisJfQorI2VuZGlmCiAJc2RoY2lfd3JpdGViKGhvc3QsIGNvdW50LCBTREhDSV9USU1FT1VUX0NP
TlRST0wpOwogCiAJaWYgKGhvc3QtPmZsYWdzICYgKFNESENJX1VTRV9TRE1BIHwgU0RIQ0lfVVNF
X0FETUEpKQpAQCAtMTUyMiw3ICsxNTM0LDE3IEBACiAKIAlpZiAoKGludG1hc2sgJiBTREhDSV9J
TlRfREFUQV9USU1FT1VUKSAmJgogCSAgICAhKGludG1hc2sgJiBTREhDSV9JTlRfREFUQV9FTkQp
KQorCXsKKyNpZmRlZiBDT05GSUdfU0RIQ0lfU1RVRFlfVElNRU9VVFMKKwkJc3RydWN0IHRpbWVz
cGVjIG5vdyA9IENVUlJFTlRfVElNRTsKKwkJdTY0IGFjdHVhbF90aW1lb3V0ID0gdGltZXNwZWNf
dG9fbnMoJm5vdykgLSBob3N0LT5zdGFydF90aW1lOworCQlwcmludGsoS0VSTl9XQVJOSU5HICJz
ZGhjaTogdGltZW91dCwgcmVxdWVzdGVkICVsbGRucyBhY3R1YWwgJWxsZG5zLCBUTUNMSyBjb25m
aWd1cmVkICVkIGVzdGltYXRlZCAlbGxkXG4iLAorCQkgICAgICAgKGxvbmcgbG9uZylob3N0LT5l
eHBlY3RlZF90aW1lb3V0LCAobG9uZyBsb25nKWFjdHVhbF90aW1lb3V0LAorCQkgICAgICAgaG9z
dC0+dGltZW91dF9jbGssCisJCSAgICAgICAobG9uZyBsb25nKSgodTY0KSgxIDw8ICgxMytob3N0
LT50aW1lb3V0X2NvdW50ZXIpKSAqIDEwMDAwMDAgLyBhY3R1YWxfdGltZW91dCkpOworI2VuZGlm
CiAJCWhvc3QtPmRhdGEtPmVycm9yID0gLUVUSU1FRE9VVDsKKwl9CiAJZWxzZSBpZiAoaW50bWFz
ayAmIFNESENJX0lOVF9EQVRBX0VORF9CSVQpCiAJCWhvc3QtPmRhdGEtPmVycm9yID0gLUVJTFNF
UTsKIAllbHNlIGlmICgoaW50bWFzayAmIFNESENJX0lOVF9EQVRBX0NSQykgJiYKLS0tIGxpbnV4
LTIuNi4zOC9pbmNsdWRlL2xpbnV4L21tYy9zZGhjaS5oCTIwMTEtMDMtMTQgMjE6MjA6MzIuMDAw
MDAwMDAwIC0wNDAwCisrKyBsaW51eC0yLjYuMzgvaW5jbHVkZS9saW51eC9tbWMvc2RoY2kuaAky
MDExLTA1LTI4IDE4OjAyOjEyLjYzMjM2NzgzMCAtMDQwMApAQCAtMTcsNiArMTcsOCBAQAogI2lu
Y2x1ZGUgPGxpbnV4L2lvLmg+CiAjaW5jbHVkZSA8bGludXgvbW1jL2hvc3QuaD4KIAorI2RlZmlu
ZSBDT05GSUdfU0RIQ0lfU1RVRFlfVElNRU9VVFMKKwogc3RydWN0IHNkaGNpX2hvc3QgewogCS8q
IERhdGEgc2V0IGJ5IGhhcmR3YXJlIGludGVyZmFjZSBkcml2ZXIgKi8KIAljb25zdCBjaGFyICpo
d19uYW1lOwkvKiBIYXJkd2FyZSBidXMgbmFtZSAqLwpAQCAtMTQ1LDYgKzE0NywxMSBAQAogCXVu
c2lnbmVkIGludCAgICAgICAgICAgIG9jcl9hdmFpbF9zZDsKIAl1bnNpZ25lZCBpbnQgICAgICAg
ICAgICBvY3JfYXZhaWxfbW1jOwogCisjaWZkZWYgQ09ORklHX1NESENJX1NUVURZX1RJTUVPVVRT
CisJdTY0IGV4cGVjdGVkX3RpbWVvdXQsIHN0YXJ0X3RpbWU7CisJdTggdGltZW91dF9jb3VudGVy
OworI2VuZGlmCisKIAl1bnNpZ25lZCBsb25nIHByaXZhdGVbMF0gX19fX2NhY2hlbGluZV9hbGln
bmVkOwogfTsKICNlbmRpZiAvKiBfX1NESENJX0ggKi8K
--001636e0a66fa1319e04a45e25ba
Content-Type: text/x-patch; charset=US-ASCII; name="sdhci-timeout-limit.diff"
Content-Disposition: attachment; filename="sdhci-timeout-limit.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go9682tn3

LS0tIGxpbnV4LTIuNi4zOC9kcml2ZXJzL21tYy9jb3JlL2NvcmUuYwkyMDExLTAzLTE0IDIxOjIw
OjMyLjAwMDAwMDAwMCAtMDQwMAorKysgbGludXgtMi42LjM4L2RyaXZlcnMvbW1jL2NvcmUvY29y
ZS5jCTIwMTEtMDUtMjggMTc6MzA6MTUuMjg3MzkyNjQ4IC0wNDAwCkBAIC0zMDgsNyArMzA4LDcg
QEAKIAkJCSAqIFRoZSBsaW1pdCBpcyByZWFsbHkgMjUwIG1zLCBidXQgdGhhdCBpcwogCQkJICog
aW5zdWZmaWNpZW50IGZvciBzb21lIGNyYXBweSBjYXJkcy4KIAkJCSAqLwotCQkJbGltaXRfdXMg
PSAzMDAwMDA7CisJCQlsaW1pdF91cyA9IDEwMDAwMDA7CiAJCWVsc2UKIAkJCWxpbWl0X3VzID0g
MTAwMDAwOwogCg==
--001636e0a66fa1319e04a45e25ba--
