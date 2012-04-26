Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab2DZWIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:08:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65370 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab2DZWIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:08:52 -0400
MIME-Version: 1.0
Date: Thu, 26 Apr 2012 15:08:51 -0700
Message-ID: <CAAcYxUdUBgwuxNKpiXp8r9-aw7+pi7U2E35dnsoL2RD9tf47oQ@mail.gmail.com>
Subject: High CPU usage of scheduler?
From: Dave Johansen <davejohansen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae93993d1aa252904be9c3b3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae93993d1aa252904be9c3b3f
Content-Type: text/plain; charset=ISO-8859-1

I am looking into moving an application from RHEL 5 to RHEL 6 and I
noticed an unexpected increase in CPU usage. A little digging has led
me to believe that the scheduler may be the culprit.

I created the attached test_select_work.c file to test this out. I
compiled it with the following command on RHEL 5:

cc test_select_work.c -O2 -DSLEEP_TYPE=0 -Wall -Wextra -lm -lpthread
-o test_select_work

I then played with the parameters until the execution time per
iteration was about 1 ms on a Dell Precision m6500.

I got the following result on RHEL 5:

    ./test_select_work 1000 10000 300 4
    time_per_iteration: min: 911.5 us avg: 913.7 us max: 917.1 us stddev: 2.4 us
    ./test_select_work 1000 10000 300 8
    time_per_iteration: min: 1802.6 us avg: 1803.9 us max: 1809.1 us
stddev: 2.1 us
    ./test_select_work 1000 10000 300 40
    time_per_iteration: min: 7580.4 us avg: 8567.3 us max: 9022.0 us
stddev: 299.6 us

And the following on RHEL 6:

    ./test_select_work 1000 10000 300 4
    time_per_iteration: min: 914.6 us avg: 975.7 us max: 1034.5 us
stddev: 50.0 us
    ./test_select_work 1000 10000 300 8
    time_per_iteration: min: 1683.9 us avg: 1771.8 us max: 1810.8 us
stddev: 43.4 us
    ./test_select_work 1000 10000 300 40
    time_per_iteration: min: 7997.1 us avg: 8709.1 us max: 9061.8 us
stddev: 310.0 us

On both versions, these results were about what I expected with the
average amount of time per iteration scaling relatively linearly. I
then recompiled with -DSLEEP_TYPE=1 and got the following results on
RHEL 5:

    ./test_select_work 1000 10000 300 4
    time_per_iteration: min: 1803.3 us avg: 1902.8 us max: 2001.5 us
stddev: 113.8 us
    ./test_select_work 1000 10000 300 8
    time_per_iteration: min: 1997.1 us avg: 2002.0 us max: 2010.8 us
stddev: 5.0 us
    ./test_select_work 1000 10000 300 40
    time_per_iteration: min: 6958.4 us avg: 8397.9 us max: 9423.7 us
stddev: 619.7 us

And the following results on RHEL 6:

    ./test_select_work 1000 10000 300 4
    time_per_iteration: min: 2107.1 us avg: 2143.1 us max: 2177.7 us
stddev: 30.3 us
    ./test_select_work 1000 10000 300 8
    time_per_iteration: min: 2903.3 us avg: 2903.8 us max: 2904.3 us
stddev: 0.3 us
    ./test_select_work 1000 10000 300 40
    time_per_iteration: min: 8877.7.1 us avg: 9016.3 us max: 9112.6 us
stddev: 62.9 us

On RHEL 5, the results were about what I expected (4 threads taking
twice as long because of the 1 ms sleep but the 8 threads taking the
same amount of time since each thread is now sleeping for about half
the time, and a still fairly linear increase with the 40 threads).

However, with RHEL 6, the time taken with 4 threads increased by about
15% more than the expected doubling and the 8 thread case increased by
about 45% more than the expected slight increase. The increase in the
4 thread case seems to be that RHEL 6 is actually sleeping for a
handful of microseconds more than 1 ms while RHEL 5 is only sleep
about 900 us, but this doesn't explain the unexpectedly large increase
in the 8 and 40 thread cases.

I saw similar types of behaviour with all 3 -DSLEEP_TYPE values. I
also tried playing with the scheduler parameters in sysctl, but
nothing seemed to have a significant impact on the results. Any ideas
on how I can further diagnose this issue?

Thanks,
Dave

--14dae93993d1aa252904be9c3b3f
Content-Type: text/x-csrc; charset=US-ASCII; name="test_select_work.c"
Content-Disposition: attachment; filename="test_select_work.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1id4ok50

I2luY2x1ZGUgPGZsb2F0Lmg+CiNpbmNsdWRlIDxtYXRoLmg+CiNpbmNsdWRlIDxwb2xsLmg+CiNp
bmNsdWRlIDxwdGhyZWFkLmg+CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8c3RkbGliLmg+
CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHN5cy9zZWxlY3QuaD4KI2luY2x1ZGUgPHN5
cy90aW1lLmg+CgoKLy8gVW5jb21tZW50IHRvIHVzZSBzZWxlY3QgaW5zaWRlIHRoZSBsb29wIG9m
IGVhY2ggb2YgdGhlIHRocmVhZHMKI2RlZmluZSBTTEVFUF9UWVBFIDEKLy8gVW5jb21tZW50IHRv
IHVzZSBwb2xsIGluc2lkZSB0aGUgbG9vcCBvZiBlYWNoIG9mIHRoZSB0aHJlYWRzCi8vI2RlZmlu
ZSBTTEVFUF9UWVBFIDIKLy8gVW5jb21tZW50IHRvIHVzZSB1c2xlZXAgaW5zaWRlIHRoZSBsb29w
IG9mIGVhY2ggb2YgdGhlIHRocmVhZHMKLy8jZGVmaW5lIFNMRUVQX1RZUEUgMwoKCnN0cnVjdCB0
aHJlYWRfaW5mbyB7CglpbnQgc2xlZXBfdGltZTsKCWludCBudW1faXRlcmF0aW9uczsKCWludCB3
b3JrX3NpemU7Cn07Cgp2b2lkICpkb190ZXN0KHZvaWQgKmFyZykKewoJY29uc3Qgc3RydWN0IHRo
cmVhZF9pbmZvICp0aW5mbyA9IChzdHJ1Y3QgdGhyZWFkX2luZm8gKilhcmc7CgoJY29uc3QgaW50
IHNsZWVwX3RpbWUgPSB0aW5mby0+c2xlZXBfdGltZTsKCWNvbnN0IGludCBudW1faXRlcmF0aW9u
cyA9IHRpbmZvLT5udW1faXRlcmF0aW9uczsKCWNvbnN0IGludCB3b3JrX3NpemUgPSB0aW5mby0+
d29ya19zaXplOwoKI2lmIFNMRUVQX1RZUEUgPT0gMQoJLy8gRGF0YSBmb3IgY2FsbGluZyBzZWxl
Y3QKCXN0cnVjdCB0aW1ldmFsIHRzOwojZWxpZiBTTEVFUF9UWVBFID09IDIKCS8vIERhdGEgZm9y
IGNhbGxpbmcgcG9sbAoJc3RydWN0IHBvbGxmZCBwZmQ7CiNlbmRpZgoJLy8gRGF0YSBmb3IgZG9p
bmcgd29yawoJaW50ICpidWY7CglpbnQgcHNlZWQ7CglpbnQgaW51bSwgYm51bTsKCS8vIERhdGEg
Zm9yIHRyYWNraW5nIHRoZSB0aW1lCiAgc3RydWN0IHRpbWV2YWwgYmVmb3JlLCBhZnRlcjsKCWxv
bmcgbG9uZyAqZGlmZjsKIAoJYnVmID0gY2FsbG9jKHdvcmtfc2l6ZSwgc2l6ZW9mKGludCkpOwoJ
ZGlmZiA9IG1hbGxvYyhzaXplb2YodW5zaWduZWQgbG9uZyBsb25nKSk7CgojaWYgU0xFRVBfVFlQ
RSA9PSAyCgkvLyBJbml0aWFsaXplIHRoZSBwb2xsIGRhdGEKCXBmZC5mZCA9IDA7CglwZmQuZXZl
bnRzID0gMDsKI2VuZGlmCgoJLy8gR2V0IHRoZSB0aW1lIGJlZm9yZSBzdGFydGluZyB0aGUgcHJv
Y2Vzc2luZwogIGdldHRpbWVvZmRheSgmYmVmb3JlLCBOVUxMKTsKCgkvLyBEbyB0aGUgcmVxdWVz
dGVkIG51bWJlciBvZiBpdGVyYXRpb25zCglmb3IgKGludW09MDsgaW51bTxudW1faXRlcmF0aW9u
czsgKytpbnVtKSB7CiNpZiBTTEVFUF9UWVBFID09IDEKCQl0cy50dl9zZWMgPSAwOwoJCXRzLnR2
X3VzZWMgPSBzbGVlcF90aW1lOwoJCXNlbGVjdCgwLCAwLCAwLCAwLCAmdHMpOwojZWxpZiBTTEVF
UF9UWVBFID09IDIKCQlwb2xsKCZwZmQsIDEsIHNsZWVwX3RpbWUgLyAxMDAwKTsKI2VsaWYgU0xF
RVBfVFlQRSA9PSAzCgkJdXNsZWVwKHNsZWVwX3RpbWUpOwojZWxzZQoJCS8vIEdldCByaWQgb2Yg
d2FybmluZyBhYm91dCB1bnVzZWQgdmFyaWFibGUKCQkodm9pZClzbGVlcF90aW1lOwojZW5kaWYK
CgkJLy8gRmlsbCBpbiBhIGJ1ZmZlciB3aXRoIHJhbmRvbSBudW1iZXJzICh0YWtlbiBmcm9tIGxh
dHQuYyBieSBKZW5zIEF4Ym9lIDxqZW5zLmF4Ym9lQG9yYWNsZS5jb20+KQoJCXBzZWVkID0gMTsK
CQlmb3IgKGJudW09MDsgYm51bTx3b3JrX3NpemU7ICsrYm51bSkgewoJCQlwc2VlZCA9IHBzZWVk
ICogMTEwMzUxNTI0NSArIDEyMzQ1OwoJCQlidWZbYm51bV0gPSAocHNlZWQgLyA2NTUzNikgJSAz
Mjc2ODsKCQl9Cgl9CgoJLy8gR2V0IHRoZSB0aW1lIGFmdGVyIHN0YXJ0aW5nIHRoZSBwcm9jZXNz
aW5nCiAgZ2V0dGltZW9mZGF5KCZhZnRlciwgTlVMTCk7CgoJLy8gQ2FsY3VsYXRlIHRoZSBkZWx0
YSB0aW1lCiAgKmRpZmYgPSAxMDAwMDAwTEwgKiAoYWZ0ZXIudHZfc2VjIC0gYmVmb3JlLnR2X3Nl
Yyk7CiAgKmRpZmYgKz0gYWZ0ZXIudHZfdXNlYyAtIGJlZm9yZS50dl91c2VjOwoKCS8vIENsZWFu
IHVwIHRoZSBkYXRhCglmcmVlKGJ1Zik7CgoJcmV0dXJuIGRpZmY7Cn0KCmludCBtYWluKGludCBh
cmdjLCBjaGFyICoqYXJndikKewoJaWYgKGFyZ2MgPCA0KSB7CgkJcHJpbnRmKCJVc2FnZTogJXMg
PHNsZWVwX3RpbWU+IDxudW1faXRlcmF0aW9ucz4gPHdvcmtfc2l6ZT4gPG51bV90aHJlYWRzPlxu
IiwgYXJndlswXSk7CgkJcmV0dXJuIC0xOwoJfQoKCXN0cnVjdCB0aHJlYWRfaW5mbyB0aW5mbzsK
CWludCBzLCB0bnVtLCBudW1fdGhyZWFkczsKCXB0aHJlYWRfYXR0cl90IGF0dHI7CglwdGhyZWFk
X3QgKnRocmVhZHM7Cglsb25nIGxvbmcgKnJlczsKCWxvbmcgbG9uZyAqdGltZXM7CgoJLy8gR2V0
IHRoZSBwYXJhbWV0ZXJzCgl0aW5mby5zbGVlcF90aW1lID0gYXRvaShhcmd2WzFdKTsKCXRpbmZv
Lm51bV9pdGVyYXRpb25zID0gYXRvaShhcmd2WzJdKTsKCXRpbmZvLndvcmtfc2l6ZSA9IGF0b2ko
YXJndlszXSkgKiAxMDI0OwoJbnVtX3RocmVhZHMgPSBhdG9pKGFyZ3ZbNF0pOwoKCS8vIEluaXRp
YWxpemUgdGhlIHRocmVhZCBjcmVhdGlvbiBhdHRyaWJ1dGVzCglzID0gcHRocmVhZF9hdHRyX2lu
aXQoJmF0dHIpOwogIGlmIChzICE9IDApIHsKCQlwcmludGYoIkVycm9yIGluaXRpYWxpemluZyB0
aHJlYWQgYXR0cmlidXRlc1xuIik7CgkJcmV0dXJuIC0yOwoJfQoKCS8vIEFsbG9jYXRlIHRoZSBt
ZW1vcnkgdG8gdHJhY2sgdGhlIHRocmVhZHMKIAl0aHJlYWRzID0gY2FsbG9jKG51bV90aHJlYWRz
LCBzaXplb2YocHRocmVhZF90KSk7CiAJdGltZXMgPSBjYWxsb2MobnVtX3RocmVhZHMsIHNpemVv
Zih1bnNpZ25lZCBsb25nIGxvbmcpKTsKCWlmICh0aHJlYWRzID09IE5VTEwpIHsKCQlwcmludGYo
IkVycm9yIGFsbG9jYXRpbmcgbWVtb3J5IHRvIHRyYWNrIHRocmVhZHNcbiIpOwoJCXJldHVybiAt
MzsKCX0KCgkvLyBTdGFydCBhbGwgb2YgdGhlIHRocmVhZHMKCWZvciAodG51bT0wOyB0bnVtPG51
bV90aHJlYWRzOyArK3RudW0pIHsKCQlzID0gcHRocmVhZF9jcmVhdGUoJnRocmVhZHNbdG51bV0s
ICZhdHRyLCAmZG9fdGVzdCwgJnRpbmZvKTsKCgkJaWYgKHMgIT0gMCkgewoJCQlwcmludGYoIkVy
cm9yIHN0YXJ0aW5nIHRocmVhZFxuIik7CgkJCXJldHVybiAtNDsKCQl9Cgl9CgoJLy8gQ2xlYW4g
dXAgdGhlIHRocmVhZCBjcmVhdGlvbiBhdHRyaWJ1dGVzCglzID0gcHRocmVhZF9hdHRyX2Rlc3Ry
b3koJmF0dHIpOwogIGlmIChzICE9IDApIHsKCQlwcmludGYoIkVycm9yIGNsZWFuaW5nIHVwIHRo
cmVhZCBhdHRyaWJ1dGVzXG4iKTsKCQlyZXR1cm4gLTU7Cgl9CgoJLy8gV2FpdCBmb3IgYWxsIHRo
ZSB0aHJlYWRzIHRvIGZpbmlzaAoJZm9yICh0bnVtPTA7IHRudW08bnVtX3RocmVhZHM7ICsrdG51
bSkgewoJCXMgPSBwdGhyZWFkX2pvaW4odGhyZWFkc1t0bnVtXSwgKHZvaWQgKiopKCZyZXMpKTsK
CgkJaWYgKHMgIT0gMCkgewoJCQlwcmludGYoIkVycm9yIHdhaXRpbmcgZm9yIHRocmVhZFxuIik7
CgkJCXJldHVybiAtNjsKCQl9CgoJCS8vIFNhdmUgdGhlIHRpbWUKCQl0aW1lc1t0bnVtXSA9ICpy
ZXM7CgoJCS8vIEFuZCBjbGVhbiBpdCB1cAoJCWZyZWUocmVzKTsKCX0KCgkvLyBDYWxjdWxhdGUg
dGhlIG1pbiwgbWF4LCBhbmQgYXZlcmFnZSB0aW1lcwoJZmxvYXQgbWluX3RpbWUgPSBGTFRfTUFY
OwoJZmxvYXQgbWF4X3RpbWUgPSAtRkxUX01BWDsKCWZsb2F0IGF2Z190aW1lID0gMDsKCWZvciAo
dG51bT0wOyB0bnVtPG51bV90aHJlYWRzOyArK3RudW0pIHsKCQlpZiAodGltZXNbdG51bV0gPCBt
aW5fdGltZSkKCQkJbWluX3RpbWUgPSB0aW1lc1t0bnVtXTsKCQlpZiAodGltZXNbdG51bV0gPiBt
YXhfdGltZSkKCQkJbWF4X3RpbWUgPSB0aW1lc1t0bnVtXTsKCQlhdmdfdGltZSArPSAodGltZXNb
dG51bV0gLSBhdmdfdGltZSkgLyAoZmxvYXQpKHRudW0gKyAxKTsKCX0KCS8vIENhbGN1bGF0ZSB0
aGUgc3RhbmRhcmQgZGV2aWF0aW9uIG9mIHRoZSB0aW1lCglmbG9hdCBzdGRkZXZfdGltZSA9IDA7
CglpZiAobnVtX3RocmVhZHMgPiAxKSB7CgkJZm9yICh0bnVtPTA7IHRudW08bnVtX3RocmVhZHM7
ICsrdG51bSkKCQkJc3RkZGV2X3RpbWUgKz0gcG93KHRpbWVzW3RudW1dIC0gYXZnX3RpbWUsIDIp
OwoJCXN0ZGRldl90aW1lID0gc3FydGYoc3RkZGV2X3RpbWUgLyAobnVtX3RocmVhZHMgLSAxKSk7
Cgl9CgoJLy8gUHJpbnQgb3V0IHRoZSBzdGF0aXN0aWNzIG9mIHRoZSB0aW1lcwoJcHJpbnRmKCJ0
aW1lX3Blcl9pdGVyYXRpb246IG1pbjogJS4xZiB1cyBhdmc6ICUuMWYgdXMgbWF4OiAlLjFmIHVz
IHN0ZGRldjogJS4xZiB1c1xuIiwKCQkJbWluX3RpbWUgLyB0aW5mby5udW1faXRlcmF0aW9ucywK
CQkJYXZnX3RpbWUgLyB0aW5mby5udW1faXRlcmF0aW9ucywKCQkJbWF4X3RpbWUgLyB0aW5mby5u
dW1faXRlcmF0aW9ucywKCQkJc3RkZGV2X3RpbWUgLyB0aW5mby5udW1faXRlcmF0aW9ucyk7CgoJ
Ly8gQ2xlYW4gdXAgdGhlIGFsbG9jYXRlZCB0aHJlYWRzCglmcmVlKHRocmVhZHMpOwoKCXJldHVy
biAwOwp9Cg==
--14dae93993d1aa252904be9c3b3f--
