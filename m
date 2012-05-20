Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2ETTEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 15:04:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55253 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab2ETTED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 15:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205191930310.24674@chino.kir.corp.google.com>
References: <20120518212656.GA4992@kroah.com> <20120519010105.GB18264@home.goodmis.org>
 <20120519042038.GB11939@kroah.com> <1337479307.32434.16.camel@gandalf.stny.rr.com>
 <alpine.DEB.2.00.1205191930310.24674@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 May 2012 12:03:40 -0700
X-Google-Sender-Auth: SgekXNQOgS6yxVAwYxa1v7MUJF8
Message-ID: <CA+55aFwGpDtMR=8GfDqyZGdw_pQFxG-EL15LaNm0wVoXZChXSA@mail.gmail.com>
Subject: Re: [PATCH] pidmap: Use GFP_ATOMIC to allocate page (was: Re: [
 00/54] 3.0.32-stable review)
To: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: multipart/mixed; boundary=0016e6d58aebc7d28c04c07c7237
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d58aebc7d28c04c07c7237
Content-Type: text/plain; charset=ISO-8859-1

On Sat, May 19, 2012 at 7:32 PM, David Rientjes <rientjes@google.com> wrote:
>
> Why wasn't this caught by gfp_allowed_mask in slab_pre_alloc_hook()?
> GFP_KERNEL should be allowed in this context.

We set gfp_allowed_mask to allow all allocations before this point: it
happens when we enable interrupts fairly early during start_kernel().

So by the time pidmap_init() is called, GFP_KERNEL does imply that
scheduling can happen.

Which does imply that we set gfp_allowed_mask *much* too early. We
still cannot schedule at that point (well, at least there's a comment
saying so):

        /*
         * Disable preemption - early bootup scheduling is extremely
         * fragile until we cpu_idle() for the first time.
         */
        preempt_disable();

so logically we should move the gfp_allowed_mask setting down to where
we really are properly alive.

How about moving it down to after we've done the full smp_init() and
after we've actually done the first schedule and have proper idle
CPU's?

Something like the attached (UNTESTED!) patch?

                       Linus

--0016e6d58aebc7d28c04c07c7237
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2gh5e5w0

IGluaXQvbWFpbi5jIHwgNiArKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyks
IDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5pdC9tYWluLmMgYi9pbml0L21haW4uYwpp
bmRleCA0NGIyNDMzMzM0YzcuLjBjZjAwOTQzZDc1NSAxMDA2NDQKLS0tIGEvaW5pdC9tYWluLmMK
KysrIGIvaW5pdC9tYWluLmMKQEAgLTU2MCw5ICs1NjAsNiBAQCBhc21saW5rYWdlIHZvaWQgX19p
bml0IHN0YXJ0X2tlcm5lbCh2b2lkKQogCWVhcmx5X2Jvb3RfaXJxc19kaXNhYmxlZCA9IGZhbHNl
OwogCWxvY2FsX2lycV9lbmFibGUoKTsKIAotCS8qIEludGVycnVwdHMgYXJlIGVuYWJsZWQgbm93
IHNvIGFsbCBHRlAgYWxsb2NhdGlvbnMgYXJlIHNhZmUuICovCi0JZ2ZwX2FsbG93ZWRfbWFzayA9
IF9fR0ZQX0JJVFNfTUFTSzsKLQogCWttZW1fY2FjaGVfaW5pdF9sYXRlKCk7CiAKIAkvKgpAQCAt
ODYxLDYgKzg1OCw5IEBAIHN0YXRpYyBpbnQgX19pbml0IGtlcm5lbF9pbml0KHZvaWQgKiB1bnVz
ZWQpCiAJc21wX2luaXQoKTsKIAlzY2hlZF9pbml0X3NtcCgpOwogCisJLyogTm93IHdlJ3JlIGZp
bmFsbHkgc2V0IHVwIGFuZCBjYW4gZG8gYW55IGFsbG9jYXRpb24gKi8KKwlnZnBfYWxsb3dlZF9t
YXNrID0gX19HRlBfQklUU19NQVNLOworCiAJZG9fYmFzaWNfc2V0dXAoKTsKIAogCS8qIE9wZW4g
dGhlIC9kZXYvY29uc29sZSBvbiB0aGUgcm9vdGZzLCB0aGlzIHNob3VsZCBuZXZlciBmYWlsICov
Cg==
--0016e6d58aebc7d28c04c07c7237--
