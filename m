Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946095Ab2JYPCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:02:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42130 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975Ab2JYPCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:02:20 -0400
MIME-Version: 1.0
In-Reply-To: <20121024124607.43f599e8.akpm@linux-foundation.org>
References: <1350045042-1369134-1-git-send-email-avagin@openvz.org>
	<20121023165651.88af399d.akpm@linux-foundation.org>
	<CANaxB-xVVmQaCze=4+SaLbwkbJYxBwjbzF0hWX+Js94veWxj3w@mail.gmail.com>
	<20121024124607.43f599e8.akpm@linux-foundation.org>
Date: Thu, 25 Oct 2012 19:02:18 +0400
Message-ID: <CANaxB-x413bEkfA=1FRrYz6=P+T-V372UUuP0o67KT2=7-eTPA@mail.gmail.com>
Subject: Re: [PATCH] pidns: limit the nesting depth of pid namespaces
From: Andrey Wagin <avagin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: multipart/mixed; boundary=047d7b621bdc5181f104cce37d0d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b621bdc5181f104cce37d0d
Content-Type: text/plain; charset=ISO-8859-1

2012/10/24 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 24 Oct 2012 09:38:57 +0400
> Andrey Wagin <avagin@gmail.com> wrote:
>
>> >
>> > I think that returning -ENOMEM in response to an excessive nesting
>> > attempt is misleading - the system *didn't* run out of memory.  EINVAL
>> > is better?
>>
>> I chose ENOMEM by analogy with max_pid.  When a new PID can not be
>> allocated, ENOMEM is returned too.
>
> I don't know what this means - please be carefully specific when
> identifying kernel code.

Sorry.

>
> If you're referring to kernel/pid.c:alloc_pid() then -ENOMEM is
> appropriate there, because a failure *is* caused by memory allocation
> failure.

I'm referring to alloc_pidmap().
For example I set pid_max to 500 and try to create more than 500 processes.

[pid   345] clone(child_stack=0,
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
child_tidptr=0x7f8721716a10) = -1 ENOMEM (Cannot allocate memory)

Actually I'm agree with EINVAL and a patch is attached to this message.

Thanks.
>
> But ENOMEM isn't appropriate for nesting-depth-exceeded - we shouldn't
> tell the user "you ran out of memory" when he didn't!  -EINVAL isn't
> really appropriate either ("Invalid argument") but it has become a
> general you-screwed-up catchall and seems to me to be the most
> appropriate errno we have available.
>

--047d7b621bdc5181f104cce37d0d
Content-Type: application/octet-stream; 
	name="0001-pidns-limit-the-nesting-depth-of-pid-namespaces-v2.patch"
Content-Disposition: attachment; 
	filename="0001-pidns-limit-the-nesting-depth-of-pid-namespaces-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8q01vib0

RnJvbSA1MzI4NmJhMGNmNTY1ODUwNDhiNTM2Mzg0NGRlYzkyNDA4MWZlMDZkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRyZXcgVmFnaW4gPGF2YWdpbkBvcGVudnoub3JnPgpEYXRl
OiBXZWQsIDEwIE9jdCAyMDEyIDEyOjIyOjE2ICswNDAwClN1YmplY3Q6IFtQQVRDSF0gcGlkbnM6
IGxpbWl0IHRoZSBuZXN0aW5nIGRlcHRoIG9mIHBpZCBuYW1lc3BhY2VzICh2MikKCidzdHJ1Y3Qg
cGlkJyBpcyBhICJ2YXJpYWJsZSBzaXplZCBzdHJ1Y3QiIC0gYSBoZWFkZXIgd2l0aCBhbiBhcnJh
eQpvZiB1cGlkcyBhdCB0aGUgZW5kLgoKQSBzaXplIG9mIHRoZSBhcnJheSBkZXBlbmRzIG9uIGEg
bGV2ZWwgKGRlcHRoKSBvZiBwaWQgbmFtZXNwYWNlcy4gTm93CmEgbGV2ZWwgb2YgcGlkbnMgaXMg
bm90IGxpbWl0ZWQsIHNvICdzdHJ1Y3QgcGlkJyBjYW4gYmUgbW9yZSB0aGFuIG9uZQpwYWdlLgoK
TG9va3MgcmVhc29uYWJsZSwgdGhhdCBpdCBzaG91bGQgYmUgbGVzcyB0aGFuIGEgcGFnZS4gTUFY
X1BJU19OU19MRVZFTAppcyBub3QgY2FsY3VsYXRlZCBmcm9tIFBBR0VfU0laRSwgYmVjYXVzZSBp
biB0aGlzIGNhc2UgaXQgZGVwZW5kcyBvbgphcmNoaXRlY3R1cmVzLCBjb25maWcgb3B0aW9ucyBh
bmQgaXQgd2lsbCBiZSByZWR1Y2VkLCBpZiBzb21lb25lIGFkZHMgYQpuZXcgZmllbGRzIGluIHN0
cnVjdCBwaWQgb3Igc3RydWN0IHVwaWQuCgpJIHN1Z2dlc3QgdG8gc2V0IE1BWF9QSVNfTlNfTEVW
RUwgPSAzMiwgYmVjYXVzZSBpdCBzYXZlcyBhYmlsaXR5IHRvCmV4cGFuZCAic3RydWN0IHBpZCIg
YW5kIGl0J3MgbW9yZSB0aGFuIGVub3VnaCBmb3IgYWxsIGtub3duIGZvciBtZQp1c2UtY2FzZXMu
ICBXaGVuIHNvbWVvbmUgZmluZHMgYSByZWFzb25hYmxlIHVzZSBjYXNlLCB3ZSBjYW4gYWRkIGEK
Y29uZmlnIG9wdGlvbiBvciBhIHN5c2N0bCBwYXJhbWV0ZXIuCgpJbiBhZGRpdGlvbiBpdCB3aWxs
IHJlZHVjZSBlZmZlY3Qgb2YgYW5vdGhlciBwcm9ibGVtLCB3aGVuIHdlIGhhdmUgbWFueQpuZXN0
ZWQgbmFtZXNwYWNlcyBhbmQgdGhlIG9sZGVzdCBvbmUgc3RhcnRzIGR5aW5nLiAgemFwX3BpZF9u
c19wcm9jZXNzZQp3aWxsIGJlIGNhbGxlZCBmb3IgZWFjaCBuYW1lc3BhY2UgYW5kIGZpbmRfdnBp
ZCB3aWxsIGJlIGNhbGxlZCBmb3IgZWFjaApwcm9jZXNzIGluIGEgbmFtZXNwYWNlLiBmaW5kX3Zw
aWQgd2lsbCBiZSBjYWxsZWQgbWluaW11bSBtYXhfbGV2ZWxeMiAvIDIKdGltZXMuIFRoZSByZWFz
b24gb2YgdGhhdCBpcyB0aGF0IHdoZW4gd2UgZm91bmQgYSBiaXQgaW4gcGlkbWFwLCB3ZQpjYW4n
dCBkZXRlcm1pbmUgdGhpcyBwaWRucyBpcyB0b3AgZm9yIHRoaXMgcHJvY2VzcyBvciBpdCBpc24n
dC4KCnZwaWQgaXMgYSBoZWF2eSBvcGVyYXRpb24sIHNvIGEgZm9yayBib21iLCB3aGljaCBjcmVh
dGUgbWFueSBuZXN0ZWQKbmFtZXNwYWNlLCBjYW4gZG8gYSBzeXN0ZW0gaW5hY2Nlc3NpYmxlIGZv
ciBhIGxvbmcgdGltZS4KCnYyOiByZXR1cm4gRUlOVkFMIGluIHJlc3BvbnNlIHRvIGFuIGV4Y2Vz
c2l2ZSBuZXN0aW5nIGF0dGVtcHQKCkNjOiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5k
YXRpb24ub3JnPgpDYzogT2xlZyBOZXN0ZXJvdiA8b2xlZ0ByZWRoYXQuY29tPgpDYzogQ3lyaWxs
IEdvcmN1bm92IDxnb3JjdW5vdkBvcGVudnoub3JnPgpDYzogIkVyaWMgVy4gQmllZGVybWFuIiA8
ZWJpZWRlcm1AeG1pc3Npb24uY29tPgpDYzogUGF2ZWwgRW1lbHlhbm92IDx4ZW11bEBwYXJhbGxl
bHMuY29tPgpTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgVmFnaW4gPGF2YWdpbkBvcGVudnoub3JnPgot
LS0KIGtlcm5lbC9waWRfbmFtZXNwYWNlLmMgfCAgICA2ICsrKysrKwogMSBmaWxlcyBjaGFuZ2Vk
LCA2IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3Bp
ZF9uYW1lc3BhY2UuYyBiL2tlcm5lbC9waWRfbmFtZXNwYWNlLmMKaW5kZXggNDc4YmFkMi4uYzky
M2JiNSAxMDA2NDQKLS0tIGEva2VybmVsL3BpZF9uYW1lc3BhY2UuYworKysgYi9rZXJuZWwvcGlk
X25hbWVzcGFjZS5jCkBAIC03MSwxMiArNzEsMTggQEAgZXJyX2FsbG9jOgogCXJldHVybiBOVUxM
OwogfQogCisvKiBNQVhfUElEX05TX0xFVkVMIGlzIG5lZWRlZCBmb3IgbGltaXRpbmcgc2l6ZSBv
ZiAnc3RydWN0IHBpZCcgKi8KKyNkZWZpbmUgTUFYX1BJRF9OU19MRVZFTCAzMgorCiBzdGF0aWMg
c3RydWN0IHBpZF9uYW1lc3BhY2UgKmNyZWF0ZV9waWRfbmFtZXNwYWNlKHN0cnVjdCBwaWRfbmFt
ZXNwYWNlICpwYXJlbnRfcGlkX25zKQogewogCXN0cnVjdCBwaWRfbmFtZXNwYWNlICpuczsKIAl1
bnNpZ25lZCBpbnQgbGV2ZWwgPSBwYXJlbnRfcGlkX25zLT5sZXZlbCArIDE7CiAJaW50IGksIGVy
ciA9IC1FTk9NRU07CiAKKwlpZiAobGV2ZWwgPiBNQVhfUElEX05TX0xFVkVMKQorCQlyZXR1cm4g
RVJSX1BUUigtRUlOVkFMKTsKKwogCW5zID0ga21lbV9jYWNoZV96YWxsb2MocGlkX25zX2NhY2hl
cCwgR0ZQX0tFUk5FTCk7CiAJaWYgKG5zID09IE5VTEwpCiAJCWdvdG8gb3V0OwotLSAKMS43LjEK
Cg==
--047d7b621bdc5181f104cce37d0d--
