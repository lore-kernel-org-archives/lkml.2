Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1HISzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:55:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62460 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1HISzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:55:07 -0400
MIME-Version: 1.0
Reply-To: jwboyer@redhat.com
Date: Tue, 9 Aug 2011 14:55:05 -0400
X-Google-Sender-Auth: jsNRC3sjdRgO1xa7JU_tnl8Vnm4
Message-ID: <CA+5PVA4TjqNjKKgDsnbfzC-s9U3m=ZtXWb6rCAOYGz_Vbzunrg@mail.gmail.com>
Subject: Cryptomgr race vs built-in aesni
From: Josh Boyer <jwboyer@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fedora has had a bug[1] open for a while with people seeing this upon boot:

[    0.807387] alg: skcipher: Failed to load transform for ecb-aes-aesni: -2

We're still seeing it with the 3.0 kernel, so I poked at it today.

We have the crypto manager built in to the kernel, as well as the
AES_NI_INTEL module.  The tests are not disabled, as that would disable
FIPS and apparnetly Fedora wants that on.  (I have no idea why.)

I instrumented that module and the place where the error is being spit out,
and it seems as if cryptomgr is racing against itself and trying to request
an algorithm that is still being registered.  The instrumented printks are
below (the aesni printks are of the form <__func__>:<__LINE__> <whatever>.

[    0.805053] aesni_init: 1275 registering ablk_ecb_alg
[    0.807387] alg: skcipher: Failed to load transform for ecb-aes-aesni: -2
[    0.807441] Pid: 36, comm: cryptomgr_test Not tainted 2.6.40-4.fc15.x86_64 #6
[    0.807443] Call Trace:
[    0.807450]  [<ffffffff81215df6>] alg_test_skcipher+0x48/0xa3
[    0.807453]  [<ffffffff812160a9>] ? alg_find_test+0x3a/0x5d
[    0.807456]  [<ffffffff8121628c>] alg_test+0x1c0/0x277
[    0.807459]  [<ffffffff814b58c3>] ? schedule+0x690/0x6be
[    0.807462]  [<ffffffff81213d86>] ? cryptomgr_probe+0xca/0xca
[    0.807465]  [<ffffffff81213daf>] cryptomgr_test+0x29/0x44
[    0.807468]  [<ffffffff8106fd2b>] kthread+0x84/0x8c
[    0.807471]  [<ffffffff814be924>] kernel_thread_helper+0x4/0x10
[    0.807473]  [<ffffffff8106fca7>] ? kthread_worker_fn+0x148/0x148
[    0.807475]  [<ffffffff814be920>] ? gs_change+0x13/0x13
[    0.807482] aesni_init: 1278 err: 0
[    0.807627] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.807768] aesni_init: 1307 err: 0

So it seems that the aesni module is trying to register the ecb(aes) alg
and before that completes (or something?) the test gets scheduled and
tries to do a CRYPTO_MSG_ALG_REQUEST on something that hasn't
finished it's module_init function yet.  Eventually the aesni_init function
completes successfully (the last printk), so I'm assuming that the
module is still present but that particular algorithm is listed as unavailable.

My understanding of the crypto layer and it's use of kthreads to schedule
the self-tests is pretty limited so I might have mis-interpreted things.  I'd
appreciate it if someone could look this over and give me any thoughts
that might come to mind.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=721002
