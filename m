Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1DMCYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:24:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab1DMCYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:24:42 -0400
MIME-Version: 1.0
In-Reply-To: <20110413070827.11b2a71d@notabene.brown>
References: <20110411223623.4278fad1@notabene.brown> <4DA2F8AD.1060605@fusionio.com>
 <20110412011255.GA29236@infradead.org> <4DA40F0E.1070903@fusionio.com>
 <20110412122248.GC31057@dastard> <4DA4456F.3070301@fusionio.com>
 <20110412124134.GD31057@dastard> <4DA44C86.3090305@fusionio.com>
 <20110412133117.GE31057@dastard> <4DA45790.2010109@fusionio.com>
 <20110412143452.GH31057@dastard> <20110413070827.11b2a71d@notabene.brown>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Apr 2011 19:23:52 -0700
Message-ID: <BANLkTikBEJa7bJJoLFU7NoiEgOjVHVG08A@mail.gmail.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
To: NeilBrown <neilb@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <jaxboe@fusionio.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0022154012fa1cd2bd04a0c38101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0022154012fa1cd2bd04a0c38101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 12, 2011 at 2:08 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 13 Apr 2011 00:34:52 +1000 Dave Chinner <david@fromorbit.com> wro=
te:
>>
>> Well, not really - now taking any sleeping lock or waiting on
>> anything can trigger a plug flush where previously you had to
>> explicitly issue them. I'm not saying what we had is better, just
>> that there are implicit flushes with your changes that are
>> inherently uncontrollable...
>
> It's not just sleeping locks - if preempt is enabled a schedule can happe=
n at
> any time - at any depth. =A0I've seen a spin_unlock do it.

Hmm. I don't think we should flush IO in the preemption path. That
smells wrong on many levels, just one of them being the "any time, any
depth".

It also sounds really wrong from an IO pattern standpoint. The process
is actually still running, and the IO flushing _already_ does the
"only if it's going to sleep" test, but it actually does it _wrong_.
The "current->state" check doesn't make sense for a preemption event,
because it's not actually going to sleep there.

So a patch like the attached (UNTESTED!) sounds like the right thing to do.

Whether it makes any difference for any MD issues, who knows.. But
considering that the unplugging already used to test for "prev->state
!=3D TASK_RUNNING", this is absolutely the right thing to do - that old
test was just broken.

                                   Linus

--0022154012fa1cd2bd04a0c38101
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmfmyb2w0

IGtlcm5lbC9zY2hlZC5jIHwgICAyMCArKysrKysrKysrLS0tLS0tLS0tLQogMSBmaWxlcyBjaGFu
Z2VkLCAxMCBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJu
ZWwvc2NoZWQuYyBiL2tlcm5lbC9zY2hlZC5jCmluZGV4IDQ4MDEzNjMzZDc5Mi4uYTE4N2MzZmUw
MjdiIDEwMDY0NAotLS0gYS9rZXJuZWwvc2NoZWQuYworKysgYi9rZXJuZWwvc2NoZWQuYwpAQCAt
NDExMSwyMCArNDExMSwyMCBAQCBuZWVkX3Jlc2NoZWQ6CiAJCQkJCXRyeV90b193YWtlX3VwX2xv
Y2FsKHRvX3dha2V1cCk7CiAJCQl9CiAJCQlkZWFjdGl2YXRlX3Rhc2socnEsIHByZXYsIERFUVVF
VUVfU0xFRVApOworCisJCQkvKgorCQkJICogSWYgd2UgYXJlIGdvaW5nIHRvIHNsZWVwIGFuZCB3
ZSBoYXZlIHBsdWdnZWQgSU8gcXVldWVkLCBtYWtlCisJCQkgKiBzdXJlIHRvIHN1Ym1pdCBpdCB0
byBhdm9pZCBkZWFkbG9ja3MuCisJCQkgKi8KKwkJCWlmIChibGtfbmVlZHNfZmx1c2hfcGx1Zyhw
cmV2KSkgeworCQkJCXJhd19zcGluX3VubG9jaygmcnEtPmxvY2spOworCQkJCWJsa19mbHVzaF9w
bHVnKHByZXYpOworCQkJCXJhd19zcGluX2xvY2soJnJxLT5sb2NrKTsKKwkJCX0KIAkJfQogCQlz
d2l0Y2hfY291bnQgPSAmcHJldi0+bnZjc3c7CiAJfQogCi0JLyoKLQkgKiBJZiB3ZSBhcmUgZ29p
bmcgdG8gc2xlZXAgYW5kIHdlIGhhdmUgcGx1Z2dlZCBJTyBxdWV1ZWQsIG1ha2UKLQkgKiBzdXJl
IHRvIHN1Ym1pdCBpdCB0byBhdm9pZCBkZWFkbG9ja3MuCi0JICovCi0JaWYgKHByZXYtPnN0YXRl
ICE9IFRBU0tfUlVOTklORyAmJiBibGtfbmVlZHNfZmx1c2hfcGx1ZyhwcmV2KSkgewotCQlyYXdf
c3Bpbl91bmxvY2soJnJxLT5sb2NrKTsKLQkJYmxrX2ZsdXNoX3BsdWcocHJldik7Ci0JCXJhd19z
cGluX2xvY2soJnJxLT5sb2NrKTsKLQl9Ci0KIAlwcmVfc2NoZWR1bGUocnEsIHByZXYpOwogCiAJ
aWYgKHVubGlrZWx5KCFycS0+bnJfcnVubmluZykpCg==
--0022154012fa1cd2bd04a0c38101--
