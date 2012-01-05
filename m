Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2AERCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:02:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49174 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2AERCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:02:22 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jan 2012 09:02:00 -0800
X-Google-Sender-Auth: VOUHWb2SEwmgM8uVd0rZlwTw_vQ
Message-ID: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
Subject: Broken ioctl error returns (was Re: [PATCH 2/3] block: fail SCSI
 passthrough ioctls on partition devices)
To: Paolo Bonzini <pbonzini@redhat.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Content-Type: multipart/mixed; boundary=20cf30363877428bf704b5cae5b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30363877428bf704b5cae5b4
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jan 5, 2012 at 8:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Just fix the *obvious* breakage in BLKROSET. It's clearly what the
> code *intends* to do, it just didn't check for ENOIOCTLCMD.

So it seems from quick grepping that the block layer isn't actually
all that confused apart from that one BLK[SG]ETRO issue, although I'm
sure there are crazy drivers that think that EINVAL is the right error
return.

The *really* confused layer seems to be the damn media drivers. The
confusion there seems to go very deep indeed, where for some crazy
reason the media people seem to have made it part of the semantics
that "if a driver doesn't support a particular ioctl, it returns
EINVAL".

Added, linux-media and Mauro to the Cc, because I'm about to commit
something like the attached patch to see if anything breaks. We may
have to revert it if things get too nasty, but we should have done
this years and years ago, so let's hope not.

Basic rules: ENOTTY means "I don't recognize this ioctl". Yes, the
name is odd, and yes, it's for historical Unix reasons. ioctl's were
originally a way to control mainly terminal settings - think termios -
so when you did an ioctl on a file, you'd get "I'm not a tty, dummy".
File flags were controlled with fcntl().

In contrast, EINVAL means "there is something wrong with the
arguments", which very much implies "I do recognize the ioctl".

And finally, ENOIOCTLCMD is a way to say ENOTTY in a sane manner, and
will now be turned into ENOTTY for the user space return (not EINVAL -
I have no idea where that idiocy came from, but it's clearly confused,
although it's also clearly very old).

This fixes the core files I noticed. It removes the *insane*
complaints from the compat_ioctl() (which would complain if you
returned ENOIOCTLCMD after an ioctl translation - the reason that is
totally insane is that somebody might use an ioctl on the wrong kind
of file descriptor, so even if it was translated perfectly fine,
ENOIOCTLCMD is a perfectly fine error return and shouldn't cause
warnings - and that allows us to remove stupid crap from the socket
ioctl code).

Does this break things and need to be reverted? Maybe. There could be
user code that tests *explicitly* for EINVAL and considers that the
"wrong ioctl number", even though it's the wrong error return.

And we may have those kinds of mistakes inside the kernel too. We did
in the block layer BLKSETRO code, for example, as pointed out by
Paulo. That one is fixed here, but there may be others.

I didn't change any media layers, since there it's clearly an endemic
problem, and there it seems to be used as a "we pass media ioctls down
and drivers should by definition recognize them, so if they don't, we
assume the driver is limited and doesn't support those particular
settings and return EINVAL".

But in general, any code like this is WRONG:

   switch (cmd) {
   case MYIOCTL:
      .. do something ..
   default:
      return -EINVAL;
   }

while something like this is CORRECT:

   switch (cmd) {
   case MYIOCT:
      if (arg)
         return -EINVAL;
      ...

   case OTHERIOCT:
      /* I recognize this one, but I don't support it */
      return -EINVAL;

   default:
      return -ENOIOCTLCMD; // Or -ENOTTY - see below about the difference
   }

where right now we do have some magic differences between ENOIOCTLCMD
and ENOTTY (the compat layer will try to do a translated ioctl *only*
if it gets ENOIOCTLCMD, iirc, so ENOTTY basically means "this is my
final answer").

I'll try it out on my own setup here to see what problems I can
trigger, but I thought I'd send it out first just as (a) a heads-up
and (b) to let others try it out and see.. See the block/ioctl.c code
for an example of the kinds of things we may need even just inside the
kernel (and the kinds of things that could cause problems for
user-space that makes a difference between EINVAL and ENOTTY).

                             Linus

--20cf30363877428bf704b5cae5b4
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx20v45a0

IGJsb2NrL2lvY3RsLmMgICAgIHwgICAyNiArKysrKysrKysrKysrKysrKysrKysrLS0tLQogZnMv
Y29tcGF0X2lvY3RsLmMgfCAgICA5ICsrLS0tLS0tLQogZnMvaW9jdGwuYyAgICAgICAgfCAgICAy
ICstCiBuZXQvc29ja2V0LmMgICAgICB8ICAgMTYgKy0tLS0tLS0tLS0tLS0tLQogNCBmaWxlcyBj
aGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspLCAyNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9i
bG9jay9pb2N0bC5jIGIvYmxvY2svaW9jdGwuYwppbmRleCBjYTkzOWZjMTAzMGYuLmFmODM2M2U3
NzVhOCAxMDA2NDQKLS0tIGEvYmxvY2svaW9jdGwuYworKysgYi9ibG9jay9pb2N0bC5jCkBAIC0x
ODAsNiArMTgwLDI2IEBAIGludCBfX2Jsa2Rldl9kcml2ZXJfaW9jdGwoc3RydWN0IGJsb2NrX2Rl
dmljZSAqYmRldiwgZm1vZGVfdCBtb2RlLAogRVhQT1JUX1NZTUJPTF9HUEwoX19ibGtkZXZfZHJp
dmVyX2lvY3RsKTsKIAogLyoKKyAqIElzIGl0IGFuIHVucmVjb2duaXplZCBpb2N0bD8gVGhlIGNv
cnJlY3QgcmV0dXJucyBhcmUgZWl0aGVyCisgKiBFTk9UVFkgKGZpbmFsKSBvciBFTk9JT0NUTENN
RCAoIkkgZG9uJ3Qga25vdyB0aGlzIG9uZSwgdHJ5IGEKKyAqIGZhbGxiYWNrIikuIEVOT0lPQ1RM
Q01EIGdldHMgdHVybmVkIGludG8gRU5PVFRZIGJ5IHRoZSBpb2N0bAorICogY29kZSBiZWZvcmUg
cmV0dXJuaW5nLgorICoKKyAqIENvbmZ1c2VkIGRyaXZlcnMgc29tZXRpbWVzIHJldHVybiBFSU5W
QUwsIHdoaWNoIGlzIHdyb25nLiBJdAorICogbWVhbnMgIkkgdW5kZXJzdG9vZCB0aGUgaW9jdGwg
Y29tbWFuZCwgYnV0IHRoZSBwYXJhbWV0ZXJzIHRvCisgKiBpdCB3ZXJlIHdyb25nIi4KKyAqCisg
KiBXZSBzaG91bGQgYWltIHRvIGp1c3QgZml4IHRoZSBicm9rZW4gZHJpdmVycywgdGhlIEVJTlZB
TCBjYXNlCisgKiBzaG91bGQgZ28gYXdheS4KKyAqLworc3RhdGljIGlubGluZSBpbnQgaXNfdW5y
ZWNvZ25pemVkX2lvY3RsKGludCByZXQpCit7CisJcmV0dXJuCXJldCA9PSAtRUlOVkFMIHx8CisJ
CXJldCA9PSAtRU5PVFRZIHx8CisJCXJldCA9PSBFTk9JT0NUTENNRDsKK30KKworLyoKICAqIGFs
d2F5cyBrZWVwIHRoaXMgaW4gc3luYyB3aXRoIGNvbXBhdF9ibGtkZXZfaW9jdGwoKQogICovCiBp
bnQgYmxrZGV2X2lvY3RsKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGZtb2RlX3QgbW9kZSwg
dW5zaWduZWQgY21kLApAQCAtMTk2LDggKzIxNiw3IEBAIGludCBibGtkZXZfaW9jdGwoc3RydWN0
IGJsb2NrX2RldmljZSAqYmRldiwgZm1vZGVfdCBtb2RlLCB1bnNpZ25lZCBjbWQsCiAJCQlyZXR1
cm4gLUVBQ0NFUzsKIAogCQlyZXQgPSBfX2Jsa2Rldl9kcml2ZXJfaW9jdGwoYmRldiwgbW9kZSwg
Y21kLCBhcmcpOwotCQkvKiAtRUlOVkFMIHRvIGhhbmRsZSBvbGQgdW5jb3JyZWN0ZWQgZHJpdmVy
cyAqLwotCQlpZiAocmV0ICE9IC1FSU5WQUwgJiYgcmV0ICE9IC1FTk9UVFkpCisJCWlmICghaXNf
dW5yZWNvZ25pemVkX2lvY3RsKHJldCkpCiAJCQlyZXR1cm4gcmV0OwogCiAJCWZzeW5jX2JkZXYo
YmRldik7CkBAIC0yMDYsOCArMjI1LDcgQEAgaW50IGJsa2Rldl9pb2N0bChzdHJ1Y3QgYmxvY2tf
ZGV2aWNlICpiZGV2LCBmbW9kZV90IG1vZGUsIHVuc2lnbmVkIGNtZCwKIAogCWNhc2UgQkxLUk9T
RVQ6CiAJCXJldCA9IF9fYmxrZGV2X2RyaXZlcl9pb2N0bChiZGV2LCBtb2RlLCBjbWQsIGFyZyk7
Ci0JCS8qIC1FSU5WQUwgdG8gaGFuZGxlIG9sZCB1bmNvcnJlY3RlZCBkcml2ZXJzICovCi0JCWlm
IChyZXQgIT0gLUVJTlZBTCAmJiByZXQgIT0gLUVOT1RUWSkKKwkJaWYgKCFpc191bnJlY29nbml6
ZWRfaW9jdGwocmV0KSkKIAkJCXJldHVybiByZXQ7CiAJCWlmICghY2FwYWJsZShDQVBfU1lTX0FE
TUlOKSkKIAkJCXJldHVybiAtRUFDQ0VTOwpkaWZmIC0tZ2l0IGEvZnMvY29tcGF0X2lvY3RsLmMg
Yi9mcy9jb21wYXRfaW9jdGwuYwppbmRleCA1MTM1MmRlODhlZjEuLjVjMTRlOGQ0MjhhNSAxMDA2
NDQKLS0tIGEvZnMvY29tcGF0X2lvY3RsLmMKKysrIGIvZnMvY29tcGF0X2lvY3RsLmMKQEAgLTE2
MjEsMTMgKzE2MjEsOCBAQCBhc21saW5rYWdlIGxvbmcgY29tcGF0X3N5c19pb2N0bCh1bnNpZ25l
ZCBpbnQgZmQsIHVuc2lnbmVkIGludCBjbWQsCiAJCWdvdG8gZm91bmRfaGFuZGxlcjsKIAogCWVy
cm9yID0gZG9faW9jdGxfdHJhbnMoZmQsIGNtZCwgYXJnLCBmaWxwKTsKLQlpZiAoZXJyb3IgPT0g
LUVOT0lPQ1RMQ01EKSB7Ci0JCXN0YXRpYyBpbnQgY291bnQ7Ci0KLQkJaWYgKCsrY291bnQgPD0g
NTApCi0JCQljb21wYXRfaW9jdGxfZXJyb3IoZmlscCwgZmQsIGNtZCwgYXJnKTsKLQkJZXJyb3Ig
PSAtRUlOVkFMOwotCX0KKwlpZiAoZXJyb3IgPT0gLUVOT0lPQ1RMQ01EKQorCQllcnJvciA9IC1F
Tk9UVFk7CiAKIAlnb3RvIG91dF9mcHV0OwogCmRpZmYgLS1naXQgYS9mcy9pb2N0bC5jIGIvZnMv
aW9jdGwuYwppbmRleCAxZDliOWZjYjJkYjQuLjA2NjgzNmU4MTg0OCAxMDA2NDQKLS0tIGEvZnMv
aW9jdGwuYworKysgYi9mcy9pb2N0bC5jCkBAIC00Miw3ICs0Miw3IEBAIHN0YXRpYyBsb25nIHZm
c19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwgdW5zaWduZWQgaW50IGNtZCwKIAogCWVycm9yID0g
ZmlscC0+Zl9vcC0+dW5sb2NrZWRfaW9jdGwoZmlscCwgY21kLCBhcmcpOwogCWlmIChlcnJvciA9
PSAtRU5PSU9DVExDTUQpCi0JCWVycm9yID0gLUVJTlZBTDsKKwkJZXJyb3IgPSAtRU5PVFRZOwog
IG91dDoKIAlyZXR1cm4gZXJyb3I7CiB9CmRpZmYgLS1naXQgYS9uZXQvc29ja2V0LmMgYi9uZXQv
c29ja2V0LmMKaW5kZXggMjg3NzY0N2YzNDdiLi5hMDA1Mzc1MGUzN2EgMTAwNjQ0Ci0tLSBhL25l
dC9zb2NrZXQuYworKysgYi9uZXQvc29ja2V0LmMKQEAgLTI4ODMsNyArMjg4Myw3IEBAIHN0YXRp
YyBpbnQgYm9uZF9pb2N0bChzdHJ1Y3QgbmV0ICpuZXQsIHVuc2lnbmVkIGludCBjbWQsCiAKIAkJ
cmV0dXJuIGRldl9pb2N0bChuZXQsIGNtZCwgdWlmcik7CiAJZGVmYXVsdDoKLQkJcmV0dXJuIC1F
SU5WQUw7CisJCXJldHVybiAtRU5PSU9DVExDTUQ7CiAJfQogfQogCkBAIC0zMjEwLDIwICszMjEw
LDYgQEAgc3RhdGljIGludCBjb21wYXRfc29ja19pb2N0bF90cmFucyhzdHJ1Y3QgZmlsZSAqZmls
ZSwgc3RydWN0IHNvY2tldCAqc29jaywKIAkJcmV0dXJuIHNvY2tfZG9faW9jdGwobmV0LCBzb2Nr
LCBjbWQsIGFyZyk7CiAJfQogCi0JLyogUHJldmVudCB3YXJuaW5nIGZyb20gY29tcGF0X3N5c19p
b2N0bCwgdGhlc2UgYWx3YXlzCi0JICogcmVzdWx0IGluIC1FSU5WQUwgaW4gdGhlIG5hdGl2ZSBj
YXNlIGFueXdheS4gKi8KLQlzd2l0Y2ggKGNtZCkgewotCWNhc2UgU0lPQ1JUTVNHOgotCWNhc2Ug
U0lPQ0dJRkNPVU5UOgotCWNhc2UgU0lPQ1NSQVJQOgotCWNhc2UgU0lPQ0dSQVJQOgotCWNhc2Ug
U0lPQ0RSQVJQOgotCWNhc2UgU0lPQ1NJRkxJTks6Ci0JY2FzZSBTSU9DR0lGU0xBVkU6Ci0JY2Fz
ZSBTSU9DU0lGU0xBVkU6Ci0JCXJldHVybiAtRUlOVkFMOwotCX0KLQogCXJldHVybiAtRU5PSU9D
VExDTUQ7CiB9CiAK
--20cf30363877428bf704b5cae5b4--
