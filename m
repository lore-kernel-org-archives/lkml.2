Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab2IZSUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:20:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62150 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab2IZSUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120926163233.GA5339@x1.osrc.amd.com>
References: <1348505683.11847.111.camel@twins> <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic> <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com> <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Sep 2012 11:19:42 -0700
X-Google-Sender-Auth: uJ76KGInoaHnF4_UYPV-wb4o0uY
Message-ID: <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: multipart/mixed; boundary=e89a8fb201da11967404ca9edfa0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8fb201da11967404ca9edfa0
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Sep 26, 2012 at 9:32 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Sep 25, 2012 at 10:21:28AM -0700, Linus Torvalds wrote:
>> How does pgbench look? That's the one that apparently really wants to
>> spread out, possibly due to user-level spinlocks. So I assume it will
>> show the reverse pattern, with "kill select_idle_sibling" being the
>> worst case. Sad, because it really would be lovely to just remove that
>> thing ;)
>
> Yep, correct. It hurts.

I'm *so* not surprised.

That said, I think your "kill select_idle_sibling()" one was
interesting, but the wrong kind of "get rid of that logic".

It always selected target_cpu, but the fact is, that doesn't really
sound very sane. The target cpu is either the previous cpu or the
current cpu, depending on whether they should be balanced or not. But
that still doesn't make any *sense*.

In fact, the whole select_idle_sibling() logic makes no sense
what-so-ever to me. It seems to be total garbage.

For example, it starts with the maximum target scheduling domain, and
works its way in over the scheduling groups within that domain. What
the f*ck is the logic of that kind of crazy thing? It never makes
sense to look at a biggest domain first. If you want to be close to
something, you want to look at the *smallest* domain first. But
because it looks at things in the wrong order, it then needs to have
that inner loop saying "does this group actually cover the cpu I am
interested in?"

Please tell me I am mis-reading this?

But starting from the biggest ("llc" group) is wrong *anyway*, since
it means that it starts looking at the L3 level, and then if it finds
an acceptable cpu inside that level, it's all done. But that's
*crazy*. Once again, it's much better to try to find an idle sibling
*closeby* rather than at the L3 level. No? So once again, we should
start at the inner level and if we can't find something really close,
we work our way out, rather than starting from the outer level and
working our way in.

If I read the code correctly, we can have both "prev" and "cpu" in the
same L2 domain, but because we start looking at the L3 domain, we may
end up picking another "affine" CPU that isn't even sharing L2's
*before* we pick one that actually *is* sharing L2's with the target
CPU. But that code is confusing enough with the scheduler groups inner
loop that maybe I am mis-reading it entirely.

There are other oddities in select_idle_sibling() too, if I read
things correctly.

For example, it uses "cpu_idle(target)", but if we're actively trying
to move to the current CPU (ie wake_affine() returned true), then
target is the current cpu, which is certainly *not* going to be idle
for a sync wakeup. So it should actually check whether it's a sync
wakeup and the only thing pending is that synchronous waker, no?

Maybe I'm missing something really fundamental, but it all really does
look very odd to me.

Attached is a totally untested and probably very buggy patch, so
please consider it a "shouldn't we do something like this instead" RFC
rather than anything serious. So this RFC patch is more a "ok, the
patch tries to fix the above oddnesses, please tell me where I went
wrong" than anything else.

Comments?

                    Linus

--e89a8fb201da11967404ca9edfa0
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7krb6hw0

IGtlcm5lbC9zY2hlZC9mYWlyLmMgfCA4MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQzIGluc2VydGlvbnMoKyks
IDM3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9zY2hlZC9mYWlyLmMgYi9rZXJu
ZWwvc2NoZWQvZmFpci5jCmluZGV4IDk2ZTJiMThiNjI4My4uMjU4MTdjZmY3MmM0IDEwMDY0NAot
LS0gYS9rZXJuZWwvc2NoZWQvZmFpci5jCisrKyBiL2tlcm5lbC9zY2hlZC9mYWlyLmMKQEAgLTI2
MzIsNTMgKzI2MzIsNTMgQEAgZmluZF9pZGxlc3RfY3B1KHN0cnVjdCBzY2hlZF9ncm91cCAqZ3Jv
dXAsIHN0cnVjdCB0YXNrX3N0cnVjdCAqcCwgaW50IHRoaXNfY3B1KQogLyoKICAqIFRyeSBhbmQg
bG9jYXRlIGFuIGlkbGUgQ1BVIGluIHRoZSBzY2hlZF9kb21haW4uCiAgKi8KLXN0YXRpYyBpbnQg
c2VsZWN0X2lkbGVfc2libGluZyhzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAsIGludCB0YXJnZXQpCitz
dGF0aWMgaW50IHNlbGVjdF9pZGxlX3NpYmxpbmcoc3RydWN0IHRhc2tfc3RydWN0ICpwLCBpbnQg
dGFyZ2V0LCBzdHJ1Y3Qgc2NoZWRfZG9tYWluICphZmZpbmUpCiB7Ci0JaW50IGNwdSA9IHNtcF9w
cm9jZXNzb3JfaWQoKTsKLQlpbnQgcHJldl9jcHUgPSB0YXNrX2NwdShwKTsKLQlzdHJ1Y3Qgc2No
ZWRfZG9tYWluICpzZDsKLQlzdHJ1Y3Qgc2NoZWRfZ3JvdXAgKnNnOworCXN0cnVjdCBzY2hlZF9k
b21haW4gKnNkLCAqbGxjX3NkOwogCWludCBpOwogCiAJLyoKIAkgKiBJZiB0aGUgdGFzayBpcyBn
b2luZyB0byBiZSB3b2tlbi11cCBvbiB0aGlzIGNwdSBhbmQgaWYgaXQgaXMKIAkgKiBhbHJlYWR5
IGlkbGUsIHRoZW4gaXQgaXMgdGhlIHJpZ2h0IHRhcmdldC4KIAkgKi8KLQlpZiAodGFyZ2V0ID09
IGNwdSAmJiBpZGxlX2NwdShjcHUpKQotCQlyZXR1cm4gY3B1OwotCi0JLyoKLQkgKiBJZiB0aGUg
dGFzayBpcyBnb2luZyB0byBiZSB3b2tlbi11cCBvbiB0aGUgY3B1IHdoZXJlIGl0IHByZXZpb3Vz
bHkKLQkgKiByYW4gYW5kIGlmIGl0IGlzIGN1cnJlbnRseSBpZGxlLCB0aGVuIGl0IHRoZSByaWdo
dCB0YXJnZXQuCi0JICovCi0JaWYgKHRhcmdldCA9PSBwcmV2X2NwdSAmJiBpZGxlX2NwdShwcmV2
X2NwdSkpCi0JCXJldHVybiBwcmV2X2NwdTsKKwlpZiAoaWRsZV9jcHUodGFyZ2V0KSkKKwkJcmV0
dXJuIHRhcmdldDsKIAogCS8qCiAJICogT3RoZXJ3aXNlLCBpdGVyYXRlIHRoZSBkb21haW5zIGFu
ZCBmaW5kIGFuIGVsZWdpYmxlIGlkbGUgY3B1LgogCSAqLwotCXNkID0gcmN1X2RlcmVmZXJlbmNl
KHBlcl9jcHUoc2RfbGxjLCB0YXJnZXQpKTsKLQlmb3JfZWFjaF9sb3dlcl9kb21haW4oc2QpIHsK
LQkJc2cgPSBzZC0+Z3JvdXBzOwotCQlkbyB7Ci0JCQlpZiAoIWNwdW1hc2tfaW50ZXJzZWN0cyhz
Y2hlZF9ncm91cF9jcHVzKHNnKSwKLQkJCQkJCXRza19jcHVzX2FsbG93ZWQocCkpKQotCQkJCWdv
dG8gbmV4dDsKKwlsbGNfc2QgPSByY3VfZGVyZWZlcmVuY2UocGVyX2NwdShzZF9sbGMsIHRhcmdl
dCkpOworCWZvcl9lYWNoX2RvbWFpbih0YXJnZXQsIHNkKSB7CisJCWZvcl9lYWNoX2NwdShpLCBz
Y2hlZF9kb21haW5fc3BhbihzZCkpIHsKKwkJCWlmICghY3B1bWFza190ZXN0X2NwdShpLCB0c2tf
Y3B1c19hbGxvd2VkKHApKSkKKwkJCQljb250aW51ZTsKKwkJCWlmICghaWRsZV9jcHUoaSkpCisJ
CQkJY29udGludWU7CisJCQlyZXR1cm4gIGk7CisJCX0KKwkJLyogRG9uJ3QgaXRlcmF0ZSBwYXN0
IHRoZSBsYXN0IGxldmVsIGNhY2hlIGRvbWFpbiAqLworCQlpZiAoc2QgPT0gbGxjX3NkKQorCQkJ
YnJlYWs7CisJCS8qIERvbid0IGl0ZXJhdGUgcGFzdCB0aGUgYWZmaW5pdHkgbGV2ZWwgKi8KKwkJ
aWYgKHNkID09IGFmZmluZSkKKwkJCWJyZWFrOworCX0KKwlyZXR1cm4gLTE7Cit9CiAKLQkJCWZv
cl9lYWNoX2NwdShpLCBzY2hlZF9ncm91cF9jcHVzKHNnKSkgewotCQkJCWlmICghaWRsZV9jcHUo
aSkpCi0JCQkJCWdvdG8gbmV4dDsKLQkJCX0KKy8qCisgKiBGb3Igc3luY2hyb25vdXMgd2FrZS11
cHM6IGlzIHRoZSBjdXJyZW50bHkgcnVubmluZworICogcHJvY2VzcyB0aGUgb25seSBwZW5kaW5n
IHByb2Nlc3Mgb2YgdGhpcyBDUFUgcnVucXVldWU/CisgKi8KK3N0YXRpYyBpbmxpbmUgaW50IHNp
bmdsZV9ydW5uaW5nKGludCBjcHUpCit7CisJc3RydWN0IHJxICpycSA9IGNwdV9ycShjcHUpOwog
Ci0JCQl0YXJnZXQgPSBjcHVtYXNrX2ZpcnN0X2FuZChzY2hlZF9ncm91cF9jcHVzKHNnKSwKLQkJ
CQkJdHNrX2NwdXNfYWxsb3dlZChwKSk7Ci0JCQlnb3RvIGRvbmU7Ci1uZXh0OgotCQkJc2cgPSBz
Zy0+bmV4dDsKLQkJfSB3aGlsZSAoc2cgIT0gc2QtPmdyb3Vwcyk7Ci0JfQotZG9uZToKLQlyZXR1
cm4gdGFyZ2V0OworI2lmZGVmIENPTkZJR19TTVAKKwlpZiAoIWxsaXN0X2VtcHR5KCZycS0+d2Fr
ZV9saXN0KSkKKwkJcmV0dXJuIDA7CisjZW5kaWYKKwlyZXR1cm4gY3B1X3JxKGNwdSktPm5yX3J1
bm5pbmcgPD0gMTsKIH0KIAogLyoKQEAgLTI3NTksMTEgKzI3NTksMTcgQEAgc2VsZWN0X3Rhc2tf
cnFfZmFpcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAsIGludCBzZF9mbGFnLCBpbnQgd2FrZV9mbGFn
cykKIAl9CiAKIAlpZiAoYWZmaW5lX3NkKSB7Ci0JCWlmIChjcHUgPT0gcHJldl9jcHUgfHwgd2Fr
ZV9hZmZpbmUoYWZmaW5lX3NkLCBwLCBzeW5jKSkKKwkJaWYgKGNwdSA9PSBwcmV2X2NwdSB8fCB3
YWtlX2FmZmluZShhZmZpbmVfc2QsIHAsIHN5bmMpKSB7CiAJCQlwcmV2X2NwdSA9IGNwdTsKKwkJ
CWlmIChzeW5jICYmIHNpbmdsZV9ydW5uaW5nKGNwdSkpIHsKKwkJCQluZXdfY3B1ID0gY3B1Owor
CQkJCWdvdG8gdW5sb2NrOworCQkJfQorCQl9CiAKLQkJbmV3X2NwdSA9IHNlbGVjdF9pZGxlX3Np
YmxpbmcocCwgcHJldl9jcHUpOwotCQlnb3RvIHVubG9jazsKKwkJbmV3X2NwdSA9IHNlbGVjdF9p
ZGxlX3NpYmxpbmcocCwgcHJldl9jcHUsIGFmZmluZV9zZCk7CisJCWlmIChuZXdfY3B1ID49IDAp
CisJCQlnb3RvIHVubG9jazsKIAl9CiAKIAl3aGlsZSAoc2QpIHsK
--e89a8fb201da11967404ca9edfa0--
