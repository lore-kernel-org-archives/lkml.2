Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0L0Ge0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 01:34:26 -0500
Received: from nm19.bullet.mail.ac4.yahoo.com ([98.139.52.216]:26648 "HELO
	nm19.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752890Ab0L0GeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 01:34:25 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 740931.43955.bm@omp1022.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=g8xW5sRSicCGnTWz0hG52aA3SOYnjeZS6gcfII+Oeuqoop8GoYcsaZh/fnkobV+JMl5U4/iHlexMnS0t4oaoSxpc5ab3g8TBiNWAvivjk6koPBemUxXa6zrtIOzxfS6dCWehInOvD6XktlxFSte36/hxx06GuX84dVL0Xb37slk=;
Message-ID: <466840.5514.qm@web65716.mail.ac4.yahoo.com>
X-YMail-OSG: Es1fIbsVM1nq.Q9wMmPUWUqIuVRTNgnIT1b8vKtKo.80rUG
 RUHE1Jz6HXGiHkkIz6IY.E_y3fvK9xgbpsqWMiGlny2vmRxspc_GUBtP0nUJ
 d9qr3H8gAvr10Y3oz1Y6dg.XmYE3xJ9bZRFXnFH5tn5ZhLQ4subDltMjQgII
 rIJLaa87X0JQweYwZKn4cBluJItvXl4eDDB82KC_tFrHNVdJYYtjX1hUibqc
 yXO5O_gJ21NC70RFWohVg0sD92zvPHujewaaDQVEX9ZqKeNDea8eIIkoxNt0
 eG_u9PVAgkz1GOI.oCblxt8FwoOnM7JW5nBr3horKCraokxPyRnxryzsKkWA
 zYnYurwTDcXNnZw7a12xkiQrhPNunRQQupdmIyjFNtFZEGlQEo9eO
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Sun, 26 Dec 2010 22:34:23 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl and _get_icount functions
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-75916433-1293431663=:5514"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-75916433-1293431663=:5514
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Pete,=0A=0AAgain many thanks for the additional review and comments. =0A=0A=
I addressed your second concern and added 3 locks/unlocks around places whe=
re mct_u232_port->icount struct is being read (I attached new patch to this=
 email).=0A=0ARegarding your first concern I have a slight reservation. Usu=
ally MSR contains information about both states which are raised and states=
 which are changed. It looks like we use upper MSR nibble which contains in=
formation about 4 states which were raised, not lower MSR nibble which cont=
ains information about 4 states which were changed (Please refer to http://=
www.lammertbies.nl/comm/info/serial-uart.html for further details). So we s=
et control state when it's raised and clear all the states which are not ra=
ised at the moment. Implementing your proposal would increase ring state re=
ading by two times if between 2 consecutive rings another state is raised a=
t the moment when first ring state is off. I also researched implementation=
s under usb/serial and saw that all of them are rely on the current states =
(not change states) to increment the respective counter variables. In addit=
ion after I completed initial implementation I benchmarked rm60 radiation r=
eadings
 against PDM-2 readings. The differences were far below expected maximum ex=
pected error threshold.=0A=0AThank you again,=0A Vadim.=0A=0A--- On Sun, 12=
/26/10, Pete Zaitcev <zaitcev@redhat.com> wrote:=0A=0A> From: Pete Zaitcev =
<zaitcev@redhat.com>=0A> Subject: Re: [PATCH 1/1] mct_u232: added _ioctl an=
d _get_icount functions=0A> To: "Tsozik" <tsozik@yahoo.com>=0A> Cc: "Greg K=
roah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org, linux-kernel@vge=
r.kernel.org, zaitcev@redhat.com=0A> Date: Sunday, December 26, 2010, 10:57=
 PM=0A> On Sun, 26 Dec 2010 18:58:46 -0800=0A> (PST)=0A> Tsozik <tsozik@yah=
oo.com>=0A> wrote:=0A> =0A> > Please let me know if there's anything else I=
 need to=0A> correct before=0A> > it can be rolled out,=0A> =0A> I am hardl=
y an expert here, but I looked it up as much as I=0A> could,=0A> and this l=
ooks like a wrong way to do it:=0A> =0A> > @@ -386,27 +396,41 @@ static int=
=0A> mct_u232_get_modem_stat(struc=0A> >=A0 =A0=A0=A0 /* Translate Control =
Line=0A> states */=0A> > +=A0=A0=A0 if (msr & MCT_U232_MSR_DSR) {=0A> >=A0 =
=A0=A0=A0 =A0=A0=A0=0A> *control_state |=3D=A0 TIOCM_DSR;=0A> > +=A0=A0=A0 =
=A0=A0=A0=0A> icount->dsr++;=0A> > +=A0=A0=A0 } else {=0A> >=A0 =A0=A0=A0 =
=A0=A0=A0=0A> *control_state &=3D ~TIOCM_DSR;=0A> > +=A0=A0=A0 }=0A> =0A> U=
nfortunately, Kerrisk's manpages do not seem to offer an=0A> authoritative=
=0A> definition, but the expectations across the code seems that=0A> the co=
unter=0A> actually counts the changes. I know that some people talked=0A> a=
bout=0A> counting "interrupts", but the way it's implemented in=0A> trustwo=
rthy=0A> drivers suggests something like this:=0A> =0A> =A0=A0=A0 unsigned =
int old_ctl_state;=0A> =0A> =A0=A0=A0 old_ctl_state =3D *control_state;=0A>=
 =A0=A0=A0 if (msr & MCT_U232_MSR_DSR)=0A> =A0=A0=A0 =A0=A0=A0 *control_sta=
te=0A> |=3D=A0 TIOCM_DSR;=0A> =A0=A0=A0 else=0A> =A0=A0=A0 =A0=A0=A0 *contr=
ol_state &=3D=0A> ~TIOCM_DSR;=0A> =A0=A0=A0 if (old_ctl_state !=3D *control=
_state)=0A> =A0=A0=A0 =A0=A0=A0 icount->dsr++;=0A> =A0=A0=A0 ...... repeat =
for all bits=0A> =0A> E.g. for DSR going down too, although perhaps I'm not=
=0A> suggesting the=0A> best way to do it. Could you re-implement it like t=
he above=0A> and=0A> check that your radiation counter works the same with =
it=0A> and=0A> when driven by a built-in serial port?=0A> =0A> Another thin=
g, you should take priv->lock around=0A> fetching of=0A> mct_u232_port->ico=
unt in mct_u232_ioctl. It seems=0A> superfluous,=0A> I know, because the AP=
I itself is racy, but just to be=0A> nice=0A> and doing the expected thing.=
..=0A> =0A> -- Pete=0A>=0A=0A=0A      
--0-75916433-1293431663=:5514
Content-Type: application/octet-stream; name="mct_u232.c.patch.submit_v2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="mct_u232.c.patch.submit_v2"

RnJvbTogRnJvbTogVmFkaW0gVHNvemlrIDx0c296aWtAeWFob28uY29tPgoK
QWRkZWQgbWN0X3UyMzJfaW9jdGwgKGltcGxlbWVudHMgVElPQ01JV0FJVCBj
b21tYW5kKSBhbmQgbWN0X3UyMzJfZ2V0X2ljb3VudCAoaW1wbGVtZW50cyBU
SU9DR0lDT1VOVCBjb21tYW5kKSBmdW5jdGlvbnMuIE1DVCB1MjMyIHA5IGlz
IG9uZSBvZiBhIGZldyB1c2IgdG8gc2VyYWlsIGFkYXB0ZXJzIHdoaWNoIGNv
bnZlcnRzIFVTQiArLy01diB2b2x0YWdlIGxldmVscyB0byBDT00gKy8tMTUg
dm9sdGFnZXMuIFNvIGl0IGNhbiBhbHNvIHBvd2VyIENPTSBpbnRlcmZhY2Vk
IGRldmljZXMuIFRoaXMgbWFrZXMgaXQgdmVyeSB1c2FibGUgZm9yIGxlZ2Fj
eSBDT00gaW50ZXJmYWNlZCBkYXRhLWFjcXVpc2l0aW9uIGhhcmR3YXJlLiBJ
IHRlc3RlZCBuZXcgaW1wbGVtZW50YXRpb24gd2l0aCBBV0FSRSBFbGVjdHJv
bmljcyBSTS02MCByYWRpYXRpb24gbWV0ZXIsIHdoaWNoIHNlbmRzIHB1bHNl
IHZpYSBSTkcgQ09NIGxpbmUgd2hlbmV2ZXIgbmV3IHBhcnRpY2xlIGlzIHJl
Z2lzdGVyZWQuCgpTaWduZWQtb2ZmLWJ5OiBWYWRpbSBUc296aWsgPHRzb3pp
a0B5YWhvby5jb20+CgotLS0KClBhdGNoIGJlbG93IGlzIGJhc2VkIG9uIGxp
bnV4LTIuNi4zNy1yYzcKCi0tLSB1c2Ivc2VyaWFsL21jdF91MjMyLmMub3Jp
ZwkyMDEwLTEyLTI2IDE2OjU0OjE2LjY2MDI5NDkyNCAtMDUwMAorKysgdXNi
L3NlcmlhbC9tY3RfdTIzMi5jCTIwMTAtMTItMjcgMDA6MDk6MzMuNjM4ODk0
OTM4IC0wNTAwCkBAIC03OCw2ICs3OCw4IEBACiAjaW5jbHVkZSA8YXNtL3Vu
YWxpZ25lZC5oPgogI2luY2x1ZGUgPGxpbnV4L3VzYi5oPgogI2luY2x1ZGUg
PGxpbnV4L3VzYi9zZXJpYWwuaD4KKyNpbmNsdWRlIDxsaW51eC9zZXJpYWwu
aD4KKyNpbmNsdWRlIDxsaW51eC9pb2N0bC5oPgogI2luY2x1ZGUgIm1jdF91
MjMyLmgiCiAKIC8qCkBAIC0xMDQsNiArMTA2LDEwIEBAIHN0YXRpYyB2b2lk
IG1jdF91MjMyX2JyZWFrX2N0bChzdHJ1Y3QgdHQKIHN0YXRpYyBpbnQgIG1j
dF91MjMyX3Rpb2NtZ2V0KHN0cnVjdCB0dHlfc3RydWN0ICp0dHksIHN0cnVj
dCBmaWxlICpmaWxlKTsKIHN0YXRpYyBpbnQgIG1jdF91MjMyX3Rpb2Ntc2V0
KHN0cnVjdCB0dHlfc3RydWN0ICp0dHksIHN0cnVjdCBmaWxlICpmaWxlLAog
CQkJdW5zaWduZWQgaW50IHNldCwgdW5zaWduZWQgaW50IGNsZWFyKTsKK3N0
YXRpYyBpbnQgIG1jdF91MjMyX2lvY3RsKHN0cnVjdCB0dHlfc3RydWN0ICp0
dHksIHN0cnVjdCBmaWxlICpmaWxlLAorCQkJdW5zaWduZWQgaW50IGNtZCwg
dW5zaWduZWQgbG9uZyBhcmcpOworc3RhdGljIGludCAgbWN0X3UyMzJfZ2V0
X2ljb3VudChzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5LAorCQkJc3RydWN0IHNl
cmlhbF9pY291bnRlcl9zdHJ1Y3QgKmljb3VudCk7CiBzdGF0aWMgdm9pZCBt
Y3RfdTIzMl90aHJvdHRsZShzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5KTsKIHN0
YXRpYyB2b2lkIG1jdF91MjMyX3VudGhyb3R0bGUoc3RydWN0IHR0eV9zdHJ1
Y3QgKnR0eSk7CiAKQEAgLTE1MCw5ICsxNTYsMTAgQEAgc3RhdGljIHN0cnVj
dCB1c2Jfc2VyaWFsX2RyaXZlciBtY3RfdTIzMgogCS50aW9jbXNldCA9CSAg
ICAgbWN0X3UyMzJfdGlvY21zZXQsCiAJLmF0dGFjaCA9CSAgICAgbWN0X3Uy
MzJfc3RhcnR1cCwKIAkucmVsZWFzZSA9CSAgICAgbWN0X3UyMzJfcmVsZWFz
ZSwKKwkuaW9jdGwgPSAgICAgICAgICAgICBtY3RfdTIzMl9pb2N0bCwKKwku
Z2V0X2ljb3VudCA9ICAgICAgICBtY3RfdTIzMl9nZXRfaWNvdW50LAogfTsK
IAotCiBzdHJ1Y3QgbWN0X3UyMzJfcHJpdmF0ZSB7CiAJc3BpbmxvY2tfdCBs
b2NrOwogCXVuc2lnbmVkIGludAkgICAgIGNvbnRyb2xfc3RhdGU7IC8qIE1v
ZGVtIExpbmUgU2V0dGluZyAoVElPQ00pICovCkBAIC0xNjAsNiArMTY3LDkg
QEAgc3RydWN0IG1jdF91MjMyX3ByaXZhdGUgewogCXVuc2lnbmVkIGNoYXIJ
ICAgICBsYXN0X2xzcjsgICAgICAvKiBMaW5lIFN0YXR1cyBSZWdpc3RlciAq
LwogCXVuc2lnbmVkIGNoYXIJICAgICBsYXN0X21zcjsgICAgICAvKiBNb2Rl
bSBTdGF0dXMgUmVnaXN0ZXIgKi8KIAl1bnNpZ25lZCBpbnQJICAgICByeF9m
bGFnczsgICAgICAvKiBUaHJvdHRsaW5nIGZsYWdzICovCisJc3RydWN0IGFz
eW5jX2ljb3VudCAgaWNvdW50OworCXdhaXRfcXVldWVfaGVhZF90ICAgIG1z
cl93YWl0OwkvKiBmb3IgaGFuZGxpbmcgc2xlZXBpbmcgd2hpbGUgd2FpdGlu
ZworCQkJCQkJZm9yIG1zciBjaGFuZ2UgdG8gaGFwcGVuICovCiB9OwogCiAj
ZGVmaW5lIFRIUk9UVExFRAkJMHgwMQpAQCAtMzg2LDI3ICszOTYsNDEgQEAg
c3RhdGljIGludCBtY3RfdTIzMl9nZXRfbW9kZW1fc3RhdChzdHJ1YwogCXJl
dHVybiByYzsKIH0gLyogbWN0X3UyMzJfZ2V0X21vZGVtX3N0YXQgKi8KIAot
c3RhdGljIHZvaWQgbWN0X3UyMzJfbXNyX3RvX3N0YXRlKHVuc2lnbmVkIGlu
dCAqY29udHJvbF9zdGF0ZSwKLQkJCQkJCXVuc2lnbmVkIGNoYXIgbXNyKQor
c3RhdGljIHZvaWQgbWN0X3UyMzJfbXNyX3RvX3N0YXRlKHN0cnVjdCBtY3Rf
dTIzMl9wcml2YXRlICpwcml2KQogeworCXVuc2lnbmVkIGNoYXIgbXNyID0g
cHJpdi0+bGFzdF9tc3I7CisJdW5zaWduZWQgaW50ICpjb250cm9sX3N0YXRl
ID0gJnByaXYtPmNvbnRyb2xfc3RhdGU7CisJc3RydWN0IGFzeW5jX2ljb3Vu
dCAqaWNvdW50ID0gJnByaXYtPmljb3VudDsKKwogCS8qIFRyYW5zbGF0ZSBD
b250cm9sIExpbmUgc3RhdGVzICovCi0JaWYgKG1zciAmIE1DVF9VMjMyX01T
Ul9EU1IpCisJaWYgKG1zciAmIE1DVF9VMjMyX01TUl9EU1IpIHsKIAkJKmNv
bnRyb2xfc3RhdGUgfD0gIFRJT0NNX0RTUjsKLQllbHNlCisJCWljb3VudC0+
ZHNyKys7CisJfSBlbHNlIHsKIAkJKmNvbnRyb2xfc3RhdGUgJj0gflRJT0NN
X0RTUjsKLQlpZiAobXNyICYgTUNUX1UyMzJfTVNSX0NUUykKKwl9CisJaWYg
KG1zciAmIE1DVF9VMjMyX01TUl9DVFMpIHsKIAkJKmNvbnRyb2xfc3RhdGUg
fD0gIFRJT0NNX0NUUzsKLQllbHNlCisJCWljb3VudC0+Y3RzKys7CisJfSBl
bHNlIHsKIAkJKmNvbnRyb2xfc3RhdGUgJj0gflRJT0NNX0NUUzsKLQlpZiAo
bXNyICYgTUNUX1UyMzJfTVNSX1JJKQorCX0KKwlpZiAobXNyICYgTUNUX1Uy
MzJfTVNSX1JJKSB7CiAJCSpjb250cm9sX3N0YXRlIHw9ICBUSU9DTV9SSTsK
LQllbHNlCisJCWljb3VudC0+cm5nKys7CisJfSBlbHNlIHsKIAkJKmNvbnRy
b2xfc3RhdGUgJj0gflRJT0NNX1JJOwotCWlmIChtc3IgJiBNQ1RfVTIzMl9N
U1JfQ0QpCisJfQorCWlmIChtc3IgJiBNQ1RfVTIzMl9NU1JfQ0QpIHsKIAkJ
KmNvbnRyb2xfc3RhdGUgfD0gIFRJT0NNX0NEOwotCWVsc2UKKwkJaWNvdW50
LT5kY2QrKzsKKwl9IGVsc2UgewogCQkqY29udHJvbF9zdGF0ZSAmPSB+VElP
Q01fQ0Q7CisJfQorCiAJZGJnKCJtc3JfdG9fc3RhdGU6IG1zcj0weCV4ID09
PiBzdGF0ZT0weCV4IiwgbXNyLCAqY29udHJvbF9zdGF0ZSk7CisKKwl3YWtl
X3VwX2ludGVycnVwdGlibGUoJnByaXYtPm1zcl93YWl0KTsKIH0gLyogbWN0
X3UyMzJfbXNyX3RvX3N0YXRlICovCiAKIC8qCkBAIC00MjIsNiArNDQ2LDcg
QEAgc3RhdGljIGludCBtY3RfdTIzMl9zdGFydHVwKHN0cnVjdCB1c2Jfcwog
CWlmICghcHJpdikKIAkJcmV0dXJuIC1FTk9NRU07CiAJc3Bpbl9sb2NrX2lu
aXQoJnByaXYtPmxvY2spOworCWluaXRfd2FpdHF1ZXVlX2hlYWQoJnByaXYt
Pm1zcl93YWl0KTsKIAl1c2Jfc2V0X3NlcmlhbF9wb3J0X2RhdGEoc2VyaWFs
LT5wb3J0WzBdLCBwcml2KTsKIAogCWluaXRfd2FpdHF1ZXVlX2hlYWQoJnNl
cmlhbC0+cG9ydFswXS0+d3JpdGVfd2FpdCk7CkBAIC00OTgsNyArNTIzLDcg
QEAgc3RhdGljIGludCAgbWN0X3UyMzJfb3BlbihzdHJ1Y3QgdHR5X3N0cgog
CW1jdF91MjMyX2dldF9tb2RlbV9zdGF0KHNlcmlhbCwgJmxhc3RfbXNyKTsK
IAlzcGluX2xvY2tfaXJxc2F2ZSgmcHJpdi0+bG9jaywgZmxhZ3MpOwogCXBy
aXYtPmxhc3RfbXNyID0gbGFzdF9tc3I7Ci0JbWN0X3UyMzJfbXNyX3RvX3N0
YXRlKCZwcml2LT5jb250cm9sX3N0YXRlLCBwcml2LT5sYXN0X21zcik7CisJ
bWN0X3UyMzJfbXNyX3RvX3N0YXRlKHByaXYpOwogCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJnByaXYtPmxvY2ssIGZsYWdzKTsKIAogCXBvcnQtPnJlYWRf
dXJiLT5kZXYgPSBwb3J0LT5zZXJpYWwtPmRldjsKQEAgLTYxOSw3ICs2NDQs
NyBAQCBzdGF0aWMgdm9pZCBtY3RfdTIzMl9yZWFkX2ludF9jYWxsYmFjayhz
CiAJcHJpdi0+bGFzdF9tc3IgPSBkYXRhW01DVF9VMjMyX01TUl9JTkRFWF07
CiAKIAkvKiBSZWNvcmQgQ29udHJvbCBMaW5lIHN0YXRlcyAqLwotCW1jdF91
MjMyX21zcl90b19zdGF0ZSgmcHJpdi0+Y29udHJvbF9zdGF0ZSwgcHJpdi0+
bGFzdF9tc3IpOworCW1jdF91MjMyX21zcl90b19zdGF0ZShwcml2KTsKIAog
I2lmIDAKIAkvKiBOb3QgeWV0IGhhbmRsZWQuIFNlZSBiZWxraW5fc2EuYyBm
b3IgZnVydGhlciBpbmZvcm1hdGlvbiAqLwpAQCAtODI2LDcgKzg1MSw2IEBA
IHN0YXRpYyB2b2lkIG1jdF91MjMyX3Rocm90dGxlKHN0cnVjdCB0dHkKIAl9
CiB9CiAKLQogc3RhdGljIHZvaWQgbWN0X3UyMzJfdW50aHJvdHRsZShzdHJ1
Y3QgdHR5X3N0cnVjdCAqdHR5KQogewogCXN0cnVjdCB1c2Jfc2VyaWFsX3Bv
cnQgKnBvcnQgPSB0dHktPmRyaXZlcl9kYXRhOwpAQCAtODQ3LDYgKzg3MSw4
MiBAQCBzdGF0aWMgdm9pZCBtY3RfdTIzMl91bnRocm90dGxlKHN0cnVjdCB0
CiAJfQogfQogCitzdGF0aWMgaW50ICBtY3RfdTIzMl9pb2N0bChzdHJ1Y3Qg
dHR5X3N0cnVjdCAqdHR5LCBzdHJ1Y3QgZmlsZSAqZmlsZSwKKwkJCXVuc2ln
bmVkIGludCBjbWQsIHVuc2lnbmVkIGxvbmcgYXJnKQoreworCURFRklORV9X
QUlUKHdhaXQpOworCXN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQgKnBvcnQgPSB0
dHktPmRyaXZlcl9kYXRhOworCXN0cnVjdCBtY3RfdTIzMl9wcml2YXRlICpt
Y3RfdTIzMl9wb3J0ID0gdXNiX2dldF9zZXJpYWxfcG9ydF9kYXRhKHBvcnQp
OworCXN0cnVjdCBhc3luY19pY291bnQgY25vdywgY3ByZXY7CisJdW5zaWdu
ZWQgbG9uZyBmbGFnczsKKworCWRiZygiJXMgLSBwb3J0ICVkLCBjbWQgPSAw
eCV4IiwgX19mdW5jX18sIHBvcnQtPm51bWJlciwgY21kKTsKKworCXN3aXRj
aCAoY21kKSB7CisKKwljYXNlIFRJT0NNSVdBSVQ6CisKKwkJZGJnKCIlcyAo
JWQpIFRJT0NNSVdBSVQiLCBfX2Z1bmNfXywgIHBvcnQtPm51bWJlcik7CisK
KwkJc3Bpbl9sb2NrX2lycXNhdmUoJm1jdF91MjMyX3BvcnQtPmxvY2ssIGZs
YWdzKTsKKwkJY3ByZXYgPSBtY3RfdTIzMl9wb3J0LT5pY291bnQ7CisJCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJm1jdF91MjMyX3BvcnQtPmxvY2ssIGZs
YWdzKTsKKwkJZm9yICggOyA7ICkgeworCQkJcHJlcGFyZV90b193YWl0KCZt
Y3RfdTIzMl9wb3J0LT5tc3Jfd2FpdCwKKwkJCQkJJndhaXQsIFRBU0tfSU5U
RVJSVVBUSUJMRSk7CisJCQlzY2hlZHVsZSgpOworCQkJZmluaXNoX3dhaXQo
Jm1jdF91MjMyX3BvcnQtPm1zcl93YWl0LCAmd2FpdCk7CisJCQkvKiBzZWUg
aWYgYSBzaWduYWwgZGlkIGl0ICovCisJCQlpZiAoc2lnbmFsX3BlbmRpbmco
Y3VycmVudCkpCisJCQkJcmV0dXJuIC1FUkVTVEFSVFNZUzsKKwkJCXNwaW5f
bG9ja19pcnFzYXZlKCZtY3RfdTIzMl9wb3J0LT5sb2NrLCBmbGFncyk7CisJ
CQljbm93ID0gbWN0X3UyMzJfcG9ydC0+aWNvdW50OworCQkJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmbWN0X3UyMzJfcG9ydC0+bG9jaywgZmxhZ3MpOwor
CQkJaWYgKGNub3cucm5nID09IGNwcmV2LnJuZyAmJiBjbm93LmRzciA9PSBj
cHJldi5kc3IgJiYKKwkJCSAgICBjbm93LmRjZCA9PSBjcHJldi5kY2QgJiYg
Y25vdy5jdHMgPT0gY3ByZXYuY3RzKQorCQkJCXJldHVybiAtRUlPOyAvKiBu
byBjaGFuZ2UgPT4gZXJyb3IgKi8KKwkJCWlmICgoKGFyZyAmIFRJT0NNX1JO
RykgJiYgKGNub3cucm5nICE9IGNwcmV2LnJuZykpIHx8CisJCQkgICAgKChh
cmcgJiBUSU9DTV9EU1IpICYmIChjbm93LmRzciAhPSBjcHJldi5kc3IpKSB8
fAorCQkJICAgICgoYXJnICYgVElPQ01fQ0QpICAmJiAoY25vdy5kY2QgIT0g
Y3ByZXYuZGNkKSkgfHwKKwkJCSAgICAoKGFyZyAmIFRJT0NNX0NUUykgJiYg
KGNub3cuY3RzICE9IGNwcmV2LmN0cykpKSB7CisJCQkJcmV0dXJuIDA7CisJ
CQl9CisJCQljcHJldiA9IGNub3c7CisJCX0KKworCX0KKwlyZXR1cm4gLUVO
T0lPQ1RMQ01EOworfQorCitzdGF0aWMgaW50ICBtY3RfdTIzMl9nZXRfaWNv
dW50KHN0cnVjdCB0dHlfc3RydWN0ICp0dHksCisJCQlzdHJ1Y3Qgc2VyaWFs
X2ljb3VudGVyX3N0cnVjdCAqaWNvdW50KQoreworCXN0cnVjdCB1c2Jfc2Vy
aWFsX3BvcnQgKnBvcnQgPSB0dHktPmRyaXZlcl9kYXRhOworCXN0cnVjdCBt
Y3RfdTIzMl9wcml2YXRlICptY3RfdTIzMl9wb3J0ID0gdXNiX2dldF9zZXJp
YWxfcG9ydF9kYXRhKHBvcnQpOworCXN0cnVjdCBhc3luY19pY291bnQgKmlj
ID0gJm1jdF91MjMyX3BvcnQtPmljb3VudDsKKwl1bnNpZ25lZCBsb25nIGZs
YWdzOworCisJc3Bpbl9sb2NrX2lycXNhdmUoJm1jdF91MjMyX3BvcnQtPmxv
Y2ssIGZsYWdzKTsKKworCWljb3VudC0+Y3RzID0gaWMtPmN0czsKKwlpY291
bnQtPmRzciA9IGljLT5kc3I7CisJaWNvdW50LT5ybmcgPSBpYy0+cm5nOwor
CWljb3VudC0+ZGNkID0gaWMtPmRjZDsKKwlpY291bnQtPnJ4ID0gaWMtPnJ4
OworCWljb3VudC0+dHggPSBpYy0+dHg7CisJaWNvdW50LT5mcmFtZSA9IGlj
LT5mcmFtZTsKKwlpY291bnQtPm92ZXJydW4gPSBpYy0+b3ZlcnJ1bjsKKwlp
Y291bnQtPnBhcml0eSA9IGljLT5wYXJpdHk7CisJaWNvdW50LT5icmsgPSBp
Yy0+YnJrOworCWljb3VudC0+YnVmX292ZXJydW4gPSBpYy0+YnVmX292ZXJy
dW47CisKKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZtY3RfdTIzMl9wb3J0
LT5sb2NrLCBmbGFncyk7CisKKwlkYmcoIiVzICglZCkgVElPQ0dJQ09VTlQg
Ulg9JWQsIFRYPSVkIiwKKwkJX19mdW5jX18sICBwb3J0LT5udW1iZXIsIGlj
b3VudC0+cngsIGljb3VudC0+dHgpOworCXJldHVybiAwOworfQorCiBzdGF0
aWMgaW50IF9faW5pdCBtY3RfdTIzMl9pbml0KHZvaWQpCiB7CiAJaW50IHJl
dHZhbDsK

--0-75916433-1293431663=:5514--
