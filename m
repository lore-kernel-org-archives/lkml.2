Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0FZPq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 11:46:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54230 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab0FZPqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 11:46:25 -0400
Message-ID: <4C2620F4.7030900@colorfullife.com>
Date: Sat, 26 Jun 2010 17:47:00 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com
Subject: 2.6.35-rc3: System unresponsive under load
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <20100621200118.GA4021@nb-core2.darkstar.lan> <4C223657.3030507@colorfullife.com> <AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com> <AANLkTinw8qzAkHTNB05PqfWMQmuya1Dq6AZCgz2nWx6_@mail.gmail.com> <4C251AFF.70803@colorfullife.com> <AANLkTilm19O8nPGHSzExdCOPWR2Cridxq_sjs_uRkd8E@mail.gmail.com>
In-Reply-To: <AANLkTilm19O8nPGHSzExdCOPWR2Cridxq_sjs_uRkd8E@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040804050201030900030803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040804050201030900030803
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Luca,

On 06/26/2010 02:52 PM, Luca Tettamanti wrote:
> They don't seem really hung as before, I see two different behaviours:
> * Near the end of the run ab is frozen for a few seconds, but in the
> end all requests are processed; however I see a few "length" errors,
> meaning that the received page does not match the expected content
> (I'm testing a static page):
>
>    
That's consistent with what I see:
If I run:
#./semtimedop 100 100&
#./semtimedop 100 100&
#./semtimedop 100 100&
#./semtimedop 100 100&

(i.e.: 4 times the attached test app concurrently), then the system 
sometimes locks up for 10..20 seconds:
The keyboard is unresponsive, not even the numlock key is processed 
(i.e.: the LED does not change anymore).
After 10 or 20 seconds, the keyboard reacts again (both to <enter> and 
to Num Lock)
The stock Fedora 13 kernel (2.6.33.5) does not exhibit this behavior
The load average is 300 or so, that's expected.

I have no idea why and how to debug the behavior.
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
> strace on apache shows:
> [pid  3787] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3789] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3788] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3784] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3783] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3782] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3239] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3233] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3238] restart_syscall(<... resuming interrupted call ...>  <unfinished ...>
> [pid  3237] restart_syscall(<... resuming interrupted call ...>
>    

That can't be semop:
sysv ipc and msg are among the (broken) parts of the kernel that do not 
honor SA_RESTART.

--
     Manfred



--------------040804050201030900030803
Content-Type: text/plain;
 name="semtimedop.cpp"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="semtimedop.cpp"

LyoKICogc2Vtc2NhbGUuY3BwIC0gc3lzdiBzY2FsaW5nIHRlc3QKICoKICogQ29weXJpZ2h0
IChDKSAxOTk5LCAyMDAxLCAyMDA1LCAyMDA4LCAyMDEwIGJ5IE1hbmZyZWQgU3ByYXVsLgog
KglBbGwgcmlnaHRzIHJlc2VydmVkIGV4Y2VwdCB0aGUgcmlnaHRzIGdyYW50ZWQgYnkgdGhl
IEdQTC4KICoKICogUmVkaXN0cmlidXRpb24gb2YgdGhpcyBmaWxlIGlzIHBlcm1pdHRlZCB1
bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSAKICogR2VuZXJhbCBQdWJsaWMgTGljZW5zZSAo
R1BMKSB2ZXJzaW9uIDIgb3IgbGF0ZXIuCiAqICRIZWFkZXIkCiAqLwoKI2luY2x1ZGUgPHN0
ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVk
ZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxnZXRvcHQuaD4KI2luY2x1ZGUgPGVycm5vLmg+CiNp
bmNsdWRlIDxzeXMvdHlwZXMuaD4KI2luY2x1ZGUgPHN5cy9pcGMuaD4KI2luY2x1ZGUgPHN5
cy9zZW0uaD4KI2luY2x1ZGUgPHB0aHJlYWQuaD4KCiNpZmRlZiBfX3N1bgoJICNpbmNsdWRl
IDxzeXMvcHNldC5oPiAvKiBQX1BJRCwgcHJvY2Vzc29yX2JpbmQoKSAqLwojZW5kaWYKCiNk
ZWZpbmUgREVMQVlfMU1TCSgxMDAwKQoKc3RhdGljIGVudW0gewoJV0FJVElORywKCVJVTk5J
TkcsCglTVE9QUEVELAp9IHZvbGF0aWxlIGdfc3RhdGUgPSBXQUlUSU5HOwoKaW50IGdfc3Zz
ZW1faWQ7CnB0aHJlYWRfdCAqZ190aHJlYWRzOwoKdm9pZCogd29ya2VyX3RocmVhZCh2b2lk
ICphcmcpCnsKCXVuc2lnbmVkIGxvbmcgbG9uZyByb3VuZHM7CglpbnQgcmV0OwoKCXJvdW5k
cyA9IDA7Cgl3aGlsZShnX3N0YXRlID09IFdBSVRJTkcpIHsKI2lmZGVmIF9fR05VQ19fCiNp
ZiBkZWZpbmVkKF9faTM4Nl9fKSB8fCBkZWZpbmVkIChfX3g4Nl82NF9fKQoJCV9fYXNtX18g
X192b2xhdGlsZV9fKCJwYXVzZSI6IDogOiJtZW1vcnkiKTsKI2Vsc2UKCQlfX2FzbV9fIF9f
dm9sYXRpbGVfXygiIjogOiA6Im1lbW9yeSIpOwojZW5kaWYKI2VuZGlmCgl9CgoJd2hpbGUo
Z19zdGF0ZSA9PSBSVU5OSU5HKSB7CgkJc3RydWN0IHNlbWJ1ZiBzb3BbMV07CgkJc3RydWN0
IHRpbWVzcGVjIHQ7CgoJCS8qIDEpIGNoZWNrIGlmIHRoZSBzZW1hcGhvcmUgdmFsdWUgaXMg
MCAqLwoJCXNvcFswXS5zZW1fbnVtPTA7CgkJc29wWzBdLnNlbV9vcD0wOwoJCXNvcFswXS5z
ZW1fZmxnPTA7CgkJdC50dl9zZWMgPSAwOwoJCXQudHZfbnNlYyA9IDEqMTAwMCoxMDAwOwoJ
CXJldCA9IHNlbXRpbWVkb3AoZ19zdnNlbV9pZCxzb3AsMSwgJnQpOwoJCWlmIChyZXQgPT0g
MCkKCQkJY29udGludWU7CgkJaWYgKHJldCA9PSAtMSAmJiBlcnJubyA9PSBFQUdBSU4pCgkJ
CWNvbnRpbnVlOwoJCWlmIChyZXQgPT0gLTEgJiYgZXJybm8gPT0gRUlEUk0pCgkJCWJyZWFr
OwoJCXByaW50ZigibWFpbiBzZW1vcCBmYWlsZWQsIHJldCAlZCBlcnJubyAlZC5cbiIsIHJl
dCwgZXJybm8pOwoJCWZmbHVzaChzdGRvdXQpOwoJCWV4aXQoMSk7Cgl9CgoJcHRocmVhZF9l
eGl0KDApOwoJcmV0dXJuIE5VTEw7Cn0KCnZvaWQgaW5pdF90aHJlYWQoaW50IGkpCnsKCWlu
dCByZXQ7CgoJcmV0ID0gcHRocmVhZF9jcmVhdGUoJmdfdGhyZWFkc1tpXSwgTlVMTCwgd29y
a2VyX3RocmVhZCwgTlVMTCk7CglpZiAocmV0KSB7CgkJcHJpbnRmKCIgcHRocmVhZF9jcmVh
dGUgZmFpbGVkIHdpdGggZXJyb3IgY29kZSAlZFxuIiwgcmV0KTsKCQlleGl0KDEpOwoJfQp9
CgovLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8v
Ly8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8KCnN0YXRpYyB2b2lkIGRvX3BzZW0oaW50IHRo
cmVhZHMsIGludCBzZWNzKQp7CglpbnQgcmVzOwoJaW50IGk7CglnX3N0YXRlID0gV0FJVElO
RzsKCglnX3RocmVhZHMgPSAocHRocmVhZF90KiltYWxsb2Moc2l6ZW9mKHB0aHJlYWRfdCkq
dGhyZWFkcyk7CgoJZ19zdnNlbV9pZCA9IHNlbWdldChJUENfUFJJVkFURSx0aHJlYWRzLDA3
Nzd8SVBDX0NSRUFUKTsKCWlmKGdfc3ZzZW1faWQgPT0gLTEpIHsKCQlwcmludGYoInNlbSBh
cnJheSBjcmVhdGUgZmFpbGVkLlxuIik7CgkJZXhpdCgxKTsKCX0KCglmb3IgKGk9MDtpPHRo
cmVhZHM7aSsrKQoJCWluaXRfdGhyZWFkKGkpOwoKCXVzbGVlcChERUxBWV8xTVMpOwoJZ19z
dGF0ZSA9IFJVTk5JTkc7Cglmb3IgKGk9MDtpPHNlY3MqNTAwO2krKykgewoJCXN0cnVjdCBz
ZW1idWYgc29wWzFdOwoKCQlzb3BbMF0uc2VtX251bT0wOwoJCXNvcFswXS5zZW1fb3A9MTsK
CQlzb3BbMF0uc2VtX2ZsZz0wOwoKCQlyZXMgPSBzZW1vcChnX3N2c2VtX2lkLHNvcCwxKTsK
CQlpZihyZXMhPTApIHsKCQkJcHJpbnRmKCJjb250cm9sIHNlbW9wKCwxLCkgZmFpbGVkLCBy
ZXQgJWQgZXJybm8gJWQuXG4iLCByZXMsIGVycm5vKTsKCQkJZXhpdCgyKTsKCQl9CgkJdXNs
ZWVwKDIqREVMQVlfMU1TKTsKCgkJc29wWzBdLnNlbV9udW09MDsKCQlzb3BbMF0uc2VtX29w
PS0xOwoJCXNvcFswXS5zZW1fZmxnPTA7CgoJCXJlcyA9IHNlbW9wKGdfc3ZzZW1faWQsc29w
LDEpOwoJCWlmKHJlcyE9MCkgewoJCQlwcmludGYoImNvbnRyb2wgc2Vtb3AoLC0xLCkgZmFp
bGVkLCByZXQgJWQgZXJybm8gJWQuXG4iLCByZXMsIGVycm5vKTsKCQkJZXhpdCgyKTsKCQl9
Cgl9CglnX3N0YXRlID0gU1RPUFBFRDsKCXVzbGVlcChERUxBWV8xTVMpOwoKCXJlcyA9IHNl
bWN0bChnX3N2c2VtX2lkLDEsSVBDX1JNSUQsTlVMTCk7CglpZiAocmVzIDwgMCkgewoJCXBy
aW50Zigic2VtY3RsKElQQ19STUlEKSBmYWlsZWQgZm9yICVkLCBlcnJubyVkLlxuIiwKCQkJ
Z19zdnNlbV9pZCwgZXJybm8pOwoJfQoKCWZvciAoaT0wO2k8dGhyZWFkcztpKyspCgkJcHRo
cmVhZF9qb2luKGdfdGhyZWFkc1tpXSwgTlVMTCk7CgoJZnJlZShnX3RocmVhZHMpOwp9Cgov
Ly8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8vLy8v
Ly8vLy8vLy8vLy8vLy8vLy8vLy8vLy8KCmludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJn
dikKewoJaW50IHRpbWVvdXQsIHRocmVhZHM7CgoJcHJpbnRmKCJzZW10aW1lZG9wIFt0aW1l
b3V0XSBbdGhyZWFkc11cbiIpOwoKCWlmIChhcmdjICE9IDMpIHsKCQlwcmludGYoIiBJbnZh
bGlkIHBhcmFtZXRlcnMuXG4iKTsKCQlyZXR1cm4gMDsKCX0KCXRpbWVvdXQgPSBhdG9pKGFy
Z3ZbMV0pOwoJdGhyZWFkcyA9IGF0b2koYXJndlsyXSk7CgoJcHJpbnRmKCJSdW5uaW5nICVk
IHRocmVhZHMgZm9yICVkIHNlY29uZHMuLi5cbiIsIHRocmVhZHMsIHRpbWVvdXQpOwoJZG9f
cHNlbSh0aHJlYWRzLCB0aW1lb3V0KTsKfQo=
--------------040804050201030900030803--
