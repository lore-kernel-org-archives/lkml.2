Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1GRSM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:12:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505Ab1GRSMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:12:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
 <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107171740260.1327@sister.anvils> <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Jul 2011 11:11:40 -0700
Message-ID: <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6de008179d6a204a85beff6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6de008179d6a204a85beff6
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Jul 17, 2011 at 11:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Now, I do agree that maybe that case simply should check the dentry
> sequence count. I wish all cases did. Hugh patch did that. But the
> reason I dislike Hugh's patch is that when I say "I wish they all
> did", I mean that I dislike the special casing. And Hugh's patch just
> adds *more* special casing for that NULL entry - I'd wish we just
> always did it regardless of whether it was NULL or not.

Btw, looking at that, I think Hugh's patch is wrong. It does

  if (!read_seqcount_retry(&dentry->d_seq, nd->seq))

but that's after we've done the __follow_mount_rcu() that may actually
have changed "nd->seq" to the mount-point inode (and has changed
path->dentry to match it).

Now, it only does it if inode is NULL, so I guess it doesn't matter,
but it's the kind of inconsistency that I think is really dangerous,
because it basically compares incompatible sequence numbers.

Also, looking at that whole mount-point traversal sequence, it looks
like __follow_mount_rcu() will happily totally ignore the old sequence
number when it replaces it with the mount-point sequence number. So it
looks to me that we have a case where we miss the sequence number
check that can happen with a positive dentry too!

No?

So I think that whenever we change "nd->seq", we should always heck
the previous sequence number first (the way do_lookup() itself does
for the *normal* traversal case). Otherwise we will have traversed the
mount-point without ever having checked the previous sequence number.

Something like the (untested) attached patch.

Comments? This mount-point case is independent of the negative dentry
issue, and probably never really an issue in practice, but...

                          Linus

--0016e6de008179d6a204a85beff6
Content-Type: text/x-patch; charset=US-ASCII; name="mount-sequence.diff"
Content-Disposition: attachment; filename="mount-sequence.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gq9r3ij20

IGZzL25hbWVpLmMgfCAgIDEzICsrKysrKysrKysrKy0KIDEgZmlsZXMgY2hhbmdlZCwgMTIgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9uYW1laS5jIGIvZnMv
bmFtZWkuYwppbmRleCA1Yzg2N2RkMWMwYjMuLmY3OGQyYWYzYWVmNCAxMDA2NDQKLS0tIGEvZnMv
bmFtZWkuYworKysgYi9mcy9uYW1laS5jCkBAIC05MzgsNiArOTM4LDggQEAgc3RhdGljIGJvb2wg
X19mb2xsb3dfbW91bnRfcmN1KHN0cnVjdCBuYW1laWRhdGEgKm5kLCBzdHJ1Y3QgcGF0aCAqcGF0
aCwKIHsKIAlmb3IgKDs7KSB7CiAJCXN0cnVjdCB2ZnNtb3VudCAqbW91bnRlZDsKKwkJdW5zaWdu
ZWQgaW50IHNlcTsKKwogCQkvKgogCQkgKiBEb24ndCBmb3JnZXQgd2UgbWlnaHQgaGF2ZSBhIG5v
bi1tb3VudHBvaW50IG1hbmFnZWQgZGVudHJ5CiAJCSAqIHRoYXQgd2FudHMgdG8gYmxvY2sgdHJh
bnNpdC4KQEAgLTk1Miw5ICs5NTQsMTggQEAgc3RhdGljIGJvb2wgX19mb2xsb3dfbW91bnRfcmN1
KHN0cnVjdCBuYW1laWRhdGEgKm5kLCBzdHJ1Y3QgcGF0aCAqcGF0aCwKIAkJbW91bnRlZCA9IF9f
bG9va3VwX21udChwYXRoLT5tbnQsIHBhdGgtPmRlbnRyeSwgMSk7CiAJCWlmICghbW91bnRlZCkK
IAkJCWJyZWFrOworCQlzZXEgPSByZWFkX3NlcWNvdW50X2JlZ2luKCZtb3VudGVkLT5tbnRfcm9v
dC0+ZF9zZXEpOworCisJCS8qCisJCSAqIFRoZSBtZW1vcnkgYmFycmllciBpbiByZWFkX3NlcWNv
dW50X2JlZ2luKCkgaXMgc3VmZmljaWVudCwKKwkJICogc28gd2UgY2FuIHVzZSBfX3JlYWRfc2Vx
Y291bnRfcmV0cnkoKSB0byBjaGVjayB0aGUgcHJldgorCQkgKiBzZXF1ZW5jZSBudW1iZXJzLgor
CQkgKi8KKwkJaWYgKCFfX3JlYWRfc2VxY291bnRfcmV0cnkoJnBhdGgtPmRlbnRyeS0+ZF9zZXEs
IG5kLT5zZXEpKQorCQkJcmV0dXJuIGZhbHNlOwogCQlwYXRoLT5tbnQgPSBtb3VudGVkOwogCQlw
YXRoLT5kZW50cnkgPSBtb3VudGVkLT5tbnRfcm9vdDsKLQkJbmQtPnNlcSA9IHJlYWRfc2VxY291
bnRfYmVnaW4oJnBhdGgtPmRlbnRyeS0+ZF9zZXEpOworCQluZC0+c2VxID0gc2VxOwogCX0KIAly
ZXR1cm4gdHJ1ZTsKIH0K
--0016e6de008179d6a204a85beff6--
