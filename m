Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1AZGma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:42:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41539 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1AZGm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:42:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dZo0sTwAfxxEbvm14FtrKqTe9Cg+uCUNP1I1+8Rgu3iY5oVhQ1zekdpaJoxH+jdf0z
         v37qQ5PVbB6DcNRFUdzDa2YNR8NQqoc8Eeuhtl7xFHAhDlE6pYDEbQmh9jSYHEyOEn5y
         alNIoILyegjug6qWRzLQzbFmagn3yjvkeOmCA=
MIME-Version: 1.0
In-Reply-To: <1295946736.28776.479.camel@laptop>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	<1295894492.28776.470.camel@laptop>
	<AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
	<1295946736.28776.479.camel@laptop>
Date: Wed, 26 Jan 2011 01:42:27 -0500
Message-ID: <AANLkTikQs1UcfBGf_6shNVtdDSzR+8XzUKcx0amFZXey@mail.gmail.com>
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused by pm_idle
From: Luming Yu <luming.yu@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: multipart/mixed; boundary=20cf3054a2e9f1d2f4049aba223c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3054a2e9f1d2f4049aba223c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 25, 2011 at 4:12 AM, Peter Zijlstra <peterz@infradead.org> wrot=
e:
> On Mon, 2011-01-24 at 20:59 -0500, Luming Yu wrote:
>>
>> > Ow god this is ugly.. pm_idle should die asap, not find it way into ge=
neric code, so NAK!
>>
>> Without the ugly fix, we seem not able to fix the problem in short time.
>> Or , Are you suggesting to wrap =C2=A0pm_idle or similar in some generic
>> code that would not disappear in foreseeable future ,
>
> There are patches out there removing pm_idle from x86 (at least).
> pm_idle is a horribly broken interface that really should die.
>
>> =C2=A0Or =C2=A0Are you just
>> suggesting me don't do the stuff in kerne/cpu.c, and do it in Arch
>> code?
>
> Well, as it stand only about half the architectures out there even have
> a pm_idle pointer, so your patch would break the other half.
>
> If you really need to do this, do it in arch code, but really, why is
> this needed at all? The changelog failed to explain wth happens and why
> this solves it.

Ok, How about the new patch in the attachment?

We have seen an extremely slow system under the CPU-OFFLINE-ONLIE test
on a 4-sockets NHM-EX system.

The test case of off-line-on-line a cpu 1000 times and its performance
is dominated by IPI and ipi_handler performance. On NHM-EX, Sending
IPI not through broadcast is very slow. Needs to wake up processor by
IPI from deep-c-state also incurs heavy weight delay in set_mtrr
synchronization in stop_machinecontext. NHM-EX's c3-stop-APIC timer
adds more trouble to the problem. If I understand the problem
correctly, We probably need to tweak IPI code in upstream to get a
clean solution for NHM-EX's slow IPI delivery problem to get
reschedule tick processed without any delay on CPU which was in deep c stat=
e.
But it needs more time. So A quick fix is provided to make the test pass.

Without the patch the current CPU Office Online feature would not work
reliably, since it currently unnecessarily implicitly interact with
CPU power management.

--Luming

--20cf3054a2e9f1d2f4049aba223c
Content-Type: application/octet-stream; name="switch-idle-procedure.patch"
Content-Disposition: attachment; filename="switch-idle-procedure.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gjduwbrx0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9zbXBib290LmMgYi9hcmNoL3g4Ni9rZXJuZWwv
c21wYm9vdC5jCmluZGV4IDA4M2U5OWQuLjgzMmJiZGMgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tl
cm5lbC9zbXBib290LmMKKysrIGIvYXJjaC94ODYva2VybmVsL3NtcGJvb3QuYwpAQCAtODMsNiAr
ODMsNyBAQCBERUZJTkVfUEVSX0NQVShpbnQsIGNwdV9zdGF0ZSkgPSB7IDAgfTsKICogZm9yIGlk
bGUgdGhyZWFkcy4KICovCiAjaWZkZWYgQ09ORklHX0hPVFBMVUdfQ1BVCitzdGF0aWMgc3RydWN0
IG5vdGlmaWVyX2Jsb2NrIHBtX2lkbGVfY3B1X25vdGlmaWVyOwogLyoKICAqIE5lZWRlZCBvbmx5
IGZvciBDT05GSUdfSE9UUExVR19DUFUgYmVjYXVzZSBfX2NwdWluaXRkYXRhIGlzCiAgKiByZW1v
dmVkIGFmdGVyIGluaXQgZm9yICFDT05GSUdfSE9UUExVR19DUFUuCkBAIC0xMTYyLDYgKzExNjMs
NyBAQCB2b2lkIF9faW5pdCBuYXRpdmVfc21wX3ByZXBhcmVfY3B1cyh1bnNpZ25lZCBpbnQgbWF4
X2NwdXMpCiAJCXV2X3N5c3RlbV9pbml0KCk7CiAKIAlzZXRfbXRycl9hcHNfZGVsYXllZF9pbml0
KCk7CisJcmVnaXN0ZXJfaG90Y3B1X25vdGlmaWVyKCZwbV9pZGxlX2NwdV9ub3RpZmllcik7CiBv
dXQ6CiAJcHJlZW1wdF9lbmFibGUoKTsKIH0KQEAgLTE0NjksNiArMTQ3MSw0MiBAQCB2b2lkIG5h
dGl2ZV9wbGF5X2RlYWQodm9pZCkKIAlobHRfcGxheV9kZWFkKCk7CiB9CiAKK3N0YXRpYyB2b2lk
ICgqcG1faWRsZV9zYXZlZCkodm9pZCk7CisKK3N0YXRpYyBpbmxpbmUgdm9pZCBzYXZlX3BtX2lk
bGUodm9pZCkKK3sKKwlwbV9pZGxlX3NhdmVkID0gcG1faWRsZTsKKwlwbV9pZGxlID0gZGVmYXVs
dF9pZGxlOworCWNwdV9pZGxlX3dhaXQoKTsKK30KKworc3RhdGljIGlubGluZSB2b2lkIHJlc3Rv
cmVfcG1faWRsZSh2b2lkKQoreworCXBtX2lkbGUgPSBwbV9pZGxlX3NhdmVkOworCWNwdV9pZGxl
X3dhaXQoKTsKK30KKworc3RhdGljIGludCBwbV9pZGxlX2NhbGxiYWNrKHN0cnVjdCBub3RpZmll
cl9ibG9jayAqbmZiLAorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxv
bmcgYWN0aW9uLCB2b2lkICpoY3B1KQoreworCXN3aXRjaCAoYWN0aW9uKSB7CisJY2FzZSBDUFVf
VVBfUFJFUEFSRToKKwljYXNlIENQVV9ET1dOX1BSRVBBUkU6CisJCXNhdmVfcG1faWRsZSgpOwor
CQlicmVhazsKKwljYXNlIENQVV9PTkxJTkU6CisJY2FzZSBDUFVfVVBfQ0FOQ0VMRUQ6CisJY2Fz
ZSBDUFVfRE9XTl9GQUlMRUQ6CisJY2FzZSBDUFVfREVBRDoKKwkJcmVzdG9yZV9wbV9pZGxlKCk7
CisJCWJyZWFrOworCX0KKwlyZXR1cm4gTk9USUZZX09LOworfQorc3RhdGljIHN0cnVjdCBub3Rp
Zmllcl9ibG9jayBfX3JlZmRhdGEgcG1faWRsZV9jcHVfbm90aWZpZXIgPSB7CisgICAgICAgIC5u
b3RpZmllcl9jYWxsID0gcG1faWRsZV9jYWxsYmFjaywKK307CisKICNlbHNlIC8qIC4uLiAhQ09O
RklHX0hPVFBMVUdfQ1BVICovCiBpbnQgbmF0aXZlX2NwdV9kaXNhYmxlKHZvaWQpCiB7Cg==
--20cf3054a2e9f1d2f4049aba223c--
