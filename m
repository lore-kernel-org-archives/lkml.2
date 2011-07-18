Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab1GRVnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:43:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752Ab1GRVnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:43:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
References: <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107171740260.1327@sister.anvils> <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
 <alpine.LSU.2.00.1107181135170.2722@sister.anvils> <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
 <20110718194703.GI11013@ZenIV.linux.org.uk> <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Jul 2011 14:42:51 -0700
Message-ID: <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6454998ba700a04a85ee29c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6454998ba700a04a85ee29c
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jul 18, 2011 at 2:19 PM, Hugh Dickins <hughd@google.com> wrote:
>
> __d_lookup_rcu() is being careful about *inode, yes.
>
> But I'd forgotten it was even setting it: doesn't that setting get
> overridden later by the more careless *inode = path->d_entry->d_inode
> at the head of __follow_mount_rcu()'s loop?
>
> Perhaps that line just needs to be moved to the tail of the loop?

Ahh. Bingo. Yes, I think you found it.

I don't think it should touch that *inode value in
__follow_mount_rcu() unless we actually followed a mount, exactly
because it will overwrite the thing that we were so careful about in
__d_lookup_rcu().

So how about this patch that replaces the earlier mount-point sequence
number one. The only difference is (as you mention) to just do the
*inode update at the end of the loop, so that we don't overwrite the
valid inode data with a non-checked one when we don't do anything.

Untested. But this should make my propised change to fs/dcache.c be
irrelevant, because whether we clear d_inode or not, the existing
sequence number checks will catch it. Agreed?

                      Linus

--0016e6454998ba700a04a85ee29c
Content-Type: text/x-patch; charset=US-ASCII; name="mount-sequence.diff"
Content-Disposition: attachment; filename="mount-sequence.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gq9ylxie0

IGZzL25hbWVpLmMgfCAgIDIxICsrKysrKysrKysrKysrKysrKystLQogMSBmaWxlcyBjaGFuZ2Vk
LCAxOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL25hbWVp
LmMgYi9mcy9uYW1laS5jCmluZGV4IDVjODY3ZGQxYzBiMy4uYjljZDU1OGEwMGJlIDEwMDY0NAot
LS0gYS9mcy9uYW1laS5jCisrKyBiL2ZzL25hbWVpLmMKQEAgLTkzOCwxMSArOTM4LDEyIEBAIHN0
YXRpYyBib29sIF9fZm9sbG93X21vdW50X3JjdShzdHJ1Y3QgbmFtZWlkYXRhICpuZCwgc3RydWN0
IHBhdGggKnBhdGgsCiB7CiAJZm9yICg7OykgewogCQlzdHJ1Y3QgdmZzbW91bnQgKm1vdW50ZWQ7
CisJCXVuc2lnbmVkIGludCBzZXE7CisKIAkJLyoKIAkJICogRG9uJ3QgZm9yZ2V0IHdlIG1pZ2h0
IGhhdmUgYSBub24tbW91bnRwb2ludCBtYW5hZ2VkIGRlbnRyeQogCQkgKiB0aGF0IHdhbnRzIHRv
IGJsb2NrIHRyYW5zaXQuCiAJCSAqLwotCQkqaW5vZGUgPSBwYXRoLT5kZW50cnktPmRfaW5vZGU7
CiAJCWlmICh1bmxpa2VseShtYW5hZ2VkX2RlbnRyeV9taWdodF9ibG9jayhwYXRoLT5kZW50cnkp
KSkKIAkJCXJldHVybiBmYWxzZTsKIApAQCAtOTUyLDkgKzk1MywyNSBAQCBzdGF0aWMgYm9vbCBf
X2ZvbGxvd19tb3VudF9yY3Uoc3RydWN0IG5hbWVpZGF0YSAqbmQsIHN0cnVjdCBwYXRoICpwYXRo
LAogCQltb3VudGVkID0gX19sb29rdXBfbW50KHBhdGgtPm1udCwgcGF0aC0+ZGVudHJ5LCAxKTsK
IAkJaWYgKCFtb3VudGVkKQogCQkJYnJlYWs7CisJCXNlcSA9IHJlYWRfc2VxY291bnRfYmVnaW4o
Jm1vdW50ZWQtPm1udF9yb290LT5kX3NlcSk7CisKKwkJLyoKKwkJICogVGhlIG1lbW9yeSBiYXJy
aWVyIGluIHJlYWRfc2VxY291bnRfYmVnaW4oKSBpcyBzdWZmaWNpZW50LAorCQkgKiBzbyB3ZSBj
YW4gdXNlIF9fcmVhZF9zZXFjb3VudF9yZXRyeSgpIHRvIGNoZWNrIHRoZSBwcmV2CisJCSAqIHNl
cXVlbmNlIG51bWJlcnMuCisJCSAqLworCQlpZiAoIV9fcmVhZF9zZXFjb3VudF9yZXRyeSgmcGF0
aC0+ZGVudHJ5LT5kX3NlcSwgbmQtPnNlcSkpCisJCQlyZXR1cm4gZmFsc2U7CiAJCXBhdGgtPm1u
dCA9IG1vdW50ZWQ7CiAJCXBhdGgtPmRlbnRyeSA9IG1vdW50ZWQtPm1udF9yb290OwotCQluZC0+
c2VxID0gcmVhZF9zZXFjb3VudF9iZWdpbigmcGF0aC0+ZGVudHJ5LT5kX3NlcSk7CisJCW5kLT5z
ZXEgPSBzZXE7CisKKwkJLyoKKwkJICogVXBkYXRlIHRoZSBpbm9kZSB0b28uIFdlIGRvbid0IG5l
ZWQgdG8gcmUtY2hlY2sgdGhlCisJCSAqIGRlbnRyeSBzZXF1ZW5jZSBudW1iZXIgaGVyZSBhZnRl
ciB0aGlzIGRfaW5vZGUgcmVhZCwKKwkJICogYmVjYXVzZSBhIG1vdW50LXBvaW50IGlzIGFsd2F5
cyBwaW5uZWQuCisJCSAqLworCQkqaW5vZGUgPSBwYXRoLT5kZW50cnktPmRfaW5vZGU7CiAJfQog
CXJldHVybiB0cnVlOwogfQo=
--0016e6454998ba700a04a85ee29c--
