Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab2AQATK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:19:10 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36933 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2AQATI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:19:08 -0500
MIME-Version: 1.0
In-Reply-To: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
References: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 16:18:46 -0800
X-Google-Sender-Auth: 2pLDLE-D-kAx5Sfz7Vj76yxZnWs
Message-ID: <CA+55aFys9zddHAoKURGAeu0QYD_MC11uEyOQGU_4Ybsf200NkQ@mail.gmail.com>
Subject: Re: [patch] x86, tsc: fix SMI induced variation in quick_pit_calibrate()
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, asit.k.mallick@intel.com
Content-Type: multipart/mixed; boundary=f46d043748f383e60604b6ae4788
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043748f383e60604b6ae4788
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jan 16, 2012 at 12:15 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> Linus, We are seeing NTP failures on a big cluster as a result of big
> variation in calibrated TSC values. Our debug showed that it is indeed
> because of the SMI and its effect on quick pit calibration. Appended
> patch helps fix it. It ran over the weekend boot tests with out any
> failures.

Ok, I think your patch is wrong.

HOWEVER.

I think it may be *close* to right.

So what happens is that right now we calculate the "deltatsc" over the
last PIT read - the one that returned the new MSB.

But what we *should* do is to calculate deltatsc over the *two* last
PIT reads - so that we have the time delay over seeing both the old
MSB _and_ seeign the new one. That's the true measure of how precisely
we caught the "MSB changed" thing, after all!

So I think your patch is a total hack that just compares the two last
TSC deltas, but it's actually close to the "correct' thing in that it
does start taking the time to see the last of the previous MSB into
account.

So this patch changes pit_expect_msb() so that

 - the 'tsc' is the TSC in between the two reads that read the MSB
change from the PIT (same as before)

 - the 'delta' is the difference in TSC from *before* the MSB changed
to *after* the MSB changed.

Now the delta is twice as big as before (it covers four PIT accesses,
roughly 4us), so the comments might have to be updated to match, but
the rest of the code should "just work" (except it might loop a bit
longer, and maybe it gives closer to 250 ppm precision).

Does this fix it for you? I have NOT tested it in any way.

                     Linus

--f46d043748f383e60604b6ae4788
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxi6d0av0

IGFyY2gveDg2L2tlcm5lbC90c2MuYyB8ICAgIDUgKysrLS0KIDEgZmlsZXMgY2hhbmdlZCwgMyBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5l
bC90c2MuYyBiL2FyY2gveDg2L2tlcm5lbC90c2MuYwppbmRleCBjMGRkNWI2MDM3NDkuLjZiNzQy
ZGE0MTMwNCAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL3RzYy5jCisrKyBiL2FyY2gveDg2
L2tlcm5lbC90c2MuYwpAQCAtMjkwLDE0ICsyOTAsMTUgQEAgc3RhdGljIGlubGluZSBpbnQgcGl0
X3ZlcmlmeV9tc2IodW5zaWduZWQgY2hhciB2YWwpCiBzdGF0aWMgaW5saW5lIGludCBwaXRfZXhw
ZWN0X21zYih1bnNpZ25lZCBjaGFyIHZhbCwgdTY0ICp0c2NwLCB1bnNpZ25lZCBsb25nICpkZWx0
YXApCiB7CiAJaW50IGNvdW50OwotCXU2NCB0c2MgPSAwOworCXU2NCB0c2MgPSAwLCBwcmV2X3Rz
YyA9IDA7CiAKIAlmb3IgKGNvdW50ID0gMDsgY291bnQgPCA1MDAwMDsgY291bnQrKykgewogCQlp
ZiAoIXBpdF92ZXJpZnlfbXNiKHZhbCkpCiAJCQlicmVhazsKKwkJcHJldl90c2MgPSB0c2M7CiAJ
CXRzYyA9IGdldF9jeWNsZXMoKTsKIAl9Ci0JKmRlbHRhcCA9IGdldF9jeWNsZXMoKSAtIHRzYzsK
KwkqZGVsdGFwID0gZ2V0X2N5Y2xlcygpIC0gcHJldl90c2M7CiAJKnRzY3AgPSB0c2M7CiAKIAkv
Kgo=
--f46d043748f383e60604b6ae4788--
