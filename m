Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab1EXWGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:06:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51061 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab1EXWGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:06:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=GhI15EaJe3S80ntp7ajNES1ok5FubiILbsI2pi48bE4wSO5DiXPlHf+wdXNG/egEWo
         P6JCZUxDWb3tvlG4BXMx7odc316Pj+4zKGxehqA4ohPGxBZ8Hhe/IYjvuMRJO+u5fXHz
         PoXx8EKBHXHPFTOjiLtFRhIe5ttXvpBd35uwc=
MIME-Version: 1.0
In-Reply-To: <20110521103315.GA23651@elte.hu>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
 <1305968203-14240-3-git-send-email-jim.cromie@gmail.com> <20110521103315.GA23651@elte.hu>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 24 May 2011 16:05:53 -0600
Message-ID: <BANLkTikSMR7AyJi-LEr8iA2x9TxobJr9gA@mail.gmail.com>
Subject: Re: [PATCH 2/2] dont commify big numbers by default, let -B do it
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net
Content-Type: multipart/mixed; boundary=000e0cd3077c6ce43204a40cccd7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd3077c6ce43204a40cccd7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, May 21, 2011 at 4:33 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jim Cromie <jim.cromie@gmail.com> wrote:
>
>> Currently, big numbers get commas by default, which complicates parsing
>> by automation. [...]
>
> Well, automation can turn it off via --no-big-num, right?

ah.  my man-page is a bit behind
(but is in usage, and in Doc/perf-stat.txt)

> Also, i think for automation we'd also like to have a 'simple output' mod=
e,
> would you like to add that?

OK, heres 1st cut at it, adding option --simple, for review / feedback

Its based upon the csv-output code mostly, with some vestiges of verbose..

I altered csv-output to have event-name 1st
this seems what folks would expect normally,
I surmised that existing was a short-cut..
Then added "noise"

part of reason for sending early is this column swap,
it might annoy existing users.

[jimc@groucho perf]$ ./perf stat -r3 -x' ' true
task-clock-msecs1.009533  0.142%
context-switches 0 -nan%
CPU-migrations 0 100.000%
page-faults 85 0.000%
cycles 789434 0.107%
instructions 488768 0.546%
branches 102796 0.505%
branch-misses 8472 1.688%
cache-references 0 -nan%  (scaled from 0.00%)
cache-misses 0 -nan%  (scaled from 0.00%)

[jimc@groucho perf]$ ./perf stat -r3 -x' ------- ' true
task-clock-msecs1.036450 -------  ------- 3.519%
context-switches ------- 0 ------- -nan%
CPU-migrations ------- 0 ------- -nan%
page-faults ------- 85 ------- 0.000%
cycles ------- 812151 ------- 3.463%
instructions ------- 499263 ------- 0.368%
branches ------- 104240 ------- 0.224%
branch-misses ------- 8125 ------- 4.627%
cache-references ------- 0 ------- -nan%  (scaled from 0.00%)
cache-misses ------- 0 ------- -nan%  (scaled from 0.00%)

I also need to do something better with -no-aggr format,
doesnt do right with extra column

[jimc@groucho perf]$ sudo ./perf stat -r3 -x' ------- ' -A -a true
CPU0 ------- task-clock-msecs2.099862 -------
CPU1 ------- task-clock-msecs2.084522 -------
CPU2 ------- task-clock-msecs2.072948 -------
CPU3 ------- task-clock-msecs2.071611 -------
CPU0 ------- context-switches ------- 2
CPU1 ------- context-switches ------- 0
CPU2 ------- context-switches ------- 3
CPU3 ------- context-switches ------- 6
CPU0 ------- CPU-migrations ------- 2
...




> Something a bit like what you can see in 'perf stat -v true':
> Without the human output later on, and with elapsed time added as well.

for my part, Id like the moral equivalent of time(s)? output too,
though I suspect thats a separate patch..

[jimc@groucho perf]$ time ./perf stat -x'  ' -- sh -c 'sleep 3'
task-clock-msecs6.830999
context-switches  2
CPU-migrations  1
page-faults  477
cycles  5404163  (scaled from 72.07%)
instructions  3302699
branches  804750
branch-misses  51870
cache-references  1584532  (scaled from 45.93%)
cache-misses  36616  (scaled from 31.36%)

real	0m3.019s
user	0m0.005s
sys	0m0.012s

are these timings already taken by perf-stat ?
is it a simple matter of addition and printing ?
If not, whats involved ?

Also, task-clock-msec doesnt quite match up with times' user number
Whats going on here ?


> Thanks,
>
> =A0 =A0 =A0 =A0Ingo
>

thank you
~jimc

PS: attaching now (in gmail web iface),
will try to thread up to this, RSN, with git send-email

--000e0cd3077c6ce43204a40cccd7
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-add-simple-output-mode-to-perf-stat-based-upon-csv-o.patch"
Content-Disposition: attachment; 
	filename="0001-add-simple-output-mode-to-perf-stat-based-upon-csv-o.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go3e82qb0

RnJvbSA2Y2QxNjY3YWU1MjI3MzdkNTc3ZDNmNjczMTRjNjk1MmJjM2E1ZTRmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKaW0gQ3JvbWllIDxqaW0uY3JvbWllQGdtYWlsLmNvbT4KRGF0
ZTogVHVlLCAyNCBNYXkgMjAxMSAxNTo1NjozOSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIGFkZCAt
LXNpbXBsZSBvdXRwdXQgbW9kZSB0byBwZXJmLXN0YXQsIGJhc2VkIHVwb24gY3N2LW91dHB1dAoK
cHJvZHVjZXMgb3V0cHV0IGxpa2UgdGhpcyAoV0lQKToKCnBlcmZdJCAuL3BlcmYgc3RhdCAteCcg
ICcgLXIzIC0tIHNoIC1jICdzbGVlcCAzJwp0YXNrLWNsb2NrLW1zZWNzNi44OTY1OTQgICAgMS4x
MDUlCmNvbnRleHQtc3dpdGNoZXMgIDMgIDAuMDAwJQpDUFUtbWlncmF0aW9ucyAgMCAgLW5hbiUK
cGFnZS1mYXVsdHMgIDQ3NyAgMC4wMDAlCmN5Y2xlcyAgNTU0MDQ4MyAgMS4wMDIlICAoc2NhbGVk
IGZyb20gNjkuOTIlKQppbnN0cnVjdGlvbnMgIDM4ODE3OTQgIDcuNzc5JSAgKHNjYWxlZCBmcm9t
IDgzLjcwJSkKYnJhbmNoZXMgIDkzMjQzNSAgMy4zNDMlICAoc2NhbGVkIGZyb20gODIuMjElKQpi
cmFuY2gtbWlzc2VzICA0MzgzMCAgMTEuOTk5JQpjYWNoZS1yZWZlcmVuY2VzICAxNTgyOTMxICAz
LjcxOCUgIChzY2FsZWQgZnJvbSA1Mi43MiUpCmNhY2hlLW1pc3NlcyAgMzcxOTkgIDEwLjE1NCUg
IChzY2FsZWQgZnJvbSAzNy42NSUpCgpJdHMgYmFzZWQgdXBvbiBjc3Ytb3V0cHV0LCBhbmQgcHJp
bnRzIGV2ZW50LW5hbWUgaW4gMXN0IGNvbHVtbiwgaW4KY29udHJhc3QgdG8gcHJldmlvdXMgZm9y
bWF0LiAgVGhpcyBtYXkgYmUgcHJvYmxlbWF0aWMgZm9yIHNvbWUKZXhpc3RpbmcgdXNlcnMsIGJ1
dCBpcyBtb3JlICJub3JtYWwiIGFuZCB0aGVyZWZvcmUgYmV0dGVyLgoKV2hldGhlciAnJScgc3lt
Ym9scyBvciBzY2FsaW5ncyBzaG91bGQgYmUgcHJpbnRlZCBpcyBUQkQuCkFsc28sIC1BIC1hIG91
dHB1dCBuZWVkcyB3b3JrLgoKU2lnbmVkLW9mZi1ieTogSmltIENyb21pZSA8amltLmNyb21pZUBn
bWFpbC5jb20+Ci0tLQogdG9vbHMvcGVyZi9idWlsdGluLXN0YXQuYyB8ICAgNDQgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgMzIg
aW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvdG9vbHMvcGVyZi9i
dWlsdGluLXN0YXQuYyBiL3Rvb2xzL3BlcmYvYnVpbHRpbi1zdGF0LmMKaW5kZXggM2E3MDNlNC4u
MTcxMTUzNSAxMDA2NDQKLS0tIGEvdG9vbHMvcGVyZi9idWlsdGluLXN0YXQuYworKysgYi90b29s
cy9wZXJmL2J1aWx0aW4tc3RhdC5jCkBAIC05MSw2ICs5MSw3IEBAIHN0YXRpYyBpbnQJCQliaWdf
bnVtX29wdAkJCT0gIC0xOwogc3RhdGljIGNvbnN0IGNoYXIJCSpjcHVfbGlzdDsKIHN0YXRpYyBj
b25zdCBjaGFyCQkqY3N2X3NlcAkJCT0gTlVMTDsKIHN0YXRpYyBib29sCQkJY3N2X291dHB1dAkJ
CT0gZmFsc2U7CitzdGF0aWMgYm9vbAkJCXNpbXBsZQkJCQk9IGZhbHNlOwogCiBzdGF0aWMgaW50
IGxvZ2ZkID0gMjsJLyogc3RkZXJyIGJ5IGRlZmF1bHQsIG92ZXJyaWRlIHdpdGggLWwgKi8KIHN0
YXRpYyBGSUxFICpsb2dmcDsJLyogPSBmZG9wZW4obG9nZmQsInciKSAqLwpAQCAtMjEyLDcgKzIx
Myw3IEBAIHN0YXRpYyBpbnQgcmVhZF9jb3VudGVyX2FnZ3Ioc3RydWN0IHBlcmZfZXZzZWwgKmNv
dW50ZXIpCiAJZm9yIChpID0gMDsgaSA8IDM7IGkrKykKIAkJdXBkYXRlX3N0YXRzKCZwcy0+cmVz
X3N0YXRzW2ldLCBjb3VudFtpXSk7CiAKLQlpZiAodmVyYm9zZSkgeworCWlmICh2ZXJib3NlIHx8
IHNpbXBsZSkgewogCQlmcHJpbnRmKGxvZ2ZwLCAiJXM6ICUiIFBSSXU2NCAiICUiIFBSSXU2NCAi
ICUiIFBSSXU2NCAiXG4iLAogCQkJZXZlbnRfbmFtZShjb3VudGVyKSwgY291bnRbMF0sIGNvdW50
WzFdLCBjb3VudFsyXSk7CiAJfQpAQCAtMzgzLDIyICszODQsMzEgQEAgc3RhdGljIHZvaWQgcHJp
bnRfbm9pc2Uoc3RydWN0IHBlcmZfZXZzZWwgKmV2c2VsLCBkb3VibGUgYXZnKQogCQlyZXR1cm47
CiAKIAlwcyA9IGV2c2VsLT5wcml2OwotCWZwcmludGYobG9nZnAsICIgICAoICstICU3LjNmJSUg
KSIsCi0JCQkxMDAgKiBzdGRkZXZfc3RhdHMoJnBzLT5yZXNfc3RhdHNbMF0pIC8gYXZnKTsKKwlp
ZiAoIWNzdl9vdXRwdXQpCisJCWZwcmludGYobG9nZnAsICIgICAoICstICU3LjNmJSUgKSIsCisJ
CQkJMTAwICogc3RkZGV2X3N0YXRzKCZwcy0+cmVzX3N0YXRzWzBdKSAvIGF2Zyk7CisJZWxzZQor
CSAgZnByaW50Zihsb2dmcCwgIiVzJS4zZiUlIiwKKwkJICBjc3Zfc2VwLCAxMDAgKiBzdGRkZXZf
c3RhdHMoJnBzLT5yZXNfc3RhdHNbMF0pIC8gYXZnKTsKKworCiB9CiAKIHN0YXRpYyB2b2lkIG5z
ZWNfcHJpbnRvdXQoaW50IGNwdSwgc3RydWN0IHBlcmZfZXZzZWwgKmV2c2VsLCBkb3VibGUgYXZn
KQogewogCWRvdWJsZSBtc2VjcyA9IGF2ZyAvIDFlNjsKIAljaGFyIGNwdXN0clsxNl0gPSB7ICdc
MCcsIH07Ci0JY29uc3QgY2hhciAqZm10ID0gY3N2X291dHB1dCA/ICIlcyUuNmYlcyVzIiA6ICIl
cyUxOC42ZiVzJS0yNHMiOworCWNvbnN0IGNoYXIgKmZtdCA9IGNzdl9vdXRwdXQgPyAiJXMlcyUu
NmYlcyIgOiAiJXMlMTguNmYlcyUtMjRzIjsKIAogCWlmIChub19hZ2dyKQogCQlzcHJpbnRmKGNw
dXN0ciwgIkNQVSUqZCVzIiwKIAkJCWNzdl9vdXRwdXQgPyAwIDogLTQsCiAJCQlldnNlbF9saXN0
LT5jcHVzLT5tYXBbY3B1XSwgY3N2X3NlcCk7CiAKLQlmcHJpbnRmKGxvZ2ZwLCBmbXQsIGNwdXN0
ciwgbXNlY3MsIGNzdl9zZXAsIGV2ZW50X25hbWUoZXZzZWwpKTsKKwlpZiAoIWNzdl9vdXRwdXQp
CisJICBmcHJpbnRmKGxvZ2ZwLCBmbXQsIGNwdXN0ciwgbXNlY3MsIGNzdl9zZXAsIGV2ZW50X25h
bWUoZXZzZWwpKTsKKwllbHNlCisJICBmcHJpbnRmKGxvZ2ZwLCBmbXQsIGNwdXN0ciwgZXZlbnRf
bmFtZShldnNlbCksIGNzdl9zZXAsIG1zZWNzKTsKIAogCWlmIChldnNlbC0+Y2dycCkKIAkJZnBy
aW50Zihsb2dmcCwgIiVzJXMiLCBjc3Zfc2VwLCBldnNlbC0+Y2dycC0+bmFtZSk7CkBAIC00MTgs
NyArNDI4LDcgQEAgc3RhdGljIHZvaWQgYWJzX3ByaW50b3V0KGludCBjcHUsIHN0cnVjdCBwZXJm
X2V2c2VsICpldnNlbCwgZG91YmxlIGF2ZykKIAljb25zdCBjaGFyICpmbXQ7CiAKIAlpZiAoY3N2
X291dHB1dCkKLQkJZm10ID0gIiVzJS4wZiVzJXMiOworCQlmbXQgPSAiJXMlcyVzJS4wZiI7CiAJ
ZWxzZSBpZiAoYmlnX251bSkKIAkJZm10ID0gIiVzJScxOC4wZiVzJS0yNHMiOwogCWVsc2UKQEAg
LTQzMSw3ICs0NDEsMTAgQEAgc3RhdGljIHZvaWQgYWJzX3ByaW50b3V0KGludCBjcHUsIHN0cnVj
dCBwZXJmX2V2c2VsICpldnNlbCwgZG91YmxlIGF2ZykKIAllbHNlCiAJCWNwdSA9IDA7CiAKLQlm
cHJpbnRmKGxvZ2ZwLCBmbXQsIGNwdXN0ciwgYXZnLCBjc3Zfc2VwLCBldmVudF9uYW1lKGV2c2Vs
KSk7CisJaWYgKGNzdl9vdXRwdXQpCisJICBmcHJpbnRmKGxvZ2ZwLCBmbXQsIGNwdXN0ciwgZXZl
bnRfbmFtZShldnNlbCksIGNzdl9zZXAsIGF2Zyk7CisJZWxzZQorCSAgZnByaW50Zihsb2dmcCwg
Zm10LCBjcHVzdHIsIGF2ZywgY3N2X3NlcCwgZXZlbnRfbmFtZShldnNlbCkpOwogCiAJaWYgKGV2
c2VsLT5jZ3JwKQogCQlmcHJpbnRmKGxvZ2ZwLCAiJXMlcyIsIGNzdl9zZXAsIGV2c2VsLT5jZ3Jw
LT5uYW1lKTsKQEAgLTQ3NSw3ICs0ODgsNyBAQCBzdGF0aWMgdm9pZCBwcmludF9jb3VudGVyX2Fn
Z3Ioc3RydWN0IHBlcmZfZXZzZWwgKmNvdW50ZXIpCiAJZG91YmxlIGF2ZyA9IGF2Z19zdGF0cygm
cHMtPnJlc19zdGF0c1swXSk7CiAJaW50IHNjYWxlZCA9IGNvdW50ZXItPmNvdW50cy0+c2NhbGVk
OwogCi0JaWYgKHNjYWxlZCA9PSAtMSkgeworCWlmIChzY2FsZWQgPT0gLTEgJiYgIWNzdl9vdXRw
dXQpIHsKIAkJZnByaW50Zihsb2dmcCwgIiUqcyVzJSpzIiwKIAkJCWNzdl9vdXRwdXQgPyAwIDog
MTgsCiAJCQkiPG5vdCBjb3VudGVkPiIsCkBAIC00OTUsNyArNTA4LDcgQEAgc3RhdGljIHZvaWQg
cHJpbnRfY291bnRlcl9hZ2dyKHN0cnVjdCBwZXJmX2V2c2VsICpjb3VudGVyKQogCWVsc2UKIAkJ
YWJzX3ByaW50b3V0KC0xLCBjb3VudGVyLCBhdmcpOwogCi0JaWYgKGNzdl9vdXRwdXQpIHsKKwlp
ZiAoMCAmJiBjc3Zfb3V0cHV0KSB7CiAJCWZwdXRjKCdcbicsIGxvZ2ZwKTsKIAkJcmV0dXJuOwog
CX0KQEAgLTUzNiw5ICs1NDksMTIgQEAgc3RhdGljIHZvaWQgcHJpbnRfY291bnRlcihzdHJ1Y3Qg
cGVyZl9ldnNlbCAqY291bnRlcikKIAkJCQljc3Zfb3V0cHV0ID8gMCA6IC0yNCwKIAkJCQlldmVu
dF9uYW1lKGNvdW50ZXIpKTsKIAotCQkJaWYgKGNvdW50ZXItPmNncnApCisJCQlpZiAoY291bnRl
ci0+Y2dycCkgeworCQkJICBpZiAoY3N2X291dHB1dCkKKwkJCQlmcHJpbnRmKGxvZ2ZwLCAiJXMl
cyIsIGNvdW50ZXItPmNncnAtPm5hbWUsIGNzdl9zZXApOworCQkJICBlbHNlCiAJCQkJZnByaW50
Zihsb2dmcCwgIiVzJXMiLCBjc3Zfc2VwLCBjb3VudGVyLT5jZ3JwLT5uYW1lKTsKLQorCQkJfQog
CQkJZnB1dGMoJ1xuJywgbG9nZnApOwogCQkJY29udGludWU7CiAJCX0KQEAgLTU2Nyw2ICs1ODMs
OCBAQCBzdGF0aWMgdm9pZCBwcmludF9zdGF0KGludCBhcmdjLCBjb25zdCBjaGFyICoqYXJndikK
IAogCWZmbHVzaChzdGRvdXQpOwogCisJaWYgKHNpbXBsZSkgcmV0dXJuOworCiAJaWYgKCFjc3Zf
b3V0cHV0KSB7CiAJCWZwcmludGYobG9nZnAsICJcbiIpOwogCQlmcHJpbnRmKGxvZ2ZwLCAiIFBl
cmZvcm1hbmNlIGNvdW50ZXIgc3RhdHMgZm9yICIpOwpAQCAtNjcwLDEyICs2ODgsMTQgQEAgc3Rh
dGljIGNvbnN0IHN0cnVjdCBvcHRpb24gb3B0aW9uc1tdID0gewogCU9QVF9CT09MRUFOKCdBJywg
Im5vLWFnZ3IiLCAmbm9fYWdnciwKIAkJICAgICJkaXNhYmxlIENQVSBjb3VudCBhZ2dyZWdhdGlv
biIpLAogCU9QVF9TVFJJTkcoJ3gnLCAiZmllbGQtc2VwYXJhdG9yIiwgJmNzdl9zZXAsICJzZXBh
cmF0b3IiLAotCQkgICAicHJpbnQgY291bnRzIHdpdGggY3VzdG9tIHNlcGFyYXRvciIpLAorCQkg
ICAicHJpbnQgY291bnRzIHdpdGggY3VzdG9tIHNlcGFyYXRvciAoY3N2LW91dHB1dCkiKSwKIAlP
UFRfQ0FMTEJBQ0soJ0cnLCAiY2dyb3VwIiwgJmV2c2VsX2xpc3QsICJuYW1lIiwKIAkJICAgICAi
bW9uaXRvciBldmVudCBpbiBjZ3JvdXAgbmFtZSBvbmx5IiwKIAkJICAgICBwYXJzZV9jZ3JvdXBz
KSwKIAlPUFRfSU5URUdFUignbCcsICJsb2dmZCIsICZsb2dmZCwKIAkJICAgICJsb2cgb3V0cHV0
IHRvIGZkLCBpbnN0ZWFkIG9mIHN0ZGVyciIpLAorCU9QVF9CT09MRUFOKCdzJywgInNpbXBsZSIs
ICZzaW1wbGUsCisJCSAgICAic2ltcGxlIG91dHB1dCBmb3Igc2NyaXB0cy9hdXRvbWF0aW9uIiks
CiAJT1BUX0VORCgpCiB9OwogCi0tIAoxLjcuNC40Cgo=
--000e0cd3077c6ce43204a40cccd7--
